function testSweeps_createPlots(fileNameSuffix,ForkliftParams)

testConds
cd(fileparts(which(mfilename)));
cd("Test_"+fileNameSuffix);
resultsFolder = pwd;

load(['MastLift_' fileNameSuffix '_SweepRes.mat'],'resultsTableMS');
tbl2heat_MastLift(resultsTableMS,'heatmap',resultsFolder,['MastLift_' fileNameSuffix]);
tbl2heat_MastLift(resultsTableMS,'surface',resultsFolder,['MastLift_' fileNameSuffix]);

load(['ConstRadAccFwd_' fileNameSuffix '_SweepRes.mat'],'resultsTableFV');
tbl2heat_constRad(resultsTableFV,constRadFSweep,'heatmap',resultsFolder,['ConstRadAccFwd_' fileNameSuffix]);
tbl2heat_constRad(resultsTableFV,constRadFSweep,'surface',resultsFolder,['ConstRadAccFwd_' fileNameSuffix]);

load(['ConstRadAccRev_' fileNameSuffix '_SweepRes.mat'],'resultsTableRV');
tbl2heat_constRad(resultsTableRV,constRadRSweep,'heatmap',resultsFolder,['ConstRadAccRev_' fileNameSuffix]);
tbl2heat_constRad(resultsTableRV,constRadRSweep,'surface',resultsFolder,['ConstRadAccRev_' fileNameSuffix]);

load(['StepSteerFwdL_' fileNameSuffix '_SweepRes.mat'],'resultsTableFPS');
tbl2heat_stepSteer(resultsTableFPS,stepSteerFLSweep,'heatmap',resultsFolder,['StepSteerFwdL_' fileNameSuffix]);
tbl2heat_stepSteer(resultsTableFPS,stepSteerFLSweep,'surface',resultsFolder,['StepSteerFwdL_' fileNameSuffix]);

load(['StepSteerFwdR_' fileNameSuffix '_SweepRes.mat'],'resultsTableFNS');
tbl2heat_stepSteer(resultsTableFNS,stepSteerFRSweep,'heatmap',resultsFolder,['StepSteerFwdR_' fileNameSuffix]);
tbl2heat_stepSteer(resultsTableFNS,stepSteerFRSweep,'surface',resultsFolder,['StepSteerFwdR_' fileNameSuffix]);

load(['StepSteerRevL_' fileNameSuffix '_SweepRes.mat'],'resultsTableRPS');
tbl2heat_stepSteer(resultsTableRPS,stepSteerRLSweep,'heatmap',resultsFolder,['StepSteerRevL_' fileNameSuffix]);
tbl2heat_stepSteer(resultsTableRPS,stepSteerRLSweep,'surface',resultsFolder,['StepSteerRevL_' fileNameSuffix]);

load(['StepSteerRevR_' fileNameSuffix '_SweepRes.mat'],'resultsTableRNS');
tbl2heat_stepSteer(resultsTableRNS,stepSteerRRSweep,'heatmap',resultsFolder,['StepSteerRevR_' fileNameSuffix]);
tbl2heat_stepSteer(resultsTableRNS,stepSteerRRSweep,'surface',resultsFolder,['StepSteerRevR_' fileNameSuffix]);

load(['Static_' fileNameSuffix '_SweepRes.mat'],'resultsTableSMS');
tbl2heat_StaticMast(resultsTableSMS,'heatmap',resultsFolder,['Static_' fileNameSuffix]);
tbl2heat_StaticMast(resultsTableSMS,'surface',resultsFolder,['Static_' fileNameSuffix]);