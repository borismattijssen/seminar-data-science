% shape = [
% 0 1 1 1 1;
% 1 1 1 1 1;
% 1 1 1 1 1;
% 1 1 1 1 0];
% shape = [
% 0 1 1 1 1;
% 1 1 1 0 0;
% 0 1 1 1 1;
% 1 1 1 1 0]

% define a shape
shape = [
0 1 1;
1 1 0;
0 1 1;]

% make a test "image"
[h w] = size(shape);
U = shape*(rand*256);

% this is the gradient vector we expect
g_expected = 0.5*[
 U(1,2) - U(2,2);
 U(2,2) - U(3,2);

 U(2,2) - U(2,1);
 U(1,3) - U(1,2);
 U(3,3) - U(3,2)];

% compute gradient matrix
G = gradient_flex(shape);
% flatten and remove zeros
U = double(reshape(U,w*h,1));
U = U(U ~= 0);
% compute the gradient vector
g_computed = G*U;

% check if g_expected and g_computed are equal
sum(g_expected == g_computed) == length(g_expected)