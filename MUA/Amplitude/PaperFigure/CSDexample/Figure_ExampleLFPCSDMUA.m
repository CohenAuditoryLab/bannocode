DATA_PATH = pwd;
% SAVE_PATH = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\2_CSDMUA';
SAVE_PATH = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\2_CSDMUA\ver2';

% example from CORE
RecDate = '20191009';
ch = [7 8]; % specify channel for STRF
% fName_CSDMUA = strcat(RecDate,'_CSDMUA');
fName_CSDMUA = strcat(RecDate,'_CSDMUA_ver2'); % 01/04/22 modified (further smoothing)
load(fName_CSDMUA);

figure('Position',[300 300 1050 450]);
subplot(1,4,1);
plot_LFP(time,MeanAEP,'n');
y_range = get(gca,'YLim');
subplot(1,4,2);
plot_CSD(time,MeanCSD,'n');
subplot(1,4,3);
plot_MUA(time,MeanRectMUA,'n');

n_ch = size(MeanAEP,2);
spacing = 120; % spacingAEP in plot_LFP: 120
rTop = ( spacing + y_range(2) ) / spacing;
rBottom = -( y_range(1) + spacing*n_ch ) / spacing;

s_CSD = 75; % spacingCSD in plot_CSL: 75
y_range_CSD = [-s_CSD*n_ch-s_CSD*rBottom -s_CSD+s_CSD*rTop];
subplot(1,4,2); hold on
set(gca,'YLim',y_range_CSD);
plot([0 100],[y_range_CSD(1) y_range_CSD(1)],'k','LineWidth',3);

s_MUA = 6; % spacingCSD in plot_CSL: 6
y_range_MUA = [-s_MUA*n_ch-s_MUA*rBottom -s_MUA+s_MUA*rTop];
subplot(1,4,3); hold on;
set(gca,'YLim',y_range_MUA);
plot([0 100],[y_range_MUA(1) y_range_MUA(1)],'k','LineWidth',3);

fName_STRF = strcat(RecDate,'_STRF');
load(fName_STRF);
t = taxis;
f = faxis;

subplot(2,4,4); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(1));
% plot(strf_param.x,strf_param.y,'+w');
% text(.45*max(t),.85*8,['BF = ' num2str(round(strf_param.bf,2)) ' Hz']);
% title(['Channel ', num2str(ch(1))]);
title(['STRF (ch' num2str(ch(1)) ')']);
hold off;

subplot(2,4,8); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(2));
% plot(strf_param.x,strf_param.y,'+w');
% text(.45*max(t),.85*8,['BF = ' num2str(round(strf_param.bf,2)) ' Hz']);
% title(['Channel ', num2str(ch(2))]);
title(['STRF (ch' num2str(ch(2)) ')']);
hold off;

exportgraphics(gcf,fullfile(SAVE_PATH,'Example_CORE.eps'),'Resolution',600);

clear all; 

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Example from BELT
RecDate = '20200110';
ch = [6 7]; % specify channel for STRF
% fName_CSDMUA = strcat(RecDate,'_CSDMUA');
fName_CSDMUA = strcat(RecDate,'_CSDMUA_ver2'); % 01/04/22 modified (further smoothing)
load(fName_CSDMUA);

figure('Position',[300 300 1050 450]);
subplot(1,4,1);
plot_LFP(time,MeanAEP,'n');
y_range = get(gca,'YLim');
subplot(1,4,2);
plot_CSD(time,MeanCSD,'n');
subplot(1,4,3);
plot_MUA(time,MeanRectMUA,'n');

n_ch = size(MeanAEP,2);
spacing = 120; % spacingAEP in plot_LFP: 120
rTop = ( spacing + y_range(2) ) / spacing;
rBottom = -( y_range(1) + spacing*n_ch ) / spacing;

s_CSD = 75; % spacingCSD in plot_CSL: 75
y_range_CSD = [-s_CSD*n_ch-s_CSD*rBottom -s_CSD+s_CSD*rTop];
subplot(1,4,2); hold on
set(gca,'YLim',y_range_CSD);
plot([0 100],[y_range_CSD(1) y_range_CSD(1)],'k','LineWidth',3);

s_MUA = 6; % spacingCSD in plot_CSL: 6
y_range_MUA = [-s_MUA*n_ch-s_MUA*rBottom -s_MUA+s_MUA*rTop];
subplot(1,4,3); hold on;
set(gca,'YLim',y_range_MUA);
plot([0 100],[y_range_MUA(1) y_range_MUA(1)],'k','LineWidth',3);

fName_STRF = strcat(RecDate,'_STRF');
load(fName_STRF);
t = taxis;
f = faxis;

subplot(2,4,4); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(1));
% plot(strf_param.x,strf_param.y,'+w');
% text(.45*max(t),.85*8,['BF = ' num2str(round(strf_param.bf,2)) ' Hz']);
% title(['Channel ', num2str(ch(1))]);
title(['STRF (ch' num2str(ch(1)) ')']);
hold off;

subplot(2,4,8); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(2));
% plot(strf_param.x,strf_param.y,'+w');
% text(.45*max(t),.85*8,['BF = ' num2str(round(strf_param.bf,2)) ' Hz']);
% title(['Channel ', num2str(ch(2))]);
title(['STRF (ch' num2str(ch(2)) ')']);
hold off;

exportgraphics(gcf,fullfile(SAVE_PATH,'Example_BELT.eps'),'Resolution',600);