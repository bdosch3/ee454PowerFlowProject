%main function
function main(inputFile, outputFile, inputLineData, generalOutput,...
    lineDataOutput, iterRecordOutput, powerInfoOutput)

    S_BASE = 100; %MVA
    EPS = 0.1/S_BASE;
    thetaSwing = 0;

    % read in data of the transmission lines. separate for bus renumbering
    Ydata = xlsread(inputFile, inputLineData);
    sendingBuses = Ydata(:, 1);
    receivingBuses = Ydata(:, 2);
    RXBvalues = Ydata(:, [3, 4, 5]);
    % assumption: the Nth bus will have a connection in the system
    N = max([sendingBuses; receivingBuses]);

    % read in PV data and manipulate as necessary
    PVdata = xlsread(inputFile, 'PV_Data');
    PVdata(:,2) = PVdata(:,2)./S_BASE;
    m = length(PVdata);
    Vswing = PVdata(1, 3);
    % list of buses in the system which are PV
    PV_buses = PVdata((2:end), 1);
    PV = [PVdata((2:end), 2); PVdata((2:end), 3)];

    % create dictionary for bus renumbering
    dictionary = createDictionary(PV_buses, N);

    % renumber buses and prepare data for creating the Y matrix
    sendingBusesRenumbered =   renumberBuses(sendingBuses, dictionary);
    receivingBusesRenumbered = renumberBuses(receivingBuses, dictionary);
    YdataRenumbered = [sendingBusesRenumbered, receivingBusesRenumbered, RXBvalues];

    % create Y matrix
    Y = createY(YdataRenumbered, N);

    % read in the PQ data of the loads. renumber to line up with new convention
    PQ = xlsread(inputFile, 'Load_Data');
    PQ_original = [PQ(:, 2); PQ(:, 3)];
    PQ_original = PQ_original./S_BASE;
    PQ_renumbered = renumberPQ(PQ_original, dictionary, N);

    % initial guess with all theta = 0 and all V = 1 pu
    x = [zeros(N - 1, 1); ones(N - m, 1)];

    % form initial mismatch equations
    [f_x, f_comp] = createMismatch(x, Y, N, m, PV, PQ_renumbered, Vswing, thetaSwing);
    
    %prepare iteration record for looping. we have no way of knowing the size,
    %so it will grow each time
    iterationRecord = [];
    
    % perform newton raphson until convergence is satisfied
    count = 1;
    while max(f_x) > EPS
        iterationRecord = [iterationRecord; recordIteration(f_x, S_BASE, count, dictionary, N, m)];
        jacobian = createJacobian(x, Y, N, m, PV, f_comp, Vswing, thetaSwing);
        x = newtonRaphson(jacobian, f_x, x);
        f_x = createMismatch(x, Y, N, m, PV, PQ_renumbered, Vswing, thetaSwing);
        count = count + 1;
    end

    % extract all the renumbered data
    [theta_renumbered, V_renumbered, P_renumbered, Q_renumbered] = ...
    solveExplicitEquations(x, Y, N, m, PV, PQ_renumbered, PV_buses, Vswing, ...
    thetaSwing, S_BASE, outputFile, powerInfoOutput);

    % recover the original numbering
    theta_original = recover(theta_renumbered, [1; dictionary], N);
    theta_deg = (180/pi).*theta_original;
    V_original = recover(V_renumbered, [1; dictionary], N);
    P_original = S_BASE.*(recover(P_renumbered, [1; dictionary], N));
    Q_original = S_BASE.*(recover(Q_renumbered, [1; dictionary], N));
        
    % determine whether the calculated V values exceed the range:
    % 0.95 < V < 1.05
    % genearlData includes P, Q, V, theta values, V limit check at each bus
    VLimit = checkVLimit(V_original);
    busNumber = createBusNumber(N);
    generalData = [busNumber, theta_deg, V_original, P_original, ...
                    Q_original, VLimit];
    generalLabel = ["Bus Number", "Angle (degrees)", "V (p.u.)", ...
              "P (MW)", "Q (MVAr)", "Exceeds Vlimit?"]; 
    xlswrite(outputFile, [generalLabel; generalData], generalOutput);
    
    % lineData has |S|, P, Q, Fmax check for each transmission line
    lineData = createLineData(S_BASE, V_original, theta_original, Ydata);
    lineLabel = ["sendingBus", "receivingBus", "|S| (MVA)", ...
                 "P (MW)", "Q (MVAr)", "Exceeds Fmax?"];
    xlswrite(outputFile, [lineLabel; lineData], lineDataOutput);
    
    iterLabel = ["Iteration Number",...
                 "Max. P" + newline + "Mismatch Magnitude (MW)",...
                 "Bus Number",...
                 "Max. Q" + newline + "Mismatch Magnitude (MVAr)",...
                 "Bus Number"];
    xlswrite(outputFile,[iterLabel; iterationRecord],iterRecordOutput);   
end