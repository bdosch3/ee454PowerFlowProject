% renumberUnitTest.m
% by Brad Dosch, Alex Htut, Bernardo Olivas, Muhammad Shafawi

%unit test for the renumbering scheme

%hardcode values that we know the answers for
PV_buses = [2;3;10;12];
N = 12;
m = 5;
dict = createDictionary(PV_buses, N);
PQ_orig = 1.4*rand(2*N - 2, 1);
PQ_renum = renumberPQ(PQ_orig, dict, N);
buses_orig1 = [1;1;2;2;2;3;4;4;5;6;6;6;7;7;8;10;11];
buses_orig2 = [2;5;3;4;5;4;5;7;6;9;10;11;8;12;9;11;12];
busesRenum1 = renumberBuses(buses_orig1, dict);
busesRenum2 = renumberBuses(buses_orig2, dict);

%test these values against our theoretical results
