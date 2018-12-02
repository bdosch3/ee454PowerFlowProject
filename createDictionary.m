function dictionary = createDictionary(PV_buses, N)
%createDictionary 
%   creates a dictionary for renumbering other data in the system

ref = zeros(N -1, 1);
for j = 1:(N - 1)
    ref(j) = j + 1;
end
dictionary = ref;

for k = 1:length(PV_buses)
    if PV_buses(k) ~= (k + 1)
        dictionary(k) = PV_buses(k);
        dictionary(PV_buses(k) - 1) = ref(k);
    end
end
