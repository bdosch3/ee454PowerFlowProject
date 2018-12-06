function newBusData = renumberBuses(buses, dictionary)
    %{
    renumberBuses renumbers the buses for the Y matrix
    inputs: 
        buses: column list of buses to be renumbered
        dictionary: look up table used for renumbering
    outputs: 
        newBusData: renumbered buses to match up with mismatch equations
    %}
    
    dictionary = [1; dictionary];
    newBusData = zeros(length(buses), 1);

    for k = 1:length(buses)
        newBusData(k) = dictionary(buses(k));
    end
end

