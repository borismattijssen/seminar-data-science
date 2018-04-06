clc
w = 4;
h = 4;
img = rand(h,w)*256;
g_expected = 0.5*[
    0
    0
    0
    0
    img(2,2) - img(3,2)
    0
    0
    img(2,3) - img(3,3)
    0
    0
    0
    0
    0
    0
    0
    0
    0
    img(2,3) - img(2,2)
    img(3,3) - img(3,2)
    0
    0
    0
    0
    0];
    

[h w] = size(img);

U = double(reshape(img,w*h,1));
G = gradient(h,w);

g = G*U;
g = boundary_gradients_zero(g, h, w);

sum(g_expected == g) == length(g_expected)