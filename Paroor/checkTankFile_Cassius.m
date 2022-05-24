% stimulus on time was recaluculated based on TDT tank data
% FA with too short reaction time and touch error were identified and the 
% index was rewritten
% In the index, 0, 1, 2, 3, and 4 respectively means hit, miss, false alarm,
% start error, and touch error
% trial numbers for FA with too short RT were in the index_tsRT 

clear all;
% set variables
% Block = '~20181210_ABBA_d01'; % frequency task
Block = '~20200804_test';
% FileName_LabVIEW = 'domo_frq_dynamic_2018121001';
DataTimeRange = [-0.5 2.5];
ErrorStimOn = -2.5e-3; % actual onset of the stimulus is ~2.5 ms before the estimated time
% ErrorStimOn = 0;

% set global variables (should NOT change)
TANK_FILE_DIR = 'C:\TDT\Synapse\Tanks\MrCassius-200804';
% TANK_FILE_DIR = 'C:\TDT\Synapse\Tanks\Domo-180813-182551';
STORE_NAME = 'Stm/';
EPOCH_START = 0; % Enter the start of epoch in seconds relative to stimulus onset
EPOCH_DURATION = 12; % maximum length of trial epoch = 10 sec
SF_hand = 1017.252625; % sampling rate for lever and rew
SF_stim = 48828.125; % sampling rate for stim
% LABVIEW_FILE_DIR = strcat('C:\Taku\04_ABBA\',Block(2:9));
% 
% % access LabVIEW file
% addpath(LABVIEW_FILE_DIR);
% load(FileName_LabVIEW);
% if length(FileName_LabVIEW)>31
%     Data = eval(FileName_LabVIEW(1:31));
% else
%     Data = eval(FileName_LabVIEW);
% end

% % Data = Data(2:end); %20180822 trial number mismatch
% nTrial = numel(Data);
% for i=1:nTrial
%     reactionTime(i,1) = Data(i).LeverAcquired(2) - Data(i).TimeStamp(2);
% %     behavEnd(i,1) = Data(i).EndOfBehavior;
%     stimOn(i,1) = Data(i).TimeStamp(1);
%     targetOn(i,1) = Data(i).TimeStamp(2);
%     if size(Data(i).TimeStamp,2)==4
%         rt(i,:) = Data(i).TimeStamp(4);
%     else
%         rt(i,:) = NaN;
%     end
%     leverOn(i,1) = Data(i).LeverAcquired(1);
%     leverRelease(i,1) = Data(i).LeverAcquired(2);
%     temp_params = textscan(Data(i).CurrentParam,'%s','delimiter','.');
%     params(i,:) = transpose(str2double(temp_params{1}));
% %     Error(i,:) = Data(i).Error;
% end
% toneA = unique(params(:,1));
% stDiff = params(:,2); % semitone difference
% targetTime = params(:,3);
% % count hit, miss, false alarm, and start error
% iSE = stimOn == -1; % index of start error ... 3
% iFA = targetOn == -1; % index of false alarm ... 2
% iMiss = leverRelease <= 0; % index of miss ... 1
% index = iSE + iFA + iMiss; % create index
% % FA with too short (<200 ms) reaction time 
% rt(rt<0) = NaN;
% index(~isnan(rt)) = 2;
% temp = 1:nTrial;
% index_tsRT = transpose(temp(~isnan(rt)));

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

% obtain continuous analog Data
TT.SetGlobals('WavesSFEvent=STMM; Channel=1');
wStim1 = TT.ReadWavesV('STMM'); % stimulus
% TT.SetGlobals('WavesSFEvent=Wav2; Channel=2'); % for location task
% wStim2 = TT.ReadWavesV('Wav2');
TT.SetGlobals('WavesSFEvent=HNDD; Channel=1');
wLever1 = TT.ReadWavesV('HNDD'); % lever touch
TT.SetGlobals('WavesSFEvent=HNDD; Channel=2');
wLever2 = TT.ReadWavesV('HNDD'); % lever manipulation
TT.SetGlobals('WavesSFEvent=HNDD; Channel=3');
wRew = TT.ReadWavesV('HNDD'); % reward

% filtering stim
Wn = [55 65] / (SF_stim/2) ;
% Wn = 130 / (SF_stim/2);
[b,a] = butter(2,Wn,'stop');
stim = filtfilt(b,a,double(wStim1));
Wn = [115 125] / (SF_stim/2) ;
[b,a] = butter(3,Wn,'stop');
stim = filtfilt(b,a,double(stim));
Wn = [235 245] / (SF_stim/2) ;
[b,a] = butter(3,Wn,'stop');
stim_noNoise = filtfilt(b,a,double(stim));

% obtain trial onset time
invoke(TT,'ResetFilters');
invoke(TT, 'SetGlobals', 'Options = FILTERED');
% invoke(TT,'SetGlobals','RespectOffsetEpoc = 0'); % don't know why we need this for our data
MyEpocs = invoke(TT,'GetEpocsV',STORE_NAME,0,0,1000);%Returns the Epoc events for Trigger returns a NaN event in this case
Filt = invoke(TT,'SetEpocTimeFilterV', STORE_NAME, EPOCH_START, EPOCH_DURATION);% Sets the Time filter-the first number is starting time, the second number is epoch duration
tranges = invoke (TT, 'GetValidTimeRangesV');% Gets the start and end of the Time ranges.
% tranges = tranges(:,30:end); % omit invalid data  on 2018/09/05
nTrial = size(tranges,2); % number of valid trials on TDT

% get stimulus onset on TDT
clear stimOn leverOn targetOn leverRelease; % clear stimOn from LabView
baseline = mean(wStim1(1000:11000));
% check_th_val = max(abs(wStim1(1000:11000) - baseline)); % 0.0094
% stim_threshold = 0.015; % must be larger than check_th_val
% lever_threshold = 2;
% t = DataTimeRange(1):1/SF:DataTimeRange(2);
% t = t * 1000; % convert time in ms
% n_50ms = numel(0:1/SF:0.050) - 1;

t_stim = DataTimeRange(1):1/SF_stim:DataTimeRange(2);
t_hand = DataTimeRange(1):1/SF_hand:DataTimeRange(2);
t_stim = t_stim * 1000;
t_hand = t_hand * 1000;
stim_threshold = 0.0052; % must be larger than check_th_val
lever_threshold = 2.0; %0.39;
n_50ms = numel(0:1/SF_stim:0.050) - 1;
for n=1:nTrial
    trial_on = round( (tranges(2,n)) * SF_stim );
    trial_off = round( (tranges(2,n)+2.5) * SF_stim );
    stim_trial = stim_noNoise(trial_on:trial_off) - baseline;
    time = (0:numel(stim_trial)-1) / SF_stim;
    
    trial_on_h = round( (tranges(2,n)) * SF_hand );
    trial_off_h = round( (tranges(2,n)+2.5) * SF_hand );
    lever_trial = wLever2(trial_on_h:trial_off_h);
    time_h = (0:numel(lever_trial)-1) / SF_hand;
    if sum( abs(stim_trial) > stim_threshold )==0
        stim_on = 0; % cut out data from the trial onset
        stimOn(n,:) = NaN; % start error trial
%         lever_on = NaN;
        lever_release = NaN;
%         leverOnTDT(n,:) = lever_on;
        leverRelease(n,:) = lever_release;
%         index(n) = 3; % start error
    else 
        stim_on = min(time(abs(stim_trial) > stim_threshold));
        % correction of stim onset error
        temp = abs( time - (stim_on+ErrorStimOn) );
        stim_on = time(temp==min(temp));
        stimOn(n,:) = stim_on * 1000; % in ms
%         lever_on = min(time(lever_trial > lever_threshold));
        lever_release = min(time_h(lever_trial < lever_threshold));
        if isempty(lever_release)
            lever_release = NaN;
        end
        
%         if isempty(lever_on) % false alarm detection of stim
%             stim_on = 0;
%             stimOn(n,:) = NaN;
%             lever_on = NaN;
%             lever_release = NaN;
%             leverOnTDT(n,:) = lever_on;
%             leverRelease(n,:) = lever_release;
%             index(n) = 3; % start error
%         else
%             leverOnTDT(n,:) = lever_on * 1000; % in ms
%             leverRelease(n,:) = lever_release * 1000; % in ms
%             temp_leverOn = find(time==lever_on);
%             temp_stimOn = find(time==stim_on);
%             if temp_stimOn-temp_leverOn > 150
%                 temp_leverOn = temp_stimOn-20;
%             end
%             lever_around_stim_on = lever_trial(temp_leverOn:temp_stimOn+n_50ms);
%             if sum(lever_around_stim_on < lever_threshold)
%                 if index(n)==2
%                     index(n) = 4; % touch error trial
%                 end
%             end
%             clear lever_around_stim_on
%         end
    end
    
%     stim_on_time = tranges(2,n); % in sec
    stim_on_time = tranges(2,n) + stim_on; % in sec
    lever_release_time = tranges(2,n) + lever_release; % in sec
    % cut out data in the specified time range (with respect to stim onset)
    data_onset_stim = round((stim_on_time + DataTimeRange(1)) * SF_stim); % corresponding point
    Stim(n,:) = stim_noNoise(data_onset_stim:data_onset_stim+floor(diff(DataTimeRange)*SF_stim)); % stim in trial
%     Stim2(n,:) = wStim2(data_onset:data_onset+floor(diff(DataTimeRange)*SF)); % stim in trial
    data_onset_hand = round((stim_on_time + DataTimeRange(1)) * SF_hand);
    Lever1(n,:) = wLever1(data_onset_hand:data_onset_hand+floor(diff(DataTimeRange)*SF_hand)); % lever status in trial
    Lever2(n,:) = wLever2(data_onset_hand:data_onset_hand+floor(diff(DataTimeRange)*SF_hand)); % lever status in trial
    Rew(n,:) = wRew(data_onset_hand:data_onset_hand+floor(diff(DataTimeRange)*SF_hand)); % reward status in trial
    StimOnTime(n,:) = stim_on_time;
    LeverReleaseTime(n,:) = lever_release_time;
    leverRelease(n,:) = (lever_release - stim_on) * 1000;
end
% targetOn = stimOn + targetTime;
% rtTDT = leverRelease - targetOn;


figure;
tid = 3; % trial id
plot(t_stim,Stim(tid,:)); hold on;
plot(t_hand,Lever2(tid,:) / 16);
plot(t_hand,Rew(tid,:) / 32);
plot(leverRelease(tid),lever_threshold/16,'.k');
plot([0 0],[-0.2 0.2],':r');

% % show touch error trials for check
% iTE = find(index==4);
% for i=1:numel(iTE)
%     figure;
%     plot(t,Rew(iTE(i),:),'Color',[.9 .8 .8]); hold on
%     plot(t,Lever(iTE(i),:),'Color',[.5 .5 .5]);
%     plot(t,Stim1(iTE(i),:) * 4,'k');
%     plot(t,Stim2(iTE(i),:) * 4,'k');
%     set(gca,'ylim',[-5 10]);
%     title(['trial #' num2str(iTE(i))]);
%     xlabel('time [ms]');
%     box off;
% end
% 
% std_list = unique(stDiff);
% std_hit = stDiff(index==0);
% std_miss = stDiff(index==1);
% std_fa = stDiff(index==2);
% for i=1:numel(std_list)
%     j = std_list(i);
%     count_trial(i,:) = [sum(std_hit==j) sum(std_miss==j) sum(std_fa==j)];
% end
% 
% % show performance
% figure;
% subplot(2,1,1);
% semilogx(std_list,count_trial(:,1)./sum(count_trial,2)*100,'or','LineWidth',2); hold on;
% semilogx(std_list,count_trial(:,2)./sum(count_trial,2)*100,'^b','LineWidth',2);
% semilogx(std_list,count_trial(:,3)./sum(count_trial,2)*100,'xk','LineWidth',2);
% set(gca,'xlim',[2 24],'ylim',[0 100],'xTick',[2 4 8 10 16 24],'yTick',0:20:100);
% xlabel('semitone difference'); ylabel('% correct');
% box off; grid on;
% % title(dataFileName);
% pfm = sum(count_trial,1); % overall performance
% legend(['Hit ... ' num2str(round(pfm(1)/sum(pfm)*100,1)) '%'], ...
%        ['Miss ...  ' num2str(round(pfm(2)/sum(pfm)*100,1)) '%'], ...
%        ['FA ...  ' num2str(round(pfm(3)/sum(pfm)*100,1)) '%'], ...
%        'Location','NorthWest');
% subplot(2,1,2);
% % rtHit = reactionTime(index==0); % from LabVIEW data
% % rtFAts = rt(index_tsRT); % from LabVIEW data
% rtHit = rtTDT(index==0);
% rtFAts = rtTDT(index_tsRT);
% rtStat = quantile(rtHit,[0.05 0.5 0.95]);
% rtStat = round(rtStat,1);
% bin = 0:25:800;
% histogram(rtHit,bin); hold on;
% histogram(rtFAts,bin);
% box off;
% xlabel('time [ms]'); ylabel('count');
% title('reaction time');
% ylim = get(gca,'ylim');
% text(25,ylim(2)*0.8,['median = ' num2str(rtStat(2))]);
% text(25,ylim(2)*0.7,['90% range = [' num2str(rtStat(1)) ', ' num2str(rtStat(3)) ']']);
% 
% % save data
% date = Block(2:9);
% param.Data = Block(2:end);
% param.DataTimeRange = DataTimeRange;
% param.EpochTimeRange = [EPOCH_START EPOCH_DURATION+EPOCH_START];
% param.SF = SF;
% param.ToneA = toneA;
% param.nValidTrials = nTrial;
% % param.nChannel = nChannel;
% 
% disp('saving the spike data...');
% save_file_name = [date '_ABBA_BehavData.mat'];
% save(save_file_name,'param','tranges', ...
%                     'stimOn','StimOnTime','leverRelease','LeverReleaseTime', ...
%                     'index','index_tsRT','targetTime','stDiff', ...
%                     'Stim1','Stim2','Lever','Rew','t');
% 
% 
disp('done!');        