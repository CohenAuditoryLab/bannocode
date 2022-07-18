% test ft_connectivity with simulation data
% tutorial from: www.fieldtriptoolbox.org/tutorial/connectivity
% clear all

isSave = 0;
% set pass to fieldtrip
DATA_DIR    = 'G:\LFP\FieldTrip';
SAVE_DIR    = 'G:\LFP\TimeFrequency'; % save file directory
TOOLBOX_DIR = 'C:\Users\Cohen\OneDrive\Documents\MATLAB';
addpath(fullfile(TOOLBOX_DIR,'fieldtrip'));
addpath(fullfile(TOOLBOX_DIR,'fieldtrip','plotting'));
% rmpath C:\Users\Cohen\OneDrive\Documents\MATLAB\fieldtrip\external\signal

% define data to analyze
Animal    = 'MrCassius'; %'MrMiyagi'; 
RecDate   = '190421'; %'190904';
Epoch     = 'testToneOnset'; % should use testToneOnset!!
Condition = 'Both'; % stimulus condition

% load fieldtrip data formatted by FormatLFP_ft_v2.m
% fName = strcat(Animal,'-',RecDate,'_bdLFP_',Epoch,'_ft'); % bipolar derived data
fName = strcat(Animal,'-',RecDate,'_bipolarLFP_',Epoch); % bipolar derived data
load(fullfile(DATA_DIR,fName));
% load(fName);

t_length = 2;% make the trial length 2 sec with zero-padding
if strcmp(Epoch,'testToneOnset')
%     t_length = 1.6; %1.4;
    t_win = 0.20; % 200 ms
    t_slidingwin = -0.80:0.01:-0.65; % 10-ms sliding window (baseline period)
    
%     % old setting
%     t_win = 0.25; % 250 ms 
%     t_slidingwin = -0.75:0.01:-0.65; % 10-ms sliding window (baseline period)
elseif strcmp(Epoch,'preCueOnset')
%     t_length = 1.0;
    t_win = 0.20; % 200 ms
%     t_slidingwin = 0.00:0.01:0.80; % 10-ms sliding window
elseif strcmp(Epoch,'moveOnset')
%     t_length = 1.0;
    t_win = 0.20; % 200 ms
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
iSelect.err = 'valid'; % choose both correct and wrong trial
data_baseline = selectData(data,params,iSelect);
% correct trials
% iSelect.err = 'c'; % choose correct trials
% data_c = selectData(data,params,iSelect);
% % wrong trials
% iSelect.err = 'w'; % choose wrong trials
% data_w = selectData(data,params,iSelect);


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
cfg.keeptrials = 'yes';
cfg.pad = t_length;

tfreq_baseline = ft_freqanalysis(cfg, data_baseline);
% tfreq_c       = ft_freqanalysis(cfg, data_c);
% tfreq_w       = ft_freqanalysis(cfg, data_w);

pow = tfreq_baseline.powspctrm; % power spectrum
crs = tfreq_baseline.crsspctrm; % cross spectrum

% collapse time
pow = mean(pow,4);
crs = mean(crs,4);

% mean and standard deviation across trials
mean_pow = squeeze(mean(pow,1));
std_pow  = squeeze(std(pow,[],1));
mean_crs = squeeze(mean(crs,1));
std_crs  = squeeze(std(crs,[],1));

% reorganize data
tfreq_baseline.powspctrm_mean = mean_pow;
tfreq_baseline.powspctrm_std  = std_pow;
tfreq_baseline.crsspctrm_mean = mean_crs;
tfreq_baseline.crsspctrm_std  = std_crs;
tfreq_baseline = rmfield(tfreq_baseline,'powspctrm');
tfreq_baseline = rmfield(tfreq_baseline,'crsspctrm');
tfreq_baseline = rmfield(tfreq_baseline,'cumtapcnt');
tfreq_baseline.time      = tfreq_baseline.time([1 end]);


% % get coherogram
% cfg            = [];
% cfg.method     = 'coh';
% tcoh_c = ft_connectivityanalysis(cfg, tfreq_c);
% tcoh_w = ft_connectivityanalysis(cfg, tfreq_w);


% save data...
if isSave==1
    disp('saving...')
%     save_file_name = 'coherence_Both';
    subdir = strcat(Animal,'-',RecDate);
    save_file_name = strcat('TimeFrequency_baseline','_',Condition,'_pad');
    if ~isfolder(fullfile(SAVE_DIR,subdir))
        mkdir(SAVE_DIR,subdir);
    end
    save(fullfile(SAVE_DIR,subdir,save_file_name), ...
        'tfreq_baseline',...
        'iSelect');
   
    clc;
    disp('Data saved successfully!');
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