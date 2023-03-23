function [] = plot_MUA(time,MeanRectMUA,isPaperSize)
%ExtractTDTDataAvgOnly_Penn

%This program extracts AEP, MUA, and CSD Data from the OpenEx data tank and
%saves the averaged data in individual files


% figure; % MUA
spacingRectMUA = 6;%spacing in microvolts
% spacingRectMUA = 10;

for n=1:16 % data channels
   z=MeanRectMUA(:,n);
   points=size(MeanRectMUA,1);
   grid off
   axis on

   plot(time,z-n*spacingRectMUA,'k','LineWidth',1);  %plots RectMUA
   hold on
   baseline=(zeros(1,points)-n*spacingRectMUA);
   plot(time,baseline,'k','LineWidth',.5); %plots baseline
end
% paper setting
if strcmp(isPaperSize,'y')
    set(gcf,'Units','inches');%sets units of figure dimensions
    D=[4.5 .5 4.75 8.5];%left,bottom,width,height
    set(gcf,'Position',D);%sets figure position to values in D
end
axis tight

xlabel('Time [ms]'), ylabel ('Amplitude [\muV]')
% title(['RectMUA ',Stimulus,' Inter-Waveform Spacing= ',num2str(spacingRectMUA)])
title('RectMUA');
hold off;


end