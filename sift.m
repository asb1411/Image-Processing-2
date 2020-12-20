function [des, magn] = sift(inputImage)
% This function is to extract sift features from a given image
Octaves=3;
Scales=5;
Sigma=1.4;
    
    %% Setting Variables.
    Sigmas = sigmas(Octaves,Scales,Sigma);
    ContrastThreshhold = 7.68;
    rCurvature = 10;
    G = cell(1,Octaves); % Gaussians
    D = cell(1,Octaves); % DoG
    GO = cell(1,Octaves); % Gradient Orientation
    GM = cell(1,Octaves); % Gradient Scale
    P = [];
    Descriptors = {}; % Key Points

    %% Calculating Gaussians
    for o = 1:Octaves
        [row,col] = size(inputImage);
        temp = zeros(row,col,Scales);
        for s=1:Scales
            temp(:,:,s) = imgaussfilt(inputImage,Sigmas(o,s));
        end
        G(o) = {temp};
        inputImage = inputImage(2:2:end,2:2:end);
    end

    %% Calculating DoG
    for o=1:Octaves
        images = cell2mat(G(o));
        [row,col,Scales] = size(images);
        temp = zeros([row,col,Scales-1]);
        for s=1:Scales-1
            temp(:,:,s) = images(:,:,s+1) - images(:,:,s);
        end
        D(o) = {temp};
    end
    
    %% Calculating orientation of gradient in each scale
    for o = 1:Octaves
        images = cell2mat(G(o));
        [row,col,Scales] = size(images);
        tempO = zeros([row,col,Scales]);
        tempM = zeros([row,col,Scales]);
        for s = 1:Scales
            [tempM(:,:,s),tempO(:,:,s)] = imgradient(images(:,:,s));
        end
        GO(o) = {tempO};
        GM(o) = {tempM};
    end

    %% Extracting Key Points
    for o=1:Octaves
        images = cell2mat(D(o));
        GradientOrientations = cell2mat(GO(o));
        GradientMagnitudes = cell2mat(GM(o));
        [row,col,Scales] = size(images);
        for s=2:Scales-1
            % Weight for gradient vectors
            weights = gaussianKernel(Sigmas(o,s));
            radius = (length(weights)-1)/2;
            for y=14:col-12
                for x=14:row-12
                    sub = images(x-1:x+1,y-1:y+1,s-1:s+1);
                    if sub(2,2,2) > max([sub(1:13),sub(15:end)]) || sub(2,2,2) < min([sub(1:13),sub(15:end)])
                        % Getting rid of bad Key Points
                        if abs(sub(2,2,2)) < ContrastThreshhold
                            % Low contrast.
                            continue
                        else
                            % Calculating trace and determinant of hessian
                            % matrix.
                            Dxx = sub(1,2,2)+sub(3,2,2)-2*sub(2,2,2);
                            Dyy = sub(2,1,2)+sub(2,3,2)-2*sub(2,2,2);
                            Dxy = sub(1,1,2)+sub(3,3,2)-2*sub(1,3,2)-2*sub(3,1,2);
                            trace = Dxx+Dyy;
                            determinant = Dxx*Dyy-Dxy*Dxy;
                            curvature = trace*trace/determinant;
                            if curvature > (rCurvature+1)^2/rCurvature
                                % Not a corner.
                                continue
                            end
                        end
                        %% Calculating orientation and magnitude of pixels at key point vicinity
                        % Fixing overflow key points near corners and edges
                        % of image.
                        a=0;b=0;c=0;d=0;
                        if x-1-radius < 0;a = -(x-1-radius);end
                        if y-1-radius < 0;b = -(y-1-radius);end
                        if row-x-radius < 0;c = -(row-x-radius);end
                        if col-y-radius < 0;d = -(col-y-radius);end
                        tempMagnitude = GradientMagnitudes(x-radius+a:x+radius-c,y-radius+b:y+radius-d,s).*weights(1+a:end-c,1+b:end-d);
                        tempOrientation = GradientOrientations(x-radius+a:x+radius-c,y-radius+b:y+radius-d,s);
                        [wRows, wCols] = size(tempMagnitude);
                        % 36 bin histogram generation.
                        gHist = zeros(1,36);
                        for i = 1:wRows
                            for j = 1:wCols
                                % Converting orientation calculation window
                                temp = tempOrientation(i,j);
                                if temp < 0
                                    temp = 360 + temp;
                                end
                                bin = floor(temp/10)+1;
                                gHist(bin) = gHist(bin) + tempMagnitude(i,j);
                            end
                        end
                        %% Extracting keypoint coordinates
                        % TODO: Interpolation for X and Y value to get
                        % subpixel accuracy.
                        %% Extracting keypoint orientation
                        % Marking 80% Threshold
                        orientationThreshold = max(gHist(:))*4/5;
                        tempP = [];
                        for i=1:length(gHist)
                            if gHist(i) > orientationThreshold
                                % Connrection both ends of the histogram
                                % for interpolation
                                if i-1 <= 0
                                    X = 0:2;
                                    Y = gHist([36,1,2]);
                                elseif i+1 > 36
                                    X = 35:37;
                                    Y = gHist([35,36,1]);
                                else
                                    X = i-1:i+1;
                                    Y = gHist(i-1:i+1);
                                end
                                % interpolation of Orientation.
                                dir = interpolateExterma([X(1),Y(1)],[X(2),Y(2)],[X(3),Y(3)])*10; % Orientation
                                mag = gHist(i); % Size
                                % Filtering points with the same
                                % orientation.
                                if ismember(dir,tempP(5:6:end)) == false
                                    tempP = [tempP,x,y,o,s,dir,mag];
                                end
                            end
                        end
                        P = [P,tempP];
                    end
                end
            end
        end
    end
    
    %% Creating feature Descriptors
    % TODO: Extract Descriptors
    weights = gaussianKernel(Sigmas(o,s),13);
    weights = weights(1:end-1,1:end-1);
    for i = 1:6:length(P)
        x = P(i);
        y = P(i+1);
        oct = P(i+2);
        scl = P(i+3);
        dir = P(i+4);
        mag = P(i+5);
        directions = cell2mat(GO(oct));
        directions = directions(x-13:x+12,y-13:y+12,scl);
        magnitudes = cell2mat(GM(oct));
        magnitudes = magnitudes(x-13:x+12,y-13:y+12,scl).*weights;
        descriptor = [];
        for m = 5:4:20
            for n = 5:4:20
                hist = zeros(1,8);
                for o = 0:3
                    for p = 0:3
                        [newx,newy] = rotateCoordinates(m+o,n+p,13,13,-dir);
                        % Creating 8 bin histogram.
                        hist(categorizeDirection8(directions(newx,newy))) = magnitudes(newx,newy);
                    end
                end
                descriptor = [descriptor, hist];
            end
        end
        descriptor = descriptor ./ norm(descriptor,2);
        for j =1:128
            if descriptor(j) > 0.2
                descriptor(j) = 0.2;
            end
        end
        descriptor = descriptor ./ norm(descriptor,2);
        % Creating keypoint object
        kp = KeyPoint;
        kp.Coordinates = [x*2^(oct-1),y*2^(oct-1)];
        kp.Magnitude = mag;
        kp.Direction = dir;
        kp.Descriptor = descriptor;
        kp.Octave = oct;
        kp.Scale = scl;
        Descriptors(end+1) = {kp};
    end
    
    des=zeros(length(Descriptors),128);
    coord=zeros(length(Descriptors),2);
    magn=zeros(length(Descriptors),1);
    for yu=1:length(Descriptors)
        des(yu,:)=Descriptors{yu}.Descriptor;
        coord(yu,:)=Descriptors{yu}.Coordinates;
        magn(yu,:)=Descriptors{yu}.Magnitude;
    end
    
end