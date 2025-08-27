%% Model Setup Parameters
stopTime = 20; % [s]

%% Mass Properties
% Body 
ForkliftParams.chassis.mass = 1200; % [kg] 
ForkliftParams.counterweight.mass = 2500; % [kg]
ForkliftParams.lpTank.mass = 30; % [kg]

% Operator Compartment
ForkliftParams.operatorConsole.mass = 50; % [kg]
ForkliftParams.operatorCompartment.mass = 200; % [kg]
ForkliftParams.seat.mass = 25; % [kg]
ForkliftParams.seatBase.mass = 50; % [kg]
ForkliftParams.steeringWheel.mass = 5; % [kg]

% Rear Axle
ForkliftParams.rearAxle.mass = 120; % [kg]
ForkliftParams.rearWheel.mass = 10; % [kg]
ForkliftParams.rearWheel.wid  = 0.1778; % [m]
ForkliftParams.leftRearKnuckle.mass = 25; % [kg]
ForkliftParams.leftSteerLink.mass = 5; % [kg]
ForkliftParams.rearSteerCylinder.mass = 15; % [kg]
ForkliftParams.rearSteerRod.mass = 10; % [kg]
ForkliftParams.rearWheelHub.mass = 10; % [kg]
ForkliftParams.rightRearKnuckle.mass = 25; % [kg]
ForkliftParams.rightSteerLink.mass = 5; % [kg]

% Front Axle
ForkliftParams.frontAxle.mass = 120; % [kg]
ForkliftParams.frontWheel.mass = 20; % [kg]
ForkliftParams.frontWheel.wid  = 0.2286; % [m]
ForkliftParams.frontHub.mass = 10; % [kg]

% Carriage
ForkliftParams.carriageFreeLiftRod.mass = 100; % [kg]
ForkliftParams.carriageSideShiftCyl.mass = 30; % [kg]
ForkliftParams.carriageSideShiftRod.mass = 20; % [kg]
ForkliftParams.fork.mass = 50; % [kg]
ForkliftParams.innerCarriage.mass = 80; % [kg]
ForkliftParams.outerCarriage.mass = 80; % [kg]
ForkliftParams.loadBackRest.mass = 80; % [kg]

% Mast
ForkliftParams.innerMast.mass = 100; % [kg]
ForkliftParams.mastTiltCylinder.mass = 10; % [kg]
ForkliftParams.mastTiltRod.mass = 10; % [kg]
ForkliftParams.middleMast.mass = 150; % [kg]
ForkliftParams.outerMast.mass = 200; % [kg]
ForkliftParams.mastCylinder.mass = 80; % [kg]
ForkliftParams.mastRod.mass = 60; % [kg]

% Chain
ForkliftParams.liftChain.offset1 = -0.05;
ForkliftParams.liftChain.offset2 = -0.38;

%% Colors
ForkliftParams.clr.whl     = [1 1 1]*0.3;
ForkliftParams.clr.knuckle = [1 1 1]*0.5;
ForkliftParams.clr.axle    = [1 1 1]*0.2;
ForkliftParams.clr.chainLift = [0.9294 0.6941 0.1255];

%% Force Visualization
ForkliftParams.FnVis.FtoRGain = 0.0002;

%% Performance Specifications
% Load
ForkliftParams.perfSpecs.maxLoad = 3175; % [kg] 7000lb capacity forklift

% Carriage side shift
ForkliftParams.perfSpecs.maxCarriageSideShift      = 152.4; % [mm] Left and right of center
ForkliftParams.perfSpecs.maxCarriageSideShiftSpeed = 152/2; % [m/s] Left and right of center

% Mast tilt
ForkliftParams.perfSpecs.maxMastForwardTiltAngle = 10; % [deg]
ForkliftParams.perfSpecs.maxMastBackTiltAngle = -5; % [deg]
ForkliftParams.perfSpecs.maxMastTiltSpeed = 5; % [deg/s]

