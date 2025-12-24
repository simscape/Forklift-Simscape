function sm_forklift_plot3activeTestCmds(activeTestCmds)
% Code to plot model inputs for sm_forklift
%% Plot Description:
%
% The plot below shows the position of the vehicle during the maneuver.

% Copyright 2021-2025 The MathWorks, Inc.

% Reuse figure if it exists, else create new figure
figString = ['h1_' mfilename];
% Only create a figure if no figure exists
figExist = 0;
fig_hExist = evalin('base',['exist(''' figString ''')']);
if (fig_hExist)
    figExist = evalin('base',['ishandle(' figString ') && strcmp(get(' figString ', ''type''), ''figure'')']);
end
if ~figExist
    fig_h = figure('Name',figString);
    assignin('base',figString,fig_h);
else
    fig_h = evalin('base',figString);
end
figure(fig_h)
clf(fig_h)

% Get simulation results
%simlog_xVeh = simlogRes.Forklift.Body_to_Ground.x6_DOF_Joint.Px.p.series.values;
%simlog_yVeh = simlogRes.Forklift.Body_to_Ground.x6_DOF_Joint.Py.p.series.values;

% Plot results
ah(1) = subplot(5,1,1);
plot(activeTestCmds.get('Velocity').Time, activeTestCmds.get('Velocity').Data, 'LineWidth', 1)
ylabel('Velocity (m/s)')
title('Model Inputs')
grid on

ah(2) = subplot(5,1,2);
plot(activeTestCmds.get('MastLiftPos').Time, activeTestCmds.get('MastLiftPos').Data, 'LineWidth', 1)
ylabel('Lift (mm)')
grid on

ah(3) = subplot(5,1,3);
plot(activeTestCmds.get('MastTiltAngle').Time, activeTestCmds.get('MastTiltAngle').Data, 'LineWidth', 1)
ylabel('Tilt (mm)')
grid on

ah(4) = subplot(5,1,4);
plot(activeTestCmds.get('SteerAngle').Time, activeTestCmds.get('SteerAngle').Data, 'LineWidth', 1)
ylabel('Steer (deg)')
grid on

ah(5) = subplot(5,1,5);
plot(activeTestCmds.get('SideShiftPos').Time, activeTestCmds.get('SideShiftPos').Data, 'LineWidth', 1)
ylabel('Shift (mm)')
xlabel('Time (sec)')
grid on

linkaxes(ah,'x')

