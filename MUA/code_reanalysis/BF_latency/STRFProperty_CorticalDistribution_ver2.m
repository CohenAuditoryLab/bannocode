% Examine STRF properties
% plot STRF properties on the grid coordinate...
clear all;

LIST_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';
DATA_PATH = 'C:\Users\Taku\Documents\01_Research\STRF_stats';
% set index number that specifies STRF parameter
% 3 -- BF
% 4 -- BW
% 5 -- latency
% 6 -- duration
% 7 -- Phase Locking Index (PLI)
iParam = 3;

animal = 'Cassius';
load(fullfile(LIST_PATH,strcat('RecordingDate_',animal))); % load list of rec_session
load(strcat('Grid_',animal)); % load grid coordinate

params_core = [];
params_belt = [];
figure(1); hold on;
figure(2); hold on;
for ff=1:length(list_RecDate)
    d = list_RecDate{ff}; % date
    f_name = strcat(d,'_STRFParam');
    load(fullfile(DATA_PATH,f_name));
    % 7 parameters in strf_param.all are:
    % H, p_Val, BF, BW, latency, duration, PLI
    params_all = strf_param.all;
    i_sig = params_all(:,1);
    params_sig = params_all(i_sig==1,:);
    i_area = area_index(ff);
    AP = grid(ff,1) * ones(sum(i_sig),1);
    LM = grid(ff,2) * ones(sum(i_sig),1);

    if i_area==1 % core
        params_core = cat(1,params_core,params_sig);
        figure(1); % plot best frequency
        plot(median(AP),median(log2(params_sig(:,iParam)/200)),'bo','LineWidth',2);
        figure(2); % plot latency
        plot(median(LM),median(params_sig(:,5)),'bo','LineWidth',2);
%         stem3(AP,LM,log2(params_sig(:,3)),'o');
    elseif i_area==0 % belt
        params_belt = cat(1,params_belt,params_sig);
        figure(1); % plot best frequency
        plot(median(AP),median(log2(params_sig(:,iParam)/200)),'r^','LineWidth',2);
        figure(2); % plot latency
        plot(median(LM),median(params_sig(:,5)),'r^','LineWidth',2);
%         stem3(AP,LM,log2(params_sig(:,3)),'^');
    end
end
figure(1);
xlabel('AP axis [mm]'); ylabel('Best Frequency [octave]');
title(animal);
figure(2);
xlabel('LM axis [mm]'); ylabel('Latency [ms]');
title(animal);

% parameters core
BW_core = params_core(:,4);
latency_core = params_core(:,5);
duration_core = params_core(:,6);
PLI_core = params_core(:,7);
% parameters belt
BW_belt = params_belt(:,4);
latency_belt = params_belt(:,5);
duration_belt = params_belt(:,6);
PLI_belt = params_belt(:,7);

figure;
subplot(2,2,1);
bin = 0:0.25:6;
histogram(BW_core,bin); hold on;
histogram(BW_belt,bin);
title('BW');
box off;

subplot(2,2,2);
bin = 0:10:150;
histogram(latency_core,bin); hold on;
histogram(latency_belt,bin);
title('latency');
box off;

subplot(2,2,3);
bin = 0:5:90;
histogram(duration_core,bin); hold on;
histogram(duration_belt,bin);
title('duration');
box off;

subplot(2,2,4);
bin = 0:0.025:0.4;
histogram(PLI_core,bin); hold on;
histogram(PLI_belt,bin);
title('PLI');
box off;

% rank-sum test with Z-value
[p,h,stats] = ranksum(latency_core,latency_belt,'method','approximate');