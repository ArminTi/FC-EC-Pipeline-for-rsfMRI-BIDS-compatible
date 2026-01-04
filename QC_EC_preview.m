function QC_EC_preview(Datadir)

load(fullfile(Datadir, 'DCM_all.mat'));
load(fullfile(Datadir, 'rDCM_all.mat'));


a = load(fullfile(Datadir,'conn_rsfMRI','results','firstlevel','RRC','resultsROI_Condition001.mat'));

% Plot each subject beside each other for rDCM and spDCM and coorelate them
% using scatter plot
subjects = fieldnames(DCM_all);
subjects_r = fieldnames(rDCM_all);
nSub = numel(subjects);

for s = 1:nSub
    
    subj = subjects{s};
    subj_r = subjects_r{s};
    
    % -------- Functional connectivity --------
    FCmat = a.Z(:,:,s);
    FCnames_raw = a.names(:);
    FCnames = cellfun(@(x) regexp(x,'networks\.([^.]+\.[^ ]+)','tokens','once'), ...
                      FCnames_raw,'UniformOutput',false);
    FCnames = vertcat(FCnames{:});

    % -------- spDCM effective connectivity --------    
    DCMmat = DCM_all.(subj).Ep.A;
    % -------- rDCM effective connectivity --------
    rDCMmat = rDCM_all.(subj_r).Ep.A;
    
    
    figure('Name',subj,'Color','w')
    
    subplot(1,3,1)
    PlotConnectMatrix(FCmat,FCnames)
    title([subj '  |  FC'],'FontSize',14)
    
    subplot(1,3,2)
    PlotConnectMatrix(DCMmat,FCnames)
    title([subj '  |  spDCM'],'FontSize',14)

    subplot(1,3,3)
    PlotConnectMatrix(rDCMmat,FCnames)
    title([subj '  |  rDCM'],'FontSize',14)
    
end



end