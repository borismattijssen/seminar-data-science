image=imread('target.jpg');
[h w d]=size(image);
U = double(reshape(image,w*h,d))/255;

image2=imread('source.jpg');
[h2 w2 d2]=size(image2);
%boundary pixels only
U2 = double(reshape(image2,w2*h2,d2))/255;

x=211;
y=81;

%[s,t] =  select_boundary(h2,w2,h,w,x,y);
[s,t] = select_boundary2(h2,w2);
U2(t,:) = 0;

%image3 =uint8(reshape(U,h,w,d)*255);

%figure, imshow(image3)

%[s,t] = select_inner(h2,w2,h,w,x,y);
%U(t,:) = 0.5;
image =uint8(reshape(U2,h2,w2,d)*255);

figure, imshow(image)
% hd = h;
% wd = w;
% hs = h2;
% ws = w2;
% T=[];
% v = y*hd + x;
% (x+hs)*(y*ws)
% for i=1:hs+1
%     T(i) = v;
%     v = v+1;
% end
% 
% v = (y+1)* hd + x;
% for i=hs+2:2:hs+2*ws-3
%     T(i) = v;
%     v = v + hs;
%     T(i+1) = v;
%     v = v + hd - hs;
% end
% 
% v = (y+ws-1)* hd + x;
% for i=hs+2*ws-2:2*hs+2*ws-2
%     T(i) = v;
%     v = v + 1;
% end
% S = T;
% U = double(reshape(image,w*h,d))/255;
% U(S,:) = 0;
% image =uint8(reshape(U,h,w,d)*255);
% 
% figure, imshow(image)
