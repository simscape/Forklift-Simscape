function sm_forklift_plot2bodypos(simlogRes)
% Code to plot simulation results from sm_vehicle_2axle_heave_roll
%% Plot Description:
%
% The plot below shows the position of the vehicle during the maneuver.

% Copyright 2021-2024 The MathWorks, Inc.

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
simlog_xVeh = simlogRes.Forklift.Body_to_Ground.x6_DOF_Joint.Px.p.series.values;
simlog_yVeh = simlogRes.Forklift.Body_to_Ground.x6_DOF_Joint.Py.p.series.values;

% Plot results
plot(simlog_xVeh, simlog_yVeh, 'LineWidth', 1)
xlabel('X Position (m)')
ylabel('Y Position (m)')
title('Vehicle Position, World Coordinates')
grid on
axis equal

% Calculate turning circle
simlog_t = simlogRes.Forklift.Body_to_Ground.x6_DOF_Joint.Px.p.series.time;
ind12    = find(simlog_t>12,1);
minY     = min(simlog_yVeh(ind12:end));
maxY     = max(simlog_yVeh(ind12:end));
%minX     = min(simlog_xVeh(ind12:end));
%maxX     = max(simlog_xVeh(ind12:end));

tcd = (maxY-minY);

text(0.05,0.05,['Final Position: ' sprintf('%3.2fm, %3.2fm',simlog_xVeh(end),simlog_yVeh(end)) '    TCD: ' sprintf('%3.2fm',tcd)],'Color',[0.6 0.6 0.6],'Units','Normalized')







