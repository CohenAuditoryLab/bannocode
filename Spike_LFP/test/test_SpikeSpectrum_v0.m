% add path for Chronux
addpath(genpath('C:\Users\Cohen\Documents\MATLAB\chronux_2_12\chronux_2_12'));

% specify data directory
SPIKE_DIR = 'G:\Domo\SPIKE';

rec_date = '20180727';
fName_spike = strcat(rec_date,'_activeCh');

% load data
load(fullfile( SPIKE_DIR, rec_date, fName_spike));
iBehav = trialInfo.behav_ind; % index for behavioral outcome
clID = clInfo.all_cluster;

% choose spike data to analyze...
cl = 73; % 70;
iCluster = 1:length(clID);
iCluster = iCluster(clID==cl);
raster_cl = Raster(iBehav==0,:,iCluster); % choose responding unit

figure;
subplot(2,2,1);
% imagesc(raster_cl); caxis([0 1]);
r = sum(raster_cl,1);
bar(t_raster,r);
f_title = ['PSTH (cluster #' num2str(cl) ')'];
title(f_title);

% set parameter for spectrum analysis (Chronux format)
params.Fs = 1000;
params.fpass = [0 50];
params.tapers = [5 9]; %[10 19];
params.pad = 0; % default is 0
params.trialave = 1;
params.err = 0;

raster_cl = raster_cl'; % data must be samples x trials

% extract data from defined delay period
delay_times = [0.5 1.5]; % def delay period (between 0.5 to 1.5 sec)
data_sp = extractdatapb(raster_cl,params.Fs,delay_times);

% compute spike spectrum
% [S,f,R] = mtspectrumpb(data_sp,params,0);
[S,f,R] = mtspectrumpb(raster_cl,params,0);
% plot spectrum
subplot(2,2,3);
plot_vector(S,f,'l');
set(gca,'XLim',params.fpass);
title('Spike Spectrum');

% spectrogram
movingwin = [0.5 0.05];
[S1,t,f,R1] = mtspecgrampb(raster_cl,movingwin,params,0);
% normalize spectrogram by firing rate
S_norm = S1 ./ repmat(R1(:,1),[1 size(S1,2)]);

% plot spectrogram
subplot(2,2,4);
plot_matrix(S_norm,t,f);
set(gca,'XTickLabel',0:0.5:2.5);
% caxis([-5 8]);
colormap jet