DATA_PATH = pwd;
% SAVE_PATH = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\2_CSDMUA';
% SAVE_PATH = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\2_CSDMUA\ver2';
% SAVE_PATH = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\2_CSDMUA\ver3';

% example from CORE
RecDate = '20191009';
ch = [7 8]; % specify channel for STRF
% fName_CSDMUA = strcat(RecDate,'_CSDMUA');
fName_CSDMUA = strcat(RecDate,'_CSDMUA_ver2'); % 01/04/22 modified (further smoothing)
load(fName_CSDMUA);

figure('Position',[100 100 1315 900]);
subplot(2,5,1);
plot_LFP(time,MeanAEP,'n');
y_range = get(gca,'YLim');
subplot(2,5,2);
plot_CSD(time,MeanCSD,'n');
subplot(2,5,3);
plot_MUA(time,MeanRectMUA,'n');

n_ch = size(MeanAEP,2);
spacing = 120; % spacingAEP in plot_LFP: 120
rTop = ( spacing + y_range(2) ) / spacing;
rBottom = -( y_range(1) + spacing*n_ch ) / spacing;

s_CSD = 75; % spacingCSD in plot_CSL: 75
y_range_CSD = [-s_CSD*n_ch-s_CSD*rBottom -s_CSD+s_CSD*rTop];
subplot(2,5,2); hold on
set(gca,'YLim',y_range_CSD);
plot([0 100],[y_range_CSD(1) y_range_CSD(1)],'k','LineWidth',3);

s_MUA = 6; % spacingCSD in plot_CSL: 6
y_range_MUA = [-s_MUA*n_ch-s_MUA*rBottom -s_MUA+s_MUA*rTop];
subplot(2,5,3); hold on;
set(gca,'YLim',y_range_MUA);
plot([0 100],[y_range_MUA(1) y_range_MUA(1)],'k','LineWidth',3);

% plot AVREC
c = [153 0 255] / 255; % line color
subplot(2,5,9:10);
plot_AVREC(time,MeanCSD,c);
hold on;

% Plot STRF
fName_STRF = strcat(RecDate,'_STRF');
load(fName_STRF);
t = taxis;
f = faxis;

subplot(4,5,4); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(1));
title(['Core (ch' num2str(ch(1)) ')']);
hold off;

subplot(4,5,5); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(2));
title(['Core (ch' num2str(ch(2)) ')']);
hold off;

% exportgraphics(gcf,fullfile(SAVE_PATH,'Example_CORE.eps'),'Resolution',600);

clear all; 

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Example from BELT
RecDate = '20200110';
ch = [6 7]; % specify channel for STRF
% fName_CSDMUA = strcat(RecDate,'_CSDMUA');
fName_CSDMUA = strcat(RecDate,'_CSDMUA_ver2'); % 01/04/22 modified (further smoothing)
load(fName_CSDMUA);

% figure('Position',[300 300 1050 450]);
subplot(2,5,6);
plot_LFP(time,MeanAEP,'n');
y_range = get(gca,'YLim');
subplot(2,5,7);
plot_CSD(time,MeanCSD,'n');
subplot(2,5,8);
plot_MUA(time,MeanRectMUA,'n');

n_ch = size(MeanAEP,2);
spacing = 120; % spacingAEP in plot_LFP: 120
rTop = ( spacing + y_range(2) ) / spacing;
rBottom = -( y_range(1) + spacing*n_ch ) / spacing;

s_CSD = 75; % spacingCSD in plot_CSL: 75
y_range_CSD = [-s_CSD*n_ch-s_CSD*rBottom -s_CSD+s_CSD*rTop];
subplot(2,5,7); hold on
set(gca,'YLim',y_range_CSD);
plot([0 100],[y_range_CSD(1) y_range_CSD(1)],'k','LineWidth',3);

s_MUA = 6; % spacingCSD in plot_CSL: 6
y_range_MUA = [-s_MUA*n_ch-s_MUA*rBottom -s_MUA+s_MUA*rTop];
subplot(2,5,8); hold on;
set(gca,'YLim',y_range_MUA);
plot([0 100],[y_range_MUA(1) y_range_MUA(1)],'k','LineWidth',3);

% plot AVREC
c = [0 204 0] / 255; % line color
subplot(2,5,9:10);
plot_AVREC(time,MeanCSD,c);
% stimulus period
plot([0 100],zeros(1,2),'k','LineWidth',3);
hold off;
box off;
set(gca,'xlim',[time(1) time(end)]);
xlabel('Time [ms]');
title('AVREC');
legend({'Core','Belt'});


% plot STRF
fName_STRF = strcat(RecDate,'_STRF');
load(fName_STRF);
t = taxis;
f = faxis;

subplot(4,5,9); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(1));
title(['Belt (ch' num2str(ch(1)) ')']);
hold off;

subplot(4,5,10); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(2));
title(['Belt (ch' num2str(ch(2)) ')']);
hold off;


% save figure
SAVE_PATH = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\2_CSDMUA\ver3';
exportgraphics(gcf,fullfile(SAVE_PATH,'Figure2_3.eps'),'Resolution',600);