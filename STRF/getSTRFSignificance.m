function getSTRFSignificance(DATA_FILE_NAME,alpha,NB)
% obtain STRF reliability
disp('calculating STRF reliability index');

% clear all;
addpath('C:\STRF_files\matlab\keck'); 
DATE = DATA_FILE_NAME(1:8);
DEPTH = DATA_FILE_NAME(end-2:end);

% load shuffled data
file_name = strcat(DATE, '_shuffledSTRF_', DEPTH);
load(file_name);

for i=1:16
    STRF1Ash{i} = STRFData(i).STRF1A;
    STRF2Ash{i} = STRFData(i).STRF2A;
    STRF1Bsh{i} = STRFData(i).STRF1B;
    STRF2Bsh{i} = STRFData(i).STRF2B;
end

clear STRFData

% load STRF
file_name = strcat(DATE, '_STRF_', DEPTH);
load(file_name);

RF1P = getSTRFParam(STRFData); % obtain STRF params

STRFBootData = STRFData;
clear STRFData
for i=1:16
    STRFBootData(i).STRF1Ash = STRF1Ash{i};
    STRFBootData(i).STRF2Ash = STRF2Ash{i};
    STRFBootData(i).STRF1Bsh = STRF1Bsh{i};
    STRFBootData(i).STRF2Bsh = STRF2Bsh{i};
end

% Calculate the reliability of the STRFs
% alpha = 0.05;
% NB = 10;

for i=1:16
    STRFSig(i) = wstrfreliability(STRFBootData(i),alpha,NB);
end

params.data_file_name = DATA_FILE_NAME;
params.alpha = alpha;
params.nBoot = NB;
% save
disp('saving STRF reliability index');
save_file_name = strcat(DATE, '_STRFReliability');
save(save_file_name,'STRFSig','RF1P','params');

disp('done!');
end