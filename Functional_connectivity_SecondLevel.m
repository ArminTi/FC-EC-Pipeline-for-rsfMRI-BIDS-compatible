function Functional_connectivity_SecondLevel(Datadir)

clear batch
batch.filename=fullfile(Datadir,'conn_rsfMRI.mat');

% Second Level
batch.Results.done = 1;
batch.Results.overwrite = 1;
batch.Results.analysis_number = 'RRC'; % sequential indexes inditify each set of independent analysis, alternative a string identifying the analysis name
batch.Results.foldername = 'Group_Level'; % folder to store the results
%batch.Results.between_subjects.effect_names = {}; % cell array of second-level effect names
%batch.Results.between_subjects.contract = []; % constrast vector, same size as effect_names
%batch.Results.between_conditions.effect_names = {}; % cell array of condition names (as in Setup.conditions.names)
%batch.Results.between_conditions.contract = []; % constrast vector, same size as effect_names
%batch.Results.between_sources.effect_names = {}; % cell array of source names (as in Analysis.regressors, typically appended wiht _N_M, see documentation)
%batch.Results.between_sources.contract = []; % constrast vector, same size as effect_names

conn_batch(batch);

% Launch CONN GUI to specify second and plot them
conn
conn('load',fullfile(Datadir,'conn_rsfMRI.mat'));
conn gui_results

end