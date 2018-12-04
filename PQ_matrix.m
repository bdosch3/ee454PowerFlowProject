function [PQ,N] = PQ_matrix(filename)
P = xlsread(filename,'A:A');
Q = xlsread(filename,'B:B');
PQ = [P;Q];
N = length(P) + 1;
end
