w = 4;
h = 4;
img = rand(h,w)*256;

U_expected = [
    img(1,1)
    img(2,1)
    img(3,1)
    img(4,1)

    img(1,2)
    img(4,2)

    img(1,3)
    img(4,3)

    img(1,4)
    img(2,4)
    img(3,4)
    img(4,4)
];
U_img = reshape(img,w*h,1);

S = selmat_rect(h, w);
U_computed = S*U_img;

sum(U_expected == U_computed) == length(U_expected)