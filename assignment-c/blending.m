 image=imread('target.jpg');
[h w d]=size(image);
U = double(reshape(image,w*h,d))/255;

image2=imread('source.jpg');
[h2 w2 d2]=size(image2);
%boundary pixels only
U2 = double(reshape(image2,w2*h2,d2))/255;

a = 0.2;

%% Write your method here
%g = zeros(h*w,d);
%for i=1:h*w
%    for j=1:3
%        g(i,j) = (U(i+1,j) - U(i,j) + U(i-1,j) - U(i,j) + U(i+w,j) - U(i,j) + U(i-w,j) - U(i,j))/2;
%    end
%end

%inner and boundary gradients only
G = gradient(h2,w2);

%selector matrix, boundary pixels only
[S,T] = select_boundary(h2,w2,h,w,211,81);
Ub = S*U;
[S2, T2] = select_boundary2(h2,w2);

%gradients of source image
g = G * U2;
G = gradient(h,w);

%source gradients, zero for boundary gradients
[S3,T3] = select_inner(h2,w2,h,w,211,81);
g2 = G*U;
T=T(1:size(T,2)-1);
g2(T,:) = 0;
for i=1:size(T3,2)
    g2(T3(i)) = g(i);
end


leftside =  G' * G + a *  S'*S;
rightside = G'*g2 + a*S'*Ub;

U3 = leftside\rightside;

for i=1:size(T3,2)
    U(T3(i)) = U3(T3(i));
end

%final = U + U3;
image =uint8(reshape(U,h,w,d)*255);

figure, imshow(image)


%image =uint8(reshape(U2,h,w,d)*255);
%figure, imshow(image)
%imwrite(image,'out.png')