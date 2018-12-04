    function [x_diff] = convergeCheck(x_new, x_old)
% Calucaltes the differnce between the old x matrix and the one after
% another iteration. 
%   input: x_new and x_old
%   output: x_diff
x_diff = x_new - x_old;
    end