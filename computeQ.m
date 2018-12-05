function Qcomp = computeQ(Y, N, m, theta, V)
%next loop through Q mismatches
Qcomp = zeros(N-1, 1);
    for k = 2:N
        Qsum = 0;
        for i = 1:N
            sum = V(k)*V(i) * (real(Y(k,i))*sin(theta(k) - theta(i)) ...
                            - (imag(Y(k,i))*cos(theta(k) - theta(i))));
            Qsum = Qsum + sum;
        end
        Qcomp(k-1) = Qsum;
    end
end
