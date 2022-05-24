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
iSelect.pretone = 'N';
iSelect.pretoneLength = 0;
iSelect.prior = [];
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
cfg.tapsmofrq = 4; %2
% cfg.pad       = 'nextpow2';
cfg.foi       = 0:1/t_length:150; % trial length = 1.4 sec
% cfg.foi       = 0:100;
% freq          = ft_freqanalysis(cfg, data);
freq_c        = ft_freqanalysis(cfg, data_c);
freq_w        = ft_freqanalysis(cfg, data_w);

% time-frequency analysis
cfg           = [];
cfg.method    = 'mtmconvol';
cfg.output    = 'powandcsd'; % 'fourier';
% cfg.tapsmofrq = 2/0.7; %5
cfg.foi       = 1:1/(t_length/2):100;
cfg.taper     = 'hanning'; %'dpss';
% cfg.output    = 'pow';
% cfg.pad       = 'nextpow2';
cfg.t_ftimwin = ones(1,length(cfg.foi)).*0.5;
cfg.toi       = -0.5:0.05:0.5;
cfg.channelcmb = {'*AC*','*PFC*'}; %{'D1_PFC*','D3_AC*'};
% tfreq         = ft_freqanalysis(cfg, data);
tfreq_c       = ft_freqanalysis(cfg, data_c);
tfreq_w       = ft_freqanalysis(cfg, data_w);

% compute coherence
cfg            = [];
cfg.method     = 'coh';
cfg.channelcmb = {'*AC*','*PFC*'};
coh_c         = ft_connectivityanalysis(cfg, freq_c);
% tcoh_c        = ft_connectivityanalysis(cfg, tfreq_c); % MEMORY OUT...
coh_w         = ft_connectivityanalysis(cfg, freq_w);
% tcoh_w        = ft_connectivityanalysis(cfg, tfreq_w); % MEMORY OUT...
% cohm       = ft_connectivityanalysis(cfg, mfreq);

cfg.channelcmb = {'*PFC*','*AC*'};
coh2_c = ft_connectivityanalysis(cfg, freq_c);
coh2_w = ft_connectivityanalysis(cfg, freq_w);

% plot coherence between areas...
nAveCh = 20; % number of averaging channel
C_c = coh_c.cohspctrm;
C_w = coh_w.cohspctrm;
N = size(C_c,1); % total combination of channels
for i=1:(N/nAveCh)
    i_start = nAveCh * (i-1) + 1;
    i_end   = nAveCh * i;
    aveC_c(i,:) = mean(C_c(i_start:i_end,:),1);
    aveC_w(i,:) = mean(C_w(i_start:i_end,:),1);
    chID{i} = coh_c.labelcmb(i_start,2);
end
ACD3_c = aveC_c(1:2:end,:);
ACD3_w = aveC_w(1:2:end,:);
ACD4_c = aveC_c(2:2:end,:);
ACD4_w = aveC_w(2:2:end,:);
chID_PFC = chID(1:2:end);

ACD3_PFCD1_c = ACD3_c(1:14,:);
ACD3_PFCD2_c = ACD3_c(15:28,:);
ACD4_PFCD1_c = ACD4_c(1:14,:);
ACD4_PFCD2_c = ACD4_c(15:28,:);

% display result
cfg           = [];
cfg.parameter = 'cohspctrm';
cfg.zlim      = [0 1];
% ft_connectivityplot(cfg, coh, cohm);
ft_connectivityplot(cfg, coh);

% compute Granger causality
cfg        = [];
cfg.method = 'granger';
granger    = ft_connectivityanalysis(cfg,freq);
% tgranger    = ft_connectivityanalysis(cfg,tfreq);


% display result
cfg           = [];
cfg.parameter = 'grangerspctrm';
cfg.zlim      = [0 0.5];
ft_connectivityplot(cfg, granger);