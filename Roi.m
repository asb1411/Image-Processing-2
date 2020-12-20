function [img, phalange1, phalange2, phalange3, phalange4] = Roi(name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
width=350;
height=400;
A=name;
%A = imread(name);
G1 = rgb2gray(A);
G=imadjust(G1);
G1=imgaussfilt(G1,29);
%GG=imgaussfilt(G, 29);
GG = imboxfilt(G, 15);
%GG=imboxfilt(A, 11);
BW = im2bw(GG, graythresh(GG));
[B,~,~] = bwboundaries(BW,'noholes');
centroid = regionprops(BW,'Centroid');
centroid = centroid.Centroid;
%[w, h]=size(G);
outline = flipud(B{1});
regionLine = zeros(length(outline),3);
for i = 1:length(outline)
    regionLine(i,:) = [outline(i,2) outline(i,1) sqrt((outline(i,2)-centroid(1))^2+(outline(i,1)-centroid(2))^2)];
end
[~, i] = findpeaks(smooth(-regionLine(:,3),50),'MINPEAKDISTANCE',60,'MINPEAKHEIGHT',mean(-regionLine(:,3)));
ri=zeros(1,2);
if regionLine(i(1),2)>centroid(2)
    if (regionLine(i(1),1)+80)<regionLine(i(2),1)
        ri=[ri;[regionLine(i(1),1) regionLine(i(1),2)]];
    end
end  
for o=1:length(i)
    if regionLine(i(o),2)<centroid(2)
        ri=[ri;[regionLine(i(o),1) regionLine(i(o),2)]];
    end
end
ri=sortrows(ri);
xmin=floor((ri(2,1)+ri(3,1))/2); ymin=floor((ri(3,2)+ri(2,2))/2);
%if (typecast(G(xmin, ymin+399), 'int8')==0)
%xmin=xmin+25;
%end;
%ox=xmin;
while (G(xmin, ymin+397)<25)
   xmin=xmin+10;
end
crop=imcrop(G1, [xmin ymin width-1 height-1]);
img=crop;
mp=zeros(length(ri)-2, 1);
for u=2:(length(ri)-1)
    mp(u-1,1)=(ri(u,1)+ri(u+1,1))/2;
    mp(u-1,2)=(ri(u,2)+ri(u+1,2))/2;
end
phalange1=imcrop(G, [mp(1,1)-200, mp(1,2)-200, 199, 129]);
phalange2=imcrop(G, [mp(2,1)-100, mp(2,2)-250, 199, 129]);
phalange3=imcrop(G, [mp(3,1)-100, mp(3,2)-250, 199, 129]);
phalange4=imcrop(G, [mp(3,1)-100, mp(3,2)-250, 199, 129]);
end


