clear
image=imread('blurryImage.png');
[h w d]=size(image);
U = double(reshape(image,w*h,d))/255;
%% Write your method here
cs = 3.2;
cu = 0.5;

G = gradient(h,w);
g = G * U;

L = G'*G;
rightside = cs*G'*g + cu*U;
leftside =  L + cu*speye(size(L));


U2 = leftside\rightside;

image =uint8(reshape(U,h,w,d)*255);

figure, imshow(image)


image =uint8(reshape(U2,h,w,d)*255);
figure, imshow(image)
imwrite(image,'out.png')