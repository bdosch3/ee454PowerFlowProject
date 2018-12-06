% EE454_Project_Dosch_Htut_Olivas_Shafawi.m
% by Brad Dosch, Alex Htut, Bernardo Olivas, Muhammad Shafawi

% script to run PowerFlow program
% NOTE: Do not modify 'EE454_Project_InputData.xlsx' file which contains
%       the given data (from the manual) formatted in a particular way.
%       The zip folder already ocntains 'EE454_Project_OutputData.xlsx'.
%       To run the program from a fresh start, simply rename the outputFile
%       variable, and the program will create a new file with the same
%       output values.

clear all;

% inputFile contains data for Line_Data for base case, con1, con2,
% Load_Data, and PV_Data
inputFile = 'EE454_Project_InputData.xlsx';
baseCaseInput = 'Line_Data';
case1Input = 'Line_Data_con1';
case2Input = 'Line_Data_con2';

% outputFile has four sheets (generalOutput, lineDataOutput,
% iterRecord, genPowerInfo) for each case for a total of 12 sheets
outputFile = 'EE454_Project_OutputData.xlsx';

% generalOutput has P, Q, V, theta, VlimitCheck for each bus
baseCaseGeneralOutput = 'BaseCase';
case1GeneralOutput = 'Con1Case';
case2GeneralOutput = 'Con2Case';

% lineDataOutput has |S|, P, Q, FlimitCheck for each line
baseCaseLineDataOutput = 'LineDataBaseCase';
case1LineDataOutput = 'LineDataCon1Case';
case2LineDataOutput = 'LineDataCon2Case';

% iterRecord has a log of max real and reactive mismatches of 
% each NR iteration
baseCaseIterRecord = 'iterRecordBaseCase';
case1IterRecord = 'iterRecordCase1';
case2IterRecord = 'iterRecordCase2';

% genPowerInfo has P, Q values for each generator
baseCaseGenPowerInfo = 'genPowerInfoBaseCase';
case1GenPowerInfo = 'genPowerInfoCase1';
case2GenPowerInfo = 'genPowerInfoCase2';

% call main function for three different cases
main(inputFile, outputFile, baseCaseInput, baseCaseGeneralOutput,...
    baseCaseLineDataOutput, baseCaseIterRecord, baseCaseGenPowerInfo);
main(inputFile, outputFile, case1Input, case1GeneralOutput,...
    case1LineDataOutput, case1IterRecord, case1GenPowerInfo);
main(inputFile, outputFile, case2Input, case2GeneralOutput,...
    case2LineDataOutput, case2IterRecord, case2GenPowerInfo);