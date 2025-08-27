function resultsTable = StabilitySweepAnalyzer(SweepResults,StabilitySweepInitCond,varargin)
%% Stability Sweep Analysis
% This script creates plots and displays the results of the stability sweep
% test

fileName   = [];
folderName = [];
if(nargin>2)
    folderName = varargin{1};
    fileName   = varargin{2};
end


%% Table of Results
% Column names
columnNames = {'Load', 'MastLiftPos', 'MastTiltAngle', 'SideShiftPos', ...
    'SteerAngle', 'Velocity', 'RightFrontNF', 'LeftFrontNF', ...
    'RightRearNF', 'LeftRearNF', 'ContactLost','spinOut','Tip'};

% Number of tests
numTests = numel(SweepResults);

% Data
load          = StabilitySweepInitCond.Load; % kg
mastLiftPos   = GetLastVals(SweepResults, 'FeedbackBus', 'MastLiftPos', numTests);
%mastTiltAngle = GetLastVals(SweepResults, 'FeedbackBus', 'MastTiltAngle', numTests);
mastTiltAngle = StabilitySweepInitCond.MastTiltAngle;
%sideShiftPos  = GetLastVals(SweepResults, 'FeedbackBus', 'SideShiftPos', numTests);
sideShiftPos  = StabilitySweepInitCond.SideShiftPos;
steerAngle    = GetLastVals(SweepResults, 'FeedbackBus', 'SteerAngle', numTests);
xVelocity     = GetLastVals(SweepResults, 'FeedbackBus', 'VelX', numTests);
yVelocity     = GetLastVals(SweepResults, 'FeedbackBus', 'VelY', numTests);
velocity      = sqrt(xVelocity.^2 + yVelocity.^2).*sign(StabilitySweepInitCond.Velocity);
rightFrontFN  = GetLastVals(SweepResults, 'fnAxleF', 'FR', numTests);
leftFrontFN   = GetLastVals(SweepResults, 'fnAxleF', 'FL', numTests);
rightRearFN   = GetLastVals(SweepResults, 'fnAxleR', 'RR', numTests);
leftRearFN    = GetLastVals(SweepResults, 'fnAxleR', 'RL', numTests);
contactLost   = GetLastVals(SweepResults, 'ContactLost', '', numTests);
Tip           = GetLastVals(SweepResults, 'Tip', '', numTests);

spinOut       = getMaxVal(SweepResults, 'FeedbackBus', {'vtFL','vtFR','vtRL','vtRR'}, numTests);

% Create a table
%resultsTable = table(load, mastLiftPos, mastTiltAngle, ...
%    sideShiftPos, steerAngle, velocity, ...
%    rightFrontFN, leftFrontFN, rightRearFN, ...
%    leftRearFN, contactLost, ...
%    'VariableNames', columnNames);

