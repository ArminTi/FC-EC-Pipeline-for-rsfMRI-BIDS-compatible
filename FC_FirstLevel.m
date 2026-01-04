function FC_FirstLevel(Datadir, NSUBJECTS)

clear batch
% batch.filename=fullfile(Datadir,'conn_rsfMRI.mat');


% First Level-ROI-to-ROI
batch{1}.filename=fullfile(Datadir,'conn_rsfMRI.mat');
batch{1}.Analysis.name = 'RRC';
%batch{1}.Analysis.analysis_number=1;
batch{1}.Analysis.measure = 'correlation (bivariate)';
batch{1}.Analysis.type = 1; % Use 1 for ROI-to-ROI analyse, 2 for seed-to-voxel analyses, or 3 for both ROI-to-ROI and seed-to-voxel analyses.
% batch.Analysis.weight = 2; % Use 1 for no hrf, 2 for hrf, 3 for hanning
% batch.Analysis.sources = {'Schaefer2018.LH.DorsAttn', 'Schaefer2018.RH.DorsAttn','Schaefer2018.LH.Default', 'Schaefer2018.RH.Default'};
batch{1}.Analysis.sources = {'networks.DefaultMode', 'networks.FrontoParietal'};
batch{1}.Analysis.done=1;
batch{1}.Analysis.overwrite='No';


%%% Cool Extra Options :) %%%

% BATCH. Analysis.sources.fbands
% This field contains a cell array ranging over each source ROI, where the
% BATCH.Analysis.sources.fbands{nsource} element contains an integer describing the number of
% frequency bands (partitioning the preprocessing band-pass filter) used to compute spectral
% decomposition of the functional connectivity measures (typically 1 to indicate no spectral
% decomposition)
% 
% BATCH. Analysis.sources.deriv
% This field contains a cell array ranging over each source ROI, where the
% BATCH.Analysis.sources.deriv{nsource} element contains an integer describing the order of
% additional time-derivatives to be used as additional source time-series for source nsource
% (typically 0 to indicate the raw BOLD signal, and no time-derivatives used)

%%% --------------- %%%

% First Level-voxel based
batch{2}.filename=fullfile(Datadir,'conn_rsfMRI.mat');
batch{2}.Analysis.name = 'LCOR';
batch{2}.Analysis.analysis_number=0;
batch{2}.Analysis.measures.names = 'LocalCorrelation';     % for voxel-to-voxel analyses
batch{2}.Analysis.done=1;
batch{2}.Analysis.overwrite='No';


% First Level-voxel based
%batch{3}.filename=fullfile(Datadir,'conn_rsfMRI.mat');
%batch{3}.Analysis.name = 'fALFF';
%batch{3}.Analysis.analysis_number=0;
%batch{3}.Analysis.measures.names = 'fALFF';     % for voxel-to-voxel analyses
%batch{3}.Analysis.done=1;
%batch{3}.Analysis.overwrite='No';


%%% You have these options for measures %%%
%'group-PCA'             : Principal Component Analysis of BOLD timeseries
%'group-ICA'             : Independent Component Analysis of BOLD timeseries
%'group-MVPA'/'MCOR'     : MultiVoxel Pattern Analysis of connectivity patterns (MCOR)
%'IntrinsicConnectivity' : Intrinsic Connectivity Contrast (ICC)
%'LocalCorrelation'      : Integrated Local Correlation (ILC,LCOR)     
%'InterHemisphericCorrelation' : Inter-hemispheric Correlation (IHC)
%'GlobalCorrelation'     : Integrated Global Correlation (IGC,GCOR)   
%'RadialCorrelation'     : Radial Correlation Contrast (RCC)
%'RadialSimilarity'      : Radial Similarity Contrast (RSC)
%'ALFF'                  : Amplitude of Low Frequency Fluctuations
%'fALFF'                 : fractional ALFF
%%% ----------------------------------- %%%

conn_batch(batch);

% Plotting First level results
a = load(fullfile(Datadir,'\conn_rsfMRI\results\firstlevel\RRC\resultsROI_Condition001.mat'));
Plot_ROItoROI(a.Z,NSUBJECTS)

end