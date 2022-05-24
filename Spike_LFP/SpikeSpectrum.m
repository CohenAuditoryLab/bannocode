clear all;

% add path for Chronux
addpath(genpath('/home/taku/Documents/MATLAB/chronux_2_12'));

% specify data directory
DATA_DIR = '/home/taku/Documents/Data';
sessionID = 'MrCassius-190922';
electrodeID = 'D4_AC';
alignment = 'stimOnset';
cw = 'C'; % correct ('C') or wrong ('W')

% set variables
period_baseline = [-100 0]; %[-500 0];
period_stimulus = [0 900]; %[0 1500];
alpha = 0.01; % value for confidence interval (0.05 for 95% CI)
cl = 235; % 68;

% set parameter for spectrum analysis (Chronux format)
params.Fs = 1000;
params.fpass = [0 50];
params.tapers = [3 5]; %[5 9]; %[10 19];
params.pad = 1; % default is 0
params.trialave = 1;
params.err = [1 alpha]; % [1 p] - Theoretical error bars; [2 p] - Jackknife error bars
% params.err = 0;

% load data
fName_spike = strcat('Spike_',electrodeID,'_',alignment);
load(fullfile( DATA_DIR, sessionID, fName_spike));
iBehav = err; % index for behavioral outcome
clID = unit_id;
chID = ch_id;
t_raster = t;

% choose spike data to analyze...
iCluster = 1:length(clID);
iCluster = iCluster(clID==cl);
raster_cl = Spikes(:,iBehav==cw,iCluster); % choose responding unit
ch = chID(iCluster);

% display response...
figure;
subplot(2,2,1);
% imagesc(raster_cl); caxis([0 1]);
r = sum(raster_cl,2);
bar(t_raster,r);
f_title = ['PSTH (cluster #' num2str(cl) ')'];
title(f_title);

% get raster from baseline and stimulus period
% raster_cl = raster_cl'; % data must be samples x trials
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
S_base_interp = interp(S_base,8); S_base_interp(end) = [];
for i=1:2
%     Serr_base_temp = interp(Serr_base(i,:),4);
%     Serr_base_interp(i,:) = Serr_base_temp(1:end-1);
    Serr_base_interp(i,:) = S_base_interp; % use for baseline correction...
end

% plot spectrum
subplot(2,2,2);
plot_vector(S_base_interp,f_stim,'l',[],':k'); hold on
% plot_vector(S_base,f_base,'l',[],':k'); hold on
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
movingwin = [0.2 0.02]; %[0.5 0.05];
[S1,t,f,R1] = mtspecgrampb(raster_cl,movingwin,params,0);
% normalize spectrogram by firing rate
S_norm = S1 ./ repmat(R1(:,1),[1 size(S1,2)]);

% plot spectrogram
subplot(2,2,4);
plot_matrix(S_norm,t,f);
% set(gca,'XTickLabel',0:0.5:2.5);
% caxis([-5 8]);
colormap jet;
colorbar off;