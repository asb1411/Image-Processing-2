function [x,y] =  rotateCoordinates(x, y, originx, originy, dir)
% Rotating a pixel around an origins
    p = [x,y,1]';
    translate = [1,0,-originx;0,1,-originy;0,0,1];
    rotate = [cosd(dir),-sind(dir),0;sind(dir),cosd(dir),0;0,0,1];
    translateBack = [1,0,originx;0,1,originy;0,0,1];
    p = translateBack*rotate*translate*p;
    x = floor(p(1));y = floor(p(2));
end