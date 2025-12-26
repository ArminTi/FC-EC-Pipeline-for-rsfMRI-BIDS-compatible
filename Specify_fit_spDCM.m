function Specify_fit_spDCM(Datadir, TR, TE)

files = dir(fullfile(Datadir,'conn_rsfMRI','results','preprocessing','ROI_Subject*_Condition001.mat'));
Network = load(fullfile(Datadir,'conn_rsfMRI','results','firstlevel','RRC','resultsROI_Condition001.mat'));

refNames = Network.names(:);
ROI_TS = struct();

for i = 1:numel(files)
    tmp = load(fullfile(files(i).folder,files(i).name));
    tokens = regexp(files(i).name,'ROI_(Subject\d+)_Condition001','tokens');
    subjID = tokens{1}{1};
    ROI_TS.(subjID) = tmp;
end

subjects = fieldnames(ROI_TS);
TS_ROI = struct();

for s = 1:numel(subjects)
    subj = subjects{s};
    subjNames = ROI_TS.(subj).names(:);
    subjData  = ROI_TS.(subj).data(:);
    [tf,idx] = ismember(refNames,subjNames);
    if any(~tf)
        error('%s missing ROIs',subj)
    end
    TS_ROI.(subj).names = refNames;
    TS_ROI.(subj).data  = subjData(idx);
end

subjects = fieldnames(TS_ROI);
DCM_all = struct();

for s = 1:numel(subjects)
    subj = subjects{s};
    roiData  = TS_ROI.(subj).data;
    roiNames = TS_ROI.(subj).names;
    nROI = numel(roiData);

    Y = cellfun(@(x)x(:),roiData,'UniformOutput',false);
    Y = cell2mat(Y');
    DCM = configureDCM(Y,roiNames,TR,TE,nROI);
    DCM_all.(subj) = spm_dcm_fmri_csd(DCM);
end

save(fullfile(Datadir,'DCM_all.mat'),'DCM_all','-v7.3')

% Plot fitted DCM for each sub and comparing with FC

a = load(fullfile(Datadir,'conn_rsfMRI','results','firstlevel','RRC','resultsROI_Condition001.mat'));

subjects = fieldnames(DCM_all);
nSub = numel(subjects);

for s = 1:nSub
    
    subj = subjects{s};
    
    % -------- Functional connectivity --------
    FCmat = a.Z(:,:,s);
    FCnames_raw = a.names(:);
    FCnames = cellfun(@(x) regexp(x,'networks\.([^.]+\.[^ ]+)','tokens','once'), ...
                      FCnames_raw,'UniformOutput',false);
    FCnames = vertcat(FCnames{:});
    
    % -------- DCM effective connectivity --------
    DCMmat = DCM_all.(subj).Ep.A;
    
    DCMnames_raw = DCM_all.(subj).Y.name(:);
    DCMnames = cellfun(@(x) regexp(x,'networks\.([^.]+\.[^ ]+)','tokens','once'), ...
                       DCMnames_raw,'UniformOutput',false);
    DCMnames = vertcat(DCMnames{:});
    
    figure('Name',subj,'Color','w')
    
    subplot(1,2,1)
    PlotConnectMatrix(FCmat,FCnames)
    title([subj '  |  Functional Connectivity'],'FontSize',18)
    
    subplot(1,2,2)
    PlotConnectMatrix(DCMmat,DCMnames)
    title([subj '  |  Effective Connectivity (DCM)'],'FontSize',18)
    
end


end
