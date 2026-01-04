function FC_Plots(Datadir, conn_name)

outdir = fullfile(Datadir, 'matrices');

% Create folder if it does not exist
if ~exist(outdir, 'dir')
    mkdir(outdir);
end

first = load(fullfile(Datadir,'conn_rsfMRI','results','firstlevel','RRC','resultsROI_Condition001.mat'));
Z = mean(first.Z,3); % mean FC over subjects;

figure
imagesc(Z);
sgtitle('Averge FC')

writeNPY(Z, fullfile(outdir,'Group_level_FC.npy'));   % for numpy readable matlab


second = fullfile(Datadir,'conn_rsfMRI','results','secondlevel','RRC',conn_name, 'rest', 'ROI.mat');
conn_display(second, 'matrix_view')


%%% Helper

%hf = conn_display(SPMfilename, ncon, style)
%  SPMfilename : input file name (either SPM.mat or ROI.mat file) containing second-level analysis results
%  ncon        : contrast number (if multiple contrasts are defined in 2nd-level results SPM.mat file)
%  style       : voxel/cluster threshold settings (see Nieto-Castanon, 2020 for details about these methods; www.conn-toolbox.org/fmri-methods)
%                  [style=1] for default settings #1 : parametric multivariate statistics (Functional Network Connectivity, Jafri et al., 2008)
%                  [style=2] for default settings #2 : non-parametric statistics (Spatial Pairwise Clustering, Zalesky et al., 2012)
%                  [style=3] for default settings #3 : non-parametric statistics (Threshold Free Cluster Enhancement, Smith and Nichols, 2007)
%                  [style=4] for alternative settings for connection-based inferences : parametric univariate statistics (connection-level inferences, FDR corrected, Benjamini & Hochberg, 1995)
%                  [style=5] for alternative settings for ROI-level inferences: parametric multivariate statistics (ROI-level inferences, FDR corrected, Benjamini & Hochberg, 1995)
%                  [style=6] for alternative settings for network-level inferences: non-parametric statistics (network-level inferences, Network Based Statistics, Zalesky et al., 2010)
%  hf          : output results explorer window handle (which can be used in advanced options described below)
end