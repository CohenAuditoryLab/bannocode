function [data_lfp] = downsample_LFP(LFP,t,dsFreq,rmNoise)
%downsample_LFP Summary of this function goes here
%   LFP     ... LFP data (trial x sample x channel)
%   t       ... time vector corresponding to the LFP
%   dsFreq    ... target frequency usually set 1000 Hz
%   rmNoise ... remove noise ('Y') or not ('N')

lfp = permute(LFP,[3 2 1]); % LFP (channel x sample x trial)

% lfp = lfp * 10e3; % convert unit to mV
lfp = lfp * 10e6; % convert unit to uV

nTrial = size(lfp,3);
for n=1:nTrial
    % downsampling
    Y = transpose(lfp(:,:,n)); % n-th trial (sample x channel)
    T = transpose(t/1000); % time in sec
    [rs_lfp,tt] = resample(Y,T,dsFreq,'spline');
    
    if strcmp(rmNoise,'Y')
        % rmpath C:\Users\Cohen\OneDrive\Documents\MATLAB\fieldtrip\external\signal
        % remove noise (require chronux)
        params.tapers = [3 5]; %[3 5];
        params.Fs  = dsFreq;
        params.pad = 3;
        
        % [S,f] = mtspecrtrumc(rs_lfp,params);
        % plot(f,log2(S));
        
        bsFilt60 = designfilt('bandstopiir','FilterOrder',2, ...
            'HalfPowerFrequency1',58,'HalfPowerFrequency2',62, ...
            'SampleRate',dsFreq);
        
        bsFilt180 = designfilt('bandstopiir','FilterOrder',2, ...
            'HalfPowerFrequency1',178,'HalfPowerFrequency2',182, ...
            'SampleRate',dsFreq);
        
        bsFilt300 = designfilt('bandstopiir','FilterOrder',2, ...
            'HalfPowerFrequency1',298,'HalfPowerFrequency2',302, ...
            'SampleRate',dsFreq);
        
        
%         y = filtfilt(bsFilt60,rs_lfp); % maybe too powerfull?
        y = rmlinesc(rs_lfp,params,[],[],60);
%         y = rs_lfp; % no filtering at 60 Hz...
        y = filtfilt(bsFilt180,y);
        y = filtfilt(bsFilt300,y);
        rs_lfp_rmNoise = y;
        
        % % rs_lfp_rmNoise = rmlinesc(rs_lfp,params,[],'y',60);
        % rs_lfp_rmNoise = rmlinesc(y,params,[],[],180);
        % rs_lfp_rmNoise = rmlinesc(rs_lfp_rmNoise,params,[],[],300);
        % rs_lfp_rmNoise = rmlinesc(rs_lfp_rmNoise,params,[],'y',420);
    elseif strcmp(rmNoise,'N')
        rs_lfp_rmNoise = rs_lfp;
    end
    
    trial{n} = transpose(rs_lfp_rmNoise);
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
% data_lfp.label = label;
data_lfp.time = time;
data_lfp.trial = trial;
data_lfp.fsample = dsFreq;
data_lfp.sampleinfo = sinfo;

end

