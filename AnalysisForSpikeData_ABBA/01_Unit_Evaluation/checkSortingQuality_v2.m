clear all;

DATA_PATH = 'F:\kilosort_Domo\20180807_ABBA_d01';

addpath(genpath('C:\MatlabTools\npy-matlab-master'));
addpath(genpath('C:\MatlabTools\sortingQuality-master'));
addpath(DATA_PATH);
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Domo\NeuralData\vProbe\04_ABBA\20180807');

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
load 20180727_ABBA_BehavData

% cNoise = cids(cgs==0); % noise clusters
% cMUA = cids(cgs==1); % MUA clusters
% cGood = cids(cgs==2); % good clusters
% cUS = cids(cgs==3); % unsorted clusters
% cDrift = cids(cgs==4); % drifting clusters

spikeTimes = double(spTime) / 24414.0625; % spike time in sec
minISI = 0.001;
refDur = 0.0015;

T = max(spikeTimes); % duration of recording (s)
RP = refDur - minISI;
for i=1:numel(cids)
    spike_train = spikeTimes(cl==cids(i));
    N = length(spike_train); % number of spikes
    RPV = sum(diff(spike_train) <= refDur);
    [ev(i),lb(i),ub(i)] = rpv_contamination(N,T,RP,RPV);
    [fpRate(i), violationRate(i)] = ISIViolations(spike_train,minISI,refDur);
end