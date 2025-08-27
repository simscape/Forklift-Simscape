%% Model Setup
% StabilitySweep - runs the 'sweepType' stability sweep test
% IncreasingMastLiftPos - single sim, lifts the mast to the max height
% Turning - single sim, increases velocity and turns and lifts the mast
% HoldSteer - single sim, initializes steering at a value and holds it
% SweepRun - single sim, define a sweep run and the run number (in the test
% definitions script) to run
testType = 'StepSteer';

% MastSweep | StaticMastLoadSweep | ForwardVelocitySweep | ReverseVelocitySweep | ForwardVelPosSteerSweep
% ReverseVelPosSteerSweep | ForwardVelNegSteerSweep | ReverseVelNegSteerSweep
sweepType = 'StepSteerSweep'; 

% Option to run the sweep or not - only used when StabilitySweep is the
% test type
runSweep = true;

% Name of the sweep - this will be used as the file name to save the
% results
sweepName = sweepType;
overwrite = true;


%% Create Test Inputs
%run ForkliftTestDefinitions;

