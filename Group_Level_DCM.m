function Group_Level_DCM(Datadir, from_sub, to_sub, X, labels, name)


%---------------PEB Configure----------------%

M = struct();
M.X = X;
M.Xnames = labels;
field = {'A'};


%---------------spDCM----------------%

DCM_all = load(fullfile(Datadir,'DCM_all.mat'));
GCM = struct2cell(DCM_all.DCM_all);
GCM_a = cell(to_sub - from_sub + 1, 1);  


for i = from_sub:to_sub
    a = GCM{i,1};  
    GCM_a{i - from_sub + 1, 1} = a;  
end

PEB = spm_dcm_peb(GCM_a, M, field);
BMA = spm_dcm_peb_bmc(PEB);

% spm_dcm_peb_review(BMA)

% Save the BMA results using the provided 'name'
save(fullfile(Datadir, [name, '_PEB.mat']), 'PEB')
save(fullfile(Datadir, [name, '_BMA.mat']), 'BMA')


%---------------rDCM----------------%

rDCM_all = load(fullfile(Datadir,'rDCM_all.mat'));
rGCM = struct2cell(rDCM_all.rDCM_all);

rGCM_a = cell(to_sub - from_sub + 1, 1);  


for i = from_sub:to_sub
    a = rGCM{i,1};  
    rGCM_a{i - from_sub + 1, 1} = a;  
end


rPEB = spm_dcm_peb(rGCM_a, M, field);
rBMA = spm_dcm_peb_bmc(rPEB);
% spm_dcm_peb_review(rBMA)

% Save the BMA results using the provided 'name'
save(fullfile(Datadir, [name, '_rPEB.mat']), 'rPEB')
save(fullfile(Datadir, [name, '_rBMA.mat']), 'rBMA')


end