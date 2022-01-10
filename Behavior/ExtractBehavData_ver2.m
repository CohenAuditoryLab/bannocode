% access the behavioral data and same d-prime as a function of semitone
% difference
% 12/20/21 hit rate and fa rate added
% get Cassius's data from Paroor rig...
clear all;

isSave = 0; % set to be 1 when saving the data...

% data file directory
ROOT_DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Domo\NeuralData\vProbe\04_ABBA';
SAVE_FILE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\Data';

load RecordingDate_Domo
RecDate = list_RecDate;
% RecDate = {'20180709','20180727'};
% RecDate = {'20180807','20180907','20181210','20181212','20190123', ...
%     '20190409','20190821','20190828','20191009','20191210','20191220', ...
%     '20200103','20200110','20200114'};

for ff = 1:numel(RecDate)
fName = strcat(RecDate{ff},'_ABBA_BehavData');
load(fullfile(ROOT_DATA_DIR,RecDate{ff},fName));

list_st = unique(stDiff);

% get reaction time
targetOn = stimOn + targetTime;
rtTDT = leverRelease - targetOn; % reaction time obtained from analog data

% get reaction time
rt_all = rtTDT(index==0); % hit trial
rt_sdf = rtTDT(index==0 & stDiff==list_st(1));
rt_ldf = rtTDT(index==0 & stDiff==list_st(end));

stDiff_tsRT = stDiff(index_tsRT);
rt_tsRT_all = rtTDT(index_tsRT);
rt_tsRT_sdf = rt_tsRT_all(stDiff_tsRT==list_st(1));
rt_tsRT_ldf = rt_tsRT_all(stDiff_tsRT==list_st(end));

rt = struct('all',rt_all,'sdf',rt_sdf,'ldf',rt_ldf);
rt_tsRT = struct('all',rt_tsRT_all,'sdf',rt_tsRT_sdf,'ldf',rt_tsRT_ldf);
clear rt_all rt_sdf rt_ldf rt_tsRT_all rt_tsRT_sdf rt_tsRT_ldf;

% remove start error (3) and touch error (4)
stDiff = stDiff(index<3);
targetTime = targetTime(index<3);
index = index(index<3);

% get number of hit/miss/fa as a function of stdiff
for i=1:length(list_st)
    index_stdiff = index(stDiff==list_st(i));
    N(i,1) = sum(index_stdiff==0); % hit
    N(i,2) = sum(index_stdiff==1); % miss
    N(i,3) = sum(index_stdiff==2); % false alarm
end
% hit rate and FA rate
r_hit  = N(:,1) ./ sum(N,2); % hit rate 
r_miss = N(:,2) ./ sum(N,2);
r_fa   = N(:,3) ./ sum(N,2); % fa rate
clear N

% d prime
dp = norminv(r_hit) - norminv(r_fa);

if isSave
    % save
    save_file_name = strcat(RecDate{ff},'_Behavior');
    save(fullfile(SAVE_FILE_DIR,save_file_name),'dp','rt','rt_tsRT','list_st',...
        'r_hit','r_miss','r_fa');
end

clear dp rt rt_tsRT list_st
end