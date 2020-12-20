function [per,bag,clfr,c,nc] = bsift(numVar, numImg)
c=1;
ca=cell([numVar*numImg,1]);
cls=zeros(numVar*numImg,1);
labelIdx=zeros(numVar*5,9);
score=zeros(numVar*5,9);
tst=zeros(numVar*5);
fh=@brisk;

for ji=1:9
    fullFileName = fullfile('C:','Users','ameya','Documents','MATLAB',ji+48);
    addpath(fullFileName);
for in=1:numVar
for ii=1:numImg
    %if(in<10)
        apa=""+in+"_"+ii+".bmp";
%     end
%     if(in>9 && in<100)
%         apa=""+in+"_"+ii+".bmp";
%     end
%     if(in>99)
%         apa=""+in+"_"+ii+".bmp";
%     end
    
     apa=char(apa);
     ca{c}=apa;
     cls(c)=in;
    
    try
    ty=imread(apa);
    catch
        continue
    end 
%     if ty==0
%         continue
%     end
    c=c+1;
%    try
%    app=divImg(ty);
%     appd=gmf(app);
%     gmfmat(c,:)=appd;
%     cls(c)=in;
%     c=c+1;
%    catch
%        err=[err; c-1];
%   end
%     for ji=1:9
%         baseFileName = sprintf('%d_%d.bmp', in,ii);
%         folder=sprintf('C:\Users\ameya\Documents\MATLAB\%d',ji);
%         fullFileName = fullfile(folder, baseFileName);
%         imwrite(app{ji}, fullFileName);
%     end
    
end
end
%folder=sprintf('C:\Users\ameya\Documents\MATLAB\%d\*.bmp',ji);
imds=imageDatastore(ca,'LabelSource','foldernames');
%imgs=readall(imds);
nn=grp2idx(imds.Labels);
for uo=1:length(nn)
    nn(uo)=cls(uo);
    %fv(uo,:)=encode(bag,imgs{uo});
end
imds.Labels=categorical(nn);
bag = bagOfFeatures(imds,'Verbose',false,'CustomExtractor',fh);
clfr=trainImageCategoryClassifier(imds,bag);
nc=1;

for in=1:numVar
    for ii=1:5
        %if(in<10)
            apa=""+in+"_"+ii+".bmp";
        %end
%         if(in>9 && in<100)
%             apa="0"+in+"_"+ii+".bmp";
%         end
%         if(in>99)
%             apa=""+in+"_"+ii+".bmp";
%         end
    %ap=newRoi(apa);
        
    try
    ap=imread(apa);
    
    catch
        continue
    end
    
    [labelIdx(nc,ji), score(nc,ji)] = predict(clfr,ap);
    tst(nc)=in;
    nc=nc+1;
%     if labelIdx==in
%         crt=crt+1;
%     end
%     try
%     app=divImg(ap);
%     appd=gmf(app);
%     aan=predict(ml, appd);
% %     if str2num(aan{1})==in
% %         crt=crt+1;
% %     end
%     if aan==in
%         crt=crt+1;
%     end
%     nc=nc+1;
%     catch
%         err=[err; nc-1];
%     end
%    per=(crt/nc)*100;
    %t="s"+apa;
    %imwrite(ap, t);
    end
end
rmpath(fullFileName);

end
%end of 1:9


nc=nc-1;
for st=1:numVar*5
    [me,~,cn]=mode(labelIdx(st,:));
    if length(cn{1})==1
        if me==tst(st)
            crt=crt+1;
        end
    end
    if length(cn{1})~=1
        prod=ones(length(cn{1}),1);
        for ip=1:length(cn{1})
            for ipo=1:9
                if labelIdx(st,ipo)==cn{1}(ip)
                    prod(ip)=prod(ip)*score(st,ipo);
                end
            end
        end
        [~,indi]=max(prod);
        if cn{1}(indi)==tst(st)
            crt=crt+1;
        end
    end
end
per=(crt/nc)*100;
end


