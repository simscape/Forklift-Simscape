function [activeTestCmds, simIn, stopTime,StabilitySweepInitCond,ForkliftParams] = ForkliftTestDefinitions(testConds,ForkliftParams)
%% Forklift Stability Test Definitions
% This script contains all model test scenario definitions and is called
% when the main parameter initialization script is ran.

% Defaults
testType = testConds.type;
stopTime = 20;
holdTime  = 2; % [s] Time to hold position at the end of a ramp before stopping the simulation
simIn = [];
StabilitySweepInitCond = [];
testDelay = ForkliftParams.testConditions.testDelay;

% Set parameter
ForkliftParams.initConditions.load = testConds.load(1); % kg

%% Test Definitions
load('ForkliftTestCommands.mat','TestCmds');
activeTestCmds = TestCmds;
StabilitySweepInputs = [];

switch testType
    case 'Idle'
        % No active inputs
        stopTime = 10; % [s]

    case {'MastLiftSweep','StaticLoadSweep','ConstantRadiusSweep','StepSteerSweep'}
        % Generate test conditions
        [StabilitySweepInputs, StabilitySweepInitCond, stopTime]  = StabilitySweepTestGenerator(testConds,ForkliftParams);

        numTests = height(StabilitySweepInitCond);
        modelName = 'sm_forklift';
        simIn = Simulink.SimulationInput(modelName);
        simIn = simIn.setModelParameter('SimMechanicsOpenEditorOnUpdate', 'off');
        simIn = simIn.setModelParameter('SimscapeLogType', 'None');
        
        % Turn off visualization - will not be seen during sweep,  
        % could cause extra simulation steps for no gain in accuracy
        simIn = simIn.setBlockParameter([modelName '/Forklift'],'popup_fnVis_onOff','Off');

        simIn(1:numTests) = simIn;

        % Define values for each test
        for ii = 1:1:numTests
            % Set the stop time
            simIn(ii) = setVariable(simIn(ii), 'stopTime', stopTime); % [s]

            % Set initial conditions
            simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.initConditions.steerAngle', StabilitySweepInitCond.SteerAngle(ii)); % [deg]
            simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.initConditions.mastLiftPos', StabilitySweepInitCond.MastLiftPos(ii)); % [mm]
            simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.initConditions.mastTiltAngle', StabilitySweepInitCond.MastTiltAngle(ii)); % [deg]
            simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.initConditions.carriageSideShiftPos', StabilitySweepInitCond.SideShiftPos(ii)); % [mm]
            simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.initConditions.velocity', StabilitySweepInitCond.Velocity(ii)); % [m/s]
            simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.initConditions.load', StabilitySweepInitCond.Load(ii)); % [kg]
            if StabilitySweepInitCond.MastLiftPos(ii) == 0
                simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.assemblyConditions.carriageFreeLiftPos', 0); % [mm]
                simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.assemblyConditions.middleOuterMastPos', 0); % [mm]
            elseif StabilitySweepInitCond.MastLiftPos(ii) < ForkliftParams.perfSpecs.maxFreeLift
                simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.assemblyConditions.carriageFreeLiftPos', ForkliftParams.initConditions.mastLiftPos);
                simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.assemblyConditions.middleOuterMastPos', 0); % [mm]
            else
                simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.assemblyConditions.carriageFreeLiftPos', ForkliftParams.perfSpecs.maxFreeLift);
                simIn(ii) = setVariable(simIn(ii), 'ForkliftParams.assemblyConditions.middleOuterMastPos', ...
                    (StabilitySweepInitCond.MastLiftPos(ii) - ForkliftParams.perfSpecs.maxFreeLift)/2); % [mm]
            end

            % Set test commands
            %simIn(ii) = setExternalInput(simIn(ii), StabilitySweepInputs{ii});
            simIn(ii) = setVariable(simIn(ii), 'activeTestCmds',StabilitySweepInputs{ii});
        end

    case 'MastLift'
        % Mast Lift Pos - 0 to requested lift
        % Initial position is 0
        ForkliftParams = sm_forklift_mast_assembly_targets(0,ForkliftParams);
        ForkliftParams.initConditions.mastLiftPos = ForkliftParams.perfSpecs.maxTotalLift*0;
        % Speed uses performance spec
        liftRampTime = testConds.lift(1)/ForkliftParams.perfSpecs.maxMastLiftSpeed; % [s]
        liftStopTime = liftRampTime+testDelay+holdTime;
        fcnCmd       = CreateRampCmd(0,testConds.lift(1),testDelay,liftRampTime,liftStopTime);                  
        fcnCmd.Name  = 'MastLiftPos';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;
        stopTime = liftStopTime; % [s]

        % Mast Tilt Pos - start and hold at requested position
        ForkliftParams.initConditions.mastTiltAngle = testConds.tilt(1); % [mm]
        fcnCmd = createConstCmd(testConds.tilt(1),liftStopTime);
        fcnCmd.Name = 'MastTiltAngle';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Carriage Side Shift Pos - start and hold at requested position
        ForkliftParams.initConditions.carriageSideShiftPos = testConds.shift(1); % [mm]
        fcnCmd = createConstCmd(testConds.shift(1),liftStopTime);
        fcnCmd.Name = 'SideShiftPos';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd; %#ok<*FNDSB>

        % Velocity  - assumed 0
        % Steer     - assumed 0

    case 'StaticLoad'
        % Parameters for test
        staticLoadStopTime = 10;

        % Mast Lift Pos - start and hold at requested position
        % Start at requested position
        ForkliftParams = sm_forklift_mast_assembly_targets(testConds.lift(1),ForkliftParams);
        ForkliftParams.initConditions.mastLiftPos = testConds.lift(1); % [mm]
        % Hold at requested position
        fcnCmd      = createConstCmd(testConds.lift(1),staticLoadStopTime);
        fcnCmd.Name = 'MastLiftPos';
        idxTmp      = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd; 

        % Mast Tilt Pos - start and hold at requested position
        ForkliftParams.initConditions.mastTiltAngle = testConds.tilt(1); % [mm]
        fcnCmd = createConstCmd(testConds.tilt(1),staticLoadStopTime);
        fcnCmd.Name = 'MastTiltAngle';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Carriage Side Shift Pos - start and hold at requested position
        ForkliftParams.initConditions.carriageSideShiftPos = testConds.shift(1); % [mm]
        fcnCmd = createConstCmd(testConds.shift(1),staticLoadStopTime);
        fcnCmd.Name = 'SideShiftPos';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd; %#ok<*FNDSB>

        % Velocity - zero
        fcnCmd = createConstCmd(0,staticLoadStopTime);
        fcnCmd.Name = 'Velocity';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Steer - assumed 0

        % Set stop time for event
        stopTime = staticLoadStopTime;

    case 'StepSteer'
        % Parameters for test
        delaySteerStart = 1;  % Hold target speed before steering
        velHoldTime     = 10; % Hold target speed to determine turning circle diameter

        % Velocity - 0 to max speed
        % Obtain acceleration based on performance specs
        if(testConds.vel(1)>0)
            maxAccel = ForkliftParams.perfSpecs.maxForwardAccel;
        elseif(testConds.vel(1)<0)
            maxAccel = ForkliftParams.perfSpecs.maxReverseAccel;
        elseif(testConds.vel(1)==0)
            error('Target velocity for Step Steer Test must be non-zero');
        end

        % Calculate time to reach max speed
        velRampTime = abs(testConds.vel(1)/maxAccel); % [s]
        % Calculate total time for test
        testStopTime = velRampTime+testDelay+velHoldTime;        
        fcnCmd      =  CreateRampCmd(0,testConds.vel(1),testDelay,velRampTime,testStopTime);
        fcnCmd.Name = 'Velocity';
        idxTmp       = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Steer Angle - 0 to target angle, start when at target speed
        ForkliftParams.initConditions.steerAngle = 0; % [deg]

        % Calculate start time for steer
        steerDelay = testDelay+velRampTime+delaySteerStart;
        % Calculate ramp time for steer
        strRampTime = abs(testConds.steer(1)/ForkliftParams.perfSpecs.maxSteerSpeed); % [s]
        fcnCmd =  CreateRampCmd(0,testConds.steer(1),steerDelay,strRampTime,testStopTime);
        fcnCmd.Name = 'SteerAngle';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Mast Lift Pos - hold at target position
        ForkliftParams = sm_forklift_mast_assembly_targets(testConds.lift(1),ForkliftParams);
        ForkliftParams.initConditions.mastLiftPos = testConds.lift(1); % [mm]
        fcnCmd = createConstCmd(testConds.lift(1),testStopTime);
        fcnCmd.Name = 'MastLiftPos';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Mast Tilt Pos - hold at target position
        ForkliftParams.initConditions.mastTiltAngle = testConds.tilt(1); % [mm]
        fcnCmd = createConstCmd(testConds.tilt(1),testStopTime);
        fcnCmd.Name = 'MastTiltAngle';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Carriage Side Shift Pos - hold at target position
        ForkliftParams.initConditions.carriageSideShiftPos = testConds.shift(1); % [mm]
        fcnCmd = createConstCmd(testConds.shift(1),testStopTime);
        fcnCmd.Name = 'SideShiftPos';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Set stop time for event
        stopTime = testStopTime; % [s]

    case 'ConstantRadius'
        % Parameters for test
        velHoldTime = 10; % Hold target speed to determine turning circle diameter

        % Velocity - 0 to target speed
        if(testConds.vel(1)>0)
            maxAccel = ForkliftParams.perfSpecs.maxForwardAccel;
        elseif(testConds.vel(1)<0)
            maxAccel = ForkliftParams.perfSpecs.maxReverseAccel;
        elseif(testConds.vel(1)==0)
            error('Target velocity for Constant Radius Test must be non-zero');
        end

        % Calculate time to ramp up speed
        velRampTime  = abs(testConds.vel(1)/maxAccel); % [s]
        % Calculate stop time for event
        testStopTime = velRampTime+testDelay+velHoldTime;
        fcnCmd       = CreateRampCmd(0,testConds.vel(1),testDelay,velRampTime,testStopTime);
        fcnCmd.Name  = 'Velocity';
        idxTmp       = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Steer Angle - hold at target angle
        ForkliftParams.initConditions.steerAngle = testConds.steer(1); % [deg]
        fcnCmd = createConstCmd(testConds.steer(1),testStopTime);
        fcnCmd.Name = 'SteerAngle';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Mast Lift Pos - hold at lift position
        ForkliftParams = sm_forklift_mast_assembly_targets(testConds.lift(1),ForkliftParams);
        ForkliftParams.initConditions.mastLiftPos = testConds.lift(1); % [mm]
        fcnCmd = createConstCmd(testConds.lift(1),testStopTime);
        fcnCmd.Name = 'MastLiftPos';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Mast Tilt Pos - hold at target position
        ForkliftParams.initConditions.mastTiltAngle = testConds.tilt(1); % [mm]
        fcnCmd = createConstCmd(testConds.tilt(1),testStopTime);
        fcnCmd.Name = 'MastTiltAngle';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Carriage Side Shift Pos - hold at target position
        ForkliftParams.initConditions.carriageSideShiftPos = testConds.shift(1); % [mm]
        fcnCmd = createConstCmd(testConds.shift(1),testStopTime);
        fcnCmd.Name = 'SideShiftPos';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Set stop time for event
        stopTime = testStopTime; % [s]

    case 'MastLowerBrake'
        % Parameters for test
        delayDecelStart = 2;  % Hold target speed before decelerating and lowering
        delayStopHold = 2;  % Hold target speed before decelerating and lowering
        %velHoldTime     = 10; % Hold target speed to determine turning circle diameter

        % Velocity - 0 to max speed
        % Obtain acceleration based on performance specs
        if(testConds.vel(1)>0)
            maxAccel = ForkliftParams.perfSpecs.maxForwardAccel;
            maxDecel = ForkliftParams.perfSpecs.maxForwardDecel;
        elseif(testConds.vel(1)<0)
            maxAccel = ForkliftParams.perfSpecs.maxReverseAccel;
            maxDecel = ForkliftParams.perfSpecs.maxReverseDecel;
        elseif(testConds.vel(1)==0)
            error('Target velocity for Step Steer Test must be non-zero');
        end

        % Calculate time to reach max speed and final speed
        velRampTime1 = abs(testConds.vel(1)/maxAccel); % [s]
        velRampTime2 = abs(testConds.vel(1)/maxDecel); % [s]
        % Calculate total time for velocity portion of test
        velStopTime = testDelay+velRampTime1+delayDecelStart+velRampTime2+delayStopHold;       
        fcnCmd      =  createTrapAsyCmd(testConds.vel(1),testDelay,delayDecelStart,velRampTime1,velRampTime2,velStopTime,0,0);
        fcnCmd.Name = 'Velocity';
        idxTmp       = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Steer Angle - 0 
        ForkliftParams.initConditions.steerAngle = 0; % [deg]

        % Calculate start time for steer
        steerDelay = testDelay+velRampTime1+delayDecelStart;
        fcnCmd = createConstCmd(0,velStopTime);
        fcnCmd.Name = 'SteerAngle';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;
        
        % Mast Lift Pos - requested lift to 0 
        % Initial position is requested lift
        ForkliftParams = sm_forklift_mast_assembly_targets(testConds.lift(1),ForkliftParams);
        ForkliftParams.initConditions.mastLiftPos = testConds.lift(1);
        % Speed uses performance spec
        liftRampTime  = testConds.lift(1)/ForkliftParams.perfSpecs.maxMastLowerSpeed; % [s]
        liftStartTime = testDelay+velRampTime1+delayDecelStart;
        liftStopTime  = liftStartTime + liftRampTime;

        %CreateRampCmd(initVal,finalVal,delay,rampTime,stopTime)
        fcnCmd       = CreateRampCmd(testConds.lift(1),0,liftStartTime,liftRampTime,liftStopTime+delayStopHold);                  
        fcnCmd.Name  = 'MastLiftPos';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Mast Tilt Pos - hold at target position
        ForkliftParams.initConditions.mastTiltAngle = testConds.tilt(1); % [mm]
        fcnCmd = createConstCmd(testConds.tilt(1),velStopTime);
        fcnCmd.Name = 'MastTiltAngle';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Carriage Side Shift Pos - hold at target position
        ForkliftParams.initConditions.carriageSideShiftPos = testConds.shift(1); % [mm]
        fcnCmd = createConstCmd(testConds.shift(1),velStopTime);
        fcnCmd.Name = 'SideShiftPos';
        idxTmp = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Set stop time for event
        stopTime = max(velStopTime,liftStopTime);

    case 'TiltLiftShift'
        % Parameters for test
        delayHold = 2;  % Hold position before next movement

        shiftPos   = min(testConds.shift(1),ForkliftParams.perfSpecs.maxCarriageSideShift);
        liftHeight = min(testConds.lift(1),ForkliftParams.perfSpecs.maxTotalLift*1000);
        if(shiftPos == 0),shiftPos = 1e-3;end
        if(liftHeight == 0),liftHeight = 1e-3;end
        if(testConds.tilt(1)>ForkliftParams.perfSpecs.maxMastForwardTiltAngle)
            tiltAngle = ForkliftParams.perfSpecs.maxMastForwardTiltAngle;
        elseif(testConds.tilt(1)<ForkliftParams.perfSpecs.maxMastBackTiltAngle)
            tiltAngle = ForkliftParams.perfSpecs.maxMastBackTiltAngle;
        elseif(testConds.tilt(1)==0)
            tiltAngle = 1e-3;
        else
            tiltAngle = testConds.tilt(1);
        end

        % Obtain Tilt, Lift, Shift times
        tiltCtrOutRampTime     = abs(  (tiltAngle)/ForkliftParams.perfSpecs.maxMastTiltSpeed); % [s]
        shiftCtrSideRampTime   = abs(  (shiftPos)/ForkliftParams.perfSpecs.maxCarriageSideShiftSpeed); % [s]
        liftUpRampTime         = abs(  (liftHeight)/ForkliftParams.perfSpecs.maxMastLiftSpeed); % [s]
        liftDownRampTime       = abs(  (liftHeight)/ForkliftParams.perfSpecs.maxMastLowerSpeed); % [s]

        testStopTime = ceil(testDelay+...
            tiltCtrOutRampTime+delayHold+liftUpRampTime+delayHold+shiftCtrSideRampTime+delayHold+...
            tiltCtrOutRampTime+delayHold+liftUpRampTime+delayHold+shiftCtrSideRampTime+testDelay);

        % Mast Lift Pos - requested lift to 0 
        % Initial position is requested lift
        ForkliftParams = sm_forklift_mast_assembly_targets(0,ForkliftParams);
        ForkliftParams.initConditions.mastLiftPos = 0;

        % Calculate times for lift portion of test
        liftStartTime = testDelay+tiltCtrOutRampTime+delayHold;
        liftHoldTime  = delayHold+shiftCtrSideRampTime+delayHold+...
            tiltCtrOutRampTime+delayHold;
        %createTrapAsyCmd(value,startOffset,holdTime,rampTime1,rampTime2,totalCmdTime,initVal,finalVal)
        fcnCmd      =  createTrapAsyCmd(liftHeight,liftStartTime,liftHoldTime,liftUpRampTime,liftDownRampTime,testStopTime,0,0);
        fcnCmd.Name = 'MastLiftPos';
        idxTmp       = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Calculate times for tilt portion of test
        tiltStartTime = testDelay;
        tiltHoldTime  = delayHold+liftUpRampTime+delayHold+shiftCtrSideRampTime+delayHold;
        %createTrapAsyCmd(value,startOffset,holdTime,rampTime1,rampTime2,totalCmdTime,initVal,finalVal)
        fcnCmd      =  createTrapAsyCmd(tiltAngle,tiltStartTime,tiltHoldTime,tiltCtrOutRampTime,tiltCtrOutRampTime,testStopTime,0,0);
        fcnCmd.Name = 'MastTiltAngle';
        idxTmp       = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Calculate times for Carriage Side Shift portion of test
        shiftStartTime = testDelay+...
            tiltCtrOutRampTime+delayHold+liftUpRampTime+delayHold;
        shiftHoldTime  = delayHold+...
            tiltCtrOutRampTime+delayHold+liftUpRampTime+delayHold;
        %createTrapAsyCmd(value,startOffset,holdTime,rampTime1,rampTime2,totalCmdTime,initVal,finalVal)
        fcnCmd      =  createTrapAsyCmd(shiftPos,shiftStartTime,shiftHoldTime,shiftCtrSideRampTime,shiftCtrSideRampTime,testStopTime,0,0);
        fcnCmd.Name = 'SideShiftPos';
        idxTmp       = find(strcmp(activeTestCmds.getElementNames,fcnCmd.Name));
        activeTestCmds{idxTmp} = fcnCmd;

        % Set stop time for event
        stopTime = testStopTime;

    case 'SweepRun'
        run StabilitySweepTestGenerator;
        ii = 1;

        % Set initial conditions
        ForkliftParams.initConditions.steerAngle = StabilitySweepInitCond.SteerAngle(ii); % [deg]
        ForkliftParams.initConditions.mastLiftPos = StabilitySweepInitCond.MastLiftPos(ii); % [mm]
        ForkliftParams.initConditions.mastTiltAngle = StabilitySweepInitCond.MastTiltAngle(ii); % [deg]
        ForkliftParams.initConditions.carriageSideShiftPos = StabilitySweepInitCond.SideShiftPos(ii); % [mm]
        ForkliftParams.initConditions.velocity = StabilitySweepInitCond.Velocity(ii); % [m/s]
        ForkliftParams.initConditions.load = StabilitySweepInitCond.Load(ii); % [kg]
        if StabilitySweepInitCond.MastLiftPos(ii) == 0
            ForkliftParams.assemblyConditions.carriageFreeLiftPos = 0; % [mm]
            ForkliftParams.assemblyConditions.middleOuterMastPos = 0; % [mm]
        elseif StabilitySweepInitCond.MastLiftPos(ii) < ForkliftParams.perfSpecs.maxFreeLift
            ForkliftParams.assemblyConditions.carriageFreeLiftPos = ForkliftParams.initConditions.mastLiftPos;
            ForkliftParams.assemblyConditions.middleOuterMastPos = 0; % [mm]
        else
            ForkliftParams.assemblyConditions.carriageFreeLiftPos = ForkliftParams.perfSpecs.maxFreeLift;
            ForkliftParams.assemblyConditions.middleOuterMastPos = ...
                (StabilitySweepInitCond.MastLiftPos(ii) - ForkliftParams.perfSpecs.maxFreeLift)/2; % [mm]
        end
        % Set test commands
        activeTestCmds = StabilitySweepInputs{ii};
    otherwise
        disp(['Event ' testType ' not found.']);