resultsTable = table(load, mastLiftPos, mastTiltAngle, ...
    sideShiftPos, steerAngle, velocity, ...
    rightFrontFN, leftFrontFN, rightRearFN, ...
    leftRearFN, contactLost, spinOut, Tip, ...
    'VariableNames', columnNames);


    function lastVals = GetLastVals(SweepResults, SignalName, FunctionName, numTests)
        % Initialize
        lastVals = zeros(numTests,1);
        % Populate
        for ii = 1:1:numel(SweepResults)
            % Get signal
            sigTmp = SweepResults(ii).logsout_sm_forklift.find(SignalName);
            % Get last value
            if isa(sigTmp.Values,'timeseries')
                lastVals(ii,1) = sigTmp.Values.Data(end);
                signValue      = sign(mean(sigTmp.Values.Data));
            else
                lastVals(ii,1) = sigTmp.Values.(FunctionName).Data(end);
                signValue      = sign(mean(sigTmp.Values.(FunctionName).Data));
            end

            % Capture "Forward" or "Reverse" in sign of X velocity
            % The sign will appear in summary tables which set plot titles
            if(signValue==0)
                signValue = 1;
            end
            if(strcmp(SignalName,'VelX'))
                lastVals(ii,1) = abs(lastVals(ii,1))*signValue;
            end

        end
    end

    function maxVal = getMaxVal(SweepResults, SignalName, FunctionName, numTests)
        % Initialize
        maxVal = zeros(numTests,1);
        % Populate
        for ii = 1:1:numel(SweepResults)
            maxValSet = [];
            for si = 1:length(FunctionName)
                % Get signal
                sigTmp = SweepResults(ii).logsout_sm_forklift.find(SignalName);
                % Get last value
                if isa(sigTmp.Values,'timeseries')
                    maxValSet(si) = sigTmp.Values.Data(end);
                    %signValue      = sign(mean(sigTmp.Values.Data));
                else
                    maxValSet(si) = sigTmp.Values.(FunctionName{si}).Data(end);
                    %signValue      = sign(mean(sigTmp.Values.(FunctionName{si}).Data));
                end
            end
            maxVal(ii,1) = max(maxValSet);

            % Capture "Forward" or "Reverse" in sign of X velocity
            % The sign will appear in summary tables which set plot titles
            %if(signValue==0)
            %    signValue = 1;
            %end
            %if(strcmp(SignalName,'VelX'))
            %    lastVals(ii,1) = abs(lastVals(ii,1))*signValue;
            %end
        end
    end

%% Normal Force Plot
figure('numbertitle','off','name','Normal Force')
hold on;
for ii = 1:1:numTests
    % Get data
    frontSig = SweepResults(ii).logsout_sm_forklift.find('fnAxleF');
    rearSig = SweepResults(ii).logsout_sm_forklift.find('fnAxleR');
    time = frontSig.Values.FR.Time;
    rightFrontOuter = frontSig.Values.FR.Data;
    %rightFrontInner = frontSig.Values.rightIn.Data;
    leftFrontOuter = frontSig.Values.FL.Data;
    %leftFrontInner = frontSig.Values.leftIn.Data;
    rightRearOuter = rearSig.Values.RR.Data;
    %rightRearInner = rearSig.Values.rightIn.Data;
    leftRearOuter = rearSig.Values.RL.Data;
    %leftRearInner = rearSig.Values.leftIn.Data;

    % Plot data
    rFOPlot = plot(time, rightFrontOuter,'k');
    %plot(time, rightFrontInner,'k');
    lFOPlot = plot(time, leftFrontOuter,'m');
    %plot(time, leftFrontInner,'m');
    rROPlot = plot(time, rightRearOuter,'r');
    %plot(time, rightRearInner,'r');
    lROPlot = plot(time, leftRearOuter,'c');
    %plot(time, leftRearInner,'c');
end
title('Normal Force');
xlabel('Time [s]');
ylabel('Normal Force [N]');
ylim([0 2e5]);
legend([rFOPlot(1);lFOPlot(1);rROPlot(1);lROPlot(1)],{'Right Front','Left Front','Right Rear','Left Rear'});

if(~isempty(fileName))
    saveas(gcf,[folderName filesep fileName '_Fn.png'])
end
%saveas(gcf,[fileName 'NormalForces.png']);

%% Contact Lost Surface Plot
%{
var1 = mastLiftPos;
var2 = load;
var3 = leftRearFN;

if(length(var1)>1 && length(var2)>2 )
    [xGrid, yGrid] = meshgrid(var1,var2);
    zGrid = griddata(var1, var2, var3, xGrid, yGrid, 'linear');

    figure('numbertitle','off','name','Two Variable Surface Plot');
    surf(xGrid,yGrid,zGrid);
    xlabel('Mast Lift Position [mm]');
    ylabel('Load [kg]');
    zlabel('Normal Force [N]');

    if(~isempty(fileName))
        saveas(gcf,[folderName filesep fileName '_Surf.png'])
    end
end
%saveas(gcf,[fileName 'SurfacePlot.png']);
%}
end