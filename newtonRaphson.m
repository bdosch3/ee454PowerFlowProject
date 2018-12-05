function x_new = newtonRaphson(J, f_x, x_old)
%newtonRaphson performs newton raphson
%   input: ...
%   output: ...
invJ = inv(J);
negInvJ = -1*invJ;
dx = negInvJ*f_x
x_new = x_old + dx;
end

