% set pass to fieldtrip
toolbox_dir = 'C:\Users\Cohen\OneDrive\Documents\MATLAB';
addpath(fullfile(toolbox_dir,'fieldtrip'));
addpath(fullfile(toolbox_dir,'fieldtrip','plotting'));

% data file
electrode = 'D3_AC';
epoch = 'testToneOnset';
data_file_name = strcat('LFP_',electrode,'_',epoch,'_ft');
% load data
load(data_file_name);

% % obtain hit trials
% lfp_hit = LFP(:,:,index==0); % LFP
% df_hit = stDiff(index==0); % delta frequency
% tt_hit = targetTime(index==0); % target time
% sinfo_hit = sampleinfo(index==0,:); % sample info
% 
% % 24 semitone difference trials
% lfp_hit_24df = lfp_hit(:,:,df_hit==24);
% tt_hit_24df = tt_hit(df_hit==24);
% sinfo_hit_24df = sinfo_hit(df_hit==24,:);
% 
% lfp_hit_24df = lfp_hit_24df * 10e3; % convert unit to mV
% 
% % plot mean LFP
% target = 900; % set target time
% y_pos = 0;
% figure; hold on
% for i=1:16
%     plot(t,mean(lfp_hit_24df(i,:,tt_hit_24df==target),3)+y_pos);
%     y_pos = y_pos - 1;
% end
% set(gca,'YTick',-15:0,'YTickLabel',16:-1:1);
% xlabel('Time [ms]'); ylabel('Channel');
% 
% % convert data structure for fieldtrip
% nTrial = size(lfp_hit_24df,3);
% for n=1:nTrial
%     trial{n} = lfp_hit_24df(:,:,n);
%     time{n} = t / 1000;
% end
% 
% label = cell(16,1);
% for i=1:16
%     if i<10
%         string = strcat('LFP0',num2str(i));
%     else
%         string = strcat('LFP',num2str(i));
%     end
%     label{i} = string;
% end
% hdr.Fs = param.SF;
% hdr.FirstTimeStamp = 0;
% hdr.TimeStampPerSample = 24;
% hdr.nSamples = param.nSamples;
% 
% data_lfp.hdr = hdr;
% data_lfp.label = label;
% data_lfp.time = time;
% data_lfp.trial = trial;
% data_lfp.fsample = param.SF;
% data_lfp.sampleinfo = sinfo_hit_24df;

cfg              = [];
cfg.output       = 'pow';
cfg.method       = 'mtmconvol'; %'wavelet';
cfg.taper        = 'hanning';
cfg.pad          = 'nextpow2';
% cfg.width        = 7; % for wavelet
cfg.foi          = 1:30; %2:2:30; % analysis 2 to 30 Hz in steps of 2 Hz
cfg.t_ftimwin    = 4./cfg.foi;
cfg.toi          = -0.6:0.020:0.6; % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)
cfg.trials       = find(err=='C'); % correct trials
TFRwave = ft_freqanalysis(cfg, data_lfp);

figure
cfg.channel = '*08'; % select channel for display
ft_singleplotTFR(cfg,TFRwave);