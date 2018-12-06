clear all;

inputFile = 'EE454_Project_InputData.xlsx';
baseCaseInput = 'Line_Data';
case1Input = 'Line_Data_con1';
case2Input = 'Line_Data_con2';

outputFile = 'EE454_Project_OutputData.xlsx';

baseCaseGeneralOutput = 'BaseCase';
case1GeneralOutput = 'Con1Case';
case2GeneralOutput = 'Con2Case';

baseCaseLineDataOutput = 'LineDataBaseCase';
case1LineDataOutput = 'LineDataCon1Case';
case2LineDataOutput = 'LineDataCon2Case';

baseCaseIterRecord = 'iterRecordBaseCase';
case1IterRecord = 'iterRecordCase1';
case2IterRecord = 'iterRecordCase2';

baseCaseGenPowerInfo = 'genPowerInfoBaseCase';
case1GenPowerInfo = 'genPowerInfoCase1';
case2GenPowerInfo = 'genPowerInfoCase2';

main(inputFile, outputFile, baseCaseInput, baseCaseGeneralOutput,...
    baseCaseLineDataOutput, baseCaseIterRecord, baseCaseGenPowerInfo);
main(inputFile, outputFile, case1Input, case1GeneralOutput,...
    case1LineDataOutput, case1IterRecord, case1GenPowerInfo);
main(inputFile, outputFile, case2Input, case2GeneralOutput,...
    case2LineDataOutput, case2IterRecord, case2GenPowerInfo);

