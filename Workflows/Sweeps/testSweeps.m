testConds

cd(fileparts(which(mfilename)))
now_string = datestr(now,'yymmdd_HHMM');
resultsFolder = [pwd filesep 'Test_' now_string];
mkdir(resultsFolder);

copyfile('testSweep_template.xlsx',[resultsFolder filesep 'testSweep_' now_string '.xlsx']);

%% Mast Test Sweep
[activeTestCmds, simIn, stopTime,StabilitySweepInitCond,ForkliftParams] = ForkliftTestDefinitions(mastLiftSweep,ForkliftParams);
SweepResultsMS = parsim(simIn, 'ShowSimulationManager', 'on', 'UseFastRestart', 'on','ShowProgress','off');
fileRootName = ['MastLift_' now_string];
resultsTableMS = StabilitySweepAnalyzer(SweepResultsMS,StabilitySweepInitCond,resultsFolder,fileRootName);
tbl2heat_MastLift(resultsTableMS,'heatmap',resultsFolder,fileRootName);
tbl2heat_MastLift(resultsTableMS,'surface',resultsFolder,fileRootName);
save([resultsFolder filesep fileRootName '_SweepRes'],'SweepResultsMS','resultsTableMS');
clear SweepResultsMS;

%% Constant Radius Accel Sweep, Forward
[activeTestCmds, simIn, stopTime,StabilitySweepInitCond,ForkliftParams] = ForkliftTestDefinitions(constRadFSweep,ForkliftParams);
SweepResultsFV = parsim(simIn, 'ShowSimulationManager', 'on', 'UseFastRestart', 'on','ShowProgress','off');
fileRootName = ['ConstRadAccFwd_' now_string];
resultsTableFV = StabilitySweepAnalyzer(SweepResultsFV,StabilitySweepInitCond,resultsFolder,fileRootName);
tbl2heat_constRad(resultsTableFV,constRadFSweep,'heatmap',resultsFolder,fileRootName);
tbl2heat_constRad(resultsTableFV,constRadFSweep,'surface',resultsFolder,fileRootName);
save([resultsFolder filesep fileRootName '_SweepRes'],'SweepResultsFV','resultsTableFV');
clear SweepResultsFV

%% Constant Radius Accel Sweep, Reverse
[activeTestCmds, simIn, stopTime,StabilitySweepInitCond,ForkliftParams] = ForkliftTestDefinitions(constRadRSweep,ForkliftParams);
SweepResultsRV = parsim(simIn, 'ShowSimulationManager', 'on', 'UseFastRestart', 'on','ShowProgress','off');
fileRootName = ['ConstRadAccRev_' now_string];
resultsTableRV = StabilitySweepAnalyzer(SweepResultsRV,StabilitySweepInitCond,resultsFolder,fileRootName);
tbl2heat_constRad(resultsTableRV,constRadRSweep,'heatmap',resultsFolder,fileRootName);
tbl2heat_constRad(resultsTableRV,constRadRSweep,'surface',resultsFolder,fileRootName);
save([resultsFolder filesep fileRootName '_SweepRes'],'SweepResultsRV','resultsTableRV');
clear SweepResultsRV

%% Step Steer, Forward Left
[activeTestCmds, simIn, stopTime,StabilitySweepInitCond,ForkliftParams] = ForkliftTestDefinitions(stepSteerFLSweep,ForkliftParams);
SweepResultsFPS = parsim(simIn, 'ShowSimulationManager', 'on', 'UseFastRestart', 'on','ShowProgress','off');
fileRootName = ['StepSteerFwdL_' now_string];
resultsTableFPS = StabilitySweepAnalyzer(SweepResultsFPS,StabilitySweepInitCond,resultsFolder,fileRootName);
tbl2heat_stepSteer(resultsTableFPS,stepSteerFLSweep,'heatmap',resultsFolder,fileRootName);
tbl2heat_stepSteer(resultsTableFPS,stepSteerFLSweep,'surface',resultsFolder,fileRootName);
save([resultsFolder filesep fileRootName '_SweepRes'],'SweepResultsFPS','resultsTableFPS');
%clear SweepResultsFPS

