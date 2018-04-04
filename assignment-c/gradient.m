function [ G ] = gradient( h, w )
%GRADIENT Summary of this function goes here
%   Detailed explanation goes here

% sizes of the gradients
gradients_x = (w-1)*h;
gradients_y = (h-1)*w;
gradients_total_num = gradients_x + gradients_y;

% The number of values is twice as much as the number of gradients
v_size = 2*gradients_total_num;

% i = row
% j = column
% G(i(k), j(k)) = v(k)
i = zeros(v_size,1);
j = zeros(v_size,1);
v = zeros(v_size,1);

% calculate vertical gradients
pointer_v = 1;
pointer_i = 1;
for x=1:w
    for y=1:h-1
        j(pointer_v) = y + h*(x-1);
        j(pointer_v+1) = y+1 + h*(x-1);
        
        i(pointer_v) = pointer_i;
        i(pointer_v+1) = pointer_i;
        v(pointer_v) = 1;
        v(pointer_v+1) = -1;
        pointer_v = pointer_v + 2;
        pointer_i = pointer_i+1;
    end
end

% calculate horizontal gradients
for x=1:w-1
    for y=1:h
        j(pointer_v) = y + (x-1)*h;
        j(pointer_v+1) = y + x*h;
        
        i(pointer_v) = pointer_i;
        i(pointer_v+1) = pointer_i;
        v(pointer_v) = -1;
        v(pointer_v+1) = 1;
        pointer_v = pointer_v + 2;
        pointer_i = pointer_i+1;
    end
end

% add the 1/2 from the definition
v = v*.5;

% return the sparse matrix
G = sparse(i,j,v);


