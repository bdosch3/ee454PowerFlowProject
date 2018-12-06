function Qcomp = computeQ(Y, N, m, theta, V)
%{
computes Q values for bus 2 to bus 12
inputs:
    Y: admittance matrix (Nx)
    N: number of buses in the system
    m: m - 1 = number of PV buses in the system
    theta: values from the first 2:N entries in x
    V: values from the last N+1:length(x) entries in x
outputs:
    Qcomp: computed Q2 to Q12 values
%}

% Qcomp is 11x1 vector
Qcomp = zeros(N-1, 1);
    for k = 2:N
        Qsum = 0;
        for i = 1:N
            sum = V(k)*V(i) * (real(Y(k,i))*sin(theta(k) - theta(i)) ...
                            - (imag(Y(k,i))*cos(theta(k) - theta(i))));
            Qsum = Qsum + sum;
        end
        % index offset
        Qcomp(k-1) = Qsum;
    end
end
