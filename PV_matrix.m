function [PV,m] = PV_matrix(filename)
P = xlsread(filename,'A:A');
V = xlsread(filename,'B:B');
PV = [P;V];
m = length(V);
end