% Propulsion
ForkliftParams.perfSpecs.maxForwardSpeed =  5; % [m/s]
ForkliftParams.perfSpecs.maxReverseSpeed = -5; % [m/s]
ForkliftParams.perfSpecs.maxForwardAccel =  1; % [m/s/s]
ForkliftParams.perfSpecs.maxReverseAccel = -1; % [m/s/s]
ForkliftParams.perfSpecs.maxForwardDecel =  1; % [m/s/s]
ForkliftParams.perfSpecs.maxReverseDecel = -1; % [m/s/s]

% Mast lift
ForkliftParams.perfSpecs.maxTotalLift     = 4800; % [mm]
ForkliftParams.perfSpecs.maxFreeLift      = 1550; % [mm] 
ForkliftParams.perfSpecs.maxMastLiftSpeed  = 500; % [mm/s] Up and down
ForkliftParams.perfSpecs.maxMastLowerSpeed = 500; % [mm/s] Up and down

% Steer
ForkliftParams.perfSpecs.maxSteerAngle = 35; % [deg]
ForkliftParams.perfSpecs.maxSteerSpeed = 17; % [deg/s]


%% Initial Conditions
ForkliftParams.initConditions.steerAngle = 0; % [deg]
ForkliftParams.initConditions.mastLiftPos = 0; % [mm]
ForkliftParams.initConditions.mastTiltAngle = 0; % [deg]
ForkliftParams.initConditions.carriageSideShiftPos = 0; % [mm]
ForkliftParams.initConditions.velocity = 0; % [m/s]
ForkliftParams.initConditions.load = 0; % [kg]
% Load position
% X = left (+) and right (-) of forklift center
% Y = fore and aft of fork arm center
% Z = 0, load solid is sitting on forks
ForkliftParams.initConditions.loadPos = [0 0 0]; % [mm]

%% Assembly Conditions
% Fork positions
% Positive value = left of center
% Negative value = right of center
ForkliftParams.assemblyConditions.leftForkPos = 250; % [mm] 
ForkliftParams.assemblyConditions.rightForkPos = -250; % [mm] 
ForkliftParams.assemblyConditions.forkSeparation = abs( ...
    ForkliftParams.assemblyConditions.leftForkPos - ForkliftParams.assemblyConditions.rightForkPos); % [mm]

if ForkliftParams.initConditions.mastLiftPos == 0
    ForkliftParams.assemblyConditions.carriageFreeLiftPos = 0; % [mm]
    ForkliftParams.assemblyConditions.middleOuterMastPos = 0; % [mm]
elseif ForkliftParams.initConditions.mastLiftPos < ForkliftParams.perfSpecs.maxFreeLift
    ForkliftParams.assemblyConditions.carriageFreeLiftPos = ForkliftParams.initConditions.mastLiftPos;
    ForkliftParams.assemblyConditions.middleOuterMastPos = 0; % [mm]
else
    ForkliftParams.assemblyConditions.carriageFreeLiftPos = ForkliftParams.perfSpecs.maxFreeLift;
    ForkliftParams.assemblyConditions.middleOuterMastPos = (ForkliftParams.initConditions.mastLiftPos - ForkliftParams.perfSpecs.maxFreeLift)/2; % [mm]
end

%% Test Conditions
ForkliftParams.testConditions.minNormalForce = 0; % [N] If any point of contact hits this value, the simulation will stop
ForkliftParams.testConditions.testDelay =  4; % [s] 
ForkliftParams.testConditions.maxRoll   =  10; % deg
ForkliftParams.testConditions.maxPitch  =  10; % deg

%% Ground Contact
ForkliftParams.groundContact.frontTireRad = 0.5334/2; % [m]
ForkliftParams.groundContact.rearTireRad = 0.4064/2; % [m]
ForkliftParams.groundContact.stiffness = 5e6; % [N/m]
ForkliftParams.groundContact.damping = 1e6; % [N/(m/s)]
ForkliftParams.groundContact.transRegWidth = 0.01; % [m]
ForkliftParams.groundContact.muStatic = 0.9;
ForkliftParams.groundContact.muDynamic = 0.8;
ForkliftParams.groundContact.velThreshold = 1e-2; % [m/s]
