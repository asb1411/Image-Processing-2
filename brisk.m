function [a,b] = brisk(img)
points = detectBRISKFeatures(img,'NumOctaves',3);
[f,v] = extractFeatures(img,points);
ff=f.Features;
a=single(ff);
b=v.Metric;
end

