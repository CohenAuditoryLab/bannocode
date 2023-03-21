function [] = convertRAW2MUA(rec_date)

% rec_date = '20201123';

% set directory...
% DATA_DIR = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/DATA';
% raw_file_dir = fullfile(DATA_DIR,'RAW'); % directory where raw files are stored...
% mua_file_dir = fullfile(DATA_DIR,'MUA'); % directory where mua files are saved...

raw_file_dir = 'G:\Cassius\RAW'; % directory where raw files are stored...
mua_file_dir = 'G:\Cassius\MUA'; % directory where mua files are saved...

%convert RAW to MUA
params.RecordingDate = rec_date;
params.SampleRate = 24414; % original SR
params.ArtRej = 500; %300;
params.Baseline = 500; % baseline correction window in ms
params.Taps = 200;
params.Wn = [500 3000]; % window for band-pass filtering
params.Points = 50; % for smoothing

% pointspermsec = SampleRate/1000;
% Nyquist = SampleRate/2;

clc;
% load RAW
disp('loading RAW data...');
data_file_name = strcat(params.RecordingDate,'_ABBA_raw');
load(fullfile(raw_file_dir,data_file_name));
RAW = permute(RAW,[2,1 3]) * 10^6; % convert to microvolts...

% split RAW
list_st = unique(stDiff);
INDEX = index;
ST_DIFF = stDiff;
TARGET_TIME = targetTime;
clear index stDiff targetTime

clc;
disp('obtaining mean MUA...');
meanMUA = [];
for i=1:length(list_st)
    std = list_st(i);
    disp([num2str(std) ' semitone difference']);
    raw = RAW(:,ST_DIFF==std,:);
    targetTime = TARGET_TIME(ST_DIFF==std);
    index = INDEX(ST_DIFF==std);
    mean_mua = [];
    for k=0:2 % hit, miss, fa
        raw_b = raw(:,index==k,:);
        if ~isempty(raw_b)
            % Artifact Rejection:
            denoise_raw = rejectArtifact(raw_b,params);
            % Get smooth mean MUA
            mua = getSmoothMUA(denoise_raw,params);
        else
            mua = NaN(size(raw,1),size(raw,3));
        end
        mean_mua = cat(3,mean_mua,mua);
        clear raw_b denoise_raw mua
    end    
%     temp_mua = getMUAAverage(mua,index);
    meanMUA = cat(4,meanMUA,mean_mua);
    clear raw mean_mua index targetTime
end
% reorder meanMUA 
meanMUA = permute(meanMUA,[1 2 4 3]); % time x channel x stdiff x behav 

clc;
% save MUA
disp('saving MUA...');
save_file_name = strcat(params.RecordingDate,'_ABBA_MUA');
save(fullfile(mua_file_dir,save_file_name),'meanMUA','list_st','t','params');
% save(save_file_name,'MUA','index','index_tsRT','stDiff','targetTime','t','-v7.3');

clc;
disp('done!');


end


