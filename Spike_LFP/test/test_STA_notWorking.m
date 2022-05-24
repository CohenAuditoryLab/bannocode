% add path for Chronux
addpath(genpath('C:\Users\Cohen\Documents\MATLAB\chronux_2_12\chronux_2_12'));

% specify data directory
SPIKE_DIR = 'G:\Domo\SPIKE';
LFP_DIR = 'G:\Domo\LFP';

rec_date = '20180727';
fName_spike = strcat(rec_date,'_activeCh');
fName_lfp = strcat(rec_date,'_ABBA_LFP');

% load data
load(fullfile( SPIKE_DIR, rec_date, fName_spike));
load(fullfile( LFP_DIR, fName_lfp));
iBehav = trialInfo.behav_ind; % index for behavioral outcome
clID = clInfo.all_cluster;

% choose spike data to analyze...
cl = 83; % 73;
iCluster = 1:length(clID);
iCluster = iCluster(clID==cl);
raster_cl = Raster(iBehav==0,:,iCluster); % choose responding unit
raster_cl = raster_cl'; % data must be samples x trials

% choose LFP data to analyze...
ch = 10;
lfp_ch = squeeze(LFP(ch,:,iBehav==0)); % choose channel 10 for test
lfp_ch = lfp_ch * 10^6; % convert unit from V to mV
% resample lfp at 1000 Hz
[y,tt] = resample(lfp_ch,t/1000,1000,'spline');
% overwrite lfp
lfp_ch = y;
t = tt*1000;

% set parameter for spectrum analysis (Chronux format)
params.Fs = 1000; %param.SF;
params.fpass = [0 100];
params.tapers = [5 9]; %[5 9];
params.pad = 1; % default is 0
params.trialave = 1;
params.err = 0;

% extract data from defined delay period
delay_times = [0.5 1.5]; % def delay period (between 0.5 to 1.5 sec)
data_sp = extractdatapb(raster_cl,params.Fs,delay_times);
data_lfp = extractdatac(lfp_ch,params.Fs,delay_times);

% compute coherence
% data_sp(end,:) = [];
% [C,phi,S12,S1,S2,f] = coherencycpb(data_lfp,data_sp,params);
[C,phi,S12,S1,S2,f] = coherencycpb(lfp_ch,raster_cl,params);

% plot coherence
figure;
plot_vector(C,f,'n'); % should not take log for coherence
set(gca,'XLim',params.fpass);
title('spike-LFP coherence');

% time-frequency coherence
movingwin = [0.5 0.05];
% [C,phi,S12,S1,S2,t,f] = cohgramcpb(lfp_ch,raster_cl,movingwin,params);
p = 0.01;
params.err = [2 p];
[C,phi,S12,S1,S2,t,f,zerosp,confC,phistd,Cerr] = cohgramcpb(lfp_ch,raster_cl,movingwin,params);
% get significant coherogram...
C_sig = C; C_sig(C<confC) = NaN; % make non-significant pixels be zero
phi_sig = phi; phi_sig(C<confC) = NaN;
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
