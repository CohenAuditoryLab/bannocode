clear all;
BLOCK_NAME = '20181212_ABBA_d01';
% DATE = '20190123';
SF_neuro = 24414.0625;
% SF_neuro = 24414.0630;

% specify data directory (neural data and behavioral data)
% NDATA_DIR = strcat('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\DATA\Domo\NeuralData\kilosort\',DATE,'_ABBA');
NDATA_DIR = fullfile('F:\kilosort_Domo', BLOCK_NAME);
BDATA_DIR = strcat('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Domo\NeuralData\vProbe\04_ABBA\',BLOCK_NAME(1:8));
% set path
addpath(genpath('C:\MatlabTools\npy-matlab-master'));
addpath(genpath('C:\MatlabTools\spikes-master'));
addpath(NDATA_DIR);
addpath(BDATA_DIR);
addpath(fullfile(NDATA_DIR,'sorting_metrics'));

% read data
spTime = readNPY('spike_times.npy');
cl = readNPY('spike_clusters.npy');
ch = readNPY('best_channels.npy');
[cids,cgs] = readClusterGroupsCSV('cluster_group.tsv'); % cluster group
load(strcat(BDATA_DIR(end-7:end),'_ABBA_BehavData'));
load isi_violations; % Matt's ISI metrics

% cNoise = cids(cgs==0); % noise clusters
% cMUA = cids(cgs==1); % MUA clusters
% cGood = cids(cgs==2); % good clusters
% cUS = cids(cgs==3); % unsorted clusters

spikeTimes = double(spTime) / SF_neuro; % spike time in sec
eventTimes = StimOnTime(index<3); % either hit, miss or fa trials
% behavInd = index(index<3);
window = [-225 225]; % analysis window in ms
w_spont = [-225 0]; % analysis window for spontaneous period
w_stim = [0 225]; % analysis window for 1st TRIPLET presentation period

list_cluster = cids;
for n=1:numel(list_cluster)
    for i=1:numel(eventTimes)
        spike_cl = spikeTimes(cl==list_cluster(n));
        spike_trial = (spike_cl - eventTimes(i)) * 1000; % spike time in ms
        raster(i,:) = histcounts(spike_trial,window(1):1:window(2));
        psth(i,:) = histcounts(spike_trial,window(1):10:window(2));
        c_spont(i,:) = histcounts(spike_trial,w_spont);
        c_stim(i,:) = histcounts(spike_trial,w_stim);
    end
    [p(n),h(n)] = signrank(c_spont,c_stim,0.01); % Wilcoxon sign rank test (1% significance)
%     [p_t(n), h_t(n)] = ttest(c_spont,c_stim); % paired t-test
    
    figure;
    subplot(2,1,1);
    imagesc(raster); colormap(1-gray);
    set(gca,'XTick',25:50:425,'XTickLabel',-200:50:200);
    title(strcat('cluster ',num2str(list_cluster(n))));
    subplot(2,1,2);
    psth = sum(psth,1) / numel(eventTimes) * 100;
    bar(psth,1);
    set(gca,'XLim',[0.25 45.75],'XTick',2.5:5:42.5,'XTickLabel',-200:50:200);
    string = strcat('cluster',num2str(list_cluster(n)));
    saveas(gcf,string,'png');
    close all
    clear spike_cl spike_trial raster psth c_spont c_stim
end
isi_violation_value = violations_isi(:,2);
% isi_violation_value = isi_violation_value(h);

h(cgs==4)=0; % all drifting neurons should be excluded from the analysis

% get info for auditory responsive units
clInfo.all_cluster = list_cluster;
clInfo.active_cluster = list_cluster(h);
clInfo.channel = transpose(ch);
clInfo.active_channel = transpose(ch(h));
clInfo.pvalue = p;
clInfo.sorting_quality_ks = cgs; % 0 -Noise, 1 -MUA, 2 -Good, 3 -Unsorted, 4 -Drift
clInfo.sorting_quality_isi = transpose(isi_violation_value<0.05); % 0 -violated (5% significance)
clInfo.isi_violation_value = transpose(isi_violation_value);

% summary for excel
excel_summary = [clInfo.all_cluster; clInfo.channel; clInfo.pvalue; ...
                   clInfo.sorting_quality_isi; clInfo.sorting_quality_ks];
excel_summary = excel_summary';

% get spike time for the auditory responsive units
eventTimes = StimOnTime; % including start error trials
window = [-500 2500]; % analysis window in ms
t_raster = window(1)+1:window(2);
SpikeTiming = cell(numel(eventTimes),1);
for n=1:numel(list_cluster)
    for i=1:numel(eventTimes)
        spike_cl = spikeTimes(cl==list_cluster(n));
        spike_trial = (spike_cl - eventTimes(i)) * 1000; % spike timing in ms
        sp_time = spike_trial( spike_trial>=window(1) & spike_trial<window(2) );
        cl_id = ones(length(sp_time),1) * list_cluster(n);
        temp = [sp_time cl_id];
        SpikeTiming{i} = [SpikeTiming{i}; temp];
        Raster(i,:,n) = histcounts(spike_trial,window(1):1:window(2));
        %     psth(i,:) = histcounts(spike_trial,window(1):10:window(2));
    end
end
lever_release = (LeverReleaseTime - StimOnTime) * 1000;

% get trial info
trialInfo.target_time = targetTime;
trialInfo.semitone_diff = stDiff;
trialInfo.behav_ind = index;
trialInfo.behav_ind_ts = index_tsRT;

% save data
save_file_name = strcat(BLOCK_NAME(1:8),'_activeCh');
save(save_file_name,'clInfo','SpikeTiming','Raster','trialInfo','t_raster','lever_release');