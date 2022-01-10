function [] = bargraph_FFTPeaks_DC(nPeak_stdiff)
% nPeak_all -- (Arate - ABrate) x channel x (hit-miss)

n_ch = size(nPeak_stdiff,2); % number of channel
FFT_1SRM = squeeze(nPeak_stdiff(2,:,:)); % FFT 13.3 Hz,
FFT_2SRM = squeeze(nPeak_stdiff(1,:,:)); % FFT 4.4 Hz,
% 
figure
subplot(2,1,1);
x=1:n_ch;
h=bar(x,FFT_2SRM); % smallest dF trial
%set(B(1),'LineWidth',25);
title('DC normalized FFT at A rate');
set(h,'BarWidth',1);
% set(h(1),'FaceColor','blue','BarWidth',1);
% set(h(2),'FaceColor','red','BarWidth',1);
xlabel('Electrode Contact');
ylabel('FFT amplitude');
xlim([0 n_ch+1]);
set(h(1),'FaceColor','red','BarWidth',1);
set(h(2),'FaceColor','blue','BarWidth',1);
% 
subplot(2,1,2);
x=1:n_ch;
h=bar(x,FFT_1SRM);
%set(B(1),'LineWidth',25);
title('DC normalized FFT at (A+B) rate');
set(h,'BarWidth',1);
% set(h(1),'FaceColor','blue','BarWidth',1);
% set(h(2),'FaceColor','red','BarWidth',1);
xlabel('Electrode Contact');
ylabel('FFT amplitude');
xlim([0 n_ch+1]);
set(h(1),'FaceColor','red','BarWidth',1);
set(h(2),'FaceColor','blue','BarWidth',1);

end