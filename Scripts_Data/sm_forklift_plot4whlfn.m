function h=sm_forklift_plot4whlfn(logsoutRes)
% Code to plot simulation results from sm_forklift_plot1whlspd
%% Plot Description:
%
% The plot below shows the wheel speeds during the maneuver.  The
% rotational wheel speeds are scaled by the unloaded radius so they can be
% compared with the translational speed of the vehicle.

% Copyright 2021-2025 The MathWorks, Inc.

% Reuse figure if it exists, else create new figure
figString = ['h1_' mfilename];
% Only create a figure if no figure exists
figExist = 0;
fig_hExist = evalin('base',['exist(''' figString ''',''var'')']);
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
simlog_t    = logsoutRes.get('fnAxleF').Values.FL.Time;
simlog_FnFL = logsoutRes.get('fnAxleF').Values.FL.Data;
simlog_FnFR = logsoutRes.get('fnAxleF').Values.FR.Data;
simlog_FnRL = logsoutRes.get('fnAxleR').Values.RL.Data;
simlog_FnRR = logsoutRes.get('fnAxleR').Values.RR.Data;

% Plot results
plot(simlog_t, simlog_FnFL, 'LineWidth', 1,'DisplayName','FL')
hold on
plot(simlog_t, simlog_FnFR, 'LineWidth', 1,'DisplayName','FR')
plot(simlog_t, simlog_FnRL, 'LineWidth', 1,'DisplayName','RL')
plot(simlog_t, simlog_FnRR, 'LineWidth', 1,'DisplayName','RR')

hold off
ylabel('Force (N)')
xlabel('Time (s)')
title('Wheel Normal Forces')
grid on
legend('Location','Best');
%text(0.05,0.05,'Wheel Speeds estimated with unloaded radius','Units','normalized','Color',[0.6 0.6 0.6])

