% newtonRaphson.m
% by Brad Dosch, Alex Htut, Bernardo Olivas, Muhammad Shafawi

function x_new = newtonRaphson(J, f_x, x_old)
%{
newtonRaphson: performs newton raphson in order to update the x varialbes
and converge to a solution
inputs: 
    J: the Jacobian matrix
    f_x: the mismatch equations
    x_old: the current x values, [theta2...thetaN;Vm+1...VN]
outputs: ...
    the updated x values
%}

    invJ = inv(J);
    negInvJ = -1*invJ; 
    dx = negInvJ*f_x;
    x_new = x_old + dx;
end
