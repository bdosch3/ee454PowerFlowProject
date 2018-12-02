function [theta_original, V_original] = recover_x (x, PV, dictionary, thetaSwing, Vswing, m, N)
%recover_x rearrange x so the original bus numbering is satisfied
%   Detailed explanation goes here

theta_mixed = [thetaSwing; x(1: N - 1)]
V_mixed = [Vswing; PV(m : length(PV)) ; x(N: length(x))]
dictionary = [1; dictionary];

theta_original = zeros(N, 1);
V_original = zeros(N, 1);

for k = 1:N
    theta_original(k) = theta_mixed(dictionary(k));
    V_original(k) = V_mixed(dictionary(k));
end
end

