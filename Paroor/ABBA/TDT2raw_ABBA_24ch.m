clear all;
addpath(genpath('C:\TDT\TDTMatlabSDK'));
% set variables 
% date = '20180711';
nChannel = 24;
% list_files = { '20191009_ABBA_BehavData', '20200110_ABBA_BehavData', '20200114_ABBA_BehavData' };
% list_files = { '20210317_ABBA_BehavData' };
% list_files = {'20201127_ABBA_BehavData_tsFA'};
% list_RecDate = {'20210306','20210308','20210310','20210313','20210317','20210324','20210331','20210403'};
list_RecDate = {'20210208','20210210','20210213','20210220','20210222','20210224'};
% list_files = {'20190830_ABBA_BehavData','20190904_ABBA_BehavData','20190930_ABBA_BehavData','20191009_ABBA_BehavData','20191014_ABBA_BehavData',};
polarity_flip = 'n'; % should be 'n' for the data of 9/5/18, 9/7/18, 9/17/18 and data from Cassius

save_file_dir = 'G:\Cassius\RAW';

for ff=1:numel(list_RecDate)
%date = list_files{ff}(1:8);
date = list_RecDate{ff};
% load behavioral data obtained from obtainBehavABBA.m
% addpath(date);f
behav_file_dir = fullfile('D:\Cassius\04_ABBA',date);
behav_file_name = strcat(date,'_ABBA_BehavData_tsFA');
load(fullfile(behav_file_dir,behav_file_name));
Block = strcat('~',param.Data);
param.DataTimeRange = [-1.0 3.0];
DataTimeRange = param.DataTimeRange;
EpochTimeRange = param.EpochTimeRange;
% EpochTimeRange = [0 14];
nTrial = param.nValidTrials; % number of valid trials on TDT

% set global variables (should NOT change)
% TANK_FILE_DIR = 'D:\TDT\Synapse\Tanks\Domo-180702-112023';
% TANK_FILE_DIR = 'C:\TDT\Synapse\Tanks\Domo-180813-182551';
TANK_FILE_DIR = ['G:\Cassius\Tanks\Cassius-' date(3:end)];
STORE_NAME = 'Trl/';
EPOCH_START = EpochTimeRange(1); % Enter the start of epoch in seconds relative to stimulus onset
EPOCH_DURATION = diff(EpochTimeRange); % maximum length of trial epoch = 10 sec
% sf = param.SF; % sampling freq for stim, lever, rew
param.SF = 24414.0625; % overwrite sampling frequency for raw data
% t_ancillary = t;
t_ancillary = t_hand; % 5/14/21 modified 


% access Tank file
TT = actxcontrol('TTank.X');
invoke(TT,'ConnectServer','Local','Me');
invoke(TT,'SetGlobalV','WavesMemLimit',128e6);
e=invoke(TT,'OpenTank',TANK_FILE_DIR,'R');
e1=invoke(TT,'SelectBlock',Block);
if e1+e==2 %checks to see if specified tank and block found
    disp('processing tank file...');
else
    disp('fail to access the tank file');
end

% obtain raw data
nTime = floor(diff(DataTimeRange)*param.SF) + 1;
t = linspace(DataTimeRange(1),DataTimeRange(2),nTime);
t = t*1000; % conversion of the unit from second to milisecond
% RAW = NaN(nChannel,nTime,nTrial);
RAW = NaN(nTrial,nTime,nChannel);
maxN = 2000000;
for i=1:nChannel
    disp(['processing channel ' num2str(i)]);
    BLOCKPATH = fullfile(TANK_FILE_DIR,Block(2:end));
    data = SEV2mat(BLOCKPATH, 'CHANNEL',i);
    raw = data.RAW1.data;
%     N = TT.ReadEventsV(maxN,'RAW1',i,0,0,3600,'All');
%     if N == maxN
%         error('Number of spikes is overflow.');
%     end
%     a =TT.ParseEvV(0, N);
%     a = a(:);
% 
%     N = TT.ReadEventsV(maxN,'RAW1',i,0,3600,0,'All');
%     if N == maxN
%         error('Number of spikes is overflow.');
%     end
%     b =TT.ParseEvV(0, N);
%     b = b(:);
%     raw = [a;b];
    if polarity_flip=='y'
        disp('fixing the polarity inversion of PZ2 amplifier');
        raw = -raw; % polarity of the neural signal flipped!!
    end
    clear data
    
    for n=1:nTrial
        stim_on_time = StimOnTime(n);
        data_onset = round((stim_on_time + DataTimeRange(1)) * param.SF); % corresponding point
%         RAW(i,:,n) = raw(data_onset:data_onset+floor(diff(DataTimeRange)*param.SF)); % stim in trial
        RAW(n,:,i) = raw(data_onset:data_onset+floor(diff(DataTimeRange)*param.SF)); % stim in trial
    end
    clear raw
end

% save data
% param.Data = Block(2:end);
% param.DataTimeRange = DataTimeRange;
% param.EpochTimeRange = [EPOCH_START EPOCH_DURATION+EPOCH_START];
% param.SF = SF;
% param.ToneA = toneA;
% param.nValidTrials = nTrial;
param.nChannel = nChannel;

disp('saving the neural data...');
save_file_name = [param.Data(1:end-3) 'raw.mat'];
% save(fullfile(save_file_dir,save_file_name),'param','tranges', ...
%                     'stimOn','StimOnTime','leverRelease','LeverReleaseTime', ...
%                     'index','index_tsRT','targetTime','stDiff', ...
%                     'Stim','Lever1','Lever2','Rew','t_ancillary', ...
%                     'RAW','t','-v7.3');

% save(fullfile(save_file_dir,save_file_name),'param', ...
%                     'index','index_tsRT','targetTime','stDiff', ...
%                     'RAW','t','-v7.3');
save(fullfile(save_file_dir,save_file_name),'param', ...
                    'index','targetTime','stDiff', ...
                    'RAW','t','-v7.3');

clear RAW param tranges stimOn StimOnTime leverRelease LeverReleaseTime
close all
clc
end
disp('done!');

% % plot data for checking
% figure;
% trial = 12;
% plot(t,Rew(trial,:),'color',[.9 .8 .8]); hold on;
% plot(t,Lever(trial,:),'color',[.5 .5 .5]);
% plot(t,Stim1(trial,:) * 4,'k');
% box off;
% 
% pos = 22;
% for i=1:16
%     lfp_trial = LFP(:,:,trial);
%     plot(t,lfp_trial(i,:)*5000+pos);
%     pos = pos - 1;
% end
% tt = targetTime(trial);
% plot([tt tt+50],[0 0],'r','LineWidth',2);
% title(['Trial #' num2str(trial)]);
% xlabel('time [ms]'); ylabel('channel');
% box off;
% set(gca,'xlim',DataTimeRange*1000,'ylim',[-3 23]);
% set(gca,'yTick',pos+1:2:pos+16,'yTickLabel',16:-2:2);
% 
% % csd
% for i=1:14
%     chs = i:i+2;
%     lfp_temp = (LFP(chs,:,trial));
%     csd(i,:) = lfp_temp(1,:) - 2*lfp_temp(2,:) + lfp_temp(3,:);
% end
% figure
% pcolor(csd); colormap jet;
% shading interp;
% set(gca,'YDir','reverse');