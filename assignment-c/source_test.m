% source image
image_source=imread('source.jpg');
[h_source w_source d_source]=size(image_source);
U_source = double(reshape(image_source,w_source*h_source,d_source))/255;

% extend with black padding
extended = padarray(image_source, [1 1], 0);
[h_extended w_extended d_extended]=size(extended);
U_extended_black = double(reshape(extended,w_extended*h_extended,d_extended))/255;

% extend with white padding
extended = padarray(image_source, [1 1], 0);
[h_extended w_extended d_extended]=size(extended);
U_extended_white = double(reshape(extended,w_extended*h_extended,d_extended))/255;

% compute gradient vectors
G = gradient(h_extended, w_extended);
g_black = G*U_extended_black;
g_white = G*U_extended_white;

% set to zero
g_black = boundary_gradients_zero(g_black, h_extended, w_extended);
g_white = boundary_gradients_zero(g_white, h_extended, w_extended);

% compare
[g_height g_width] = size(g_black);
sum(sum(g_black == g_white)) == g_height*g_width