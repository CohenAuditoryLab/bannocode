function [] = plot_AVREC(time,mCSD,color)
% function to generate AVREC of CSD
% time -- time
% mCSD -- meanCSD (time x channel)
% color -- line color

% % DATA_PATH = pwd;
% % SAVE_PATH = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\2_CSDMUA';
% % line_color = [153 0 255; 0 204 0] / 255;
% % 
% % % example from CORE
% % RecDate = '20191009';
% % % ch = [7 8]; % specify channel for STRF
% % % fName_CSDMUA = strcat(RecDate,'_CSDMUA');
% % fName_CSDMUA = strcat(RecDate,'_CSDMUA_ver2'); % 01/04/22 modified (further smoothing)
% % load(fName_CSDMUA);

% get AVREC of CSD
AVREC = mean(abs(mCSD),2);
SUMCSD = mean(mCSD,2);

% plot
% figure; 
plot(time,AVREC,'Color',color,'LineWidth',2); hold on;
% plot(time,SUMCSD,'Color',[.3 .3 .3],'LineWidth',1);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % Example from BELT
% RecDate = '20200110';
% % ch = [6 7]; % specify channel for STRF
% % fName_CSDMUA = strcat(RecDate,'_CSDMUA');
% fName_CSDMUA = strcat(RecDate,'_CSDMUA_ver2'); % 01/04/22 modified (further smoothing)
% load(fName_CSDMUA);
% 
% % get AVREC of CSD
% AVREC = mean(abs(MeanCSD),2);
% SUMCSD = mean(MeanCSD,2);
% 
% % plot
% plot(time,AVREC,'Color',line_color(2,:),'LineWidth',2);
% % plot(time,SUMCSD,'Color',[.5 .5 .5],'LineWidth',1);
% 
% % stimulus period
% plot([0 100],zeros(1,2),'k','LineWidth',3);
% 
% box off;
% set(gca,'xlim',[time(1) time(end)]);
% xlabel('Time [ms]');
% title('AVREC');
% legend({'Core','Belt'});
% 
% % export figure
% % exportgraphics(gcf,fullfile(SAVE_PATH,'AVREC.eps'),'Resolution',600);

end