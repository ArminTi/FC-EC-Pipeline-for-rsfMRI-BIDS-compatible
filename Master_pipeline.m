%% ========================================================================
% MASTER ANALYSIS PIPELINE for resting state fMRI Processing (CONN, SPM12)
% ========================================================================
%
%   Armin Toghi
%   Project: fMRI Resting State Analysis Pipeline
%   Toolbox: 
% SPM12 (https://www.fil.ion.ucl.ac.uk/spm/software/spm12/)
% CONN (https://web.conn-toolbox.org/)
% ------------------------------------------------------------------------
% REQUIREMENTS:
%   - MATLAB R2019a or newer
%   - SPM12 added to MATLAB path
%   - CONN added to MATLAB path
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

Datadir = 'D:\Package\connectivity_fMRI\sample';
TR = 2;
TE = 0.3;
NSUBJECTS = 2;

% Package Location
SPM_dir = 'C:\Users\ASUS\Desktop\Apps\spm12';
CONN_dir = 'C:\Users\ASUS\Desktop\Apps\conn';

fprintf('\nSelect a pipeline step to implement:\n')
fprintf('   1 - Preprocessing and Denoising\n')
fprintf('   2 - QC preview\n')
fprintf('   3 - functional connectivity based methods\n')
fprintf('   4 - Specify_fit_spDCM\n\n')
% fprintf('   5 - Group Level for FC-EC based methods\n')

job = input('Enter the step number: ');

%% PIPELINE CALL 

switch job
    case 1
        fMRI_preprocessing_denoising(Datadir, NSUBJECTS, TR)
    case 2
        QC_preview(Datadir)
    case 3
        Functional_connectivity_FirstLevel(Datadir, NSUBJECTS)
    case 5
        Specify_fit_spDCM(Datadir, TR, TE)
    case 6
        QC_EC_preview(Datadir)
end

fprintf('\n✓ Pipeline step completed successfully.\n')
fprintf('------------------------------------------------------------------\n');
