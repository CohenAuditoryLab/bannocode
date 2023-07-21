function [ Smooth_MUA_BLC ] = getSmoothMUA_trial( raw, params )
%smoothMUA Summary of this function goes here
%   caclurate mean MUA from raw voltage trace
%   the raw should be Time x Trial x Channel

SampleRate = params.SampleRate;
% Baseline = params.Baseline; % baseline correction window in ms
Baseline = params.Baseline + 1000; % baseline correction window in ms
Taps = params.Taps;
points = params.Points; % for smoothing
pointspermsec = SampleRate/1000;


% filtering
Nyquist = params.SampleRate / 2;
Wn = params.Wn / Nyquist; % set window for band-pass filtering
B = fir1(Taps,Wn,'bandpass');%bandpass FIR filter with 100 taps
MUA = filtfilt(B,1,raw); % use fitfilt instead of filter
MUA = abs(MUA);
% MeanMUA = squeeze(nanmean(MUA,2));

%Baseline correct MeanMUA:
n_timepoints = size(MUA,1);
n_trials = size(MUA,2);
for c=1:n_trials
    %subtracts mean of baseline from each column in the file
%     MeanMUA_BLC(:,c)=(MeanMUA(:,c)-nanmean(MeanMUA(1:round(pointspermsec*Baseline),c)));
    MUA_BLC(:,c)=(MUA(:,c)-nanmean(MUA(round(pointspermsec*Baseline(1)):round(pointspermsec*Baseline(2)),c)));
end

%Smooth MeanMUA:
Smooth_MUA_BLC = zeros(n_timepoints,n_trials);
for c=1:n_trials
    for r=(points+1):n_timepoints-(points+1) %start at row #points+1 and ends at row #end-(points+1) for n-point average smooth
        Smooth_MUA_BLC(r,c)=mean(MUA_BLC(r-points:r+points,c)); %n-point average smooth
    end
end

end

