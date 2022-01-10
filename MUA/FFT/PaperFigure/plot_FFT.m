function [  ] = plot_FFT( meanMUA, t, ch, params )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

Nyquist = params.SampleRate/2;
pointspermsec = params.SampleRate/1000;
% msecperpoint = 1/pointspermsec;
Baseline = params.Baseline;%baseline correction window in ms

% choose hit trial in small and large dF
MUA_CH = squeeze(meanMUA(:,ch,[1 end],1));

New_MUA = MUA_CH(round(pointspermsec*Baseline):round(pointspermsec*(Baseline+1500)),:);%isolate data
New_t = t(round(pointspermsec*Baseline):round(pointspermsec*(Baseline+1500)));

% figure
% subplot(2,1,1);
% plot(New_t,New_MUA);
% title('rectifed MUA');
% set(gca,'xlim',[min(New_t) max(New_t)]);
% xlabel('Time [ms]'); ylabel('Voltage [uV]');


Y = fft(New_MUA,50000,1); % computes FFT of wave
Mag = abs(Y) * 2 / 50000; % gets the magnitude
Mag = Mag(1:25000,:); % eliminates the negative frequency values
freq = linspace(0,Nyquist,25000);
freq = freq';
DC = max(Mag(1:3,:),[],1);
% figure
% subplot(2,1,2);
Mag0 = ones(size(Mag,1),1) * DC;
% plot(freq,Mag,'Linewidth',1.5); % original
plot(freq,Mag./DC,'Linewidth',1.5); % normalized by DC
axis tight;
xlim([0 50]);
%ylim([0 1]);
xlabel('frequency [Hz]'); ylabel('amplitude');
title('FFT');
box off;

end

