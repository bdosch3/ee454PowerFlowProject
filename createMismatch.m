function [f_x_new, f_comp] = createMismatch(x, Y, N, m, PV, PQ, Vswing, thetaSwing)
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
Pgen   = [PV(1 : (m - 1)); zeros(N-m,1)];
%P values from PQ will be negative injections into the system (ie a load)
Pload  = PQ(1 : (N - 1));
%Q values taken from the "bottom" of PQ will be negative injections
%positive Q injections for the generators will be explicit equations
Qload  = PQ(N : length(PQ));
%pKnown = pGen - pLoad
Pknown = Pgen - Pload;
     
%initiate f_x_new (new mismatch equations)
f_x_new = zeros(2*N - m - 1, 1);
f_comp  = zeros(N - 1, 1);
%loop through the P mismatches first. k and i represent the same indices as
%the P and Q equations in the lecture 10 notes
for k = 2:N
    Pcomp = 0;
    for i = 1:N
        sum = V(k)*V(i) * ((real(Y(k,i))*cos(theta(k) - theta(i))) + (imag(Y(k,i))*sin(theta(k) - theta(i))));
        Pcomp = Pcomp + sum;
    end
    f_x_new(k - 1) = Pcomp - Pknown(k - 1);
    f_comp (k - 1) = Pcomp;
end

%next loop through Q mismatches
for k = (m+1):N
    Qcomp = 0;
    for i = 1:N
        sum = V(k)*V(i) * ((real(Y(k,i))*sin(theta(k) - theta(i))) - (imag(Y(k,i))*cos(theta(k) - theta(i))));
        Qcomp = Qcomp + sum;
    end
    f_x_new(k + N - m -1) = Qcomp + Qload(k - 1);
end