function [f_x_new] = createMismatch(x, Y, N, m, PV, PQ)
%createMismatch Creates the mismatch equations
%   inputs: ...
%   outputs: ...

V      = [PV(N : length(PV)); x(N : length(x))];
theta  =  x(1 : (N - 1));
pGen   = PV(1 : (m - 1));
pLoad  = PQ(1 : (N - 1));
pKnown = [pGen - pLoad(1 : length(pGen)); ... 
         (pLoad(length(pGen) + 1) : length(pLoad))];
f_x_new = zeros(2*N - m - 1, 1);
for k = 2:N
    pComp = 0;
    for i = 1:N
        sum = V(k)*V(i) * (real(Y(k,i))*cos(theta(k) - theta(i)) ...
                        + (imag(Y(k,i))*sin(theta(k) - theta(i))));
        pComp = pComp + sum;
    end
    f_x_new(k - 1) = pComp - pKnown(k - 1);
end

