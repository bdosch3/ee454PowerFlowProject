% importing data from the excel file with line data
function Y = Y_matrix_function(InputExcelFile)
    filename = InputExcelFile;
    input = xlsread(filename, 1);
    [rows, cols] = size(input);

    % initializeing admittance matrix Y
    temp_Y = zeros(12);

    % modify input to get Y
    for i = 1:rows
        % adding R+jX 
        currentRow = input(i,:);
        line1 = currentRow(1);
        line2 = currentRow(2);
        Y_total = 1/(currentRow(3) + j * currentRow(4));
        temp_Y(line1, line1) = temp_Y(line1, line1) + Y_total;
        temp_Y(line2, line2) = temp_Y(line2, line2) + Y_total;
        temp_Y(line1, line2) = temp_Y(line1, line2) - Y_total; 
        temp_Y(line2, line1) = temp_Y(line2, line1) - Y_total;

        % adding shunt reactances
        B_total = currentRow(5);
        if B_total ~= 0
            % Y = G + jB
            % since G is zero, Y = jB
            % in pi model, each bus 'gets' half of Y
            halfY = 0.5 * (j * B_total);
            temp_Y(line1, line1) = temp_Y(line1, line1) + halfY;
            temp_Y(line2, line2) = temp_Y(line2, line2) + halfY;
        end
    end
    Y = temp_Y;
end

