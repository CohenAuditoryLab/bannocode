clear all;

% add path for Chronux
addpath(genpath('C:\Users\Cohen\Documents\MATLAB\chronux_2_12\chronux_2_12'));

% specify data directory
SPIKE_DIR = 'G:\Domo\SPIKE';
LFP_DIR = 'G:\Domo\LFP';

% set variables
rec_date = '20180727';
cl = 83; %73
ch = []; % use cluster channel if empty...
alpha = 0.01; % for confidence interval (0.05 for 95% CI)
movingwin = [0.5 0.05]; % sliding window for coherogram

% set parameter for spectrum analysis (Chronux format)
params.Fs = 1000; %param.SF;
params.fpass = [0 100];
params.tapers = [5 9]; %[3 5];
params.pad = 1; % default is 0
params.trialave = 1;
params.err = [1 alpha]; %[2 alpha];
% params.err = 0;

% load data
fName_spike = strcat(rec_date,'_activeCh');
fName_lfp = strcat(rec_date,'_ABBA_LFP');
load(fullfile( SPIKE_DIR, rec_date, fName_spike));
load(fullfile( LFP_DIR, fName_lfp));
iBehav = trialInfo.behav_ind; % index for behavioral outcome
list_cluster = clInfo.all_cluster; % list of cluster
list_channel = clInfo.channel;

% choose spike data to analyze...
idx = 1:length(list_cluster); % index to choose unit...
idx = idx(list_cluster==cl);
raster_cl = Raster(iBehav==0,:,idx); % choose responding unit
raster_cl = raster_cl'; % data must be samples x trials

% choose LFP data to analyze...
if isempty(ch)
    ch = list_channel(idx); % choose the channel where the spikes coming from...
end
lfp_ch = squeeze(LFP(ch,:,iBehav==0)); % choose channel 10 for test
lfp_ch = lfp_ch * 10^6; % convert unit from V to mV
% resample lfp at 1000 Hz
[y,tt] = resample(lfp_ch,t/1000,1000,'spline');
% overwrite lfp
lfp_ch = y;
t = tt*1000;

% shuffle trial...
nTrial = size(raster_cl,2);
k = randsample(nTrial,nTrial);
raster_sh = raster_cl(:,k);

% compute coherence
% data_sp(end,:) = [];
% [C,phi,S12,S1,S2,f] = coherencycpb(data_lfp,data_sp,params);
[C,phi,S12,S1,S2,f] = coherencycpb(lfp_ch,raster_cl,params);
[C_sh,phi_sh,S12,S1,S2,f] = coherencycpb(lfp_ch,raster_sh,params);
% [C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr] = coherencycpb(lfp_ch,raster_cl,params); % w/ conf interval

% plot coherence
figure;
plot_vector(C,f,'n'); % should not take log for coherence
set(gca,'XLim',params.fpass);
title('spike-LFP coherence');

% compute coherogram
% [C,phi,S12,S1,S2,t,f] = cohgramcpb(lfp_ch,raster_cl,movingwin,params);
[C,phi,S12,S1,S2,t,f,zerosp,confC,phistd,Cerr] = cohgramcpb(lfp_ch,raster_cl,movingwin,params);
% get significant coherogram...
% C_sig = C; C_sig(C<confC) = NaN; % make non-significant pixels be zero
% phi_sig = phi; phi_sig(C<confC) = NaN;
C_lb = squeeze(Cerr(1,:,:));
C_sig = C; C_sig(C_lb<confC) = NaN; % use lower boundary to get significant pix
phi_sig = phi; phi_sig(C_lb<confC) = NaN;
U = cos(phi_sig);
V = sin(phi_sig);

% plot coherogram
figure;
plot_matrix(C,t,f,'n'); % should not take log for coherence
% pcolor(t,f,C'); shading('interp');
xlabel('time [sec]'); ylabel('frequency [Hz]');
set(gca,'XTickLabel',0:0.5:2.5);
title('spike-LFP coherogram');
% caxis([8 28]);
colormap jet

% plot phase
figure;
plot_matrix(phi_sig,t,f,'n'); % should not take log for coherence
% pcolor(t,f,C'); shading('interp');
xlabel('time [sec]'); ylabel('frequency [Hz]');
set(gca,'XTickLabel',0:0.5:2.5);
title('spike-LFP coherogram (phase)');
% caxis([8 28]);
% colormap jet

% phase distribution
edges = -pi:pi/12:pi;
p_up = phi_sig; p_up(:,f<50) = NaN;
p_down = phi_sig; p_down(:,f>=50) = NaN;
figure;
subplot(2,2,1);
polarhistogram(phi_sig,edges);
title('All');
subplot(2,2,3);
polarhistogram(p_down,edges);
title('below 50 Hz');
subplot(2,2,4);
polarhistogram(p_up,edges);
title('above 50 Hz');
