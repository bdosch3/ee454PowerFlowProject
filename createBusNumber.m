% createBusNumber.m
% by Brad Dosch, Alex Htut, Bernardo Olivas, Muhammad Shafawi

function busNumber = createBusNumber(N)
%{
creates bus number column vector from 1 to N
inputs:
    N: number of buses in the system
outputs:
    busNumber: column vector from 1 to N
%}    
    busNumber = zeros(N,1);
    for i = 1:N
        busNumber(i) = i;
    end
end