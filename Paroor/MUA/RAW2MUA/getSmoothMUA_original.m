function [ Smooth_MeanMUA_BLC ] = getSmoothMUA( raw, params )
%smoothMUA Summary of this function goes here
%   caclurate mean MUA from raw voltage trace
%   the raw should be Time x Trial x Channel

SampleRate = params.SampleRate;
Baseline = params.Baseline; % baseline correction window in ms
Taps = params.Taps;
points = params.Points; % for smoothing
pointspermsec = SampleRate/1000;


% filtering
Nyquist = params.SampleRate / 2;
Wn = params.Wn / Nyquist; % set window for band-pass filtering
B = fir1(Taps,Wn,'bandpass');%bandpass FIR filter with 100 taps
MUA = filtfilt(B,1,raw); % use fitfilt instead of filter
MUA = abs(MUA);
MeanMUA = squeeze(nanmean(MUA,2));

%Baseline correct MeanMUA:
n_timepoints = size(MeanMUA,1);
n_channels = size(MeanMUA,2);
for c=1:n_channels
    MeanMUA_BLC(:,c)=(MeanMUA(:,c)-nanmean(MeanMUA(1:round(pointspermsec*Baseline),c)));%subtracts mean of baseline from each column in the file
end

%Smooth MeanMUA:
Smooth_MeanMUA_BLC = zeros(n_timepoints,n_channels);
for c=1:n_channels;
    for r=(points+1):n_timepoints-(points+1);%start at row #points+1 and ends at row #end-(points+1) for n-point average smooth
        Smooth_MeanMUA_BLC(r,c)=mean(MeanMUA_BLC(r-points:r+points,c)); %n-point average smooth
    end
end

end

