function [] = check(numVar, numImg)
% c=0;
% crt=0;
for in=1:numVar
for ii=1:numImg
    if(in<10)
        apa="s00"+in+"_"+ii+".JPG";
        apa2="s200"+in+"_"+ii+".JPG";
    end
    if(in>9 && in<100)
        apa="s0"+in+"_"+ii+".JPG";
        apa2="s20"+in+"_"+ii+".JPG";
    end
    if(in>99)
        apa="s"+in+"_"+ii+".JPG";
        apa2="s2"+in+"_"+ii+".JPG";
    end
    %ap=newRoi(apa);
    try
    ap=imread(apa);
    ap2=imread(apa2);
    catch 
        continue
    end
    if ap==0
        if ap2~=0
            imwrite(ap2, apa);
        end
    end
    if ap~=0
        if ap2~=0
            if std2(ap2)<std2(ap)
            imwrite(ap2, apa);
            end
        end
    end
end
end
end

