function Specify_fit_rDCM(Datadir, TR)

addpath C:\Users\ASUS\Desktop\Apps\rDCM-main\code\
addpath C:\Users\ASUS\Desktop\Apps\rDCM-main\misc\

setenv('MW_MINGW64_LOC','D:\Package\MinGW_w64')

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
rDCM_all = struct();

for s = 1:numel(subjects)
    subj = subjects{s};
    roiData  = TS_ROI.(subj).data;
    roiNames = TS_ROI.(subj).names;
    

    y = cellfun(@(x)x(:),roiData,'UniformOutput',false);
    y = cell2mat(y');

    % Configure setup for rDCM
    Y = struct();
    Y.y = y;
    Y.dt = TR;
    Y.name = roiNames;

    rDCM = tapas_rdcm_model_specification(Y, [], []); % model spec for rest
    rDCM_fit = tapas_rdcm_estimate(rDCM, 'r', [], 1); % estimate model
    rDCM_all.(subj) = tapas_rdcm_to_spm_struct(rDCM_fit); % transfer to SPM format
end

save(fullfile(Datadir,'rDCM_all.mat'),'rDCM_all','-v7.3')


% --------------------------------
% Plot fitted DCM for each sub and comparing with FC

a = load(fullfile(Datadir,'conn_rsfMRI','results','firstlevel','RRC','resultsROI_Condition001.mat'));

subjects = fieldnames(rDCM_all);
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
    DCMmat = rDCM_all.(subj).Ep.A;
    
    DCMnames_raw = rDCM_all.(subj).Y.name(:);
    DCMnames = cellfun(@(x) regexp(x,'networks\.([^.]+\.[^ ]+)','tokens','once'), ...
                       DCMnames_raw,'UniformOutput',false);
    DCMnames = vertcat(DCMnames{:});
    
    figure('Name',subj,'Color','w')
    
    subplot(1,2,1)
    PlotConnectMatrix(FCmat,FCnames)
    title([subj '  |  Functional Connectivity'],'FontSize',18)
    
    subplot(1,2,2)
    PlotConnectMatrix(DCMmat,DCMnames)
    title([subj '  |  Effective Connectivity (rDCM)'],'FontSize',18)
    
end


end