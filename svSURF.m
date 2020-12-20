cd('C:\Users\ameya\Documents\MATLAB\proSURF');
for i=1:230
    cd('C:\Users\ameya\Documents\MATLAB\proSURF');
    s="s";
    if i<=9
        s=s+"00"+i+"_";
    end
    if (i>9 && i<=99)
        s=s+"0"+i+"_";
    end
    if i>99
        s=s+i+"_";
    end
    mkdir (""+i);
    jj=""+i;
    h=fullfile('C:\Users\ameya\Documents\MATLAB\proSURF',jj);
    cd(h);
    for j=1:6
        try
            ss=s+j+".jpg";
            h=fullfile('C:\Users\ameya\Documents\MATLAB\RoiN',ss);
            a=imread(h);
            pts=detectSURFFeatures(a);
            imshow(a); hold on;
            anss=plot(pts.selectStrongest(10));
            d=getframe(anss);
            [anns,x]=frame2im(d);
            imwrite(anns,ss);
            close;
        catch
            ss=s+"1"+".jpg";
            h=fullfile('C:\Users\ameya\Documents\MATLAB\RoiN',ss);
            a=imread(h);
            ss=s+j+".jpg";
            pts=detectSURFFeatures(a);
            imshow(a); hold on;
            anss=plot(pts.selectStrongest(10));
            d=getframe(anss);
            [anns,x]=frame2im(d);
            imwrite(anns,ss);
            close;
        end
    end
end