% make a test "image"
w = 3;
h = 3;
U = rand(w,h)*256;

% this is the gradient vector we expect
g_expected = 0.5*[
     U(1,1) - U(2,1);
     U(2,1) - U(3,1);
     
     U(1,2) - U(2,2);
     U(2,2) - U(3,2);
     
     U(1,3) - U(2,3);
     U(2,3) - U(3,3);
     
     U(1,2) - U(1,1);
     U(2,2) - U(2,1);
     U(3,2) - U(3,1);
     
     U(1,3) - U(1,2);
     U(2,3) - U(2,2);
     U(3,3) - U(3,2)];
 
% compute gradient matrix
G = gradient(w,h);
% flatten the image
U = double(reshape(U,w*h,1));
% compute the gradient vector
g_computed = G*U;

% check if g_expected and g_computed are equal
sum(g_expected == g_computed) == length(g_expected)