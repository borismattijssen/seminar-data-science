image=imread('source.jpg');
[h w d]=size(image);
U = double(reshape(image,w*h,d))/255;

image2=imread('target.jpg');
[h2 w2 d2]=size(image2);
%boundary pixels only
U2 = double(reshape(image2,w2*h2,d2))/255;

a = 2.1;

% coordinates in [x y]
target_coord = [0 10];

%% Write your method here

%inner and boundary gradients only
G = gradient(h2,w2);

%selector matrix, boundary pixels only
S = ;

%gradients of source image
g = G * U;

%source gradients, zero for boundary gradients
g2 = 

leftside =  G' * G + a *  S'*S;
rightside = G'*g2 + a*S'*U2;

U3 = leftside\rightside;

final = U2+U3;
%image =uint8(reshape(U,h,w,d)*255);

%figure, imshow(image)


%image =uint8(reshape(U2,h,w,d)*255);
%figure, imshow(image)
%imwrite(image,'out.png')