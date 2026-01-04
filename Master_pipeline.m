%% ========================================================================
% MASTER ANALYSIS PIPELINE for resting state fMRI Processing 
% ========================================================================
%
%   Armin Toghi
%   Project: fMRI Resting State Analysis Pipeline
%   Toolbox: 
%   SPM12 (https://www.fil.ion.ucl.ac.uk/spm/software/spm12/)
%   CONN (https://web.conn-toolbox.org/)
%   TAPAS (https://github.com/ComputationalPsychiatry)
%   HEB (https://github.com/mdgreaves/hierarchical-empirical-Bayes)
% ------------------------------------------------------------------------
% REQUIREMENTS:
%   - MATLAB R2019a or newer
%   - Required package added to MATLAB path
%   - NIfTI data organized in BIDS-like format 
%
% ------------------------------------------------------------------------
% NOTE:
%   This script does NOT run all steps automatically. 
%   It executes ONE step at a time to prevent accidental overwriting.
%
% ========================================================================

clear
clc

%% Package Location
addpath 'C:\Users\ASUS\Desktop\Apps\spm12'; % SPM_dir 
addpath 'C:\Users\ASUS\Desktop\Apps\conn'; % CONN_dir 
addpath C:\Users\ASUS\Desktop\Apps\rDCM-main\ % TAPAS_dir
addpath C:\Users\ASUS\Desktop\Apps\spDCM_Greaves % HEB_dir
%% Requirement
Datadir = 'F:\fMRI_dataset\BIDS'; % specify your directory
TR = 2.08; % Repetition time
TE = 0.03;
NSUBJECTS = 29; % specify the number of subjects
% str = specify the SC matrix if you want to use hierarchical PEB
str = simulate_DMN_SC(); % Structural Connectivity matrix (Group Level); This function simulate

%% Design For Group Level

name = 'Group_mean_MCI_NCS'; % contrast name for EC group level (PEB result)
conn_name = 'AD(1).NCS(0)'; % contrast name for FC group level (conn result)



num_AD = 9;  num_MCI = 10; num_NCS = 10;
X = ones(num_MCI+num_NCS, 1);
label = {'MeanEffect'};
from_sub = 10;
to_sub = 29;

% Create the design matrix X with two columns
%X = [ones(NSUBJECTS, 1), ...  % First column: all ones Intercept
%     [ones(num_AD, 1); zeros(num_MCI, 1); zeros(num_NCS, 1)]];  % Second column: AD=1, MCI=0, NCS=0
%labels = {'MeanEffect', 'AD_effect'};

%% PIPELINE CALL 

fprintf('\nSelect a pipeline step to implement:\n')

fprintf('   1 - Preprocessing and Denoising\n')
fprintf('   2 - QC preview\n')
fprintf('   3 - Functional Connectivity First Level\n')
fprintf('   4 - Functional Connectivity Second Level\n')
fprintf('   5 - Specify and fit spDCM for specified Network\n')
fprintf('   6 - Specify and fit rDCM for specified Network\n')
fprintf('   7 - Structural Informed DCM\n')
fprintf('   8 - Group_Level_DCM using Parametric empirical bayes\n')
fprintf('   9 - EC_Plots\n')
fprintf('   10 - FC_Plots\n')

job = input('Enter the step number: ');



switch job
    case 1
        fMRI_preprocessing_denoising(Datadir, NSUBJECTS, TR) % Preprocessing & denoising & time series extraction
    case 2
        QC_preview(Datadir) % Quality Assessment
    case 3
        FC_FirstLevel(Datadir, NSUBJECTS) % ROI and Voxel based analysis (RRC, SBC, IC, LCOR, GCOR, ICA/PCA, (f)ALFF)
    case 4
        FC_SecondLevel(Datadir) % Second Level contrast and plots
    case 5
        Specify_fit_spDCM(Datadir, TR, TE) % Spectral DCM
    case 6
        Specify_fit_rDCM(Datadir, TR) % Regression DCM
    case 7
        str_spDCM_opt(Datadir, str) % Structural Informed DCM
    case 8
        Group_Level_DCM(Datadir, from_sub, to_sub, X, label, name) % Group Level Parametric Empirical Bayes 
    case 9
        EC_Plots(Datadir, name); % Plotting and Comparing EC features
    case 10
        FC_Plots(Datadir, conn_name)
end

fprintf('\n✓ Pipeline step completed successfully.\n')
fprintf('------------------------------------------------------------------\n');
