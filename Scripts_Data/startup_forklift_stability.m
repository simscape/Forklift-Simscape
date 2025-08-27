% startup_commands
sm_forklift_params;
Camera = sm_car_define_camera_forklift;
testConds
[activeTestCmds, simIn, stopTime,StabilitySweepInitCond,ForkliftParams] = ForkliftTestDefinitions(stepSteerFL,ForkliftParams);
open_system('sm_forklift')