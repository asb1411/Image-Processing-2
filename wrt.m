function [] = wrt(numVar, numImg)
for in=1:numVar
for ii=1:numImg
    if(in<10)
        apa="00"+in+"_"+ii+".bmp";
    end
    if(in>9 && in<100)
        apa="0"+in+"_"+ii+".bmp";
    end
    if(in>99)
        apa=""+in+"_"+ii+".bmp";
    end
    try
    q=imread(apa);
    catch
        continue
    end
    ap=adapthisteq(q);
    imwrite(ap, apa);
end
end
end

