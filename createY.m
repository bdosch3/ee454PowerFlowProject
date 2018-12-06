% createY.m
% by Brad Dosch, Alex Htut, Bernardo Olivas, Muhammad Shafawi

function Y = createY(input, N)
%{
outputs admittance matrix Y
inputs:
    input: matrix form of Line_Data table, which has format:
    sendingBus receivingBus  R    X    B    Fmax
    --------------------------------------------
        1            2       #    #    #    #
    and is (# of Lines x 6) big
    N: number of buses in the system
outputs:
    Y: admittance matrix
%}

    % Y is NxN
    Y = zeros(N);

    % modify input to get Y
    for i = 1:length(input(:, 1))
        % adding R+jX 
        currentRow = input(i,:);
        line1 = currentRow(1);
        line2 = currentRow(2);
        Y_total = 1/(currentRow(3) + j * currentRow(4));
        Y(line1, line1) = Y(line1, line1) + Y_total;
        Y(line2, line2) = Y(line2, line2) + Y_total;
        Y(line1, line2) = Y(line1, line2) - Y_total; 
        Y(line2, line1) = Y(line2, line1) - Y_total;

        % adding shunt reactances
        B_total = currentRow(5);
        if B_total ~= 0
            % Y = G + jB
            % since G is zero, Y = jB
            % in pi model, each bus 'gets' half of Y
            halfY = 0.5 * (j * B_total);
            Y(line1, line1) = Y(line1, line1) + halfY;
            Y(line2, line2) = Y(line2, line2) + halfY;
        end
    end
end