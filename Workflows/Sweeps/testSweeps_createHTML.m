function testSweeps_createHTML(fileNameSuffix)
% Define the filename (Recommend: file name as input argument or from CSV file)
cd(fileparts(which(mfilename)))

filename = 'Forklift_Stability_Results.m';

% Open the file for writing
fileID = fopen(filename, 'w');

fprintf(fileID, '%%%% Forklift Stability Test Results\n');
fprintf(fileID, '\n');
fprintf(fileID, '%%%% Static Test\n');
fprintf(fileID, '%% \n');
fprintf(fileID, '%% <<Static_%sMap.png>>\n',fileNameSuffix);
fprintf(fileID, '\n');
fprintf(fileID, '%%%% Constant Radius Acceleration, Forward\n');
fprintf(fileID, '%% \n');
fprintf(fileID, '%% <<ConstRadAccFwd_%sqS35.png>>\n',fileNameSuffix);
%fprintf(fileID, '\n');
%fprintf(fileID, '%%%% Constant Radius Acceleration, Forward, Steer R\n');
fprintf(fileID, '%% \n');
fprintf(fileID, '%% <<ConstRadAccFwd_%sqS-35.png>>\n',fileNameSuffix);
fprintf(fileID, '\n');
fprintf(fileID, '%%%% Constant Radius Acceleration, Reverse\n');
fprintf(fileID, '%% \n');
fprintf(fileID, '%% <<ConstRadAccRev_%sqS35.png>>\n',fileNameSuffix);
%fprintf(fileID, '\n');
%fprintf(fileID, '%%%% Constant Radius Acceleration, Reverse, Steer R\n');
fprintf(fileID, '%% \n');
fprintf(fileID, '%% <<ConstRadAccRev_%sqS-35.png>>\n',fileNameSuffix);
fprintf(fileID, '\n');
fprintf(fileID, '%%%% Step Steer, Forward Left\n');
fprintf(fileID, '%% \n');
fprintf(fileID, '%% <<StepSteerFwdL_%sMap.png>>\n',fileNameSuffix);
fprintf(fileID, '\n');
fprintf(fileID, '%%%% Step Steer, Forward Right\n');
fprintf(fileID, '%% \n');
fprintf(fileID, '%% <<StepSteerFwdR_%sMap.png>>\n',fileNameSuffix);
fprintf(fileID, '\n');
fprintf(fileID, '%%%% Step Steer, Reverse Left\n');
fprintf(fileID, '%% \n');
fprintf(fileID, '%% <<StepSteerRevL_%sMap.png>>\n',fileNameSuffix);
fprintf(fileID, '\n');
fprintf(fileID, '%%%% Step Steer, Reverse Right\n');
fprintf(fileID, '%% \n'); 
fprintf(fileID, '%% <<StepSteerRevR_%sMap.png>>\n',fileNameSuffix);
fprintf(fileID, '\n');
fprintf(fileID, '%%%% Mast Lift\n');
fprintf(fileID, '%% \n');
fprintf(fileID, '%% <<MastLift_%sMap.png>>\n',fileNameSuffix);

% Close the file
fclose(fileID);

publish('Forklift_Stability_Results.m','showCode',false)
if(~isempty(fileNameSuffix))
    movefile([pwd filesep 'html' filesep 'Forklift_Stability_Results.html'],[pwd filesep 'Test_' fileNameSuffix(1:end-1)]);
else
    movefile([pwd filesep 'html' filesep 'Forklift_Stability_Results.html'],[pwd filesep 'Example']);
end