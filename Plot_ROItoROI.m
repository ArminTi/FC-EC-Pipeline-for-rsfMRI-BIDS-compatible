function Plot_ROItoROI(Z, nSub)

% Z                 % ROI x ROI x Subject
% roi_names = a.names;     % 1 x N ROI
% nROI = size(Z,1);

% Global color limits for consistency
clim = [-1 1];  % or: clim = max(abs(Z(:))) * [-1 1];

% Calculate the number of rows for the subplot
nRows = ceil(nSub / 4);  % Create a new row after every 4 subjects

% Create the figure
figure('Color','w','Position',[100 100 400 nRows*300])

% Set up the tiled layout for the subplots with reduced space between tiles
tiledlayout(nRows, 4, ...
    'TileSpacing','compact', ... % Reduced space between tiles
    'Padding','tight')         % Reduced padding around the whole plot

for i = 1:nSub
    nexttile
    h = imagesc(Z(:,:,i), clim);
    %axis square
    axis tight

    set(gca,'XTick',[],'YTick',[])
    
    title(sprintf('Subject %d', i), ...
        'FontWeight','bold','FontSize',10)

end
sgtitle('First Level-FC', ...
    'FontWeight','bold','FontSize',12)

% Add a colorbar for each subplot
%cb = colorbar;
%cb.Layout.Tile = 'east';
%cb.Label.String = 'Functional Connectivity (Z)';
%cb.Label.FontSize = 5;



figure
mean_z = mean(Z,3);
imagesc(mean_z);
sgtitle('Averge FC')

end
