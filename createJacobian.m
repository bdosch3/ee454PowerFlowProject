function [J_new] = createJacobian(x, Y, N, m, PV, PQ, Vswing, thetaSwing)
%createMismatch Creates the mismatch equations
%   inputs:
%              x: column vector of unknowns theta(2:N) and V(m+1:N) (
%              Y: admittance matrix (N x N)
%              N: number of buses in the system
%              m: m - 1 = number of PV buses in the system
%              PV: values of PV from the generators in the system (2*m - 2)
%              PQ: values of PQ from the loads in the system (2*N - 2)
%              Vswing: voltage at the swing bus (bus 1)
%              thetaSwing: angle at the swing bus (bus 1)
%   outputs:
%              f_x_new: new mismatch equations

%voltage values are taken from PV buses if known. if not known, they are
%taken from the values of x[]
V      = [Vswing; PV(m : length(PV)); x(N : length(x))];
%theta values are the first 2:N entries in x
theta  =  [thetaSwing; x(1 : (N - 1))];
%P values from PV will be positive injections into the system (ie a gen.)
pGen   = PV(1 : (m - 1));
%P values from PQ will be negative injections into the system (ie a load)
pLoad  = PQ(1 : (N - 1));
%Q values taken from the "bottom" of PQ will be negative injections
%positive Q injections for the generators will be explicit equations
qLoad  = PQ(N : length(PQ));
     
%initiate J_new (new Jacobian square matrix)
%size of J = 2(N-1) by 2(N-1)
J_new = zeros(2*N-2);

%k and i represent row and column number respectively
%the derivative equations are obtained in the lecture 10 notes

%loop through k
for k = 1:(2*N-2)
    %loop through j
    for j = 1:(2*N-2)
        % at J_11
        if j <= (N-1) && k <= (N-1)
            if j ~= k
                J_new(k,j) = V(k+1)*V(j+1)*(real(Y(k+1,j+1))*sin(theta(k+1)-theta(j+1))... 
                            - (imag(Y(k+1,j+1)))*cos(theta(k+1)-theta(j+1)));
            else
                J_new(k,j) = -qLoad(k)-(V(k+1)^2)*(imag(Y(k+1,j+1)));
            end
        % at J_21    
        elseif j <= (N-1) && k > (N-1)
            if j ~= k
                J_new(k,j) = -V(k+2-N)*V(j+1)*((real(Y(k+2-N,j+1)))*(cos(theta(k+2-N)-theta(j+1)))... 
                            + (imag(Y(k+2-N,j+1))*(sin(theta(k+2-N)-theta(j+1)))));
            else
                J_new(k,j) = pLoad(k+1-N)-(V(k+2-N)^2)*(real(Y(k+2-N,j+1)));
            end
        % at J_12
        elseif j > (N-1) && k <= (N-1)
            if j ~= k
                J_new(k,j) = V(k+1)*(real(Y(k+1,j+2-N))*cos(theta(k+1)-theta(j+2-N))... 
                            + (imag(Y(k+1,j+2-N)))*sin(theta(k+1)-theta(j+2-N)));
            else
                J_new(k,j) = (pLoad(k)/V(k+1)) + V(k+1)*(real(Y(k+1,j+2-N)));
            end
        % at J_22
        else
            if j ~= k
                J_new(k,j) = V(k+2-N)*((real(Y(k+2-N,j+2-N)))*(sin(theta(k+2-N)-theta(j+2-N)))... 
                            - (imag(Y(k+2-N,j+2-N)))*(cos(theta(k+2-N)-theta(j+2-N))));
            else
                J_new(k,j) = (qLoad(k+1-N)/V(k+2-N))-V(k+2-N)*(real(Y(k+2-N,j+2-N)));
            end
        end
    end
end
%J_new(k,j) = 0;
                %for i = 1:N
                   % if i ~= k+1
                      %  J_new(k,j) = J_new(k,j) +  V(k+1)*V(j+1)*(-real(Y(k+1,i))*sin(theta(k+1)-theta(i))
                         %           + imag(Y(k+1,i))*cos(theta(k+1)-theta(i)));
                         %if i ~= k+1
                        %J_new(k,j) = J_new(k,j) +  V(k+1)*V(j+1)*(-real(Y(k+1,i))*sin(theta(k+1)-theta(i))
                                    %+ imag(Y(k+1,i))*cos(theta(k+1)-theta(i)));
                    %end
               % end