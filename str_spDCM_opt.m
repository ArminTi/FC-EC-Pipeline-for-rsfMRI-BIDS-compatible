function str_spDCM_opt(Datadir, str)

currentPath = pwd;
cd([pwd '\Str_spDCM_Greaves'])
DCMfile = load(fullfile(Datadir, 'DCM_all.mat'));
GCM = struct2cell(DCMfile.DCM_all);

% Structural_Connectivity = load(fullfile(test_dir, dir(fullfile(test_dir, '*SC.mat')).name)).SC;
heb_study(GCM, str, 'DMN')

% Plot comparison
load("HEB_explore_DMN.mat");
Ep = HEB.winning.Ep;   % 16 x 1
N  = 4;
A = reshape(Ep, N, N);   % column-wise reshape
b = GCM{2}.Ep.A;


DCMnames_raw = GCM{1}.Y.name(:);
DCMnames = cellfun(@(x) regexp(x,'networks\.([^.]+\.[^ ]+)','tokens','once'), ...
                   DCMnames_raw,'UniformOutput',false);
DCMnames = vertcat(DCMnames{:});

cd(currentPath)
subplot(1,3,1)
PlotConnectMatrix(b,DCMnames)
title('raw EC','FontSize',18)

subplot(1,3,2)
PlotConnectMatrix(str,DCMnames)
title('Str','FontSize',18)

subplot(1,3,3)
PlotConnectMatrix(A,DCMnames)
title('Str EC','FontSize',18)

end