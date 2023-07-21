DATA_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\DATA\Domo\RAW';
SAVE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\exampleMUA';

RecDate = '20190409'; %'20200110'; %'20180709';
ch = 5; %7; %9;

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
disp('loading data...');
fName = strcat(RecDate,'_ABBA_raw');
load(fullfile(DATA_DIR,fName));
clc;

list_stDiff = unique(stDiff);
list_ttime  = unique(targetTime);
Raw_ch = RAW(:,:,ch);

% artifact rejection
[denoiseRaw,iNT] = rejectArtifact_ch(Raw_ch,params.ArtRej);
stDiff(iNT==1) = [];
targetTime(iNT==1) = [];
index(iNT==1) = [];

% extract trial MUA
disp('obtaining trial MUA...');
MUA_trial = getSmoothMUA_trial(denoiseRaw',params);
clc;

% save data
% save MUA
disp('saving MUA...');
save_file_name = strcat(params.RecordingDate,'_trialMUA_ch',num2str(ch));
save(fullfile(SAVE_DIR,save_file_name),'MUA_trial','stDiff','targetTime','index','t','params');

clc;
disp('done!');