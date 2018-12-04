function x_new = newtonRaphson(J, f_x, x_old)
%newtonRaphson performs newton raphson
%   input: ...
%   output: ...

invJacobian = inv(J);
dx = invJacobian * f_x;
d_x = -1.*dx;
%dx = (-1).*(inv(J))*(x_old);
x_new = x_old + d_x;
end

