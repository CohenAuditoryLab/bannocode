% test ft_connectivity with simulation data
% tutorial from: www.fieldtriptoolbox.org/tutorial/connectivity
% clear all

% set pass to fieldtrip
toolbox_dir = 'C:\Users\Cohen\OneDrive\Documents\MATLAB';
addpath(fullfile(toolbox_dir,'fieldtrip'));
addpath(fullfile(toolbox_dir,'fieldtrip','plotting'));

AC  = load('LFP_D3_AC_testToneOnset_ft');
PFC = load('LFP_D2_PFC_testToneOnset_ft');

% add area id
AC.data_lfp.area = 'AC';
PFC.data_lfp.area = 'PFC';

% concatenate lfp data
data = catLFP(AC,PFC);

% get common variables
SNR = AC.SNR;
choice = AC.choice;
err = AC.err;
pretone = AC.pretone;
pretoneLength = AC.pretoneLength;
prior = AC.prior;
stim = AC.stim;
trial_id = AC.trial_id;
info = AC.info;


% % show simulation data
% cfg = [];
% cfg.viewmode = 'vertical';
% ft_databrowser(cfg, data);

% compute autoregressive coefficients (with ft_mvaranalysis)
cfg         = [];
cfg.order   = 10;
cfg.toolbox = 'bsmart';
mdata       = ft_mvaranalysis(cfg, data);

% compute spectral transfer function
cfg        = [];
cfg.method = 'mvar';
% cfg.foi    = 0:250;
cfg.foi    = 0:100;
mfreq      = ft_freqanalysis(cfg, mdata);

% data.cfg.ntrials = 3373;
% data.cfg.triallength = 1.4;
% data.cfg.fsample = 1000;
% data.cfg.nsignal = 40;

% non-parametric computation of the cross-spectral density matrix (slow)
cfg           = [];
cfg.method    = 'mtmfft';
cfg.taper     = 'dpss';
cfg.output    = 'fourier';
cfg.tapsmofrq = 5; %2
% cfg.pad       = 'nextpow2';
cfg.foi       = 0:1/1.4:250;
% cfg.foi       = 0:100;
freq          = ft_freqanalysis(cfg, data);

% time-frequency analysis
cfg           = [];
cfg.method    = 'mtmconvol';
cfg.output    = 'fourier'; %'pow';
% cfg.tapsmofrq = 2/0.7; %5
cfg.foi       = 1:1/0.7:100;
cfg.taper     = 'hanning'; %'dpss';
% cfg.output    = 'pow';
% cfg.pad       = 'nextpow2';
cfg.t_ftimwin = ones(1,length(cfg.foi)).*0.5;
cfg.toi       = -0.5:0.05:0.5;
tfreq          = ft_freqanalysis(cfg, data);

% compute coherence
cfg            = [];
cfg.method     = 'coh';
cfg.channelcmb = {'AC*','PFC*'};
coh        = ft_connectivityanalysis(cfg, freq);
tcho       = ft_connectivityanalysis(cfg, tfreq);
% cohm       = ft_connectivityanalysis(cfg, mfreq);

% display result
cfg           = [];
cfg.parameter = 'cohspctrm';
cfg.zlim      = [0 1];
% ft_connectivityplot(cfg, coh, cohm);
ft_connectivityplot(cfg, coh);

% compute Granger causality
cfg        = [];
cfg.method = 'granger';
cfg.channelcmb = {'AC*','PFC*'};
granger    = ft_connectivityanalysis(cfg,freq);
% granger    = ft_connectivityanalysis(cfg,mfreq);


% display result
cfg           = [];
cfg.parameter = 'grangerspctrm';
cfg.zlim      = [0 0.5];
ft_connectivityplot(cfg, granger);