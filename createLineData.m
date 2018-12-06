% theta is from theta_original
function lineData = createLineData(S_BASE, V, theta, Ydata)
    lineData = zeros(length(Ydata),6);
    sendIndex = 1;
    recIndex = 2;
    sIndex = 3;
    pIndex = 4;
    qIndex = 5;
    boundIndex = 6;
    
    for r = 1:length(Ydata)
        currentRow = Ydata(r, :);
        sendingBus = currentRow(1);
        receivingBus = currentRow(2);
        V1 = V(sendingBus)*exp(j*theta(sendingBus));
        V2 = V(receivingBus)*exp(j*theta(receivingBus));
        Z = currentRow(3) + j*currentRow(4);
        dV = V1-V2;
        I = dV/Z;
        S = dV*conj(I);
        lineData(r, sendIndex) = sendingBus;
        lineData(r, recIndex) = receivingBus;
        lineData(r, sIndex) = S_BASE * abs(S);
        lineData(r, pIndex) = S_BASE * real(S);
        lineData(r, qIndex) = S_BASE * imag(S);
        
        if ~isnan(Ydata(r, 6)) 
            if S_BASE * abs(S) < Ydata(r,6)
                % does it exceed Fmax?
                lineData(r, boundIndex) = 0;
            else 
                lineData(r, boundIndex) = 1;
            end
        else
             lineData(r, boundIndex) = 0;
        end
    end
end