% modify data structure for fieldtrip toolbox
% tutorial from: www.fieldtriptoolbox.org/tutorial/connectivity
% clear all

% make sure to use Matlab built-in filtfilt function!
rmpath C:\Users\Cohen\OneDrive\Documents\MATLAB\fieldtrip\external\signal

% set pass to data
DATA_DIR    = 'G:\LFP';
TOOLBOX_DIR = 'C:\Users\Cohen\OneDrive\Documents\MATLAB';
addpath(genpath(fullfile(TOOLBOX_DIR,'chronux_2_12','chronux_2_12')));
% addpath(fullfile(TOOLBOX_DIR,'fieldtrip'));
% addpath(fullfile(TOOLBOX_DIR,'fieldtrip','plotting'));
% rmpath C:\Users\Cohen\OneDrive\Documents\MATLAB\fieldtrip\external\signal

% define data to analyze
Animal  = 'MrMiyagi'; %'MrCassius';
RecDate = '190904';
Epoch   = 'preCueOnset'; %'testToneOnset';
rmNoise = 'Y'; % remove line noise 'Y' or 'N'

fName = strcat(Animal,'-',RecDate,'_LFP_',Epoch);
load(fullfile(DATA_DIR,fName));

% get electrode information
eInfo = countChannels(chanList);

% % format LFP data
% data = downsample_LFP(LFP,timeBin,1000,'Y');
% data.label = chanList;

% format bipolar-derived LFP data
% Be sure LFP is (trial) x (sample) x (channel)!!
data = downsample_bdLFP(LFP,timeBin,1000,rmNoise,eInfo);

stim = testStim;
trial_id = trialID;

% save data
sName = strcat(Animal,'-',RecDate,'_bdLFP_',Epoch);
if strcmp(rmNoise,'Y')
    save_file_name = strcat(sName,'_ft');
elseif strcmp(rmNoise,'N')
    save_file_name = strcat(sName,'_ft_noFilt');
end
save(save_file_name,'data','choice','err','pretone','pretoneLength', ...
    'prior','SNR','stim','trial_id','-v7.3');

