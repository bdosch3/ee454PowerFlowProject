function iterationRecord = recordIteration(f_x, S_BASE, count, dictionary, N, m)
%{
iterationRecord: keeps a log of the maxiumum real and reactive mismatches
of each Newton Raphson iteration
inputs:
    f_x: the current mismatch equations
    S_BASE: apparent power base for per unit scaling
    count: the iteration number
    dictionary: look up table used for renumbering
    N: number of buses in the system
    m: m - 1 = number of PV buses in the system 
output:
    iterationRecord: max real and reactive power mismatches for the current
    iteration and where at which that occurs
    
    iterationNumber    max P    bus    max Q   bus
    -----------------------------------------------
        count            ~       ~       ~      ~
%}

    iterationRecord = [];
     iterationRecord(1) = count;
    [P_max, P_index] = max(abs(f_x(1 : N - 1)));
    [Q_max, Q_index] = max(abs(f_x(N : length(f_x))));
    
    dict = [1;dictionary];
    
    iterationRecord(2) = S_BASE * P_max;
    iterationRecord(3) = dict(P_index + 1);
    iterationRecord(4) = S_BASE * Q_max;
    iterationRecord(5) = dict(Q_index + m);
    
end

