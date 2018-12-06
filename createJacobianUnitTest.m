%unit test for the jacobian

%create random numbers (hope N > m)
N = round(30*rand());
m = round(5*rand());
Yreal = rand(N,N);
Yimag = rand(N,N);
Y = Yreal + j*Yimag;
PV = 1.2*rand(2*m - 2, 1);
PQ = 1.4*rand(2*N - 2, 1);
x = rand(2*N - m - 1, 1);
vswing = 1.05;
tswing = 0;

%run the function and see if reasonable
A = createJacobian(x, Y, N, m, PV, PQ(2:N), vswing, tswing);
%[theta_test, v_test] = recover_x(x, PV, dict, tswing, vswing, m, N);
Ainv = inv(A);
 