end

% Create trapezoidal command data
    function cmd = createTrapCmd(value,startOffset,rampTime,totalCmdTime,initVal,finalVal)
        cmd = timeseries([ ...
            initVal;
            initVal;
            value;
            value;
            finalVal;
            finalVal], [ ...
            0;
            startOffset;
            startOffset + rampTime;
            startOffset + totalCmdTime - rampTime;
            startOffset + totalCmdTime;
            startOffset + startOffset + totalCmdTime]);
    end

% Create asymmetrical trapezoidal command data
    function cmd = createTrapAsyCmd(value,startOffset,holdTime,rampTime1,rampTime2,totalCmdTime,initVal,finalVal)
        cmd = timeseries([ ...
            initVal;
            initVal;
            value;
            value;
            finalVal;
            finalVal], [ ...
            0;
            startOffset;
            startOffset + rampTime1;
            startOffset + rampTime1 + holdTime;
            startOffset + rampTime1 + holdTime + rampTime2;
            totalCmdTime]);
    end


% Create constant command data
    function cmd = createConstCmd(value,totalCmdTime)
        cmd = timeseries([value; value], [0 totalCmdTime]);
    end

% Ramp command
    function cmd = CreateRampCmd(initVal,finalVal,delay,rampTime,stopTime)
        cmd = timeseries([initVal; initVal; finalVal; finalVal], ...
            [0; delay; delay+rampTime; stopTime]);
    end
end