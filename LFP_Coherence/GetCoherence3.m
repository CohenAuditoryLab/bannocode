% test ft_connectivity with simulation data
% tutorial from: www.fieldtriptoolbox.org/tutorial/connectivity
% clear all

isSave = 1;
% set pass to fieldtrip
DATA_DIR    = 'G:\LFP\FieldTrip';
SAVE_DIR    = 'G:\LFP\Coherence'; % save file directory
TOOLBOX_DIR = 'C:\Users\Cohen\OneDrive\Documents\MATLAB';
addpath(fullfile(TOOLBOX_DIR,'fieldtrip'));
addpath(fullfile(TOOLBOX_DIR,'fieldtrip','plotting'));
% rmpath C:\Users\Cohen\OneDrive\Documents\MATLAB\fieldtrip\external\signal

% define data to analyze
Animal    = 'MrCassius'; %'MrMiyagi'; 
RecDate   = '190421'; %'190904';
Epoch     = 'preCueOnset'; %'preCueOnset';
Condition = 'Both'; % stimulus condition

% load fieldtrip data formatted by FormatLFP_ft_v2.m
fName = strcat(Animal,'-',RecDate,'_bdLFP_',Epoch,'_ft'); % bipolar derived data
load(fullfile(DATA_DIR,fName));
% load(fName);

if strcmp(Epoch,'testToneOnset')
    t_length = 1.6; %1.4;
    t_win = 0.25; % 250 ms 
    t_slidingwin = -0.75:0.01:0.55; % 10-ms sliding window
elseif strcmp(Epoch,'preCueOnset')
    t_length = 1.0;
    t_win = 0.20; % 200 ms
    t_slidingwin = 0.00:0.01:0.80; % 10-ms sliding window
elseif strcmp(Epoch,'movingOnset')
    t_length = 1.0;
    t_win = 0.20; % 200 ms
    t_slidingwin = -0.40:0.01:0.40; % 10-ms sliding window
end

% set parameters
params.choice = choice;
params.err = err;
params.pretone = pretone;
params.pretoneLength = pretoneLength;
params.prior = cell2char(prior);
params.SNR = SNR;

% select data
% iSelect.choice = [];
% iSelect.pretone = []; %N;
% iSelect.pretoneLength = 3; %0;
% iSelect.prior = 'X'; %'X';
% iSelect.SNR = [];
iSelect = setStimulusCondition(Condition);

iSelect.err = 'c'; % choose correct trials
data_c = selectData(data,params,iSelect);

iSelect.err = 'w'; % choose wrong trials
data_w = selectData(data,params,iSelect);

% % visualize simulation data
% cfg = [];
% cfg.viewmode = 'vertical';
% ft_databrowser(cfg, data);

% non-parametric computation of the cross-spectral density matrix (slow)
cfg           = [];
cfg.method    = 'mtmfft';
cfg.taper     = 'dpss';
cfg.output    = 'fourier';
cfg.tapsmofrq = 4; %bandwidth of 8 Hz (+-4 Hz) smoothing...
% cfg.pad       = 'nextpow2';
cfg.foi       = 0:1/t_length:150; % trial length = 1.4 sec

freq_c        = ft_freqanalysis(cfg, data_c);
freq_w        = ft_freqanalysis(cfg, data_w);
fd_c          = ft_freqdescriptives(cfg,freq_c);
fd_w          = ft_freqdescriptives(cfg,freq_w);

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

% cfg.channelcmb = {'*PFC*','*AC*'};
% coh2_c = ft_connectivityanalysis(cfg, freq_c);
% coh2_w = ft_connectivityanalysis(cfg, freq_w);

% compute Granger causality
cfg            = [];
cfg.method     = 'granger';
cfg.channelcmb = {'*AC*','*PFC*'};
granger_c      = ft_connectivityanalysis(cfg, freq_c);
granger_w      = ft_connectivityanalysis(cfg, freq_w);

% time frequency analysis
cfg           = [];
cfg.method    = 'mtmconvol';
cfg.output    = 'powandcsd'; %'fourier';
% cfg.tapsmofrq = 2/0.7; %5
cfg.foi       = 1:1/(t_length/2):100;
cfg.taper     = 'hanning'; %'dpss';
cfg.channelcmb    = {'*AC*','*PFC*'}; % specify channel combination here!
% cfg.t_ftimwin = ones(1,length(cfg.foi)).*0.5; % 500-ms sliding window
cfg.t_ftimwin = ones(1,length(cfg.foi)) .* t_win; % 250-ms sliding window
cfg.toi       = t_slidingwin; %-0.7:0.01:0.5; % with 10-ms step

tfreq_c       = ft_freqanalysis(cfg, data_c);
tfreq_w       = ft_freqanalysis(cfg, data_w);

% cfg.channelcmb = {'*PFC*','*AC*'};
% tfreq2_c = ft_freqanalysis(cfg, data_c);
% tfreq2_w = ft_freqanalysis(cfg, data_w);

% get coherogram
cfg            = [];
cfg.method     = 'coh';
tcoh_c = ft_connectivityanalysis(cfg, tfreq_c);
tcoh_w = ft_connectivityanalysis(cfg, tfreq_w);
% tcoh2_c = ft_connectivityanalysis(cfg, tfreq2_c);
% tcoh2_w = ft_connectivityanalysis(cfg, tfreq2_w);

% save data...
if isSave==1
    disp('saving...')
%     save_file_name = 'coherence_Both';
    subdir = strcat(Animal,'-',RecDate);
    save_file_name = strcat('Coherence_',Epoch,'_',Condition);
%     save(fullfile(SAVE_DIR,save_file_name),'coh_c','coh_w','freq_c','freq_w',...
%         'tcoh_c','tcoh_w','tfreq_c','tfreq_w','granger_c','granger_w', ...
%         'iSelect','TrialInfo');
    if ~isfolder(fullfile(SAVE_DIR,subdir))
        mkdir(SAVE_DIR,subdir);
    end
    save(fullfile(SAVE_DIR,subdir,save_file_name), ...
        'fd_c','fd_w','coh_c','coh_w',...
        'tcoh_c','tcoh_w','granger_c','granger_w', ...
        'iSelect','TrialInfo');
end

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