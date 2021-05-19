function [ Z_Score_ST ] = getFFTMag_atA( MUA_ST, t, params )
%FFT_atA Summary of this function goes here
%   Detailed explanation goes here

Nyquist = params.SampleRate/2;
pointspermsec = params.SampleRate/1000;
% msecperpoint = 1/pointspermsec;
Baseline = params.Baseline;%baseline correction window in ms

% MUA_ST = meanMUA(:,:,1,HorM);

New_MUA = MUA_ST(round(pointspermsec*Baseline):round(pointspermsec*(Baseline+1500)),:);%isolate data
New_t = t(round(pointspermsec*Baseline):round(pointspermsec*(Baseline+1500)));

figure
subplot(2,1,1);
plot(New_t,New_MUA);
title('rectifed MUA');
set(gca,'xlim',[min(New_t) max(New_t)]);
xlabel('Time [ms]'); ylabel('Voltage [uV]');


Y = fft(New_MUA,50000,1); % computes FFT of wave
Mag = abs(Y) * 2 / 50000; % gets the magnitude
Mag = Mag(1:25000,:); % eliminates the negative frequency values
freq = linspace(0,Nyquist,25000);
freq = freq';
% figure
subplot(2,1,2);
plot(freq,Mag,'-k','Linewidth',2.5);
axis tight;
xlim([0 100]);
%ylim([0 1]);
% title('FFT ST8');
title('FFT');

FFT_New_MUA = Mag;

FinalFFT_New_MUA=[FFT_New_MUA,freq];



%Now compute FFTs of permuted data:

for c=1:size(New_MUA,2);%Do for all columns (electrode contacts)
    
    for p=1:100;%number of permutations
        randindex = randperm(size(New_MUA,1));% generates a random permutation of numbers from 1 to the size of the data
        randindex = randindex';
        for n=1:size(New_MUA,1);
            Rand_New_MUA(n,1)=New_MUA(randindex(n),c);%generates a randomly ordered list of data values based on randindex
        end
        
        
        RandY = fft(Rand_New_MUA(:,1),50000);%computes 2048 pt FFT
        RandMag = abs(RandY)*2/50000;%gets the magnitude
        RandMag = RandMag(1:25000,:);%eliminates the negative frequency values
        
        RandMag = RandMag(1:25000,:);% This gets rid of the negative frequency components (points 513-2048)
        freq = linspace(0,Nyquist,25000);
        freq = freq';
        PermFFT_ST(:,p) = RandMag;
    end % next p permutation
    
    MeanPermFFT_ST(:,c) = mean(PermFFT_ST,2);
    StandardDeviationPermFFT_ST(:,c) = std(PermFFT_ST,0,2);% compute STD across columns(0 indicates normalization by N-1)
    
    %FinalPermFFT_ST=[Freq,MeanPermFFTST_8,StandardDeviationPermFFTST_8,OrderedFFTST_8];
    
    FinalPermFFT_ST{1,c} = [PermFFT_ST,freq,FFT_New_MUA(:,c)];%compile FFTs for all permutations and channels into cell array
    
    
end% next electrode contact


%Compute peak FFT at A tone rate (4.4 Hz) for actual data
FFT_ST_AToneRate = FFT_New_MUA(7:14,:);%Isolate A tone rate 4.4 Hz
[FFT_ST_AToneRatePeak,index] = max(FFT_ST_AToneRate,[],1);%Find peak at A tone rate 4.4 Hz

%Compute mean peak FFT at A tone rate (4.4 Hz) for permuted data
MeanPermFFT_ST_AToneRate = MeanPermFFT_ST(7:14,:);%Isolate A tone rate 4.4 Hz

for c=1:size(New_MUA,2)
    MeanPermFFT_ST_AToneRatePeak(1,c) = MeanPermFFT_ST_AToneRate(index(1,c),c);
end

StandardDeviationPermFFTST_AToneRate = StandardDeviationPermFFT_ST(7:14,:);%Isolate A tone rate 4.4 Hz

for c=1:size(New_MUA,2)
    StandardDeviationPermFFTST_AToneRatePeak(1,c) = StandardDeviationPermFFTST_AToneRate(index(1,c),c);
end

hold on

plot(freq,MeanPermFFT_ST,'-r','Linewidth',2.5);
xlabel('Frequency [Hz]'); ylabel('FFT Amplitude');

%Compute Z-Scores (number of standard deviations above mean of FFTs of permuted
%data)

for c=1:size(New_MUA,2) %for each channel:
    Z_Score_ST(1,c) = (FFT_ST_AToneRatePeak(1,c)-MeanPermFFT_ST_AToneRatePeak(1,c))./StandardDeviationPermFFTST_AToneRatePeak(1,c);
end


end

