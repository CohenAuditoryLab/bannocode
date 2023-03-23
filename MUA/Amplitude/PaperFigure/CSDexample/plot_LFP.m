function [] = plot_LFP(time,MeanAEP,isPaperSize)
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
% dummy_AEP = NaN(size(MeanAEP,1),1);
% MeanAEP = [dummy_AEP MeanAEP dummy_AEP]; % add NaN
n_ch = size(MeanAEP,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Now We Plot the Data:
% figure; % CSD
% spacingAEP=75;%spacing in microvolts
spacingAEP=120;%spacing in microvolts
y_max = n_ch * spacingAEP;
for n=1:n_ch % data channels
   z=MeanAEP(:,n);
   points=size(MeanAEP,1);
   grid off
   axis on

   plot(time,z-n*spacingAEP,'k','LineWidth',1.5);  %plots CSD
   hold on
   baseline=(zeros(1,points)-n*spacingAEP);
   plot(time,baseline,'k','LineWidth',.5); %plots baseline
   
   y_pos(n) = -n*spacingAEP;
end
set(gca,'YTick',fliplr(y_pos),'YTickLabel',n_ch:-1:1);

% % plot scale
% scale_bar = 30;
% plot([-75 -75],[-y_max+15 -y_max+15+scale_bar],'k','LineWidth',1);

% paper setting
if strcmp(isPaperSize,'y')
    set(gcf,'Units','inches');%sets units of figure dimensions
    D=[9 .5 4.75 8.5];%left,bottom,width,height
    set(gcf,'Position',D);%sets figure position to values in D
end
axis tight

% plot stimulus period
y_lim = get(gca,'YLim');
y_barpos = floor(y_lim(1)) - 12;
plot([0 100],[y_barpos y_barpos],'k','LineWidth',3);

xlabel('Time [ms]'), ylabel ('Channel');
% title(['CSD ',Stimulus,' Inter-Waveform Spacing= ',num2str(spacingCSD)])
title('LFP');
set(gca,'XTick',-100:100:400,'XLim',[-100 400]);
hold off;


end