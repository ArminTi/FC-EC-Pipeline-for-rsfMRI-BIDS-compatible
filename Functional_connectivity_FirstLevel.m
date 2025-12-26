function Functional_connectivity_FirstLevel(Datadir, NSUBJECTS)

clear batch
batch.filename=fullfile(Datadir,'conn_rsfMRI.mat');


% First Level
batch.Analysis.name = 'RRC';
batch.Analysis.measure = 'correlation (bivariate)';
batch.Analysis.type = 1; % ROI-to-ROI
% batch.Analysis.weight = 2;
% batch.Analysis.sources = {'Schaefer2018.LH.DorsAttn', 'Schaefer2018.RH.DorsAttn','Schaefer2018.LH.Default', 'Schaefer2018.RH.Default'};
batch.Analysis.sources = {'networks.DefaultMode'};
batch.Analysis.done=1;
batch.Analysis.overwrite='No';

conn_batch(batch);

% Plotting First and Second Level
a = load(fullfile(Datadir,'\conn_rsfMRI\results\firstlevel\RRC\resultsROI_Condition001.mat'));
Plot_ROItoROI(a.Z,NSUBJECTS)


end