function [ num ] = zeros_encountered( area, y, x )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    % find sizes
    [h w] = size(area);
    % flatten
    flat = reshape(area,w*h,1);
    % position of the x,y coordinate in the flattend format
    xy_flat = (x-1)*h + y;
    % subarray that is until the xy_flat coordinate
    until = flat(1:xy_flat-1);
    
    % assume we only have 1s or 0s
    num = length(until) - sum(until);

end

