function newBusData = renumberBuses(buses, dictionary)
%renumberBuses renumbers the buses for the Y matrix
%   inputs: ...
%   outputs: ...

dictionary = [1; dictionary];
newBusData = zeros(length(buses), 1);

for k = 1:length(buses)
    newBusData(k) = dictionary(buses(k));
end

end

