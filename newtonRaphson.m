function [x_new] = newtonRaphson(J, f_x, x_old)
%newtonRaphson performs newton raphson
%   input: ...
%   output: ...

dx = -1*inv(J)*x_old;
x_new = x_old + dx;
end

