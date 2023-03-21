function [] = convertRAW2MUA_v2(animal_name, RecDate)
% clear all
% close all

% RecDate = '20180907';
% animal_name = 'Domo';
% set directory...
% DATA_DIR = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/DATA';
% raw_file_dir = fullfile(DATA_DIR,'RAW'); % directory where raw files are stored...
% mua_file_dir = fullfile(DATA_DIR,'MUA'); % directory where mua files are saved...

raw_file_dir = 'G:\Cassius\RAW'; % directory where raw files are stored...
mua_file_dir = 'G:\Cassius\MUA'; % directory where mua files are saved...

%convert RAW to MUA
params.RecordingDate = RecDate;
params.SampleRate = 24414; % original SR
params.ArtRej = 500; %300;
% params.Baseline = 500; % baseline correction window in ms
params.Baseline = [-830 -430]; % baselin period in ms
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
list_tt = unique(targetTime);
INDEX = index;
ST_DIFF = stDiff;
TARGET_TIME = targetTime;
clear index stDiff targetTime

clc;
disp('obtaining mean MUA...');
% meanMUA = [];
for i=1:length(list_st)
    std = list_st(i);
    disp([num2str(std) ' semitone difference']);
    for j=1:length(list_tt)
        tt = list_tt(j);
        disp(['processing target time #' num2str(j)]);
        raw = RAW(:,ST_DIFF==std&TARGET_TIME==tt,:);
        %     targetTime = TARGET_TIME(ST_DIFF==std);
        index = INDEX(ST_DIFF==std&TARGET_TIME==tt);
        mean_mua = [];
        for k=0:2 % hit, miss, fa
            raw_b = raw(:,index==k,:);
            n = sum(index==k);
            if ~isempty(raw_b)
                % Artifact Rejection:
                denoise_raw = rejectArtifact(raw_b,params);
                % Get smooth mean MUA
                mua = getSmoothMUA(denoise_raw,params);
            else
                mua = NaN(size(raw,1),size(raw,3));
            end
            %         mean_mua = cat(3,mean_mua,mua);
            meanMUA{i,j,k+1} = mua;
            nTrial(i,j,k+1) = n;
            clear raw_b denoise_raw mua
        end
        %     temp_mua = getMUAAverage(mua,index);
        %     meanMUA = cat(4,meanMUA,mean_mua);
        clear raw index targetTime mean_mua
    end
end
% reorder meanMUA 
% meanMUA = permute(meanMUA,[1 2 4 3]); % time x channel x stdiff x behav 

clc;
% save MUA
disp('saving MUA...');
save_file_name = strcat(params.RecordingDate,'_ABBA_MUA');
save(fullfile(mua_file_dir,save_file_name),'meanMUA','nTrial','list_st','list_tt','t','params');
% save(save_file_name,'MUA','index','index_tsRT','stDiff','targetTime','t','-v7.3');

clc;
disp('done!');

end

%%
% % select example data (24 stdiff, hit)
% raw = RAW(:,stDiff==24,:);
% iBehav = index(stDiff==24);
% raw = raw(:,iBehav==0,:); % hit trials
% 
% % Artifact Rejection:
% denoise_raw = rejectArtifact(raw,params);
% 
% % Get smooth mean MUA
% meanMUA = getSmoothMUA(denoise_raw);
%%



% % filtering
% Nyquist = params.SampleRate / 2;
% Wn = [500 3000] / Nyquist; % set window for band-pass filtering
% B = fir1(Taps,Wn,'bandpass');%bandpass FIR filter with 100 taps
% MUA = filtfilt(B,1,raw); % use fitfilt instead of filter
% MUA = abs(MUA);
% MeanMUA = squeeze(nanmean(MUA,2));
% 
% %Baseline correct MeanMUA:
% for c=1:size(MeanMUA,2);
%     MeanMUA_BLC(:,c)=(MeanMUA(:,c)-nanmean(MeanMUA(1:round(pointspermsec*Baseline),c)));%subtracts mean of baseline from each column in the file
% end
% 
% %Smooth MeanMUA:
% points = 50;%for smoothing
% rows = size(MeanMUA_BLC,1);
% columns = size(MeanMUA_BLC,2);
% % Smooth_MeanMUA_BLC=zeros(size(MeanMUA_BLC,1),size(MeanMUA_BLC,2));
% Smooth_MeanMUA_BLC = zeros(rows,columns);
% for c=1:columns;
%     for r=(points+1):rows-(points+1);%start at row #points+1 and ends at row #end-(points+1) for n-point average smooth
%         Smooth_MeanMUA_BLC(r,c)=mean(MeanMUA_BLC(r-points:r+points,c)); %n-point average smooth
%     end
% end





% clc;
% % obtain MUA
% disp('converting RAW to MUA...');
% MUA = filtfilt(b1,a1,RAW); % high-pass filtering
% MUA = abs(MUA); % half rectification
% MUA = filtfilt(b2,a2,MUA); % low-pass filtering
% clear RAW
% 
% % split MUA
% list_st = unique(stDiff);
% INDEX = index;
% ST_DIFF = stDiff;
% TARGET_TIME = targetTime;
% clear index stDiff targetTime
% 
% clc;
% disp('saving MUA...');
% meanMUA = [];
% for i=1:length(list_st)
%     std = list_st(i);
%     mua = MUA(:,ST_DIFF==std,:);
%     targetTime = TARGET_TIME(ST_DIFF==std);
%     index = INDEX(ST_DIFF==std);
%     temp_mua = getMUAAverage(mua,index);
%     meanMUA = cat(4,meanMUA,temp_mua);
% %     save_file_name = strcat(RecordingDate,'_ABBA_ST_',num2str(std));
% %     save(save_file_name,'mua','index','targetTime','std','t','-v7.3');
%     clear mua temp_mua index targetTime
% end
% % reorder meanMUA 
% meanMUA = permute(meanMUA,[1 2 4 3]); % time x channel x stdiff x behav 
% 
% clc;
% % save MUA
% disp('saving MUA...');
% save_file_name = strcat(RecordingDate,'_ABBA_MUA');
% save(save_file_name,'meanMUA','list_st','t');
% % save(save_file_name,'MUA','index','index_tsRT','stDiff','targetTime','t','-v7.3');
% 
% clc;
% disp('done!');
% 
