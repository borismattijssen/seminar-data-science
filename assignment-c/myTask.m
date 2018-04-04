image=imread('blurryImage.png');
[h w d]=size(image);
U = double(reshape(image,w*h,d))/255;
cs = 3.2;
cu = 0.5;
%% Write your method here
%g = zeros(h*w,d);
%for i=1:h*w
%    for j=1:3
%        g(i,j) = (U(i+1,j) - U(i,j) + U(i-1,j) - U(i,j) + U(i+w,j) - U(i,j) + U(i-w,j) - U(i,j))/2;
%    end
%end


G = gradient(h,w);
g = G * U;

L = G'*G;
rightside = cs*G'*g + cu*U;
leftside =  L + cu*eye();


U2 = leftside\rightside;

image =uint8(reshape(U,h,w,d)*255);

figure, imshow(image)


image =uint8(reshape(U2,h,w,d)*255);
figure, imshow(image)
imwrite(image,'out.png')