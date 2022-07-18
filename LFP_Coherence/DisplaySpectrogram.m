DATA_DIR = 'G:\LFP\TimeFrequency'; % path for coherence file

SessionName = 'MrCassius-190421_pad'; %'MrCassius-190421'; %'MrMiyagi-190904';
Epoch       = 'preCueOnset'; %either 'testToneOnset', 'preCueOnset', or 'moveOnset';
Condition   = 'Both';
eID_ac      = 'D2'; % electrode ID in 1st column (usually AC electrode)
eID_pfc     = 'D1'; % electrode ID in 2nd column (usually PFC electrode)

% load data
fName  = strcat('TimeFrequency_',Epoch,'_',Condition);
fName2 = strcat('TimeFrequency_baseline_',Condition);
load(fullfile(DATA_DIR,SessionName,fName));
load(fullfile(DATA_DIR,SessionName,fName2));

% z-score spectrogram
zPow_c = zscore_spectrogram(tfreq_c,tfreq_baseline);
zPow_w = zscore_spectrogram(tfreq_w,tfreq_baseline);
tfreq_c.zpowspctrm = zPow_c; % add zscore 
tfreq_w.zpowspctrm = zPow_w; % add zscore

% plot spectrogram
plot_spectrogram(tfreq_c,eID_ac);
% plot_Spectrogram(tfreq_w,eID_ac);
plot_spectrogram(tfreq_c,eID_pfc);
% plot_Spectrogram(tfreq_w,eID_pfc);


% % difference (correct - wrong)
% tfreq_diff = tfreq_c;
% tfreq_diff.powspctrm  = tfreq_c.powspctrm - tfreq_w.powspctrm;
% tfreq_diff.zpowspctrm = tfreq_c.zpowspctrm - tfreq_w.zpowspctrm;
% tfreq_diff.crsspctrm  = tfreq_c.crsspctrm - tfreq_w.crsspctrm;
% plot_Spectrogram(tfreq_diff,eID_ac);


