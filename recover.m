function originalValues = recover (renumberedValues, dictionary, N)
%recover_x rearrange a column vector so that the original bus numbering is
%satisfied
%   inputs:
%       renumberedValues: column vector that has been renumbered for
%       processing
%       dictionary: look up table for renumbering
%       N: number of buses in the system
%   output:
%       originalValues: column vector returned to original numbering

originalValues = zeros(N, 1);
for k = 1:N
    originalValues(k) = renumberedValues(dictionary(k));
end
end

