function QC_EC_preview(Datadir)
% For checking the explained variance for each fitted DCM

DCMfile = load(fullfile(Datadir, 'DCM_all.mat'));
GCM = struct2cell(DCMfile.DCM_all);
spm_dcm_fmri_check(GCM)

end