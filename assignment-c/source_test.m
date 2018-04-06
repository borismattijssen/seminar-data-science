% source image
image_source=imread('source.jpg');
[h_source w_source d_source]=size(image_source);
U_source = double(reshape(image_source,w_source*h_source,d_source))/255;

% extend with padding
w_extended = w_source + 2;
h_extended = h_source + 2;
source_padded = padarray(image_source, [1 1], 0);
U_extended_black = double(reshape(source_padded,w_extended*h_extended,d_source))/255;

source_padded = padarray(image_source, [1 1], 255);
U_extended_white = double(reshape(source_padded,w_extended*h_extended,d_source))/255;