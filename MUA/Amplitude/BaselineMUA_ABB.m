% This program computes the area under the MUA in baseline period and get
% grand mean and std of the baseline for z-score
% using 225-ms ABB triplet period!!
clear all
close all
addpath('../'); % path for dependent function...

ANIMAL = 'Cassius'; % either 'Domo' or 'Cassius'
% set path to the Data directory
DATA_DIR = fullfile('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\DATA',ANIMAL,'MUA');
SAVE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
% th = 1.96; % 95% threshold of z-score
% th = 2.58; % 99% threshold of z-score

params.RecordingDate = '20210403';
params.SampleRate = 24414.0625; % original SR
% params.Baseline = 500; % baseline correction window in ms
% Nyquist = SampleRate/2;
% pointspermsec = SampleRate / 1000;
% msecperpoint = 1 / pointspermsec;

fName = strcat(params.RecordingDate,'_ABBA_MUA'); % data file name
load(fullfile(DATA_DIR,fName));
params.AnalysisWindow = [0 1500]; % analysis time window in ms
nChannel = size(meanMUA{1,1,1},2);

BL_combined = []; % combine baseline activity across trial conditions...
for k=1:2 % hit or miss (1 for hit, 2 for miss)
    for i=1:length(list_st)
        for j=1:length(list_tt)
            MUA_condition = meanMUA{i,j,k}; % mean MUA of each semitone diff...
%         [resp,spont,stim] = get_MUAResponse(t,MUA_stdiff,params.AnalysisWindow);  % original
%         [abb,trp] = get_MUAResponse_AB(t,MUA_stdiff);
            BL_condition = get_BaselineActivity_ABB(t,MUA_condition);
            BL_combined = cat(1,BL_combined,BL_condition);
        end
    end
end
% mean and standard deviation of the baseline activity
% remove NaN coming from zero corresponding trial (nTrial=0)
Baseline.mean = nanmean(BL_combined,1);
Baseline.std = nanstd(BL_combined,1);

% save data
save_file_name = strcat(params.RecordingDate,'_Baseline_ABB');
save(fullfile(SAVE_DIR,params.RecordingDate,'RESP',save_file_name), ...
    'Baseline');