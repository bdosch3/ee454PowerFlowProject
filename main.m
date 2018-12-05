%main function

S_BASE = 100; %MVA
EPS = 1e-2;
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
PVdata(:,2) = PVdata(:,2)./S_BASE;
m = length(PVdata);
Vswing = PVdata(1, 3);
%list of buses in the system which are PV
PV_buses = PVdata((2:end), 1);
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
[f_x, f_comp] = createMismatch(x, Y, N, m, PV, PQ_renumbered, Vswing, thetaSwing);

%perform newton raphson until convergence is satisfied
count = 0;
%while sum(f_x > EPS) ~= 0
    jacobian = createJacobian(x, Y, N, m, PV, PQ_renumbered, Vswing, thetaSwing);
    x = newtonRaphson(jacobian, f_x, x);
    f_x = createMismatch(x, Y, N, m, PV, PQ_renumbered, Vswing, thetaSwing);
    count = count + 1;
    count
%end

%extract all the renumbered data
[theta_renumbered, V_renumbered, P_renumbered, Q_renumbered] = ...
solveExplicitEquations(x, Y, N, m, PV, PQ_renumbered, Vswing, thetaSwing);

%recover the original numbering
theta_original = recover(theta_renumbered, [1; dictionary], N);
V_original = recover(V_renumbered, [1; dictionary], N);
P_original = recover(P_renumbered, [1; dictionary], N);
Q_original = recover(Q_renumbered, [1; dictionary], N);

%write these out to excel file