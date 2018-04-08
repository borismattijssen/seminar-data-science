function [] =  sharpening(input_filename, output_filename, cs, cu)

image=imread(input_filename);
[h w d]=size(image);
U = double(reshape(image,w*h,d))/255;
cs = cs;
cu = cu;
G = gradient2(h,w);
g = G * U;

L = G'*G;
rightside = cs*G'*g + cu*U;
leftside =  L + cu*speye(size(L));

U2 = leftside\rightside;

image =uint8(reshape(U,h,w,d)*255);
figure
subplot(2,1,1), imshow(image)
title('Original Image')

image2 =uint8(reshape(U2,h,w,d)*255);
subplot(2,1,2), imshow(image2)
title('Sharpened Image')

imwrite(image2,output_filename)