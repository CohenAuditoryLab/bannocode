clear all;

% DATA_PATH = 'C:\Taku\KSSpikeSorting\20180709\ks2';
% DATA_PATH = 'F:\kilosort_Domo\20180709_ABBA_d02';
DATA_PATH = 'F:\kilosort_Domo\20180907_ABBA_d01';
SF_neuro = 24414.0625;
addpath(genpath('C:\MatlabTools\npy-matlab-master'));
addpath(genpath('C:\MatlabTools\spikes-master'));
addpath(DATA_PATH);
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Domo\NeuralData\vProbe\04_ABBA\20180907');

% % The raw data (".bin" files) are binary files of type int16 
% % and with 16 data rows (see params.py)
% fn = 'continuous.dat';
% fid = fopen(fn, 'r');
% dat = fread(fid, [16 Inf], '*int16');
% chanMap = readNPY('channel_map.npy');
% dat = dat(chanMap+1,:);

% read data
spTime = readNPY('spike_times.npy');
cl = readNPY('spike_clusters.npy');
ch = readNPY('best_channels.npy');
[cids,cgs] = readClusterGroupsCSV('cluster_group.tsv'); % cluster group
load 20180907_ABBA_BehavData

cNoise = cids(cgs==0); % noise clusters
cMUA = cids(cgs==1); % MUA clusters
cGood = cids(cgs==2); % good clusters
cUS = cids(cgs==3); % unsorted clusters

spikeTimes = double(spTime) / SF_neuro; % spike time in sec
eventTimes = StimOnTime(index<3);
trGroup = index(index<3);
window = [-0.5 2.5]; % analysis window in sec
% show PSTH
psthViewer(spikeTimes,cl,eventTimes,window,trGroup);

% % set parameter for getWaveForms.m
% gwfparams.dataDir = 'C:\Taku\KSSpikeSorting\20180727\merged\';
% gwfparams.fileName = 'continuous.dat';
% gwfparams.dataType = 'int16';
% gwfparams.nCh = 16;
% gwfparams.wfWin = [-30 31];
% gwfparams.nWf = 200;
% gwfparams.spikeTimes = spTime(1:end-10);
% gwfparams.spikeClusters = cl(1:end-10);
% % get waveforms
% wave = getWaveForms(gwfparams);
% uid = wave.unitIDs;
% wf = wave.waveForms;
% mwf = wave.waveFormsMean;
% % check spike waveform
% nUnit = length(uid);
% temp = 1:nUnit;
% i = temp(uid==cGood(6));
% a = permute(mwf(i,:,:),[2 3 1]);
% for j=1:16
%     shift = 20*(j-16);
%     temp = a(j,:) + shift;
%     plot(temp'); hold on;
%     set(gca,'xlim',[1 62]);
% end