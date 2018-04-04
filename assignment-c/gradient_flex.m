function [ G ] = gradient_flex( shape )
%GRADIENT Summary of this function goes here
%   Detailed explanation goes here

[h w] = size(shape);

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

pointer_v = 1;
pointer_i = 1;
zeros_encountered_count = 0;
for x=1:w
    for y=1:h-1
        if shape(y,x) == 0
            zeros_encountered_count = zeros_encountered_count + 1;
        end
        if shape(y,x) == 0 || shape(y+1,x) == 0
            continue
        end
        j(pointer_v) = y + h*(x-1) - zeros_encountered_count;
        j(pointer_v+1) = y+1 + h*(x-1) - zeros_encountered_count;
        
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
        if shape(y,x) == 0 || shape(y,x+1) == 0
            continue
        end
        % count amount of zeros up until this cell
        j(pointer_v) = y + (x-1)*h - zeros_encountered(shape, y,x);
        j(pointer_v+1) = y + x*h - zeros_encountered(shape, y,x+1);
        
        i(pointer_v) = pointer_i;
        i(pointer_v+1) = pointer_i;
        v(pointer_v) = -1;
        v(pointer_v+1) = 1;
        pointer_v = pointer_v + 2;
        pointer_i = pointer_i+1;
    end
end

% remove trailing zeros
i = i(1:find(i,1,'last'));
j = j(1:find(j,1,'last'));
v = v(1:find(v,1,'last'));

% add the 1/2 from the definition
v = v*.5;

% return the sparse matrix
G = sparse(i,j,v);