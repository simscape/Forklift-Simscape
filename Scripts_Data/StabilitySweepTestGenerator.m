function [StabilitySweepInputs, StabilitySweepInitCond, stopTime]  = StabilitySweepTestGenerator(sweepConds,ForkliftParams)

%% Stability Sweep Test Generator
% This script creates the sweep of stability tests
holdTime  = 2; % [s] Time to hold position at the end of a ramp before stopping the simulation
testDelay = ForkliftParams.testConditions.testDelay;

%% Initial Condition Sets
% Velocity
InitCondSetup.Velocity.values      = sweepConds.vel;
InitCondSetup.MastLiftPos.values   = sweepConds.lift;
InitCondSetup.MastTiltAngle.values = sweepConds.tilt;
InitCondSetup.Load.values          = sweepConds.load;
InitCondSetup.SteerAngle.values    = sweepConds.steer;
InitCondSetup.SideShiftPos.values  = sweepConds.shift;

sweepType = sweepConds.type;
switch sweepType
    case 'MastLiftSweep'
        % Define dynamic conditions: Mast Lift
        MastSweep.rampTime = ForkliftParams.perfSpecs.maxTotalLift/ForkliftParams.perfSpecs.maxMastLiftSpeed; % [s]
        MastSweep.stopTime = MastSweep.rampTime+testDelay+holdTime;
        MastSweep.rampCmd = CreateRampCmd(0,ForkliftParams.perfSpecs.maxTotalLift,testDelay,MastSweep.rampTime,MastSweep.stopTime);
        MastSweep.rampCmd.Name = 'MastLiftPos';
        stopTime = MastSweep.stopTime;

        % Assemble combinations of static test conditions
        % Sweep static test conditions: Tilt, Shift, Load
        % Held at 0: Steer, Velocity
        StabilitySweepInitCond = combinations(0,...
            0,...
            InitCondSetup.MastTiltAngle.values,...
            0,...
            InitCondSetup.SideShiftPos.values,...
            InitCondSetup.Load.values);
        StabilitySweepInitCond.Properties.VariableNames = {'Velocity', 'MastLiftPos', 'MastTiltAngle','SteerAngle','SideShiftPos','Load'};

        % Load empty simulation dataset for test commands
        load('ForkliftTestCommands.mat','TestCmds');
        StabilitySweepInputs = {};

        % Assemble data for simulation tests
        % Loop over all test conditions
        for ii = 1:1:height(StabilitySweepInitCond)

            % Load empty dataset
            StabilitySweepInputs{ii,1} = TestCmds;

            % Loop over model input signals: Vel, Lift, Tilt, Steer, Shift
            % Assumed to be first five variables in StabilitySweepInitCond
            for jj = 1:1:5
                % Assign data for model input signals
                StabilitySweepInputs{ii} = SetConstTestValue(StabilitySweepInitCond{ii,jj}, ...
                    StabilitySweepInitCond.Properties.VariableNames{jj}, ...
                    MastSweep.stopTime, ...
                    StabilitySweepInputs{ii});
            end

            % Overwrite inputs for dynamic condition: Mast Lift
            fcnCmd.Name = MastSweep.rampCmd.Name;
            idxTmp = find(strcmp(StabilitySweepInputs{ii}.getElementNames,fcnCmd.Name));
            StabilitySweepInputs{ii}{idxTmp} = MastSweep.rampCmd;
        end

        %% Mast and load change as initial conditions only
    case 'StaticLoadSweep'
        % Define dynamic conditions: None
        stopTime = 10;

        % Assemble combinations of static test conditions
        % Sweep static test conditions: Lift, Tilt, Shift, Load
        % Held at 0: Steer, Velocity
        StabilitySweepInitCond = combinations(0,...
            InitCondSetup.MastLiftPos.values,...
            InitCondSetup.MastTiltAngle.values,...
            0,...
            InitCondSetup.SideShiftPos.values,...
            InitCondSetup.Load.values);
        StabilitySweepInitCond.Properties.VariableNames = {'Velocity', 'MastLiftPos', 'MastTiltAngle','SteerAngle','SideShiftPos','Load'};

        % Load empty simulation dataset for test commands
        load('ForkliftTestCommands.mat','TestCmds');
        StabilitySweepInputs = {};

        % Assemble data for simulation tests
        % Loop over all test conditions
        for ii = 1:1:height(StabilitySweepInitCond)

            % Load empty dataset
            StabilitySweepInputs{ii,1} = TestCmds;

            % Loop over model input signals: Vel, Lift, Tilt, Steer, Shift
            % Assumed to be first five variables in StabilitySweepInitCond
            for jj = 1:1:5
                % Assign data for model input signals
                StabilitySweepInputs{ii} = SetConstTestValue(StabilitySweepInitCond{ii,jj}, ...
                    StabilitySweepInitCond.Properties.VariableNames{jj}, ...
                    stopTime, ...
                    StabilitySweepInputs{ii});
            end

            % Overwrite inputs for dynamic condition: None

        end
        %% Sweep forward velocity against all other initial conditions
    case 'ConstantRadiusSweep'
        % Constant Radius Acceleration
        % Get acceleration limit for forward or reverse
        if(sweepConds.vel>0)
            maxAccel = ForkliftParams.perfSpecs.maxForwardAccel;
        elseif(sweepConds.vel<0)
            maxAccel = ForkliftParams.perfSpecs.maxReverseAccel;
        elseif(sweepConds.vel==0)
            error('Target velocity for Constant Radius Test must be non-zero');
        end


        % Define dynamic conditions: Velocity
        VelocitySweep.rampTime = abs(sweepConds.vel/maxAccel); % [s]
        VelocitySweep.stopTime = VelocitySweep.rampTime+testDelay+holdTime;
        VelocitySweep.rampCmd = CreateRampCmd(0,sweepConds.vel,testDelay,VelocitySweep.rampTime,VelocitySweep.stopTime);
        VelocitySweep.rampCmd.Name = 'Velocity';
        stopTime = VelocitySweep.stopTime;

        % Assemble combinations of static test conditions
        % Sweep static test conditions: Lift, Tilt, Steer, Shift, Load
        StabilitySweepInitCond = combinations(0,...
            InitCondSetup.MastLiftPos.values,...
            InitCondSetup.MastTiltAngle.values,...
            InitCondSetup.SteerAngle.values,...
            InitCondSetup.SideShiftPos.values,...
            InitCondSetup.Load.values);
        StabilitySweepInitCond.Properties.VariableNames = {'Velocity', 'MastLiftPos', 'MastTiltAngle','SteerAngle','SideShiftPos','Load'};

        % Load empty simulation dataset for test commands
        load('ForkliftTestCommands.mat','TestCmds');
        StabilitySweepInputs = {};

        % Assemble data for simulation tests
        % Loop over all test conditions
        for ii = 1:1:height(StabilitySweepInitCond)

            % Load empty dataset
            StabilitySweepInputs{ii,1} = TestCmds;

            % Loop over model input signals: Vel, Lift, Tilt, Steer, Shift
            % Assumed to be first five variables in StabilitySweepInitCond
            for jj = 1:1:5
                StabilitySweepInputs{ii} = SetConstTestValue(StabilitySweepInitCond{ii,jj}, ...
                    StabilitySweepInitCond.Properties.VariableNames{jj}, ...
                    VelocitySweep.stopTime, ...
                    StabilitySweepInputs{ii});
            end

            % Overwrite inputs for dynamic condition: Velocity
            fcnCmd.Name = VelocitySweep.rampCmd.Name;
            idxTmp = find(strcmp(StabilitySweepInputs{ii}.getElementNames,fcnCmd.Name));
            StabilitySweepInputs{ii}{idxTmp} = VelocitySweep.rampCmd;
        end

    case 'StepSteerSweep'
        % Step Steer Forward velocity positive steer sweep
        % Velocity ramp from 0
        velHoldTime = 10;

        % Get acceleration limit for forward or reverse
        if(sweepConds.vel>0)
            maxAccel = ForkliftParams.perfSpecs.maxForwardAccel;
        elseif(sweepConds.vel<0)
            maxAccel = ForkliftParams.perfSpecs.maxReverseAccel;
        elseif(sweepConds.vel==0)
            error('Target velocity for Step Steer Test must be non-zero');
        end

        % Define dynamic conditions: Velocity, Steer
        VelocitySweep.rampTime = abs(sweepConds.vel/maxAccel); % [s]
        VelocitySweep.stopTime = VelocitySweep.rampTime+testDelay+velHoldTime;
        VelocitySweep.rampCmd = CreateRampCmd(0,sweepConds.vel,testDelay,VelocitySweep.rampTime,VelocitySweep.stopTime);
        VelocitySweep.rampCmd.Name = 'Velocity';
        stopTime = VelocitySweep.stopTime;

        % Steer ramp from 0
        steerDelay = VelocitySweep.rampTime+testDelay+1;
        SteerSweep.rampTime = abs(sweepConds.steer/ForkliftParams.perfSpecs.maxSteerSpeed); % [s]
        SteerSweep.stopTime = VelocitySweep.stopTime;
        SteerSweep.rampCmd = CreateRampCmd(0,sweepConds.steer,steerDelay,SteerSweep.rampTime,SteerSweep.stopTime);
        SteerSweep.rampCmd.Name = 'SteerAngle';

        % Assemble combinations of static test conditions
        % Sweep static test conditions: Lift, Tilt, Shift, Load
        StabilitySweepInitCond = combinations(0,...
            InitCondSetup.MastLiftPos.values,...
            InitCondSetup.MastTiltAngle.values,...
            0,...
            InitCondSetup.SideShiftPos.values,...
            InitCondSetup.Load.values);
        StabilitySweepInitCond.Properties.VariableNames = {'Velocity', 'MastLiftPos', 'MastTiltAngle','SteerAngle','SideShiftPos','Load'};

        % Load empty simulation dataset for test commands
        load('ForkliftTestCommands.mat','TestCmds');
        StabilitySweepInputs = {};

        % Assemble data for simulation tests
        % Loop over all test conditions
        for ii = 1:1:height(StabilitySweepInitCond)

            % Load empty dataset
            StabilitySweepInputs{ii,1} = TestCmds;

            % Loop over model input signals: Vel, Lift, Tilt, Steer, Shift
            % Assumed to be first five variables in StabilitySweepInitCond
            for jj = 1:1:5
                StabilitySweepInputs{ii} = SetConstTestValue(StabilitySweepInitCond{ii,jj}, ...
                    StabilitySweepInitCond.Properties.VariableNames{jj}, ...
                    VelocitySweep.stopTime, ...
                    StabilitySweepInputs{ii});
            end

            % Overwrite inputs for dynamic condition: Velocity, Steer
            fcnCmd.Name = VelocitySweep.rampCmd.Name;
            idxTmp = find(strcmp(StabilitySweepInputs{ii}.getElementNames,fcnCmd.Name));
            StabilitySweepInputs{ii}{idxTmp} = VelocitySweep.rampCmd;

            fcnCmd.Name = SteerSweep.rampCmd.Name;
            idxTmp = find(strcmp(StabilitySweepInputs{ii}.getElementNames,fcnCmd.Name));
            StabilitySweepInputs{ii}{idxTmp} = SteerSweep.rampCmd;
        end
end

%% Functions
% Constant value
    function testDataset = SetConstTestValue(val,name,stopTime,testDataset)
        fcnCmd = CreateConstCmd(val,stopTime);
        fcnCmd.Name = name;
        idxTmp = find(strcmp(testDataset.getElementNames,fcnCmd.Name));
        testDataset{idxTmp} = fcnCmd;
    end

% Ramp command
    function cmd = CreateRampCmd(initVal,finalVal,delay,rampTime,stopTime)
        cmd = timeseries([initVal; initVal; finalVal; finalVal], ...
            [0; delay; delay+rampTime; stopTime]);
    end

% Create constant command data
    function cmd = CreateConstCmd(value,totalCmdTime)
        cmd = timeseries([value; value], [0; totalCmdTime]);
    end

end