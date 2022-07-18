% code modifed from GetCoherence3.m
% obtain frequency spectrum of LFP (freq, coh, and granger) from
% bipolar-derivated LFP

isSave = 1;
% set pass to fieldtrip
DATA_DIR    = 'G:\LFP\FieldTrip';
SAVE_DIR    = 'G:\LFP\Frequency'; % save file directory
TOOLBOX_DIR = 'C:\Users\Cohen\OneDrive\Documents\MATLAB';
addpath(fullfile(TOOLBOX_DIR,'fieldtrip'));
addpath(fullfile(TOOLBOX_DIR,'fieldtrip','plotting'));
% rmpath C:\Users\Cohen\OneDrive\Documents\MATLAB\fieldtrip\external\signal

% define data to analyze
Animal    = 'MrCassius'; %'MrMiyagi'; 
RecDate   = '190421'; %'190922'; %'190904';
Epoch     = 'testToneOnset'; %'moveOnset'; 'preCueOnset';
Condition = 'Both'; % stimulus condition

% load fieldtrip data formatted by FormatLFP_ft_v2.m
% fName = strcat(Animal,'-',RecDate,'_bdLFP_',Epoch,'_ft'); % bipolar derived data
fName = strcat(Animal,'-',RecDate,'_bipolarLFP_',Epoch); % bipolar derived data
load(fullfile(DATA_DIR,fName));
% load(fName);

if strcmp(Epoch,'testToneOnset')
    t_length = 1.6; %1.4;
%     t_win = 0.25; % 250 ms 
%     t_slidingwin = -0.75:0.01:0.55; % 10-ms sliding window
elseif strcmp(Epoch,'preCueOnset')
    t_length = 1.0;
%     t_win = 0.20; % 200 ms
%     t_slidingwin = 0.00:0.01:0.80; % 10-ms sliding window
elseif strcmp(Epoch,'moveOnset')
    t_length = 1.0;
%     t_win = 0.20; % 200 ms
%     t_slidingwin = -0.40:0.01:0.40; % 10-ms sliding window
end

% set parameters
params.choice = choice;
params.err = err;
params.pretone = pretone;
params.pretoneLength = pretoneLength;
params.prior = cell2char(prior);
params.SNR = SNR;

% select data
iSelect = setStimulusCondition(Condition);
% choose correct trials
iSelect.err = 'c'; 
data_c = selectData(data,params,iSelect);
% choose wrong trials
iSelect.err = 'w'; 
data_w = selectData(data,params,iSelect);


% non-parametric computation of the cross-spectral density matrix (slow)
cfg           = [];
cfg.method    = 'mtmfft';
cfg.taper     = 'dpss';
cfg.output    = 'fourier'; %'powandcsd';
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


% compute Granger causality
cfg            = [];
cfg.method     = 'granger';
cfg.channelcmb = {'*AC*','*PFC*'};
granger_c      = ft_connectivityanalysis(cfg, freq_c);
granger_w      = ft_connectivityanalysis(cfg, freq_w);

% % time frequency analysis
% cfg           = [];
% cfg.method    = 'mtmconvol';
% cfg.output    = 'powandcsd'; %'fourier';
% % cfg.tapsmofrq = 2/0.7; %5
% cfg.foi       = 1:1/(t_length/2):100;
% cfg.taper     = 'hanning'; %'dpss';
% cfg.channelcmb    = {'*AC*','*PFC*'}; % specify channel combination here!
% % cfg.t_ftimwin = ones(1,length(cfg.foi)).*0.5; % 500-ms sliding window
% cfg.t_ftimwin = ones(1,length(cfg.foi)) .* t_win; % 250-ms sliding window
% cfg.toi       = t_slidingwin; %-0.7:0.01:0.5; % with 10-ms step


% save data...
if isSave==1
    disp('saving...')
%     save_file_name = 'coherence_Both';
    subdir = strcat(Animal,'-',RecDate);
    save_file_name = strcat('Frequency_',Epoch,'_',Condition);
%     save(fullfile(SAVE_DIR,save_file_name),'coh_c','coh_w','freq_c','freq_w',...
%         'tcoh_c','tcoh_w','tfreq_c','tfreq_w','granger_c','granger_w', ...
%         'iSelect','TrialInfo');
    if ~isfolder(fullfile(SAVE_DIR,subdir))
        mkdir(SAVE_DIR,subdir);
    end
    save(fullfile(SAVE_DIR,subdir,save_file_name), ...
        'fd_c','fd_w', ...
        'coh_c','coh_w',...
        'granger_c','granger_w', ...
        'iSelect','TrialInfo');
    
    clc;
    disp('Coherence computed successfully!');
end





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