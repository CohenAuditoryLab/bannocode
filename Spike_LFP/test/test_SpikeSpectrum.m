clear all;

% add path for Chronux
addpath(genpath('C:\Users\Cohen\Documents\MATLAB\chronux_2_12\chronux_2_12'));

% specify data directory
SPIKE_DIR = 'G:\Domo\SPIKE';

% set variables
rec_date = '20180727';
period_baseline = [-500 0];
period_stimulus = [0 1500];
alpha = 0.01; % value for confidence interval (0.05 for 95% CI)
cl =73; % 70;

% set parameter for spectrum analysis (Chronux format)
params.Fs = 1000;
params.fpass = [0 50];
params.tapers = [3 5]; %[5 9]; %[10 19];
params.pad = 0; % default is 0
params.trialave = 1;
params.err = [2 alpha];
% params.err = 0;

% load data
fName_spike = strcat(rec_date,'_activeCh');
load(fullfile( SPIKE_DIR, rec_date, fName_spike));
iBehav = trialInfo.behav_ind; % index for behavioral outcome
clID = clInfo.all_cluster;

% choose spike data to analyze...
iCluster = 1:length(clID);
iCluster = iCluster(clID==cl);
raster_cl = Raster(iBehav==0,:,iCluster); % choose responding unit

% display response...
figure;
subplot(2,2,1);
% imagesc(raster_cl); caxis([0 1]);
r = sum(raster_cl,1);
bar(t_raster,r);
f_title = ['PSTH (cluster #' num2str(cl) ')'];
title(f_title);

% get raster from baseline and stimulus period
raster_cl = raster_cl'; % data must be samples x trials
raster_base = raster_cl( t_raster>=period_baseline(1) & t_raster<period_baseline(2) , : );
raster_stim = raster_cl( t_raster>=period_stimulus(1) & t_raster<period_stimulus(2) , : );

% compute spike spectrum
% [S_base,f_base,R_base,Serr_base] = mtspectrumpb(raster_base,params,0);
[S_base,f_base,R_base] = mtspectrumpb(raster_base,params,0); % CI not needed for baseline
[S_stim,f_stim,R_stim,Serr_stim] = mtspectrumpb(raster_stim,params,0);
% normalize by firing rate
S_base = S_base / R_base; % Serr_base = Serr_base / R_base;
S_stim = S_stim / R_stim; Serr_stim = Serr_stim / R_stim;
% interpolate data to equate number of sample points...
S_base_interp = interp(S_base,4); S_base_interp(end) = [];
for i=1:2
%     Serr_base_temp = interp(Serr_base(i,:),4);
%     Serr_base_interp(i,:) = Serr_base_temp(1:end-1);
    Serr_base_interp(i,:) = S_base_interp; % use for baseline correction...
end

% plot spectrum
subplot(2,2,2);
plot_vector(S_base_interp,f_stim,'l',[],':k'); hold on
plot_vector(S_stim,f_stim,'l',Serr_stim,'r');
set(gca,'XLim',params.fpass);
title('Spike Spectrum');
legend({'baseline','stimulus'});

subplot(2,2,3);
plot_vector(S_stim./S_base_interp,f_stim,'l',Serr_stim./Serr_base_interp,'r'); hold on;
plot(params.fpass,[0 0],'k','LineWidth',0.5);
set(gca,'XLim',params.fpass);
title('Spike Spectrum (baseline corrected)');


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
colormap jet;
colorbar off;