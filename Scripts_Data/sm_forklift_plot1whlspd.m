function h=sm_forklift_plot1whlspd(simlogRes,whlRadF,whlRadR)
% Code to plot simulation results from sm_forklift_plot1whlspd
%% Plot Description:
%
% The plot below shows the wheel speeds during the maneuver.  The
% rotational wheel speeds are scaled by the unloaded radius so they can be
% compared with the translational speed of the vehicle.

% Copyright 2021-2024 The MathWorks, Inc.

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
simlog_t    = simlogRes.Forklift.AxleF.Revolute_Whl_FL.Rz.w.series.time;
simlog_vFL  = simlogRes.Forklift.AxleF.Revolute_Whl_FL.Rz.w.series.values('rad/s')*whlRadF;
simlog_vFR  = simlogRes.Forklift.AxleF.Revolute_Whl_FR.Rz.w.series.values('rad/s')*whlRadF;
simlog_vRL  = simlogRes.Forklift.AxleR.Revolute_Whl_RL.Rz.w.series.values('rad/s')*whlRadR;
simlog_vRR  = simlogRes.Forklift.AxleR.Revolute_Whl_RR.Rz.w.series.values('rad/s')*whlRadR;
signSpd = sign(sum(sign([simlog_vFL';simlog_vFR';simlog_vRL';simlog_vRR'])))';
signSpd(signSpd==0) = 1;
%simlog_Veh  = logsoutRes.get('Vehicle');
simlog_vxVeh = simlogRes.Forklift.Body_to_Ground.x6_DOF_Joint.Px.v.series.values('m/s');
simlog_vyVeh = simlogRes.Forklift.Body_to_Ground.x6_DOF_Joint.Py.v.series.values('m/s');
simlog_vVeh  = sqrt(simlog_vxVeh.^2+simlog_vyVeh.^2);

temp_colororder = get(gca,'defaultAxesColorOrder');
% Plot results
plot(simlog_t, simlog_vVeh.*signSpd, 'k--', 'LineWidth', 1)
hold on
plot(simlog_t, simlog_vFL, 'Color',temp_colororder(1,:),'LineWidth', 1)
plot(simlog_t, simlog_vFR, 'Color',temp_colororder(2,:),'LineWidth', 1)
plot(simlog_t, simlog_vRL, 'Color',temp_colororder(3,:),'LineWidth', 1)
plot(simlog_t, simlog_vRR, 'Color',temp_colororder(4,:),'LineWidth', 1)

hold off
ylabel('Speed (m/s)')
xlabel('Time (s)')
title('Wheel Speeds and Vehicle Speed')
grid on
legend({'Vehicle','FL','FR','RL','RR'},'Location','Best');
text(0.05,0.05,'Wheel Speeds estimated with unloaded radius','Units','normalized','Color',[0.6 0.6 0.6])

