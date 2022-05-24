% clear all
% % set pass to fieldtrip
% addpath('/Users/work/Documents/MATLAB/fieldtrip');
% addpath('/Users/work/Documents/MATLAB/fieldtrip/plotting');
addpath(genpath('C:\Users\Cohen\OneDrive\Documents\MATLAB\chronux_2_12\chronux_2_12')); % Chronux toolbox for removing line noise
data_path = 'D:\Spike_LFP\Data\MrCassius-190921';
% 'D1_PFC', 'D2_PFC', 'D3_AC', or 'D4_AC'
electrode = 'D2';
rec_area = 'PFC';
epoch = 'testToneOnset';
ds_freq = 1000; % downsampling frequency, use [] if no downsampling

% set parameter for rmlinesc
params.tapers = [3 5];
params.Fs = ds_freq;
params.pad = 3;

% load data
data_file_name = strcat('LFP_',electrode,'_',rec_area,'_',epoch);
load(fullfile(data_path,data_file_name));

% reshape data...
lfp = permute(LFP,[3 1 2]); % LFP (channel x sample x trial)
% sinfo = sampleinfo; % sample info

% lfp = lfp * 10e3; % convert unit to mV
lfp = lfp * 10e6; % convert unit to uV

% convert data structure for fieldtrip
nTrial = size(lfp,3);
for n=1:nTrial
    if ~isempty(ds_freq)
        % downsampling
        Y = transpose(lfp(:,:,n)); % n-th trial (sample x channel)
        T = transpose(t/1000); % time in sec
        [rs_lfp,tt] = resample(Y,T,ds_freq,'spline');
        
        % remove noise
        rs_lfp_rmNoise = rmlinesc(rs_lfp,params,[],[],180);
        rs_lfp_rmNoise = rmlinesc(rs_lfp_rmNoise,params,[],[],300);
        rs_lfp_rmNoise = rmlinesc(rs_lfp_rmNoise,params,[],[],420);
        
        trial{n} = transpose(rs_lfp_rmNoise);
        time{n} = tt; 
    else % no downsampling, no removal of noise 
        trial{n} = lfp(:,:,n);
        time{n} = transpose( t / 1000 );
    end
end

nCh = size(lfp,1); % number of channel
label = cell(nCh,1);
for i=1:nCh
    if i<10
        string = strcat(rec_area,'0',num2str(i));
    else
        string = strcat(rec_area,num2str(i));
    end
    label{i} = string;
end

% make sinfo if not available from the data (not ideal)...
if ~exist('sinfo','var')
%     nSample = size(lfp,2);
    nSample = size(rs_lfp,1); % samples in resampled data
    s_start = 1;
    for j=1:nTrial
        s_end = s_start + nSample -1;
        sinfo(j,:) = [s_start s_end];
        % update s_start
        s_start = s_end + 5; % make sure no overlap between sample periods
    end
end

if ~isempty(ds_freq)
    info.sf = ds_freq;
end

% header information not required...
% hdr.Fs = param.SF;
% hdr.FirstTimeStamp = 0;
% hdr.TimeStampPerSample = 24;
% hdr.nSamples = param.nSamples;

% data_lfp.hdr = hdr;
data_lfp.label = label;
data_lfp.time = time;
data_lfp.trial = trial;
data_lfp.fsample = info.sf;
data_lfp.sampleinfo = sinfo;

% save data
save_file_name = strcat(data_file_name,'_ft');
save(save_file_name,'data_lfp','choice','err','pretone','pretoneLength', ...
    'prior','SNR','stim','trial_id','info','-v7.3');

