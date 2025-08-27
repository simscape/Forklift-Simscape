function [simIn,StabilitySweepInitCond] = sm_forklift_run_sweep(testConds,runSweep)
ForkliftParams = evalin('base','ForkliftParams');
[~, simIn, ~,StabilitySweepInitCond,~] = ForkliftTestDefinitions(testConds,ForkliftParams);

if(runSweep)
    SweepResultsApp = parsim(simIn, 'ShowSimulationManager', 'on', 'UseFastRestart', 'on', 'ShowProgress','off');
    resultsTableApp = StabilitySweepAnalyzer(SweepResultsApp,StabilitySweepInitCond);
    switch(testConds.type)
        case('MastLiftSweep')
            tbl2heat_MastLift(resultsTableApp,'heatmap');
            tbl2heat_MastLift(resultsTableApp,'surface');
        case('StepSteerSweep')
            tbl2heat_stepSteer(resultsTableApp,testConds,'heatmap');
            tbl2heat_stepSteer(resultsTableApp,testConds,'surface');
        case('ConstantRadiusSweep')
            tbl2heat_constRad(resultsTableApp,testConds,'heatmap');
            tbl2heat_constRad(resultsTableApp,testConds,'surface');
        case('StaticLoadSweep')
            tbl2heat_StaticMast(resultsTableApp,'heatmap');
            tbl2heat_StaticMast(resultsTableApp,'surface');
    end
    assignin('base','SweepResultsMS',resultsTableApp)
    assignin('base','SweepResultsMS',resultsTableApp)
end