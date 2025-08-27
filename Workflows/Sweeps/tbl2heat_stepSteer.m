function tbl2heat_stepSteer(resultsTable,testConds,plotStyle,varargin)
% For use with Step Steer Tests

fileName   = [];
folderName = [];
if(nargin>3)
    folderName = varargin{1};
    fileName   = varargin{2};
end

% Remove numbers close to zero
resultsTable.SideShiftPos((abs(resultsTable.SideShiftPos)<1e-20))=0;

% Add columns for min normal force
fnMin = nan(1,height(resultsTable));
for ri = 1:height(resultsTable)
    fnMin(ri) = min([resultsTable.RightFrontNF(ri);resultsTable.LeftFrontNF(ri);resultsTable.RightRearNF(ri);resultsTable.LeftRearNF(ri)]);
end
resultsTable.minNF = fnMin';

% Extract unique values
%LoadList          = flipud(unique(resultsTable.Load));        % Heaviest loads at top of map
MastLiftPosList   = flipud(unique(resultsTable.MastLiftPos)); % Highest lift on top of map
MastTiltAngleList = unique(resultsTable.MastTiltAngle);
%SideShiftPosList  = unique(resultsTable.SideShiftPos);
SideShiftPosList  = [testConds.shift/1000]';
% Check forward or reverse
if(testConds.vel>=0)
    FwdOrRev = 'Fwd';
else
    FwdOrRev = 'Rev';
end

% Check left or right
if(testConds.steer>=0)
    ROrL = 'L';
else
    ROrL = 'R';
end


figure
t=tiledlayout(length(MastLiftPosList),length(MastTiltAngleList));
resHMs = [];
colorList = parula(length(MastTiltAngleList));
for mi = 1:length(MastLiftPosList)
    resHMsRow = [];
    if(strcmp(plotStyle,'surface') && mi>1)
        figure
    end
    for ti = 1:length(MastTiltAngleList)
        rows = (resultsTable.MastLiftPos==MastLiftPosList(mi)) & (resultsTable.MastTiltAngle==MastTiltAngleList(ti));
        Tsub = resultsTable(rows, :);

        aVals = flipud(unique(Tsub.Load));  % Heaviest loads at top of map
        bVals = unique(Tsub.SideShiftPos);  % Left to right

        nA = numel(aVals);
        nB = numel(bVals);

        % Preallocate the matrix for the heatmap
        heatmat = nan(nA, nB);

        % Map each row to matrix indices
        [~, aIdx] = ismember(Tsub.Load, aVals);
        [~, bIdx] = ismember(Tsub.SideShiftPos, bVals);

        for i = 1:height(Tsub)
            %heatmat(aIdx(i), bIdx(i)) = Tsub.ContactLost(i);
            heatmat(aIdx(i), bIdx(i)) = Tsub.minNF(i);
        end

        resHMsRow = [resHMsRow heatmat];

        if(strcmp(plotStyle,'heatmap'))
            nexttile
            %        ah = heatmap(string(bVals), string(aVals), heatmat, ...
            %            'Title',['Lift = ' num2str(MastLiftPosList(mi)) ', Tilt = ' num2str(MastTiltAngleList(ti))],Colormap=[0 1 0;1 0 0]);
            ah = heatmap(string(bVals), string(aVals), heatmat, ...
                'Title',['Lift = ' num2str(MastLiftPosList(mi)) ', Tilt = ' num2str(MastTiltAngleList(ti))],...
                'CellLabelFormat','%4.0f','CellLabelColor',[0 0 0],Colormap=tbl2heat_clrmap);
            ah.XDisplayLabels = nan(size(ah.XDisplayData));
            if(ti > 1)
                ah.YDisplayLabels = nan(size(ah.YDisplayData));
            end
            if(ti == 1)
                ylabel('Load (kg)')
            end
            ah.ColorbarVisible  = 'off';
            %clim([0 1]) % For Contact Lost heat map
            clim([0 max(resultsTable.minNF)])
        elseif(strcmp(plotStyle,'surface'))
            hold on
            [xGrid, yGrid] = meshgrid(aVals,bVals);
            surf(xGrid,yGrid,heatmat','FaceColor',colorList(ti,:),'FaceAlpha',0.5,'DisplayName',['Tilt = ' num2str(MastTiltAngleList(ti))]);
            xlabel('Load [kg]');
            ylabel('Side Shift [m]');
            zlabel('Min Wheel Normal Force [N]');
        end
    end
    resHMs = [resHMs; resHMsRow];
    if(strcmp(plotStyle,'surface'))
        box on
        grid on
        view(-30,20)
        set(gca,'ZLim',[0 max(fnMin)])
        legend('Location','Best')
        title(['Step Steer (' num2str(testConds.vel) 'm/s, ' num2str(testConds.steer) ' deg, Lift=' num2str(MastLiftPosList(mi)) 'mm): Min Wheel Normal Force'])
        if(~isempty(fileName))
            figFileName = [fileName '_Surf'];
        end
        if(~isempty(fileName))
            exportgraphics(gcf,[folderName filesep figFileName '_Lift' num2str(mi) '.png'],"Resolution",100)
        end
    end
end


%{
% For label on figure edge
listOfLoads = num2str(flipud(LoadList)');
result = regexprep(listOfLoads, '(?<=\d)\s+', ' || ');
ylabel(t,['Load: ' result])
%}


if(strcmp(plotStyle,'heatmap'))
    set(gcf,'Position',[260   459   831   461])
    title(t,['Step Steer Test (' num2str(testConds.vel) 'm/s, ' num2str(testConds.steer) ' deg): Min Wheel Normal Force'])

    listSideShift = num2str(SideShiftPosList');
    result = regexprep(listSideShift, '(?<=\d)\s+', ' || ');
    xlabel(t,['Side Shift: ' result])
    if(~isempty(fileName))
        %saveas(gcf,[folderName filesep fileName '_Map.png'])
        exportgraphics(gcf,[folderName filesep fileName '_Map.png'],"Resolution",100)
    end
end

if(~isempty(fileName))
    writematrix(resHMs,[folderName filesep 'testSweep_' fileName(end-10:end) '.xlsx'],'Sheet',['StepSteer_' FwdOrRev ROrL],'Range','B2');
end