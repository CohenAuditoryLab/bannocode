function [] = plot_CSD(time,MeanCSD,isPaperSize)
%ExtractTDTDataAvgOnly_Penn

%This program extracts AEP, MUA, and CSD Data from the OpenEx data tank and
%saves the averaged data in individual files

% clear all;
% close all;
% 
% % specify data...
% RecDate = '20191009';
% % RecDate = '20200110';
% 
% fName = strcat(RecDate,'_CSDMUA');
% load(fName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Now We Plot the Data:
% figure; % CSD
spacingCSD=75;%spacing in microvolts
for n=1:14 % data channels
   z=MeanCSD(:,n);
   points=size(MeanCSD,1);
   grid off
   axis on

   plot(time,z-n*spacingCSD,'k','LineWidth',1);  %plots CSD
   hold on
   baseline=(zeros(1,points)-n*spacingCSD);
   plot(time,baseline,'k','LineWidth',.5); %plots baseline
end
% paper setting
if strcmp(isPaperSize,'y')
    set(gcf,'Units','inches');%sets units of figure dimensions
    D=[9 .5 4.75 8.5];%left,bottom,width,height
    set(gcf,'Position',D);%sets figure position to values in D
end
axis tight

xlabel('Time [ms]'), ylabel ('Amplitude [\muV]')
% title(['CSD ',Stimulus,' Inter-Waveform Spacing= ',num2str(spacingCSD)])
title('CSD');
hold off;


end