function [data_bdlfp] = downsample_bdLFP(LFP,t,dsFreq,rmNoise,eInfo)
%downsample_bdLFP Summary of this function goes here
%   LFP     ... LFP data (trial x sample x channel)
%   t       ... time vector corresponding to the LFP
%   dsFreq    ... target frequency usually set 1000 Hz
%   rmNoise ... remove noise ('Y') or not ('N')
%   data_bdlpf ... bipolar derived lfp

lfp = permute(LFP,[3 2 1]); % LFP (channel x sample x trial)
Fs_original = 24414.0625/8; % sampling frequency of original
% for noise reduction
params.tapers = [3 5]; %[3 5];
params.Fs  = dsFreq;
params.pad = 3;
% make Butterworth filter
[B,A] = butter(4,250/(Fs_original/2),'low'); % 4th order Butterworth filter
[b_lp a_lp] = butter(4,150/(dsFreq/2),'low'); % low-pass filter
[b60,a60]   = butter(4,[59 61]/(dsFreq/2),'stop');
[b120,a120] = butter(4,[119 121]/(dsFreq/2),'stop');
[b180,a180] = butter(4,[179 181]/(dsFreq/2),'stop');
[b240,a240] = butter(4,[239 241]/(dsFreq/2),'stop');

disp('subtracting trial average...')
% lfp = lfp * 10e3; % convert unit to mV
lfp = lfp * 10e6; % convert unit to uV

% subtract trial average to get induced activity
mat_mlfp = repmat(mean(lfp,3),1,1,size(lfp,3)); % matrix of trial averaged LFP
lfp = lfp - mat_mlfp;
clear mat_mlfp

nTrial = size(lfp,3);
for n=1:nTrial
    clc;
    disp(['processing ' num2str(n) ' out of ' num2str(nTrial) ' trials...'])
    % downsampling
    Y = transpose(lfp(:,:,n)); % n-th trial (sample x channel)
    T = transpose(t/1000); % time in sec
    
%     % low-pass filter before resample (cutoff freq = 250 Hz)
%     Y = filtfilt(B,A,Y);
    % resample data
    [rs_lfp,tt] = resample(Y,T,dsFreq,'spline');
    
    % baseline correction
    bc_lfp = basecorrectLFP(rs_lfp,tt,[-0.7 -0.65]);
    
%     % reference LFP by average
%     ref_lfp = referenceLFP(bc_lfp,eInfo);
    
    % bipolar derivation
%     [bd_lfp,label] = bipolarLFP(ref_lfp,eInfo);
    [bd_lfp,label] = bipolarLFP(bc_lfp,eInfo);
    
    % noise removal (require chronux)
    if strcmp(rmNoise,'Y')        
        % remove noise (60, 120, 180, and 240 Hz)
        y = rmlinesc(bd_lfp,params,[],[],60);
        y = rmlinesc(y,params,[],[],120);
        y = rmlinesc(y,params,[],[],180);
        y = rmlinesc(y,params,[],[],240);
%         y = filtfilt(b240,a240,y);
        
%         % low-pass filter (cutoff = 150 Hz)
%         y = filtfilt(b_lp,a_lp,y);
        
        bd_lfp_rmNoise = y;
%         y = filtfilt(b60,a60,bd_lfp); % BW filter too powerful...
%         y = filtfilt(b120,a120,y);
%         y = filtfilt(b180,a180,y);
%         y = filtfilt(b240,a240,y);
%         bd_lfp_rmNoise = y;
    elseif strcmp(rmNoise,'N')
        % low-pass filter (cutoff = 150 Hz)
        y = filtfilt(b_lp,a_lp,bd_lfp);
        bd_lfp_rmNoise = y;
    end
    
    % put the data into cell
    trial{n} = transpose(bd_lfp_rmNoise);
    time{n} = transpose(tt);
end

nSample = size(rs_lfp,1); % samples in resampled data
s_start = 1;
for j=1:nTrial
    s_end = s_start + nSample -1;
    sinfo(j,:) = [s_start s_end];
    % update s_start
    s_start = s_end + 5; % make sure no overlap between sample periods
end

% data_lfp.hdr = hdr;
data_bdlfp.label = label;
data_bdlfp.time = time;
data_bdlfp.trial = trial;
data_bdlfp.fsample = dsFreq;
data_bdlfp.sampleinfo = sinfo;

end

