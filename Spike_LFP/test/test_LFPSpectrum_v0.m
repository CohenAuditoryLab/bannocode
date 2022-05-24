clear all;

% add path for Chronux
addpath(genpath('C:\Users\Cohen\Documents\MATLAB\chronux_2_12\chronux_2_12'));

% specify data directory
LFP_DIR = 'G:\Domo\LFP';

rec_date = '20180727';
fName_lfp = strcat(rec_date,'_ABBA_LFP');

% load data
load(fullfile( LFP_DIR, fName_lfp));
iBehav = index; % index for behavioral outcome

% choose LFP data to analyze...
ch = 10;
lfp_ch = squeeze(LFP(ch,:,iBehav==0)); % choose channel 10 for test
lfp_ch = lfp_ch * 10^6; % convert unit from V to mV

figure;
subplot(2,2,1);
plot(t,mean(lfp_ch,2));
set(gca,'xLim',[-500 2500]);
xlabel('time [ms]'); ylabel('voltage [uV]');
f_title = ['mean LFP (ch ' num2str(ch) ')'];
title(f_title);

% set parameter for spectrum analysis (Chronux format)
params.Fs = param.SF;
params.fpass = [0 50];
params.tapers = [3 5]; %[5 9];
params.pad = 1; % default is 0
params.trialave = 1;
params.err = 0;

% extract data from defined delay period
delay_times = [0.5 1.5]; % def delay period (between 0.5 to 1.5 sec)
data_lfp = extractdatac(lfp_ch,params.Fs,delay_times);

% compute spectrum
% [S,f] = mtspectrumc(data_lfp,params);
[S,f] = mtspectrumc(lfp_ch,params);

% plot spectrum
subplot(2,2,3);
plot_vector(S,f,'l');
set(gca,'XLim',params.fpass);
title('LFP spectrum');

% spectrogram
movingwin = [0.5 0.05];
[S1,t,f] = mtspecgramc(lfp_ch,movingwin,params);

% plot spectrogram
subplot(2,2,4);
plot_matrix(S1,t,f);
set(gca,'XTickLabel',0:0.5:2.5);
caxis([8 28]);
colormap jet