% Y_matrix_function.m
% accepts input excel file and outputs the Y matrix

function Y = Y_matrix_function(InputExcelFile)
    filename = InputExcelFile;
    input = xlsread(filename, 1);
    [rows, cols] = size(input);

    % initializeing admittance matrix Y
    % largest of column 1 and 2 is the number of buses
    tempY = zeros(max(max(input(:,1), max(input(:,2)))));

    % modify input to get Y
    for i = 1:rows
        % adding R+jX 
        currentRow = input(i,:);
        line1 = currentRow(1);
        line2 = currentRow(2);
        Y_total = 1/(currentRow(3) + j * currentRow(4));
        tempY(line1, line1) = tempY(line1, line1) + Y_total;
        tempY(line2, line2) = tempY(line2, line2) + Y_total;
        tempY(line1, line2) = tempY(line1, line2) - Y_total; 
        tempY(line2, line1) = tempY(line2, line1) - Y_total;

        % adding shunt reactances
        B_total = currentRow(5);
        if B_total ~= 0
            % Y = G + jB
            % since G is zero, Y = jB
            % in pi model, each bus 'gets' half of Y
            halfY = 0.5 * (j * B_total);
            tempY(line1, line1) = tempY(line1, line1) + halfY;
            tempY(line2, line2) = tempY(line2, line2) + halfY;
        end
    end
    Y = tempY;
end

