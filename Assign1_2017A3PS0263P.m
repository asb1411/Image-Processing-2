addpath('C:\Users\ameya\Documents\MATLAB\Digital Image Processing\Assignment1_2017A3PS0263P');
i=imread('me.jpg');
figure; imshow(i); title('RGB');

j=rgb2gray(i);
figure; imshow(j); title('Grayscale');

m=im2uint8(j);
imageMatrix=m;
figure; imshow(m);

b1=double(bitget(m,1));
b2=double(bitget(m,2));
b3=double(bitget(m,3));
b4=double(bitget(m,4));
b5=double(bitget(m,5));
b6=double(bitget(m,6));
b7=double(bitget(m,7));
b8=double(bitget(m,8));

figure;
subplot(2,2,1)
imshow(b1), title('Bit Plane 1');
subplot(2,2,2)
imshow(b2), title('Bit Plane 2');
subplot(2,2,3)
imshow(b3), title('Bit Plane 3');
subplot(2,2,4)
imshow(b4), title('Bit Plane 4');

figure;
subplot(2,2,1)
imshow(b5), title('Bit Plane 5');
subplot(2,2,2)
imshow(b6), title('Bit Plane 6');
subplot(2,2,3)
imshow(b7), title('Bit Plane 7');
subplot(2,2,4)
imshow(b8), title('Bit Plane 8');

tform=affine2d([2 0.33 0; 0 1 0; 0 0 1]);
trans=imwarp(m,tform);
figure; imshow(trans);
axis on equal;
