%% Step Steer
stepSteerFLSweep.vel   = 2; 
stepSteerFLSweep.lift  = linspace(0,ForkliftParams.perfSpecs.maxTotalLift,4);
stepSteerFLSweep.tilt  = linspace(...
    ForkliftParams.perfSpecs.maxMastBackTiltAngle,...
    ForkliftParams.perfSpecs.maxMastForwardTiltAngle,5);
stepSteerFLSweep.steer = ForkliftParams.perfSpecs.maxSteerAngle;
stepSteerFLSweep.shift = [...
    -ForkliftParams.perfSpecs.maxCarriageSideShift,0,...
     ForkliftParams.perfSpecs.maxCarriageSideShift];
stepSteerFLSweep.load = linspace(0,...
    ceil(ForkliftParams.perfSpecs.maxLoad*1.4/500)*500,5);
stepSteerFLSweep.type = 'StepSteerSweep';

stepSteerFRSweep = stepSteerFLSweep;
stepSteerFRSweep.steer = stepSteerFRSweep.steer*-1;

stepSteerRLSweep = stepSteerFLSweep;
stepSteerRLSweep.vel = stepSteerRLSweep.vel*-1;

stepSteerRRSweep = stepSteerFLSweep;
stepSteerRRSweep.vel = stepSteerRRSweep.vel*-1;
stepSteerRRSweep.steer = stepSteerRRSweep.steer*-1;

stepSteerFL = stepSteerFLSweep;
stepSteerFL.type = 'StepSteer';
stepSteerFL.lift = 1600;

%% Constant Radius Acceleration
constRadFSweep   = stepSteerFLSweep;
constRadFSweep.steer = [-1 1]*ForkliftParams.perfSpecs.maxSteerAngle;
constRadFSweep.type = 'ConstantRadiusSweep';

constRadRSweep   = constRadFSweep;
constRadRSweep.vel = constRadRSweep.vel*-1;

constRadF      = constRadFSweep;
constRadF.type = 'ConstantRadius';


%% Mast Lift
mastLiftSweep       = stepSteerFLSweep;
mastLiftSweep.vel   = 0;
mastLiftSweep.steer = 0;
mastLiftSweep.lift  = ForkliftParams.perfSpecs.maxTotalLift;
%mastLift.type  = 'IncreasingMastLiftPos';
mastLiftSweep.type  = 'MastLiftSweep';

mastLift = mastLiftSweep;
mastLift.type  = 'MastLift';


%% Static Load
staticLoadSweep       = stepSteerFLSweep;
staticLoadSweep.vel   = 0;
staticLoadSweep.steer = 0;
staticLoadSweep.type  = 'StaticLoadSweep';

staticLoad = staticLoadSweep;
staticLoad.type  = 'StaticLoad';

%% Mast Lower and Brake
%mastLowerBrake       = stepSteerFL;
mastLowerBrake.vel   = 5;
mastLowerBrake.steer = 0;
mastLowerBrake.lift  = ForkliftParams.perfSpecs.maxTotalLift;
mastLowerBrake.tilt  = 0;
mastLowerBrake.shift = 0;
mastLowerBrake.load  = 1125;
mastLowerBrake.type  = 'MastLowerBrake';
