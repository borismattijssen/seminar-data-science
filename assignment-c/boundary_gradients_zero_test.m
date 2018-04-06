clc
img = [
    1 5  9 13;
    2 6 10 14;
    3 7 11 15;
    4 8 12 16];
g_expected = 0.5*[
        0
    0
    0
    0
    6 - 7
    0
    0
    10 - 11
    0
    0
    0
    0
    0
    0
    0
    0
    0
    10 - 6
    11 - 7
    0
    0
    0
    0
    0];
    

[h w] = size(img);

U = double(reshape(img,w*h,1));
G = gradient(h,w);

g = G*U;
g = boundary_gradients_zero(g, w, h);

sum(g_expected == g) == length(g_expected)