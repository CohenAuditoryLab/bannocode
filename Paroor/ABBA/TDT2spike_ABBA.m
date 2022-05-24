clear all;
% set variables
date = '20210410';
nChannel = 24;

% load behavioral data obtained from obtainBehavABBA.m
file_dir = fullfile('D:\Cassius\04_ABBA',date);
addpath(file_dir);
load(strcat(date,'_ABBA_BehavData'));
Block = strcat('~',param.Data);
DataTimeRange = param.DataTimeRange;
EpochTimeRange = param.EpochTimeRange;
nTrial = param.nValidTrials; % number of valid trials on TDT

% set global variables (should NOT change)
TANK_FILE_DIR = strcat('D:\TDT\Tanks\Cassius-',date(3:end));
% TANK_FILE_DIR = 'C:\TDT\OpenEx\Tanks\Domo';
STORE_NAME = 'Stm/';
EPOCH_START = EpochTimeRange(1); % Enter the start of epoch in seconds relative to stimulus onset
EPOCH_DURATION = diff(EpochTimeRange); % maximum length of trial epoch = 10 sec
SF_stim = param.SF.stim; % sampling freq for stim
SF_hand = param.SF.hand; % sampling freq for lever and rew

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

% get spike time from TDT
bin = DataTimeRange(1)*1000:5:DataTimeRange(2)*1000; % time bin for PSTH
for n=1:nTrial
    % spike timing
    stim_on_time = StimOnTime(n);
%     nRecs = invoke(TT, 'ReadEventsV', 2000, 'eNe1', 0, 0, stim_on_time+DataTimeRange(1), stim_on_time+DataTimeRange(2), 'ALL');
    nRecs = invoke(TT, 'ReadEventsV', 2000, 'eSP1', 0, 0, stim_on_time+DataTimeRange(1), stim_on_time+DataTimeRange(2), 'ALL');
    wave_data = invoke(TT,'ParseEvV',0,nRecs); % spike waveform
    SpikeWaveform{n} = wave_data;
    time_stamps = invoke(TT,'ParseEvInfoV',0,nRecs,6) - stim_on_time; % set stimulus onset time to be 0
    TimeStamps{n} = time_stamps * 1000; % convert time in ms
    ch = invoke(TT,'ParseEvInfoV',0,nRecs,4);
    Channel{n} = ch;
    
    % spike histogram (PSTH)
    for i=1:nChannel
        ts_ch = time_stamps(ch==i) * 1000; % time stamp for each channel
        h(i,:) = histcounts(ts_ch,bin);        
    end
    PSTH(:,:,n) = h;
    
    clear wave_data time_stamps ch
end

% save data
% param.Data = Block(2:end);
% param.DataTimeRange = DataTimeRange;
% param.EpochTimeRange = [EPOCH_START EPOCH_DURATION+EPOCH_START];
% param.SF = SF;
% param.ToneA = toneA;
% param.nValidTrials = nTrial;
param.nChannel = nChannel;
param.HistTimeBin = bin;

disp('saving the spike data...');
save_file_name = [param.Data(1:end-3) 'spike.mat'];
save(fullfile(file_dir,save_file_name),'param','tranges', ...
                    'stimOn','StimOnTime','leverRelease','LeverReleaseTime', ...
                    'index','index_tsRT','targetTime','stDiff', ...
                    'Stim','Lever1','Lever2','Rew','t_stim','t_hand', ...
                    'TimeStamps','Channel','SpikeWaveform','PSTH','-v7.3');

disp('done!');

% % plot data for checking
% figure;
% trial = 16;
% plot(t,Rew(trial,:),'color',[.9 .8 .8]); hold on;
% plot(t,Lever(trial,:),'color',[.5 .5 .5]);
% plot(t,Stim1(trial,:) * 4,'k');
% box off;
% 
% ch = Channel{trial};
% time_stamps = TimeStamps{trial};
% pos = 22;
% for i=1:16
%     ts_ch = time_stamps(ch==i); % time stamp for each channel
%     showRaster(ts_ch,pos*ones(1,numel(ts_ch)),1);
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
% figure;
% imagesc(PSTH(:,:,trial));
% caxis([0 .3]);
% % pcolor(PSTH(:,:,trial));
% % shading flat; caxis([0 .3]);
% % set(gca,'YDir','reverse');
% set(gca,'XTick',100:100:600,'XTickLabel',0:500:2500);
% xlabel('time'); ylabel('channel');
%  
