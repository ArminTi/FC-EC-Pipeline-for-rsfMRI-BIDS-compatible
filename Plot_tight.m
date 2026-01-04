function [matrix] = Plot_tight(matrix, ROIs)

% Modified form UKB_DCM_dementia repository

nP = numel(ROIs);

mn = min(matrix(:));
mx = max(matrix(:));
lim = max([abs(mn), abs(mx)]);
%figure
imagesc(matrix, [-lim*1.2 lim*1.2]);
set(gca, 'FontSize', 12)


% Colormap 1 (hot)
T = [0.2 0 0.4   
    1 1 1]; 
x = [0 1];
x = x(end:-1:1);
c1 = interp1(x,T,linspace(0,1,64));

% Colormap 2 (cold)
T = [1 1 1             
    0.1 0.1 0.1]; 
x = [0 1];
x = x(end:-1:1);
c2 = interp1(x,T,linspace(0,1,64));

% Combine and add white
c = [c2;c1];
c(64:65,:) = 1;

gca2 = colorbar; set(gca2, 'FontSize', 20)
colormap('cool'); % hot is cool as well :)
xlabel('From', 'FontSize', 16)
ylabel('To',  'FontSize', 16)
set(get(gca,'YLabel'),'Rotation',0)



set(gca,'YTickLabel',ROIs(:,1),...
    'YTick',1:length(ROIs(:,1)),...
    'XTickLabel',ROIs(:,1), 'XTick', 1:length(ROIs(:,1))),...
    xtickangle(30);

set(gca, 'fontweight', 'bold')

% set(gcf, 'position', [500 0 900 700])

set(gcf, 'Position', [300 0 900 300]) % [left bottom width height]
