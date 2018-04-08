function [] =  sharpening(input_filename, output_filename, cs, cu)

%read and rescale input image
image=imread(input_filename);
[h w d]=size(image);
U = double(reshape(image,w*h,d))/255;

%create gradient matrix G
G = gradient(h,w);

%compute gradients of input image
g = G * U;

%compute right and left hand size of linear system
L = G'*G;
rightside = cs*G'*g + cu*U;
leftside =  L + cu*speye(size(L));

%solve linear system
U2 = leftside\rightside;

%display original image
image =uint8(reshape(U,h,w,d)*255);
figure
subplot(2,1,1), imshow(image)
title('Original Image')

%display sharpened image
image2 =uint8(reshape(U2,h,w,d)*255);
subplot(2,1,2), imshow(image2)
title('Sharpened Image')

%save sharpened image to file
imwrite(image2,output_filename)
end
