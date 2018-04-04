w = 3;
h = 3;
U = rand(w,h)*256;

g_expected = 0.5*[
     U(1,1) - U(2,1);
     U(2,1) - U(3,1);
     
     U(1,2) - U(2,2);
     U(2,2) - U(3,2);
     
     U(1,3) - U(2,3);
     U(2,3) - U(3,3);
     
     U(1,2) - U(1,1);
     U(1,3) - U(1,2);
     
     U(2,2) - U(2,1);
     U(2,3) - U(2,2);
     
     U(3,2) - U(3,1);
     U(3,3) - U(3,2)];
 
G = gradient(w,h);
U = double(reshape(U,w*h,1));
g_computed = G*U;

sum(g_expected == g_computed) == length(g_expected)