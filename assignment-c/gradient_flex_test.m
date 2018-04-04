% shape = [
% 0 1 1 1 1;
% 1 1 1 1 1;
% 1 1 1 1 1;
% 1 1 1 1 0];
shape = [
0 1 1 1 1;
1 1 1 0 0;
0 1 1 1 1;
1 1 1 1 0]

G = gradient_flex(shape);

2*full(G)