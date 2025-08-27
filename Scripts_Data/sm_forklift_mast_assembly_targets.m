function ForkliftParams = sm_forklift_mast_assembly_targets(initMastHeight,ForkliftParams)

% The cable constraint connecting the mast stages cannot influence the
% initial joint positions.  The initial mast height must be converted to
% initial joint extensions for each stage and applied at t=0 so that the
% cable is the correct length.

if(initMastHeight>=ForkliftParams.perfSpecs.maxFreeLift)
    % If the initial mast height is higher than the free lift height
    %   Outer-Middle Mast and Middle-Inner Mast extension is (init mast height/2) - (max free lift)
    ForkliftParams.assemblyConditions.middleOuterMastPos  = (initMastHeight-ForkliftParams.perfSpecs.maxFreeLift)/2;
    %   Carriage extension is (max free lift)
    ForkliftParams.assemblyConditions.carriageFreeLiftPos = ForkliftParams.perfSpecs.maxFreeLift;
else
    % If initial mast height is lower than free lift
    %    Outer-Middle Mast and Middle-Inner Mast extension is 0
    %    Carriage extension is (init mast height)
    ForkliftParams.assemblyConditions.middleOuterMastPos  = 0;
    ForkliftParams.assemblyConditions.carriageFreeLiftPos = initMastHeight;
end
