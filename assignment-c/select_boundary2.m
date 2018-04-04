function [ S,T ] = select_boundary2(hs, ws)
%GRADIENT Summary of this function goes here
%   Detailed explanation goes here


T=[];
v = 1;

for i=1:hs
    T(i) = v;
    v = v+1;
end

v = hs + 1;
for i=hs+1:2:hs+2*ws-4
    T(i) = v;
    v = v + hs - 1;
    T(i+1) = v;
    v = v + 1;
end

v = hs * (ws-1);
for i=hs+2*ws-3:2*hs+2*ws-4
    T(i) = v;
    v = v + 1;
end
S = sparse(T,ones(size(T)),ones(size(T)));
end