function [ zScore_Peak ] = getFFTPeaks( FFT, meanPermFFT, stdPermFFT )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% FFT = FFT_New_ST_24; % temp
% meanPermFFT = MeanPermFFT_ST_24; % temp
% stdPermFFT = StandardDeviationPermFFT_ST_24; % temp

% number of channels
nCh = size(FFT,2);

% index for frequency corresponding to stimulus rate and its integer
% multiples
% f_index = [10:9:50 56:9:90]; % set the frequency to get manually...
f_index = [10:9:50 56:9:140]; % set the frequency to get manually...
f_range = 3; % frequency range (cannot be greater than 4)
f_min = f_index - f_range;
f_max = f_index + f_range;

for i=1:numel(f_index);
    FFT_AroundFreq = FFT(f_min(i):f_max(i),:);%Isolate A tone rate 4.4 Hz
    [FFT_Peak(i,:),index] = max(FFT_AroundFreq,[],1);%Find peak at A tone rate 4.4 Hz
    
    % Compute mean peak FFT at A tone rate (4.4 Hz) for permuted data
    meanPermFFT_AroundFreq = meanPermFFT(f_min(i):f_max(i),:);%Isolate A tone rate 4.4 Hz
    stdPermFFT_AroundFreq = stdPermFFT(f_min(i):f_max(i),:);%Isolate A tone rate 4.4 Hz
    for c=1:nCh
        meanPermFFT_Peak(i,c) = meanPermFFT_AroundFreq(index(1,c),c);
        stdPermFFT_Peak(i,c) = stdPermFFT_AroundFreq(index(1,c),c);
    end
    clear index meanPermFFT_ArounFreq stdPermFFT_AroundFreq
end

% Compute Z-Scores (number of standard deviations above mean of FFTs of permuted data
zScore_Peak = ( FFT_Peak - meanPermFFT_Peak ) ./ stdPermFFT_Peak;

end

