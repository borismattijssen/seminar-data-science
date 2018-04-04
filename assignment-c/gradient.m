function [ G ] = gradient( h, w )
%GRADIENT Summary of this function goes here
%   Detailed explanation goes here
%i = zeros(2*h*(w-1)+2*w*(h-1),1);
%j = zeros(2*h*(w-1)+2*w*(h-1),1);
%v = zeros(2*h*(w-1)+2*w*(h-1),1);

% collect triplets here

mmax = h*w-1-h;
i = zeros(mmax*3,1);
j = zeros(mmax*3,1);
v = zeros(mmax*3,1);
k = 2;
for m=1:mmax
    i(2*(k-2)+m) = k-1;
    i(2*(k-2)+m +1) = k-1;
    i(2*(k-2)+m +2) = k-1;
    j(2*(k-2)+m) = k-1;
    j(2*(k-2)+m +1) = k;
    j(2*(k-2)+m +2) = k+h;
    v(2*(k-2)+m) = 1/2;
    v(2*(k-2)+m +1) = -1;
    v(2*(k-2)+m +2) = 1/2;
    k= k +1;
end


G = sparse(i,j,v);


