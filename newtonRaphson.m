function x_new = newtonRaphson(J, f_x, x_old)
%newtonRaphson performs newton raphson
%   input: ...
%   output: ...

dx = -1*J\f_x
x_new = x_old + dx;
end

