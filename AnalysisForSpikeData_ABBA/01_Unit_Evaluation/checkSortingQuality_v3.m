clear all;
BLOCK_NAME = '20200103_ABBA_d01';
% BLOCK_NAME = '20180807_ABBA_d01';

% DATA_PATH = fullfile('F:\kilosort_Domo',BLOCK_NAME);
DATA_PATH = fullfile('/Volumes/TOSHIBA_EXT/Kilosort',BLOCK_NAME);

addpath(genpath('/Users/work/Documents/MATLAB/npy-matlab'));
addpath(genpath('/Users/work/Documents/MATLAB/sortingQuality'));
addpath(DATA_PATH);
% addpath(['E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Domo\NeuralData\vProbe\04_ABBA\',BLOCK_NAME(1:8)]);
addpath(['/Volumes/TOSHIBA_EXT/01_STREAMING/DomoBehavior/',BLOCK_NAME(1:8)]);

% % The raw data (".bin" files) are binary files of type int16 
% % and with 16 data rows (see params.py)
% fn = 'continuous.dat';
% fid = fopen(fn, 'r');
% dat = fread(fid, [16 Inf], '*int16');
% chanMap = readNPY('channel_map.npy');
% dat = dat(chanMap+1,:);

% read data
spTime = readNPY('spike_times.npy'); % spike timing in sample
[cids,cgs] = readClusterGroupsCSV('cluster_group.tsv'); % cluster group
clu = readNPY('spike_clusters.npy');
% ch = readNPY('best_channels.npy');
fet = readNPY('pc_features.npy');
fetInds = readNPY('pc_feature_ind.npy');
% load 20180727_ABBA_BehavData

% calculate maskedClusterQuality
% index solely depends on spike waveform
% see https://github.com/cortex-lab/sortingQuality in detail
% ref: Schmitzer-Torber et al., Neuroscience, 2005.
[clusterIDs, unitQuality, contaminationRate] = maskedClusterQualitySparse(clu, fet, fetInds);

% cNoise = cids(cgs==0); % noise clusters
% cMUA = cids(cgs==1); % MUA clusters
% cGood = cids(cgs==2); % good clusters
% cUS = cids(cgs==3); % unsorted clusters
% cDrift = cids(cgs==4); % drifting clusters

% calculate ISIViolation
% measurement of spiks occurred in the refractory period
% see https://github.com/cortex-lab/sortingQuality in detail
% ref: Hill et al., J. Neurosci, 2011.
spikeTimes = double(spTime) / 24414.0625; % spike time in sec
minISI = 0.001;
refDur = 0.0015;
T = max(spikeTimes); % duration of recording (s)
RP = refDur - minISI;
for i=1:numel(cids)
    spike_train = spikeTimes(clu==cids(i));
    N = length(spike_train); % number of spikes
    RPV = sum(diff(spike_train) <= refDur);
    [ev(i),lb(i),ub(i)] = rpv_contamination(N,T,RP,RPV);
    [fpRate(i), violationRate(i)] = ISIViolations(spike_train,minISI,refDur);
end

% summary table for excel
excel_summary = [double(clusterIDs), fpRate', violationRate', unitQuality, contaminationRate];

% plot result
figure;
subplot(2,2,1);
x = contaminationRate;
y = fpRate;
scatter(x,y);
c = cellstr(num2str(clusterIDs));
dx = 0.03; dy = 0.03; % displacement so the text does not overlay the data points
text(x+dx, y+dy, c);
xlabel('Contamination Rate'); ylabel('False Positive Rate');

subplot(2,2,2);
x = unitQuality;
y = fpRate;
scatter(x,y);
c = cellstr(num2str(clusterIDs));
dx = 0.03; dy = 0.03; % displacement so the text does not overlay the data points
text(x+dx, y+dy, c);
xlabel('Unit Quality'); ylabel('False Positive Rate');

subplot(2,2,3);
x = unitQuality;
y = contaminationRate;
scatter(x,y);
c = cellstr(num2str(clusterIDs));
dx = 0.03; dy = 0.03; % displacement so the text does not overlay the data points
text(x+dx, y+dy, c);
xlabel('Unit Quality'); ylabel('Contamination Rate');

