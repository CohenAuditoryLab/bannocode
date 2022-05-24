clear all;

% add path for Chronux
addpath(genpath('C:\Users\Cohen\Documents\MATLAB\chronux_2_12\chronux_2_12'));

% specify data directory
DATA_DIR = 'D:\Spike_LFP';
sessionID = 'MrCassius-190917';
electrodeID = 'D1_PFC';
alignment = 'stimOnset';

% set variables
period_baseline = [-100 0]; % [2000 2500];
period_stimulus = [0 900];
alpha = 0.01; % value for confidence interval (0.05 for 95% CI)
ch = 9;

% set parameter for spectrum analysis (Chronux format)
% params.Fs = param.SF;
params.fpass = [0 50];
params.tapers = [3 5]; %[5 9];
params.pad = 1; % default is 0
params.trialave = 1;
params.err = [1 alpha]; % [1 p] - Theoretical error bars; [2 p] - Jackknife error bars
% params.err = 0;

% load data
fName_lfp = strcat('LFP_',electrodeID,'_',alignment);
load(fullfile( DATA_DIR, sessionID, fName_lfp));
iBehav = err; % index for behavioral outcome

% choose LFP data to analyze...
lfp_ch = squeeze(LFP(:,iBehav=='C',ch)); % choose channel 10 for test
lfp_ch = lfp_ch * 10^6; % convert unit from V to uV

% plot LFP
figure;
subplot(2,2,1);
plot(t,mean(lfp_ch,2));
set(gca,'xLim',[-100 900]);
xlabel('time [ms]'); ylabel('voltage [uV]');
f_title = ['mean LFP (ch ' num2str(ch) ')'];
title(f_title);

% get lfp from baseline and stimulus period
lfp_base = lfp_ch( t>=period_baseline(1) & t<period_baseline(2) , : );
lfp_stim = lfp_ch( t>=period_stimulus(1) & t<period_stimulus(2) , : );

% compute spectrum
params.Fs = info.sf;
% [S_base,f_base,Serr_base] = mtspectrumc(lfp_base,params);
[S_base,f_base] = mtspectrumc(lfp_base,params); % CI not needed for baseline
[S_stim,f_stim,Serr_stim] = mtspectrumc(lfp_stim,params);
% interpolate baseline data
S_base_interp = interp(S_base,8); S_base_interp = S_base_interp(1:end-1);
for i=1:2
%     Serr_base_temp = interp(Serr_base(i,:),4);
%     Serr_base_interp(i,:) = Serr_base_temp(1:end-2);
    Serr_base_interp(i,:) = S_base_interp; % use for baseline correction...
end

% plot spectrum
subplot(2,2,2);
plot_vector(S_base_interp,f_stim,'l',[],':k'); hold on;
plot_vector(S_stim,f_stim,'l',Serr_stim,'r');
set(gca,'XLim',params.fpass);
title('LFP spectrum');
legend({'baseline','stimulus'});

subplot(2,2,3);
plot_vector(S_stim./S_base_interp,f_stim,'l',Serr_stim./Serr_base_interp,'r'); hold on;
plot(params.fpass,[0 0],'k','LineWidth',0.5);
set(gca,'XLim',params.fpass);
title('LFP spectrum (baseline corrected)');

% spectrogram
% movingwin = [0.5 0.05];
movingwin = [0.2 0.02];
[S1,t,f] = mtspecgramc(lfp_ch,movingwin,params);

% plot spectrogram
subplot(2,2,4);
plot_matrix(S1,t,f);
% set(gca,'XTickLabel',0:0.5:2.5);
caxis([4 14]); %caxis([8 28]);
colormap jet;
colorbar off;