%% Step Steer, Forward Right
[activeTestCmds, simIn, stopTime,StabilitySweepInitCond,ForkliftParams] = ForkliftTestDefinitions(stepSteerFRSweep,ForkliftParams);
SweepResultsFNS = parsim(simIn, 'ShowSimulationManager', 'on', 'UseFastRestart', 'on','ShowProgress','off');
fileRootName = ['StepSteerFwdR_' now_string];
resultsTableFNS = StabilitySweepAnalyzer(SweepResultsFNS,StabilitySweepInitCond,resultsFolder,fileRootName);
tbl2heat_stepSteer(resultsTableFNS,stepSteerFRSweep,'heatmap',resultsFolder,fileRootName);
tbl2heat_stepSteer(resultsTableFNS,stepSteerFRSweep,'surface',resultsFolder,fileRootName);
save([resultsFolder filesep fileRootName '_SweepRes'],'SweepResultsFNS','resultsTableFNS');
clear SweepResultsFNS

%% Step Steer, Reverse Left
[activeTestCmds, simIn, stopTime,StabilitySweepInitCond,ForkliftParams] = ForkliftTestDefinitions(stepSteerRLSweep,ForkliftParams);
SweepResultsRPS = parsim(simIn, 'ShowSimulationManager', 'on', 'UseFastRestart', 'on','ShowProgress','off');
fileRootName = ['StepSteerRevL_' now_string];
resultsTableRPS = StabilitySweepAnalyzer(SweepResultsRPS,StabilitySweepInitCond,resultsFolder,fileRootName);
tbl2heat_stepSteer(resultsTableRPS,stepSteerRLSweep,'heatmap',resultsFolder,fileRootName);
tbl2heat_stepSteer(resultsTableRPS,stepSteerRLSweep,'surface',resultsFolder,fileRootName);
save([resultsFolder filesep fileRootName '_SweepRes'],'SweepResultsRPS','resultsTableRPS');
clear SweepResultsRPS

%% Step Steer, Reverse Right
[activeTestCmds, simIn, stopTime,StabilitySweepInitCond,ForkliftParams] = ForkliftTestDefinitions(stepSteerRRSweep,ForkliftParams);
SweepResultsRNS = parsim(simIn, 'ShowSimulationManager', 'on', 'UseFastRestart', 'on','ShowProgress','off');
fileRootName = ['StepSteerRevR_' now_string];
resultsTableRNS = StabilitySweepAnalyzer(SweepResultsRNS,StabilitySweepInitCond,resultsFolder,fileRootName);
tbl2heat_stepSteer(resultsTableRNS,stepSteerRRSweep,'heatmap',resultsFolder,fileRootName);
tbl2heat_stepSteer(resultsTableRNS,stepSteerRRSweep,'surface',resultsFolder,fileRootName);
save([resultsFolder filesep fileRootName '_SweepRes'],'SweepResultsRNS','resultsTableRNS');
clear SweepResultsRNS

%% Static Load Sweep
[activeTestCmds, simIn, stopTime,StabilitySweepInitCond,ForkliftParams] = ForkliftTestDefinitions(staticLoadSweep,ForkliftParams);
SweepResultsSMS = parsim(simIn, 'ShowSimulationManager', 'on', 'UseFastRestart', 'on','ShowProgress','off');
fileRootName = ['Static_' now_string];
resultsTableSMS = StabilitySweepAnalyzer(SweepResultsSMS,StabilitySweepInitCond,resultsFolder,fileRootName);
tbl2heat_StaticMast(resultsTableSMS,'heatmap',resultsFolder,fileRootName);
tbl2heat_StaticMast(resultsTableSMS,'surface',resultsFolder,fileRootName);
save([resultsFolder filesep fileRootName '_SweepRes'],'SweepResultsSMS','resultsTableSMS');
clear SweepResultsSMS

%% Create HTML to review images
testSweeps_createHTML(now_string)
