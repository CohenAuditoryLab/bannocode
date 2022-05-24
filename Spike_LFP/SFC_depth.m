% calculate spike-field coherence with shift predictor
% plot SFC along the depth (from channel 1 to 16)
% cf. Takeda et al., 2015, 2018; Kohn and Smith 2005

clear all;

% add path for Chronux
addpath(genpath('/home/taku/Documents/MATLAB/chronux_2_12'));

% specify data directory
DATA_DIR = '/home/taku/Documents/Data';
SAVE_DIR = '/home/taku/Documents/Results/SpikeFieldCoherence';
sessionID = 'MrCassius-190921';
alignment = 'stimOnset';
cw = 'W'; % correct ('C') or wrong ('W')

% choose LFP
electrodeID_lfp = 'D2_PFC';
% ch = 14; % channel ID for LFP

% choose Spike
electrodeID_spk = 'D4_AC';
cl = 197; % cluster ID for spike

% set variables
alpha = 0.01; % for confidence interval (0.05 for 95% CI)
movingwin = [0.2 0.02]; %[0.5 0.05]; % sliding window for coherogram

% set parameter for spectrum analysis (Chronux format)
params.Fs = 1000; %param.SF;
params.fpass = [0 100];
params.tapers = [5 9]; %[3 5];
params.pad = 1; % default is 0
params.trialave = 1;
params.err = [1 alpha]; % [1 p] - Theoretical error bars; [2 p] - Jackknife error bars
% params.err = 0;

% load data
fName_lfp = strcat('LFP_',electrodeID_lfp,'_',alignment);
fName_spike = strcat('Spike_',electrodeID_spk,'_',alignment);
% LFP
load(fullfile( DATA_DIR, sessionID, fName_lfp));
t_lfp = t;
% Spike
load(fullfile( DATA_DIR, sessionID, fName_spike));
t_raster = t;
iBehav = err; % index for behavioral outcome
list_cluster = unit_id; % list of cluster
list_channel = ch_id;

% choose spike data to analyze...
idx = 1:length(list_cluster); % index to choose unit...
idx = idx(list_cluster==cl);
raster_cl = Spikes(:,iBehav==cw,idx); % choose responding unit


for ch=14
% choose LFP data to analyze...
% if isempty(ch)
%     ch = list_channel(idx); % choose the channel where the spikes coming from...
% end
clear lfp_ch lfp_sh
lfp_ch = squeeze(LFP(:,iBehav==cw,ch)); % choose channel 10 for test
lfp_ch = lfp_ch * 10^6; % convert unit from V to uV
% resample lfp at 1000 Hz
[y,tt] = resample(lfp_ch,t_lfp/1000,1000,'spline');
% overwrite lfp
lfp_ch = y;
% t_lfp = tt*1000;

% get trial shifted LFP and Spikes
lfp_sh = lfp_ch(:,2:end);
raster_sh = raster_cl(:,1:end-1);

% compute coherence
[C,phi,S12,S1,S2,f] = coherencycpb(lfp_ch,raster_cl,params);
% [C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr] = coherencycpb(lfp_ch,raster_cl,params); % w/ conf interval

% compute coherogram
[Cmat,phimat,S12,S1,S2,tt,ff] = cohgramcpb(lfp_ch,raster_cl,movingwin,params);
% % when params.err = [2 p], slow...
% [C,phi,S12,S1,S2,t,f,zerosp,confC,phistd,Cerr] = cohgramcpb(lfp_ch,raster_cl,movingwin,params);
% % get significant coherogram...
% % C_sig = C; C_sig(C<confC) = NaN; % make non-significant pixels be zero
% % phi_sig = phi; phi_sig(C<confC) = NaN;
% C_lb = squeeze(Cerr(1,:,:));
% C_sig = C; C_sig(C_lb<confC) = NaN; % use lower boundary to get significant pix
% phi_sig = phi; phi_sig(C_lb<confC) = NaN;
% U = cos(phi_sig);
% V = sin(phi_sig);

% trial shift predictor
% compute coherence (shuffled trial)
[ C_sh, phi_sh ] = coherencycpb(lfp_sh,raster_sh,params);
% compute coherogram (shuffled trial)
[ Cmat_sh, phimat_sh ] = cohgramcpb(lfp_sh,raster_sh,movingwin,params);

    
% plot coherence
figure('Position',[50 50 500 700]);
subplot(3,1,1);
plot_vector(C_sh,f,'n',[],':k'); hold on;
plot_vector(C,f,'n',[],'r',1.5); % should not take log for coherence
set(gca,'XLim',params.fpass);
xlabel('frequency [Hz]'); ylabel('coherence');
title(['channel ' num2str(ch)]);
box off;


% plot coherogram
subplot(3,1,2);
plot_matrix(Cmat,tt,ff,'n'); % should not take log for coherence
% pcolor(t,f,C'); shading('interp');
xlabel('time [sec]'); ylabel('frequency [Hz]');
set(gca,'XTick',0.1:0.1:0.9,'XTickLabel',0:0.1:0.8);
title('spike-field coherogram');
% caxis([8 28]);
colormap jet

% plot shift-predictor-subtracted coherogram (shuffled trial)
subplot(3,1,3);
plot_matrix(Cmat - Cmat_sh,tt,ff,'n'); % should not take log for coherence
% pcolor(t,f,C'); shading('interp');
xlabel('time [sec]'); ylabel('frequency [Hz]');
set(gca,'XTick',0.1:0.1:0.9,'XTickLabel',0:0.1:0.8);
title('shift-predictor-subtracted SFC');
% caxis([8 28]);
colormap jet

% % works only when params.err = [2 p]...
% % plot phase
% figure;
% plot_matrix(phi_sig,t,f,'n'); % should not take log for coherence
% % pcolor(t,f,C'); shading('interp');
% xlabel('time [sec]'); ylabel('frequency [Hz]');
% % set(gca,'XTickLabel',0:0.5:2.5);
% title('spike-LFP coherogram (phase)');
% % caxis([8 28]);
% % colormap jet
% 
% % phase distribution
% edges = -pi:pi/12:pi;
% p_up = phi_sig; p_up(:,f<50) = NaN;
% p_down = phi_sig; p_down(:,f>=50) = NaN;
% figure;
% subplot(2,2,1);
% polarhistogram(phi_sig,edges);
% title('All');
% subplot(2,2,3);
% polarhistogram(p_down,edges);
% title('below 50 Hz');
% subplot(2,2,4);
% polarhistogram(p_up,edges);
% title('above 50 Hz');
end