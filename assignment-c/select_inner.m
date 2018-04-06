function [ S, T ] = select_inner( hs, ws, hd, wd, x ,y)
%GRADIENT Summary of this function goes here
%   Detailed explanation goes here

%x = round(rand() * (hd - hs));
%y = round(rand() * (wd - ws));


T=[];
v = (y+1)*hd +x+1;
c = 0;
for i=1:(hs-1)*(ws-2)
    T(i) = v;
    c = c + 1;
    if mod(c,hs-1) == 0
        v = v + hd - hs + 2;
    else    
        v = v+1;
    end
end

S = sparse(T,ones(size(T)),ones(size(T)));
end