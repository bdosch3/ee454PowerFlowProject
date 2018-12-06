function lineData = createLineData(S_BASE, V, theta, Ydata)
%{
computes powerflow data for each transmission line
inputs:
    S_BASE: base value for complex power
    V: final V values at all buses
    theta: final theta values at all buses (in rad)
    Ydata: original Line_data table 
outputs:
    lineData: matrix filled with powerflow data (S,P,Q,FmaxCheck)...
        each line
%}

    % col 1 and col 2 are sending and receiving buses
    % col 3, 4, and 5 are magnitude(S), P, an Q
    % col 6 checks whether magnitue(S) exceeds given Fmax
    % thus, lineData is #ofLines x 6 big
    lineData = zeros(length(Ydata),6);
    sendIndex = 1;
    recIndex = 2;
    sIndex = 3;
    pIndex = 4;
    qIndex = 5;
    boundIndex = 6;
    
    % iterate through each line
    for r = 1:length(Ydata)
        currentRow = Ydata(r, :);
        sendingBus = currentRow(1);
        receivingBus = currentRow(2);
        V1 = V(sendingBus)*exp(j*theta(sendingBus));
        V2 = V(receivingBus)*exp(j*theta(receivingBus));
        Z = currentRow(3) + j*currentRow(4);
        dV = V1-V2;
        I = dV/Z;
        % S is the product of Vdrop and conj(I)
        S = dV*conj(I);
        lineData(r, sendIndex) = sendingBus;
        lineData(r, recIndex) = receivingBus;
        % multiply by S_BASE to get actual values
        lineData(r, sIndex) = S_BASE * abs(S);
        lineData(r, pIndex) = S_BASE * real(S);
        lineData(r, qIndex) = S_BASE * imag(S);
        
        % check if mag(S) exceeds given Fmax
        % 0 is no, 1 is yes
        if ~isnan(Ydata(r, 6)) 
            if S_BASE * abs(S) < Ydata(r,6)
                lineData(r, boundIndex) = 0;
            else 
                lineData(r, boundIndex) = 1;
            end
        else % no Fmax given
             lineData(r, boundIndex) = 0;
        end
    end
end