function EC_Plots(Datadir, name)

%%% Name of Network %%%

a = load(fullfile(Datadir,'conn_rsfMRI','results','firstlevel','RRC','resultsROI_Condition001.mat'));
FCnames_raw = a.names(:);
FCnames = cellfun(@(x) regexp(x,'networks\.([^.]+\.[^ ]+)','tokens','once'), ...
                  FCnames_raw,'UniformOutput',false);
FCnames = vertcat(FCnames{:});

%%% PEB results; Plot Before BMR %%%
files = dir(fullfile(Datadir, [name, '_rPEB.mat']));  % Add 'name' as a prefix
load(fullfile(Datadir, files(1).name));

files = dir(fullfile(Datadir, [name, '_PEB.mat']));  % Add 'name' as a prefix
load(fullfile(Datadir, files(1).name));

Ep_full = full(PEB.Ep); % if you are using multiple contrast you should specify Ep(from:to)
rEp_full = full(rPEB.Ep); % if you are using multiple contrast you should specify Ep(from:to)
n = length(rEp_full)/8;
% Reshape the full array (64x1) into an 8x8 matrix
EC = reshape(Ep_full, [n, n]);
rEC = reshape(rEp_full, [n, n]);

outdir = fullfile(Datadir, 'matrices');

% Create folder if it does not exist
if ~exist(outdir, 'dir')
    mkdir(outdir);
end

writeNPY(EC, fullfile(outdir,[name, '_spDCM.npy']));   % for numpy readable matlab
writeNPY(rEC, fullfile(outdir,[name, '_rDCM.npy']));   % for numpy readable matlab



figure;
subplot(1,2,1)
PlotConnectMatrix(EC,FCnames)
title('spDCM','FontSize',18)

subplot(1,2,2)
PlotConnectMatrix(rEC,FCnames)
title('rDCM','FontSize',18)


%%% Plot After BMR %%%
clear EC rEC Ep_full rEp_full;

files = dir(fullfile(Datadir, [name, '_rBMA.mat']));  % Add 'name' as a prefix
load(fullfile(Datadir, files(1).name));

files = dir(fullfile(Datadir, [name, '_BMA.mat']));  % Add 'name' as a prefix
load(fullfile(Datadir, files(1).name));

Ep_full = full(BMA.Ep); % if you are using multiple contrast you should specify Ep(from:to)
rEp_full = full(rBMA.Ep); % if you are using multiple contrast you should specify Ep(from:to)
n = length(rEp_full)/8;
% Reshape the full array (64x1) into an 8x8 matrix
EC = reshape(Ep_full, [n, n]);
rEC = reshape(rEp_full, [n, n]);

writeNPY(EC, fullfile(outdir,[name, '_spDCM_BMA.npy']));   % for numpy readable matlab
writeNPY(rEC, fullfile(outdir,[name, '_rDCM_BMA.npy']));   % for numpy readable matlab

figure;
subplot(1,2,1)
PlotConnectMatrix(EC,FCnames)
title('spDCM-BMA/BMR','FontSize',18)

subplot(1,2,2)
PlotConnectMatrix(rEC,FCnames)
title('rDCM-BMA/BMR','FontSize',18)


%%% Plot After BMR with Pp > 95 %%%
Pp = BMA.Pp;
rPp = rBMA.Pp;  
rmask = rPp > 0.95;  % Posterior probability for regression DCM
mask = Pp > 0.95;  % Posterior probability for regression DCM
rEC_masked = reshape(rEp_full.* rmask,[n n]) ;
EC_masked = reshape(Ep_full.* mask, [n n]);

writeNPY(EC, fullfile(outdir,[name, '_spDCM_BMA95.npy']));   % for numpy readable matlab
writeNPY(rEC, fullfile(outdir,[name, '_rDCM_BMA95.npy']));   % for numpy readable matlab

figure;
subplot(1,2,1)
PlotConnectMatrix(EC_masked,FCnames)
title('spDCM-BMA/BMR-Pp>95','FontSize',18)

subplot(1,2,2)
PlotConnectMatrix(rEC_masked,FCnames)
title('rDCM-BMA/BMR-Pp>95','FontSize',18)

end
