function fMRI_preprocessing_denoising(Datadir, NSUBJECTS, TR)


% fMRI_preprocessing_denoising
% This function performs the preprocessing and denoising of resting-state fMRI data using the CONN toolbox.
% It includes the following steps:
% 1. Changing the working directory to the specified Datadir.
% 2. Loading functional (BOLD) and anatomical (T1w) files for each subject and session.
% 3. Setting up the preprocessing batch for CONN, which includes realignment, coregistration, segmentation,
%    normalization, and smoothing.
% 4. Masking the regions of interest (ROIs) with gray matter and extracting average time series from the ROI
%    using the defined ROIs.
% 5. Applying denoising using a frequency filter (0.008 - inf Hz).
% 6. Running the preprocessing and denoising steps using the CONN batch processing function.
%
% INPUTS:
%   Datadir    - Directory where the fMRI data (BOLD and T1w) are located.
%   NSUBJECTS  - Number of subjects to process.
%   TR         - Repetition time (in seconds) for the fMRI data.
%
% OUTPUTS:
%   A preprocessed and denoised dataset is saved as 'conn_rsfMRI.mat'.
%   The results will be displayed in the CONN GUI for further analysis.
%
% Armin Toghi Jan 2026 (This code modified from Alfonso examples on conn batch)
% This function requires the CONN toolbox to be installed and available in the MATLAB path.

cd(Datadir)
FUNCTIONAL_FILE=cellstr(conn_dir('*bold.nii'));
STRUCTURAL_FILE=cellstr(conn_dir('*T1w.nii'));
if rem(length(FUNCTIONAL_FILE),NSUBJECTS),error('mismatch number of functional files %n', length(FUNCTIONAL_FILE));end
if rem(length(STRUCTURAL_FILE),NSUBJECTS),error('mismatch number of anatomical files %n', length(FUNCTIONAL_FILE));end
nsessions=length(FUNCTIONAL_FILE)/NSUBJECTS;
FUNCTIONAL_FILE=reshape(FUNCTIONAL_FILE,[NSUBJECTS,nsessions]);
STRUCTURAL_FILE={STRUCTURAL_FILE{1:NSUBJECTS}};
disp([num2str(size(FUNCTIONAL_FILE,1)),' subjects']);
disp([num2str(size(FUNCTIONAL_FILE,2)),' sessions']);

% Prepares batch structure
clear batch;
batch.filename=fullfile(Datadir,'conn_rsfMRI.mat');            % New conn_*.mat experiment name
% batch.parallel.N=NSUBJECTS;                             % One process per subject (uses default Grid-settings profile)
batch.parallel.N=4;  

% SETUP & PREPROCESSING step (using default values for most parameters, see help conn_batch to define non-default values)
batch.Setup.isnew=1;
batch.Setup.nsubjects=NSUBJECTS;
batch.Setup.RT=TR;                                        % TR (seconds)
batch.Setup.functionals=repmat({{}},[NSUBJECTS,1]);       % Point to functional volumes for each subject/session
for nsub=1:NSUBJECTS,for nses=1:nsessions,batch.Setup.functionals{nsub}{nses}{1}=FUNCTIONAL_FILE{nsub,nses}; end; end
batch.Setup.structurals=STRUCTURAL_FILE;                  % Point to anatomical volumes for each subject
nconditions=nsessions;                                  % treats each session as a different condition (comment the following three lines and lines 84-86 below if you do not wish to analyze between-session differences)
if nconditions==1
    batch.Setup.conditions.names={'rest'};
    for ncond=1,for nsub=1:NSUBJECTS,for nses=1:nsessions,              batch.Setup.conditions.onsets{ncond}{nsub}{nses}=0; batch.Setup.conditions.durations{ncond}{nsub}{nses}=inf;end;end;end     % rest condition (all sessions)
else
    batch.Setup.conditions.names=[{'rest'}, arrayfun(@(n)sprintf('Session%d',n),1:nconditions,'uni',0)];
    for ncond=1,for nsub=1:NSUBJECTS,for nses=1:nsessions,              batch.Setup.conditions.onsets{ncond}{nsub}{nses}=0; batch.Setup.conditions.durations{ncond}{nsub}{nses}=inf;end;end;end     % rest condition (all sessions)
    for ncond=1:nconditions,for nsub=1:NSUBJECTS,for nses=1:nsessions,  batch.Setup.conditions.onsets{1+ncond}{nsub}{nses}=[];batch.Setup.conditions.durations{1+ncond}{nsub}{nses}=[]; end;end;end
    for ncond=1:nconditions,for nsub=1:NSUBJECTS,for nses=ncond,        batch.Setup.conditions.onsets{1+ncond}{nsub}{nses}=0; batch.Setup.conditions.durations{1+ncond}{nsub}{nses}=inf;end;end;end % session-specific conditions
end

% Using the Schaefer2018 and CONN ROI set 
batch.Setup.rois.names={'Schaefer2018', 'networks'}; 
batch.Setup.rois.files{1}=fullfile(fileparts(which('conn')),'rois','Schaefer2018.nii');  
batch.Setup.rois.files{2}=fullfile(fileparts(which('conn')),'rois','networks.nii');
batch.Setup.rois.dimentions = 1; % Extract average time series (1D)
batch.Setup.rois.mask = 1; % Mask with gray matter voxels (set to 0 if not wanted)

% Preprocessing step: Using the default MNI pipeline
batch.Setup.preprocessing.steps='default_mni';  % I manually created this
batch.Setup.preprocessing.sliceorder='interleaved (Siemens)';
batch.Setup.done=1;
batch.Setup.overwrite='Yes';                            

% DENOISING step
batch.Denoising.filter=[0.008, inf];  % Frequency filter (High-pass values in Hz)
batch.Denoising.done=1;
batch.Denoising.overwrite='Yes'; %(for done=1) 1/0: overwrites target files if they exist [1]

% Run all analyses
conn_batch(batch);
% save('batch.mat');

% Launch CONN GUI to explore results
conn
conn('load',fullfile(Datadir,'conn_rsfMRI.mat'));
conn gui_results

end
