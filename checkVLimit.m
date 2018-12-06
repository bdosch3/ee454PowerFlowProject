function VLimit = checkVLimit(V)
%{
checks if calculated V exceeds the V range: 
0.95 < V < 1.05
input:
    V: calculated V vector
output:
    VLimit: 0 if V is within the limit, 1 otherwise
%}

    V_hi = 1.05;
    V_lo = 0.95;
    
    VLimit = zeros(length(V), 1);
    
    for i = 1:length(V)
        if V(i) < V_lo && V(i) > V_hi
            VLimit(i) = 1;
        else
            VLimit(i) = 0;
        end
    end
end