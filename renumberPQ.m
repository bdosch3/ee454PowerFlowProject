function PQ_renumbered = renumberPQ(PQ_original, dictionary, N)
%renumberPQ 
%   renumber the PQ data of the loads in the system

P_original = PQ_original(1: N - 1);
Q_original = PQ_original(N: length(PQ_original));
P_renumbered = zeros(length(P_original), 1);
Q_renumbered = zeros(length(Q_original), 1);

for k = 1:(N - 1)
    P_renumbered(k) = P_original(dictionary(k) - 1);
    Q_renumbered(k) = Q_original(dictionary(k) - 1);
end

PQ_renumbered = [P_renumbered; Q_renumbered];
end
