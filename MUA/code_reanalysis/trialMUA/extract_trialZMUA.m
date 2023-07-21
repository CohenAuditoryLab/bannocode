function [] = extract_trialZMUA(RecDate)

DATA_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\DATA\Domo\RAW';
SAVE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';

% set parameters to get trial MUA
params.RecordingDate = RecDate;
params.SampleRate = 24414.0625; %24414; % original SR
params.ArtRej = 500; %300;
% params.Baseline = 500; % baseline correction window in ms
params.Baseline = [-830 -430]; % baselin period in ms
params.Taps = 200;
params.Wn = [500 3000]; % window for band-pass filtering
params.Points = 200; %50; % for smoothing

% load data...
disp(['loading data...', RecDate]);
fName = strcat(RecDate,'_ABBA_raw');
load(fullfile(DATA_DIR,fName));
clc;

list_stDiff = unique(stDiff);
list_ttime  = unique(targetTime);
% Raw_ch = RAW(:,:,ch);
RAW = permute(RAW,[2 1 3]) * 10^6; % convert to microvolts...
n_channel = size(RAW,3);

% artifact rejection
[denoiseRaw,iNT] = rejectArtifact_trial(RAW,params);
stDiff(iNT==1) = [];
targetTime(iNT==1) = [];
index(iNT==1) = [];

[tpos_trial,sTriplet] = getTPos_trial(targetTime);
% extract trial MUA
for ch = 1:n_channel
    disp(['obtaining trial MUA from ch ' num2str(ch)]);
    MUA_trial = getSmoothMUA_trial(denoiseRaw(:,:,ch),params);
    zMUA_temp = get_zMUAResponse_trial(t,MUA_trial,ch,params);  % get zMUA
    zMUA_trial(:,:,:,ch) = get_zMUA_tpos(zMUA_temp,tpos_trial); % align zMUA by target time
%     zMUA_trial(:,:,:,ch) = get_zMUAResponse_trial(t,MUA_trial,ch,params);
    clear MUA_trial zMUA_temp
end
% zMUA_trial -- ch x ABB x tpos x trial
zMUA_trial = permute(zMUA_trial,[4 1 2 3]);

% save MUA
disp('saving trial zMUA...');
save_file_name = strcat(params.RecordingDate,'_zMUA_trial');
save(fullfile(SAVE_DIR,save_file_name),'zMUA_trial','stDiff','targetTime','index','params','sTriplet');

clc;
% disp('done!');

end