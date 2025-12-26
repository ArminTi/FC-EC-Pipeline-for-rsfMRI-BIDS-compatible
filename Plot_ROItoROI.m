function Plot_ROItoROI(Z,nSub)

% Z                 % ROI x ROI x Subject
%roi_names = a.names;     % 1 x N ROI
%nROI = size(Z,1);

% Global color limits for consistency
clim = [-1 1];  % or: clim = max(abs(Z(:))) * [-1 1];

figure('Color','w','Position',[100 100 300*nSub 300])

tiledlayout(1, nSub, ...
    'TileSpacing','compact', ...
    'Padding','compact')

for i = 1:nSub
    nexttile
    imagesc(Z(:,:,i), clim)
    axis square
    axis tight
    set(gca,'XTick',[],'YTick',[])
    
    title(sprintf('Subject %d', i), ...
        'FontWeight','bold','FontSize',10)
end

% Colormap and colorbar
colormap(turbo)
cb = colorbar;
cb.Layout.Tile = 'east';
cb.Label.String = 'Functional Connectivity (Z)';
cb.Label.FontSize = 10;

sgtitle('First_Level-FC', ...
    'FontWeight','bold','FontSize',12)

end