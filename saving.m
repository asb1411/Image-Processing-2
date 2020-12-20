cd('C:\Users\ameya\Documents\MATLAB\CNNData');
for i=1:230
    cd('C:\Users\ameya\Documents\MATLAB\CNNData');
    s="ROI-";
    if i<=9
        s=s+"00"+i+"_";
    end
    if (i>9 && i<=99)
        s=s+"0"+i+"_";
    end
    if i>99
        s=s+i+"_";
    end
    s=s+"F_0";
    mkdir (""+i);
    jj=""+i;
    h=fullfile('C:\Users\ameya\Documents\MATLAB\CNNData',jj);
    cd(h);
    for j=1:9
        try
            ss=s+j+".bmp";
            ss1=s+j+".jpg";
            h=fullfile('C:\Users\ameya\Documents\MATLAB\PRoiN',ss);
            a=imread(h);
            imwrite(a,ss1);
        catch
            ss=s+"1"+".bmp";
            h=fullfile('C:\Users\ameya\Documents\MATLAB\PRoiN',ss);
            a=imread(h);
            ss=s+j+".jpg";
            imwrite(a,ss);
        end
    end
end