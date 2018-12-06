function outputData = outputFormat(theta_renumbered, V_renumbered, ...
P_renumbered, Q_renumbered, dictionary, N, S_BASE)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%recover the original numbering
theta_original = recover(theta_renumbered, [1; dictionary], N);
theta_deg = (180/pi).*theta_original;
V_original = recover(V_renumbered, [1; dictionary], N);
P_original = S_BASE.*(recover(P_renumbered, [1; dictionary], N));
Q_original = S_BASE.*(recover(Q_renumbered, [1; dictionary], N));

buses = zeros(N,1);
for i = 1:N
    buses(i) = i;
end

labels = ["Bus Number", "Angle (degrees)", "Voltage Magnitude(p.u.)", ...
          "Real Power (MW)", "Reactive Power (MVAr)"];
      
outputData = [labels; [buses, theta_deg, V_original, P_original, Q_original]];

end

