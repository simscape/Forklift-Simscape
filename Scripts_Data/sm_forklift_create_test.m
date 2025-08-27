function sm_forklift_create_test(testConds)

ForkliftParams = evalin('base','ForkliftParams');
[activeTestCmds, ~, stopTime,~,ForkliftParams] = ForkliftTestDefinitions(testConds,ForkliftParams);
assignin('base','activeTestCmds',activeTestCmds);
assignin('base','stopTime',stopTime);
assignin('base','ForkliftParams',ForkliftParams);

