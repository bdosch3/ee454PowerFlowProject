% importing data from the excel file with line data
filename = 'EE454_Project_InputData.xlsx';
input = xlsread(filename, 1);
[rows, cols] = size(input);

% initializeing admittance matrix Y
Y = zeros(12);

% modify input to get Y
for i = 1:rows
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
Y