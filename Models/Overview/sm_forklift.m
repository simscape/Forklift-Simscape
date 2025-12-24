%% Forklift Stability Model
% 
% 
% This example models a forklift with three-stage mast. You can use this model 
% to perform stability analyses by sweeping design parameters and test conditions. 
% The mechanical model of the lift was created in CAD software and imported 
% into Simscape Multibody. 
% 
% * *CAD geometry* is imported to ensure accurate representation of masses, 
% inertias, and joint locations.
% * *Mechanical effects* are incorporated into the design, including ground 
% contact and cables in the lift mast
% * *Stability analyses* are performed by sweeping design parameters in a 
% range of test test scenarios
% * *Actuator requirements* are refined using dynamic simulation with 
% abstract actuator models
% * *MATLAB Apps* enables rapid test configuration
% 
% <<sm_forklift_overview_image.png>>
%  
% Copyright 2025 The MathWorks, Inc.

%% Model

open_system('sm_forklift')

set_param(find_system('sm_forklift','MatchFilter',@Simulink.match.allVariants,'FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Forklift Model
%
% The chassis, front and rear axles, and mast are modeled in this
% subsystem.  

set_param('sm_forklift/Forklift','LinkStatus','none')
open_system('sm_forklift/Forklift','force')

%% Mast Model
%
% This subsystem models the mast and carriage.

set_param('sm_forklift/Forklift/Mast','LinkStatus','none')
open_system('sm_forklift/Forklift/Mast','force')

%% Rear Model with Steering
%
% This subsystem models the rear axle with steering.

set_param('sm_forklift/Forklift/AxleR','LinkStatus','none')
open_system('sm_forklift/Forklift/AxleR','force')

%% Front Model with Steering
%
% This subsystem models the front axle with driven wheels.

set_param('sm_forklift/Forklift/AxleF','LinkStatus','none')
open_system('sm_forklift/Forklift/AxleF','force')



%% Simulation Results from Simscape Logging, Constant Radius Test
%%
%
% The plot below shows the wheel speeds and forklift position during the
% maneuver.

constRadF.vel = 3;
sm_forklift_create_test(constRadF);
out=sim('sm_forklift');
sm_forklift_plot1whlspd(out.simlog_sm_forklift,ForkliftParams.groundContact.frontTireRad,ForkliftParams.groundContact.rearTireRad)
sm_forklift_plot2bodypos(out.simlog_sm_forklift)
sm_forklift_plot4whlfn(out.logsout_sm_forklift)

%% Simulation Results from Simscape Logging, Step Steer
%%
% The plot below shows the wheel speeds and forklift position during the
% maneuver.
%

stepSteerFL.vel = 3;
sm_forklift_create_test(stepSteerFL);
out=sim('sm_forklift');
sm_forklift_plot1whlspd(out.simlog_sm_forklift,ForkliftParams.groundContact.frontTireRad,ForkliftParams.groundContact.rearTireRad)
sm_forklift_plot2bodypos(out.simlog_sm_forklift)
sm_forklift_plot4whlfn(out.logsout_sm_forklift)

%% Simulation Results from Simscape Logging, Step Steer Animation
%
% This animation shows how the forklift can tip under certain test
% conditions.
%
% <<Forklift_StepSteerFL_Compare_4_minEvent_2p5sec.gif>>
% 

%% Simulation Results from Simscape Logging, Step Steer Sweep
%%
% The heatmap below shows the relative stability of the forklift under
% varying test conditions during a step steer. 
% 
% * The value in the heat map is the minimum wheel normal force at the end
% of the test. Each individual heat map *varies the amount of load and side
% shift position* of the forks.
% * From left to right, each individual heat map shows the results with
% *increasing forward mast tilt* 
% * From bottom to top, each individual heamp shows the results with
% *increasing mast height* 
%
% The results show the worst case condition occurs at maximum forward tilt,
% maximum mast height.

bdclose('sm_forklift')
close(h1_sm_forklift_plot1whlspd)
close(h1_sm_forklift_plot2bodypos)
close(h1_sm_forklift_plot4whlfn)

load_system('sm_forklift')
stepSteerFLSweep.vel = 3;
sm_forklift_run_sweep(stepSteerFLSweep,true);


%%

%clear all
close all
bdclose all
