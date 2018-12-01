% G_B_matrices_function.m
% Imports Y matrix and outputs G and B matrices
% as in Y = G + jB

function [G,B] = G_B_matrices_function(Y) 
    [rows, cols] = size(Y);
    % Y is always a square matrix
    tempG = zeros(rows);
    tempB = zeros(rows);
    for r = 1:rows
        for c = 1:cols
            current = Y(r,c);
            if current ~= 0
                tempG(r,c) = real(current);
                tempB(r,c) = j*imag(current);
            end
        end
    end
    G = tempG;
    B = tempB;
end