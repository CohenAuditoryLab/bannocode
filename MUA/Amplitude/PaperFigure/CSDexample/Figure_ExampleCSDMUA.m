DATA_PATH = pwd;

% example from CORE
RecDate = '20191009';
ch = [7 8]; % specify channel for STRF
% fName_CSDMUA = strcat(RecDate,'_CSDMUA');
fName_CSDMUA = strcat(RecDate,'_CSDMUA_ver2'); % 01/04/22 modified (further smoothing)
load(fName_CSDMUA);

figure('Position',[300 300 800 450])
subplot(1,3,1);
plot_CSD(time,MeanCSD,'n');
subplot(1,3,2);
plot_MUA(time,MeanRectMUA,'n');

fName_STRF = strcat(RecDate,'_STRF');
load(fName_STRF);
t = taxis;
f = faxis;

subplot(2,3,3); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(1));
plot(strf_param.x,strf_param.y,'+w');
% text(.45*max(t),.85*8,['BF = ' num2str(round(strf_param.bf,2)) ' Hz']);
title(['Channel ', num2str(ch(1))]);
hold off;

subplot(2,3,6); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(2));
plot(strf_param.x,strf_param.y,'+w');
% text(.45*max(t),.85*8,['BF = ' num2str(round(strf_param.bf,2)) ' Hz']);
title(['Channel ', num2str(ch(2))]);
hold off;

clear all; 

% Example from BELT
RecDate = '20200110';
ch = [6 7]; % specify channel for STRF
% fName_CSDMUA = strcat(RecDate,'_CSDMUA');
fName_CSDMUA = strcat(RecDate,'_CSDMUA_ver2'); % 01/04/22 modified (further smoothing)
load(fName_CSDMUA);

figure('Position',[300 300 800 450])
subplot(1,3,1);
plot_CSD(time,MeanCSD,'n');
subplot(1,3,2);
plot_MUA(time,MeanRectMUA,'n');

fName_STRF = strcat(RecDate,'_STRF');
load(fName_STRF);
t = taxis;
f = faxis;

subplot(2,3,3); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(1));
plot(strf_param.x,strf_param.y,'+w');
% text(.45*max(t),.85*8,['BF = ' num2str(round(strf_param.bf,2)) ' Hz']);
title(['Channel ', num2str(ch(1))]);
hold off;

subplot(2,3,6); hold on;
strf_param = plot_STRF(t,f,STRFData,RF1P,ch(2));
plot(strf_param.x,strf_param.y,'+w');
% text(.45*max(t),.85*8,['BF = ' num2str(round(strf_param.bf,2)) ' Hz']);
title(['Channel ', num2str(ch(2))]);
hold off;

