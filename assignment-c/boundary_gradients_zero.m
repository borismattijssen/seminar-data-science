function [ g ] = boundary_gradients_zero( g, h, w )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    y_max = (h-1)*w;
    % first column height
    g(1:h-1,:) = 0;
    % middle columns, top row
    columns_from = h;
    columns_step = (h-1);
    columns_to = (w-2)*(h-1) + 1;
    g(columns_from:columns_step:columns_to,:) = 0;
    % middle columns, bottom row
    columns_from = columns_from + (h-2);
    columns_to = columns_to + (h-2);
    g(columns_from:columns_step:columns_to,:) = 0;
    % last column height
    g(y_max-h+1:y_max,:) = 0;
    
    
    % left column
    offset_left = y_max+1;
    g(offset_left:offset_left+h-1,:) = 0;
    % middle columns, top row
    columns_from = y_max+1;
    columns_step = h;
    columns_to = columns_from + (w-2)*h;
    g(columns_from:columns_step:columns_to,:) = 0;
    % middle columns, bottom row
    columns_from = columns_from + h - 1;
    columns_step = h;
    columns_to = columns_to + h - 1;
    g(columns_from:columns_step:columns_to,:) = 0;
    % right column
    offset_right = offset_left + (w-2)*h;
    g(offset_right:offset_right+h-1,:) = 0;
    
end

