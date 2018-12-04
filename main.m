%main function
clear all; close all; clc;
S_BASE = 100; %MVA
EPS = 1e-4;
thetaSwing = 0;
%read in data of the transmission lines. separate for bus renumbering
Ydata = xlsread('EE454_Project_InputData', 'Line_Data');
sendingBuses = Ydata(:, 1);
receivingBuses = Ydata(:, 2);
RXBvalues = Ydata(:, [3, 4, 5]);
%assumption: the Nth bus will have a connection in the system
N = max([sendingBuses; receivingBuses]);

%read in PV data and manipulate as necessary
PVdata = xlsread('EE454_Project_InputData', 'PV_Data');
% can't do this following line for two reasons
% 1) col 1 is bus #
% 2) col 3 (V data) is already in p.u.
% V2 = 1.045 got rounded to 1.05
PVdata = PVdata./S_BASE;
m = length(PVdata);
Vswing = PVdata(1, 3);
%list of buses in the system which are PV
PV_buses = 100 * PVdata((2:end), 1);
PV = [PVdata((2:end), 2); PVdata((2:end), 3)];

%create dictionary for bus renumbering
dictionary = createDictionary(PV_buses, N);

%renumber buses and prepare data for creating the Y matrix
sendingBusesRenumbered =   renumberBuses(sendingBuses, dictionary);
receivingBusesRenumbered = renumberBuses(receivingBuses, dictionary);
YdataRenumbered = [sendingBusesRenumbered, receivingBusesRenumbered, RXBvalues];

%create Y matrix
Y = Y_matrix_function(YdataRenumbered);

%read in the PQ data of the loads. renumber to line up with new convention
PQ = xlsread('EE454_Project_InputData', 'Load_Data');
PQ = PQ./S_BASE;
PQ_original = [PQ(:, 2); PQ(:, 3)];
PQ_renumbered = renumberPQ(PQ_original, dictionary, N);

%initial guess with all theta = 0 and all V = 1 pu
x = [zeros(N - 1, 1); ones(N - m, 1)];

%form initial mismatch equations
f_x = createMismatch(x, Y, N, m, PV, PQ_renumbered, Vswing, thetaSwing);

%perform newton raphson until convergence is satisfied
while f_x > EPS
    jacobian = createJacobian(x, Y, N, m, PV, PQ_renumbered, Vswing, thetaSwing);
    x = newtonRaphson(jacobian, f_x, x);
    f_x = createMismatch(x, Y, N, m, PV, PQ_renumbered, Vswing, thetaSwing);
end

%extract all the renumbered data
[theta_renumbered, V_renumbered, P_renumbered, Q_renumbered] = ...
solveExplicitEquations(x, Y, N, m, PV, PQ_renumbered, Vswing, thetaSwing);

%recover the original numbering
theta_original = recover(theta_renumbered, dictionary, N);
V_original = recover(V_renumbered, dictionary, N);
P_original = recover(P_renumbered, dictionary, N);
Q_original = recover(Q_renumbered, dictionary, N);

%write these out to excel file