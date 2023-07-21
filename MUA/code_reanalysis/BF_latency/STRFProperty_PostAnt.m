% Examine STRF properties
% plot STRF properties on the grid coordinate...
clear all;

addpath ../
LIST_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';
DATA_PATH = 'C:\Users\Taku\Documents\01_Research\STRF_stats';

% set index number that specifies STRF parameter
% 3 -- BF
% 4 -- BW
% 5 -- latency
% 6 -- duration
% 7 -- Phase Locking Index (PLI)


animal = 'Both';
load(fullfile(LIST_PATH,strcat('RecordingDate_',animal))); % load list of rec_session
% load(strcat('Grid_',animal)); % load grid coordinate

params_post = [];
params_ant = [];
% figure(1); hold on;
% figure(2); hold on;
for ff=1:length(list_RecDate)
    d = list_RecDate{ff}; % date
    f_name = strcat(d,'_STRFParam');
    load(fullfile(DATA_PATH,f_name));
    % 7 parameters in strf_param.all are:
    % H, p_Val, BF, BW, latency, duration, PLI
    params_all = strf_param.all;
    i_sig = params_all(:,1);
    params_sig = params_all(i_sig==1,:);
    i_area = AP_index(ff); % Posterior vs Anterior

    if i_area==1 % Posterior
        params_post = cat(1,params_post,params_sig);
    elseif i_area==0 % Anterior
        params_ant = cat(1,params_ant,params_sig);
    end
end

% parameters posterior
BW_post       = params_post(:,4);
latency_post  = params_post(:,5);
duration_post = params_post(:,6);
PLI_post      = params_post(:,7);
% parameters anterior
BW_ant       = params_ant(:,4);
latency_ant  = params_ant(:,5);
duration_ant = params_ant(:,6);
PLI_ant      = params_ant(:,7);

figure;
subplot(2,2,1);
bin = 0:0.25:6;
histogram(BW_post,bin); hold on;
histogram(BW_ant,bin);
title('BW');
box off;

subplot(2,2,2);
bin = 0:10:150;
histogram(latency_post,bin); hold on;
histogram(latency_ant,bin);
title('latency');
box off;

subplot(2,2,3);
bin = 0:5:90;
histogram(duration_post,bin); hold on;
histogram(duration_ant,bin);
title('duration');
box off;

subplot(2,2,4);
bin = 0:0.025:0.4;
histogram(PLI_post,bin); hold on;
histogram(PLI_ant,bin);
title('PLI');
box off;

% rank-sum test with Z-value
[p,h,stats] = ranksum(latency_post,latency_ant,'method','approximate');