function [] = plot_MUA(time,MeanRectMUA,isPaperSize)
%ExtractTDTDataAvgOnly_Penn

%This program extracts AEP, MUA, and CSD Data from the OpenEx data tank and
%saves the averaged data in individual files


% figure; % MUA
spacingRectMUA = 6;%spacing in microvolts
% spacingRectMUA = 10;
n_ch = size(MeanRectMUA,2);
y_max = n_ch * spacingRectMUA;
for n=1:n_ch % data channels
   z=MeanRectMUA(:,n);
   points=size(MeanRectMUA,1);
   grid off
   axis on

   plot(time,z-n*spacingRectMUA,'k','LineWidth',1.5);  %plots RectMUA
   hold on
   baseline=(zeros(1,points)-n*spacingRectMUA);
   plot(time,baseline,'k','LineWidth',.5); %plots baseline
   
   y_pos(n) = -n*spacingRectMUA;
end
set(gca,'YTick',fliplr(y_pos),'YTickLabel',n_ch:-1:1);

% % % plot scale
% scale_bar = 2;
% plot([-75 -75],[-y_max+2 -y_max+2+scale_bar],'k','LineWidth',1);

% paper setting
if strcmp(isPaperSize,'y')
    set(gcf,'Units','inches');%sets units of figure dimensions
    D=[4.5 .5 4.75 8.5];%left,bottom,width,height
    set(gcf,'Position',D);%sets figure position to values in D
end
axis tight

% % plot stimulus period
% y_lim = get(gca,'YLim');
% y_barpos = floor(y_lim(1));
% plot([0 100],[y_barpos y_barpos],'k','LineWidth',3);

xlabel('Time [ms]'), ylabel ('Channel')
% title(['RectMUA ',Stimulus,' Inter-Waveform Spacing= ',num2str(spacingRectMUA)])
title('MUA');
set(gca,'XTick',-100:100:400,'XLim',[-100 400]);
hold off;


end