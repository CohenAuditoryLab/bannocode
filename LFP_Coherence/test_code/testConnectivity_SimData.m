% test ft_connectivity with simulation data
% tutorial from: www.fieldtriptoolbox.org/tutorial/connectivity
clear all

% set pass to fieldtrip
toolbox_dir = 'C:\Users\Cohen\OneDrive\Documents\MATLAB';
addpath(fullfile(toolbox_dir,'fieldtrip'));
addpath(fullfile(toolbox_dir,'fieldtrip','plotting'));

% start with the same random numbers to make the figure reproducible...
rng default
rng(50)

% set configuration
cfg             = []; % initialization
cfg.ntrials     = 500;
cfg.triallength = 1;
cfg.fsample     = 200;
cfg.nsignal     = 3;
cfg.method      = 'ar'; % autoregression

cfg.params(:,:,1) = [ 0.8    0    0 ;
                        0  0.9  0.5 ;
                      0.4    0  0.5];
                  
cfg.params(:,:,2) = [-0.5    0    0 ;
                        0 -0.8    0 ;
                        0    0 -0.2];
                    
cfg.noisecov      = [ 0.3    0    0 ;
                        0    1    0 ;
                        0    0  0.2];
                    
% generate simulation data
data              = ft_connectivitysimulation(cfg);

% % show simulation data
% figure;
% plot(data.time{1},data.trial{1});
% legend(data.label);
% xlabel('time (s)');

% compute autoregressive coefficients (with ft_mvaranalysis)
cfg         = [];
cfg.order   = 5;
cfg.toolbox = 'bsmart';
mdata       = ft_mvaranalysis(cfg, data);

% compute spectral transfer function
cfg        = [];
cfg.method = 'mvar';
mfreq      = ft_freqanalysis(cfg, mdata);

% non-parametric computation of the cross-spectral density matrix
cfg           = [];
cfg.method    = 'mtmfft';
cfg.taper     = 'dpss';
cfg.output    = 'fourier';
cfg.tapsmofrq = 5; %2;
cfg.foi       = 0:100;
freq          = ft_freqanalysis(cfg, data);

% compute coherence
cfg        = [];
cfg.method = 'coh';
coh        = ft_connectivityanalysis(cfg, freq);
cohm       = ft_connectivityanalysis(cfg, mfreq);

% display result
cfg           = [];
cfg.parameter = 'cohspctrm';
cfg.zlim      = [0 1];
ft_connectivityplot(cfg, coh, cohm);

% compute Granger causality
cfg        = [];
cfg.method = 'granger';
granger    = ft_connectivityanalysis(cfg,freq);
mgranger   = ft_connectivityanalysis(cfg,mfreq);

% display result
cfg           = [];
cfg.parameter = 'grangerspctrm';
cfg.zlim      = [0 1];
ft_connectivityplot(cfg, granger, mgranger);