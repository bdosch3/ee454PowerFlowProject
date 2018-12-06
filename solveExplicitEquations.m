function [theta, V, P, Q] = ...
solveExplicitEquations(x, Y, N, m, PV, PQ, ...
PV_buses, Vswing, thetaSwing, S_BASE, outputFile, powerInfoOutput)
%{
solveExplicitEquations
  solves the explicit equations that were not solved by newton raphson.
  this function also gathers all the data from the processing and
  compiles each value (theta, V, P, Q) at each bus to be returned to the
  user. this data is still renumbered. explicit values to be solved are
  P and Q at the swing bus as well as Qgen from the generators on the PV
  buses. This function also writes the P and Q values of the generators
  to the output excel file.

  inputs:
             x: column vector of unknowns theta(2:N) and V(m+1:N) (
             Y: admittance matrix (N x N)
             N: number of buses in the system
             m: m - 1 = number of PV buses in the system
             PV: values of PV from the generators in the system (2*m - 2)
             PQ: values of PQ from the loads in the system (2*N - 2)
             PV_buses: list of buses in the system that are PV buses
             Vswing: voltage at the swing bus (bus 1)
             thetaSwing: angle at the swing bus (bus 1)
             S_BASE: apparent power base for per unit scaling
  outputs:
             theta: theta values at buses 1-N
             V: voltage values at buses 1-N 
             P: real power values at buses 1-N
             Q: reactive power values at buses 1-N
%}

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

    Qgen = zeros(N - 1, 1);     
    Pswing = 0;
    k = 1;

    %solve real power injection from the swing bus
    for i = 1:N
        sum = V(k)*V(i)*(real(Y(k, i))*cos(theta(k) - theta(i)) + ...
                   imag(Y(k, i))*sin(theta(k) - theta(i)));
        Pswing = Pswing + sum;
    end

    %solve reactive power injection from the swing bus
    Qswing = 0;
    for i = 1:N
        sum = V(k)*V(i)*(real(Y(k, i))*sin(theta(k) - theta(i)) - ...
                   imag(Y(k, i))*cos(theta(k) - theta(i)));
        Qswing = Qswing + sum;
    end

    %solve for reactive power injections from the PV buses
    for k = 2:m
        Qcomp = 0;
        for i = 1:N
            sum = V(k)*V(i)*(real(Y(k, i))*sin(theta(k) - theta(i)) - ...
                   imag(Y(k, i))*cos(theta(k) - theta(i)));
            Qcomp = Qcomp + sum;
        end
        Qgen(k - 1) = Qcomp + Qload(k - 1);
    end

    %compile this data into matrices and write to excel file
    Qknown = Qgen - Qload;

    P = [Pswing; Pknown];
    Q = [Qswing; Qknown];

    genLabels = ["Bus Number", "Real Power Injection (MW)", ...
                "Reactive Power Injection (MVAr)"];
    genInfo = S_BASE.*[[Pswing; Pgen(1: (m-1))], [Qswing; Qgen(1: (m-1))]];
    genToExcel = [genLabels;[[1; PV_buses], genInfo]];
    xlswrite(outputFile, genToExcel, powerInfoOutput);
end
