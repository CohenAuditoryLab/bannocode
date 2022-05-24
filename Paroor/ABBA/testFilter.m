% stimulus on time was recaluculated based on TDT tank data
% FA with too short reaction time and touch error were identified and the 
% index was rewritten
% In the index, 0, 1, 2, 3, and 4 respectively means hit, miss, false alarm,
% start error, and touch error
% trial numbers for FA with too short RT were in the index_tsRT 

clear all;
addpath(genpath('C:\TDT\TDTMatlabSDK'));
% set variables
% Block = '~20200114_ABBA_d02'; % frequency task
% Block = '~20180905_ABBAl_d01'; % location task
% Block = '~20190925_ABBA_spk2_d03';
Block = '~20200907_ABBA_d01';
FileName_LabVIEW = 'cassius_frq_dynamic_2020090701';
DataTimeRange = [-0.5 3.5];
DelayStimOn = 0; %-1.0e-3; % actual onset of the stimulus is ~2.5 ms before the estimated time
% ErrorStimOn = 0;

% set global variables (should NOT change)
% TANK_FILE_DIR = 'F:\TDT\Synapse\Tanks\Domo-200114';
TANK_FILE_DIR = 'D:\TDT\Tanks\Cassius-200907';
% TANK_FILE_DIR = 'C:\TDT\Synapse\Tanks\Domo-180813-182551';
STORE_NAME = 'Stm/';
EPOCH_START = 0; % Enter the start of epoch in seconds relative to stimulus onset
EPOCH_DURATION = 4; % maximum length of trial epoch = 10 sec
% SF = 1017.252625; % sampling freq for stim, lever, rew, and lfp

% access Tank file
TT = actxcontrol('TTank.X');
invoke(TT,'ConnectServer','Local','Me');
invoke(TT,'SetGlobalV','WavesMemLimit',128e6);
e=invoke(TT,'OpenTank',TANK_FILE_DIR,'R');
e1=invoke(TT,'SelectBlock',Block);
if e1+e==2%checks to see if specified tank and block found
    disp('processing tank file...');
else
    disp('fail to access the tank file');
end

% obtain trial onset time
invoke(TT,'ResetFilters');
invoke(TT, 'SetGlobals', 'Options = FILTERED');
% invoke(TT,'SetGlobals','RespectOffsetEpoc = 0'); % don't know why we need this for our data
MyEpocs = invoke(TT,'GetEpocsV',STORE_NAME,0,0,1000);%Returns the Epoc events for Trigger returns a NaN event in this case
Filt = invoke(TT,'SetEpocTimeFilterV', STORE_NAME, EPOCH_START, EPOCH_DURATION);% Sets the Time filter-the first number is starting time, the second number is epoch duration
tranges = invoke (TT, 'GetValidTimeRangesV');% Gets the start and end of the Time ranges.
nTrial = size(tranges,2); % number of valid trials on TDT

BLOCKPATH = fullfile(TANK_FILE_DIR,Block(2:end));
data = TDTbin2mat(BLOCKPATH, 'TYPE', {'epocs', 'snips', 'streams'},'STORE',{'STMM','HNDD'});
wStim1 = data.streams.STMM.data(1,:);
wLever1 = data.streams.HNDD.data(1,:);
wLever2 = data.streams.HNDD.data(2,:);
wRew = data.streams.HNDD.data(3,:);
% wLever = interp(double(wLever),12); % upsample the data
% wRew = interp(double(wRew),12); % upsample the data
SF_stim = data.streams.STMM.fs;
SF_hand = data.streams.HNDD.fs;

% denoising stim...
Wn = [55 65] / (SF_stim/2) ;
% Wn = 130 / (SF_stim/2);
[b,a] = butter(2,Wn,'stop');
stim = filtfilt(b,a,double(wStim1));
stim = filtfilt(b,a,double(stim));
Wn = [115 125] / (SF_stim/2) ;
[b,a] = butter(3,Wn,'stop');
stim = filtfilt(b,a,double(stim));
Wn = [175 185] / (SF_stim/2) ;
[b,a] = butter(3,Wn,'stop');
stim = filtfilt(b,a,double(stim));
Wn = [235 245] / (SF_stim/2) ;
[b,a] = butter(3,Wn,'stop');
stim = filtfilt(b,a,double(stim));
Wn = [295 305] / (SF_stim/2) ;
[b,a] = butter(2,Wn,'stop');
stim_noNoise = filtfilt(b,a,double(stim));

% get stimulus onset on TDT
clear stimOn leverOn targetOn leverRelease; % clear stimOn from LabView
calib_window = round([tranges(2,1)-11 tranges(2,1)-10]*SF_stim);
baseline = mean(stim_noNoise(calib_window(1):calib_window(2)));
A = stim_noNoise(calib_window(1):calib_window(2));
% baseline = mean(wStim1(12000:141000)); % calculate baseline from first 10 sec data
% [base_up,base_lo] = envelope(abs(wStim1(12000:141000)-baseline),5,'peak');
% base_env = diff(base_up);
% th = mean(base_env) + 6.0*std(base_env);

t_stim = DataTimeRange(1):1/SF_stim:DataTimeRange(2);
t_hand = DataTimeRange(1):1/SF_hand:DataTimeRange(2);
t_stim = t_stim * 1000;
t_hand = t_hand * 1000;
stim_threshold = 0.0052; % must be larger than check_th_val
lever_threshold = 0.39;
touch_threshold = 2.5;
n_50ms = numel(0:1/SF_stim:0.050) - 1;

for n=100 %1:nTrial
    trial_on = round( (tranges(2,n)) * SF_stim );
    trial_off = round( (tranges(2,n)+DataTimeRange(2)) * SF_stim );
    stim_trial = stim_noNoise(trial_on:trial_off) - baseline;
    time = (0:numel(stim_trial)-1) / SF_stim;
    
    trial_on_h = round( (tranges(2,n)) * SF_hand );
    trial_off_h = round( (tranges(2,n)+DataTimeRange(2)) * SF_hand );
    lever1_trial = wLever1(trial_on_h:trial_off_h); % touch sensor
    lever2_trial = wLever2(trial_on_h:trial_off_h); % joystick movement
    time_h = (0:numel(lever2_trial)-1) / SF_hand;
    if sum( abs(stim_trial) > stim_threshold )==0 % start error
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
        temp = abs( time - (stim_on+DelayStimOn) );
        stim_on = time(temp==min(temp));
        stimOn(n,:) = stim_on * 1000; % in ms
%         lever_on = min(time(lever_trial > lever_threshold));
        lever_release = min(time_h(lever2_trial < lever_threshold));
        if isempty(lever_release)
            lever_release = NaN;
        end
        
        if index(n)==2
            target_on = targetTime(n)/1000;
            touch_status = lever1_trial(time_h<target_on);
%             lever_break = sum(touch_status<touch_threshold);
            lever_break = min(time_h(touch_status < touch_threshold));
            if ~isempty(lever_break)
                index(n) = 4; % touch error
                if ~isnan(lever_release)
                    if lever_break > lever_release
                        index(n) = 2; % false alarm
                    end
                end
            end
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