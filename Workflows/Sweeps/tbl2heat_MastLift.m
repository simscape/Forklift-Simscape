function tbl2heat_MastLift(resultsTable,plotStyle,varargin)
% For use with Mast Lift Tests
% Use with; MastSweep

fileName   = [];
folderName = [];
if(nargin>2)
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
%LoadList          = flipud(unique(resultsTable.Load)); % Heaviest loads at top of map
MastTiltAngleList = unique(resultsTable.MastTiltAngle);
SideShiftPosList  = unique(resultsTable.SideShiftPos);

figure
t=tiledlayout(1,length(MastTiltAngleList));
resHMs = [];
colorList = parula(length(MastTiltAngleList));
for ti = 1:length(MastTiltAngleList)
    rows = (resultsTable.MastTiltAngle==MastTiltAngleList(ti));
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

    resHMs = [resHMs heatmat];

    if(strcmp(plotStyle,'heatmap'))
        nexttile

        % Use for pass/fail heatmap
        % ah = heatmap(string(bVals), string(aVals), heatmat, ...
        %     'Title',['Lift = ' num2str(MastLiftPosList(mi)) ', Tilt = ' num2str(MastTiltAngleList(ti))],Colormap=[0 1 0;1 0 0]);

        ah = heatmap(string(bVals), string(aVals), heatmat, ...
            'Title',['Tilt = ' num2str(MastTiltAngleList(ti))],...
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
        clim([0 max(resultsTable.minNF)]) % For min normal force heat map
    elseif(strcmp(plotStyle,'surface'))
        hold on
        [xGrid, yGrid] = meshgrid(aVals,bVals);
        surf(xGrid,yGrid,heatmat','FaceColor',colorList(ti,:),'FaceAlpha',0.5,'DisplayName',['Tilt = ' num2str(MastTiltAngleList(ti))]);
        xlabel('Load [kg]');
        ylabel('Side Shift [m]');
        zlabel('Min Wheel Normal Force [N]');
        title('Mast Lift Test');

    end

end

if(strcmp(plotStyle,'heatmap'))
    listSideShift = num2str(SideShiftPosList');
    result = regexprep(listSideShift, '(?<=\d)\s+', ' || ');
    xlabel(t,['Side Shift: ' result])
    title(t,'Mast Lift Test: Min Wheel Fn [Tilt; Load vs. Shift]');
    set(gcf,'Position',[112   746   831   157])
    if(~isempty(fileName))
        figFileName = [fileName '_Map'];
    end
else
    box on
    grid on
    view(-30,20)
    legend('Location','Best')
    if(~isempty(fileName))
        figFileName = [fileName '_Surf'];
    end
end

%{
% For label on figure edge
listOfLoads = num2str(flipud(LoadList)');
result = regexprep(listOfLoads, '(?<=\d)\s+', ' || ');
ylabel(t,['Load: ' result])
%}


if(~isempty(fileName))
    %saveas(gcf,[folderName filesep fileName '_Map.png'])
    exportgraphics(gcf,[folderName filesep figFileName '.png'],"Resolution",100)
    writematrix(resHMs,[folderName filesep 'testSweep_' fileName(end-10:end)  '.xlsx'],'Sheet','MastLift','Range','B2');
end

end