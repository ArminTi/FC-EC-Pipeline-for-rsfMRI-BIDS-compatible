function QC_preview(Datadir)

 % continue batch structure from the previous function
 clear batch;
 batch.filename = fullfile(Datadir, 'conn_rsfMRI.mat');  % Specify the experiment file
 
 % Specify the output folder for QA plots
 batch.QA.foldername = fullfile(Datadir, 'Quality_Assessment');  % Save QA plots in the 'Quality_Assessment' folder
 
 % List all QA plots to be created
 batch.QA.plots = { ...
     'QA_NORM structural', ...        % Structural data + outline of MNI TPM template
     'QA_NORM functional', ...        % Mean functional data + outline of MNI TPM template
     'QA_NORM rois', ...              % ROI data + outline of MNI TPM template
     'QA_REG functional', ...         % Mean functional data + structural data overlay
     'QA_REG structural', ...         % Structural data + outline of ROI
     'QA_REG functional', ...         % Mean functional data + outline of ROI
     'QA_REG mni', ...                % Reference MNI structural template + outline of ROI
     'QA_COREG functional', ...       % Display same single-slice (z=0) across multiple sessions/datasets
     'QA_TIME functional', ...        % Display same single-slice (z=0) across all timepoints within each session
     'QA_TIMEART functional', ...     % Display same single-slice (z=0) across all timepoints within each session together with ART timeseries
     'QA_DENOISE histogram', ...      % Histogram of voxel-to-voxel correlation values (before and after denoising)
     'QA_DENOISE timeseries', ...     % BOLD signal traces before and after denoising
     'QA_DENOISE FC-QC', ...          % Histogram of FC-QC associations; between-subject correlation between QC and FC measures
     'QA_DENOISE scatterplot', ...    % Scatterplot of FC vs. distance
 };
 
 
 batch.QA.rois = [1,2,3,4];  
 batch.QA.overwrite = 1; % Overwrite existing plots if they exist
 % batch.QA.export_html = 1; % Export as HTML report; I dont know why, but
 % this is not working
 
 % Run all analyses
 conn_batch(batch);

end
