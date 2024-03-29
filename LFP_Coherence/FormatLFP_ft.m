% modify data structure for fieldtrip toolbox
% tutorial from: www.fieldtriptoolbox.org/tutorial/connectivity
% clear all
tic;
% make sure to use Matlab built-in filtfilt function!
rmpath C:\Users\Cohen\OneDrive\Documents\MATLAB\fieldtrip\external\signal

% set pass to data
isSave      = 0;
DATA_DIR    = 'G:\LFP\Original';
SAVE_DIR    = 'G:\LFP\FieldTrip';
TOOLBOX_DIR = 'C:\Users\Cohen\OneDrive\Documents\MATLAB';
addpath(genpath(fullfile(TOOLBOX_DIR,'chronux_2_12','chronux_2_12')));
% addpath(fullfile(TOOLBOX_DIR,'fieldtrip'));
% addpath(fullfile(TOOLBOX_DIR,'fieldtrip','plotting'));
% rmpath C:\Users\Cohen\OneDrive\Documents\MATLAB\fieldtrip\external\signal

% define data to analyze
Animal  = 'MrCassius'; %'MrMiyagi';
RecDate = '190421'; %'190904';
Epoch   = 'testToneOnset'; %'preCueOnset';
rmNoise = 'Y'; % remove line noise 'Y' or 'N'

disp('loading data...')
fName = strcat(Animal,'-',RecDate,'_LFP_',Epoch);
load(fullfile(DATA_DIR,fName));

% get electrode information
eInfo = countChannels(chanList);

% % format LFP data
% data = downsample_LFP(LFP,timeBin,1000,'Y');
% data.label = chanList;

% format bipolar-derived LFP data
% Be sure LFP is (trial) x (sample) x (channel)!!
data = downsample_bdLFP_v2(LFP,timeBin,1000,rmNoise,eInfo);
% data = downsample_bdLFP_original(LFP,timeBin,1000,rmNoise,eInfo);

stim = testStim;
trial_id = trialID;

if isSave==1
% save data
sName = strcat(Animal,'-',RecDate,'_bdLFP_',Epoch);
if strcmp(rmNoise,'Y')
    save_file_name = strcat(sName,'_ft');
elseif strcmp(rmNoise,'N')
    save_file_name = strcat(sName,'_ft_noFilt');
end
clc; disp('saving data...')
save(fullfile(SAVE_DIR,save_file_name),'data','choice','err','pretone', ...
    'pretoneLength','prior','SNR','stim','trial_id','info','-v7.3');
end

clc; disp('done!')
toc;