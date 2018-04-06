function [ S ] = selmat_square( w,h )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    pixels_x = 2*w;
    pixels_y = 2*h;
    pixels_overlap = 4;
    pixels_total = pixels_y + pixels_x - pixels_overlap;

    i = zeros(pixels_total,1);
    j = zeros(pixels_total,1);
    v = zeros(pixels_total,1);
    
    pointer_v = 1;
    pointer_j = 1;
    % pixels left
    for x=1:w
        for y=1:h
            % first column of pixels
            if(x == 1)
                j(pointer_v) = pointer_j;
                i(pointer_v) = pointer_v;
                v(pointer_v) = 1;
                pointer_v = pointer_v + 1;
            end
            % middle columns
            if (x > 1 && x < w)
               % first row
               if (y == 1 || y == h)
                    j(pointer_v) = pointer_j;
                    i(pointer_v) = pointer_v;
                    v(pointer_v) = 1;
                    pointer_v = pointer_v + 1;
               end
            end
            % last column
            if (x == w) 
                j(pointer_v) = pointer_j;
                i(pointer_v) = pointer_v;
                v(pointer_v) = 1;
                pointer_v = pointer_v + 1;
            end
            pointer_j = pointer_j + 1;
        end
    end
    
    S = sparse(i,j,v);

end

