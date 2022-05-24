% test ft_connectivity with simulation data
% tutorial from: www.fieldtriptoolbox.org/tutorial/connectivity
% clear all

% set pass to fieldtrip
DATA_DIR    = 'G:\LFP';
TOOLBOX_DIR = 'C:\Users\Cohen\OneDrive\Documents\MATLAB';
addpath(fullfile(TOOLBOX_DIR,'fieldtrip'));
addpath(fullfile(TOOLBOX_DIR,'fieldtrip','plotting'));
% rmpath C:\Users\Cohen\OneDrive\Documents\MATLAB\fieldtrip\external\signal

% define data to analyze
Animal  = 'MrMiyagi'; %'MrCassius';
RecDate = '190904';
Epoch   = 'testToneOnset';

% load fieldtrip data formatted by FormatLFP_ft.m
% fName = strcat(Animal,'-',RecDate,'_LFP_',Epoch,'_ft');
fName = strcat(Animal,'-',RecDate,'_bdLFP_',Epoch,'_ft');
% load(fullfile(DATA_DIR,fName));
load(fName);

if strcmp(Epoch,'testToneOnset')
    t_length = 1.4;
elseif strcmp(Epoch,'stimOnset')
    t_length = 1.0;
elseif strcmp(Epoch,'preCueOnset')
    t_length = 0.7;
end

% select data
iSelect.choice = [];
iSelect.err = 'c';
iSelect.pretone = []; %N;
iSelect.pretoneLength = 3; %0;
iSelect.prior = 'X'; %'X';
iSelect.SNR = [];
params.choice = choice;
params.err = err;
params.pretone = pretone;
params.pretoneLength = pretoneLength;
params.prior = cell2char(prior);
params.SNR = SNR;

data_c = selectData(data,params,iSelect);

iSelect.err = 'w';
data_w = selectData(data,params,iSelect);

% % visualize simulation data
% cfg = [];
% cfg.viewmode = 'vertical';
% ft_databrowser(cfg, data);

% t_length = 1.0; %1.4; % trial length in sec
% non-parametric computation of the cross-spectral density matrix (slow)
cfg           = [];
cfg.method    = 'mtmfft';
cfg.taper     = 'dpss';
cfg.output    = 'fourier';
cfg.tapsmofrq = 4; %bandwidth of 8 Hz (+-4) smoothing...
% cfg.pad       = 'nextpow2';
cfg.foi       = 0:1/t_length:150; % trial length = 1.4 sec
% cfg.foi       = 0:100;
% freq          = ft_freqanalysis(cfg, data);
freq_c        = ft_freqanalysis(cfg, data_c);
freq_w        = ft_freqanalysis(cfg, data_w);

nTrial_c = numel(data_c.trial);
nTrial_w = numel(data_w.trial);
nTaper_c = size(freq_c.fourierspctrm,1) / nTrial_c; % number of tapers
nTaper_w = size(freq_w.fourierspctrm,1) / nTrial_w; % number of tapers
nCh = numel(data_c.label); % number of channel
nFreq = numel(freq_c.freq); % number of points in freq

TrialInfo.nTrial.c = nTrial_c;
TrialInfo.nTrial.w = nTrial_w;
TrialInfo.nTaper = nTaper_c;


% compute coherence
cfg            = [];
cfg.method     = 'coh';
cfg.channelcmb = {'*AC*','*PFC*'};
coh_c         = ft_connectivityanalysis(cfg, freq_c);
coh_w         = ft_connectivityanalysis(cfg, freq_w);
% cohm       = ft_connectivityanalysis(cfg, mfreq);

cfg.channelcmb = {'*PFC*','*AC*'};
coh2_c = ft_connectivityanalysis(cfg, freq_c);
coh2_w = ft_connectivityanalysis(cfg, freq_w);


% time frequency analysis
cfg           = [];
cfg.method    = 'mtmconvol';
cfg.output    = 'powandcsd'; %'fourier';
% cfg.tapsmofrq = 2/0.7; %5
cfg.foi       = 1:1/(t_length/2):100;
cfg.taper     = 'hanning'; %'dpss';
cfg.channelcmb    = {'*AC*','*PFC*'}; % specify channel combination here!
cfg.t_ftimwin = ones(1,length(cfg.foi)).*0.5;
cfg.toi       = -0.5:0.05:0.5;
% tfreq         = ft_freqanalysis(cfg, data);
tfreq_c       = ft_freqanalysis(cfg, data_c);
tfreq_w       = ft_freqanalysis(cfg, data_w);

cfg.channelcmb = {'*PFC*','*AC*'};
tfreq2_c = ft_freqanalysis(cfg, data_c);
tfreq2_w = ft_freqanalysis(cfg, data_w);

% get coherogram
cfg            = [];
cfg.method     = 'coh';
tcoh_c = ft_connectivityanalysis(cfg, tfreq_c);
tcoh_w = ft_connectivityanalysis(cfg, tfreq_w);
tcoh2_c = ft_connectivityanalysis(cfg, tfreq2_c);
tcoh2_w = ft_connectivityanalysis(cfg, tfreq2_w);

% save data... (for test)
% save_file_name = 'coherence_noPreTone';
save_file_name = 'coherence_Both';
% save('testCoherence.mat','coh_c','coh2_c','coh_w','coh2_w','freq_c','freq_w','iSelect','TrialInfo');
save(save_file_name,'coh_c','coh2_c','coh_w','coh2_w', ...
                    'tcoh_c','tcoh2_c','tcoh_w','tcoh2_w', ...
                    'tfreq_c','tfreq_w','iSelect','TrialInfo');

clc;
disp('Coherence computed successfully!');



% % display result
% cfg           = [];
% cfg.parameter = 'cohspctrm';
% cfg.zlim      = [0 1];
% % ft_connectivityplot(cfg, coh, cohm);
% ft_connectivityplot(cfg, coh);
% 
% % compute Granger causality
% cfg        = [];
% cfg.method = 'granger';
% granger    = ft_connectivityanalysis(cfg,freq);
% % tgranger    = ft_connectivityanalysis(cfg,tfreq);
% 
% 
% % display result
% cfg           = [];
% cfg.parameter = 'grangerspctrm';
% cfg.zlim      = [0 0.5];
% ft_connectivityplot(cfg, granger);