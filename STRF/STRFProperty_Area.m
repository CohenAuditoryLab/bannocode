% Examine STRF properties
clear all;

LIST_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';
DATA_PATH = 'C:\Users\Taku\Documents\01_Research\STRF_stats';

load(fullfile(LIST_PATH,'RecordingDate_Both.mat')) ;

params_core = [];
params_belt = [];
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
    if i_area==1 % core
        params_core = cat(1,params_core,params_sig);
    elseif i_area==0 % belt
        params_belt = cat(1,params_belt,params_sig);
    end
end

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
xlabel('octaves');
box off;

p_BW = ranksum(BW_core,BW_belt);

subplot(2,2,2);
bin = 0:10:150;
histogram(latency_core,bin); hold on;
histogram(latency_belt,bin);
xlabel('msec');
title('latency');
box off;

p_latency = ranksum(latency_core,latency_belt);

subplot(2,2,3);
bin = 0:5:90;
histogram(duration_core,bin); hold on;
histogram(duration_belt,bin);
xlabel('msec');
title('duration');
box off;

p_duration = ranksum(duration_core,duration_belt);

% subplot(2,2,3);
% bin = 1:0.05:2;
% histogram(log10(duration_core),bin); hold on;
% histogram(log10(duration_belt),bin);
% title('log(duration)');
% box off;

% subplot(2,2,4);
% bin = 0:0.025:0.4;
% histogram(PLI_core,bin); hold on;
% histogram(PLI_belt,bin);
% title('PLI');
% box off;

% log(PLI)
subplot(2,2,4);
bin = -2:0.125:-0.5;
histogram(log10(PLI_core),bin); hold on;
histogram(log10(PLI_belt),bin);
title('log(PLI)');
box off;

p_PLI = ranksum(log10(PLI_core),log10(PLI_belt));

P = [p_BW p_latency p_duration p_PLI];