function [] = rw(numVar, numImg)
for in=1:numVar
for ii=1:numImg
    if(in<10)
        apa="00"+in+"_"+ii+".JPG";
    end
    if(in>9 && in<100)
        apa="0"+in+"_"+ii+".JPG";
    end
    if(in>99)
        apa=""+in+"_"+ii+".JPG";
    end
    try
    ty=imread(apa);
    catch
        continue
    end   
    app=newRoi(apa);
    apn="s2"+apa;
    imwrite(app, apn);
end
end
end

