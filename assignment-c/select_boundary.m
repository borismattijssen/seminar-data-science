function [ S, T ] = select_boundary( hs, ws, hd, wd, x ,y)
%GRADIENT Summary of this function goes here
%   Detailed explanation goes here

%x = round(rand() * (hd - hs));
%y = round(rand() * (wd - ws));


T=[];
v = y*hd + x;
%(x+hs)*(y*ws)
for i=1:hs+1
    T(i) = v;
    v = v+1;
end

v = (y+1)* hd + x;
for i=hs+2:2:hs+2*ws-3
    T(i) = v;
    v = v + hs;
    T(i+1) = v;
    v = v + hd - hs;
end

v = (y+ws-1)* hd + x;
for i=hs+2*ws-2:2*hs+2*ws-2
    T(i) = v;
    v = v + 1;
end
T(i+1) = hd*wd;
v = ones(size(T));
v(size(T,2)) = 0;
S = sparse(T,T,v);
end