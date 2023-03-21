function [ STRFSig, RF1P, params ] = getSTRFSignificance( ANIMAL, STRFData, shSTRFData, alpha, NB )
% obtain STRF reliability
disp('calculating STRF reliability index');

% clear all;
% addpath('C:\STRF_files\matlab\keck'); 
% DATE = DATA_FILE_NAME(1:8);
% DEPTH = DATA_FILE_NAME(end-2:end);

if strcmp(ANIMAL,'Domo')
    n_ch = 16;
elseif strcmp(ANIMAL,'Cassius')
    n_ch = 24;
end
% shuffled STRF
for i=1:n_ch
    STRF1Ash{i} = shSTRFData(i).STRF1A;
    STRF2Ash{i} = shSTRFData(i).STRF2A;
    STRF1Bsh{i} = shSTRFData(i).STRF1B;
    STRF2Bsh{i} = shSTRFData(i).STRF2B;
end

clear shSTRFData

% unshuffled STRF
RF1P = getSTRFParam(ANIMAL,STRFData); % obtain STRF params

% construct STRFBootData
STRFBootData = STRFData;
clear STRFData
for i=1:n_ch
    % add shuffuled data...
    STRFBootData(i).STRF1Ash = STRF1Ash{i};
    STRFBootData(i).STRF2Ash = STRF2Ash{i};
    STRFBootData(i).STRF1Bsh = STRF1Bsh{i};
    STRFBootData(i).STRF2Bsh = STRF2Bsh{i};
end

% Calculate the reliability of the STRFs
% alpha = 0.05;
% NB = 10;

for i=1:n_ch
    STRFSig(i) = wstrfreliability(STRFBootData(i),alpha,NB);
end

% params.data_file_name = DATA_FILE_NAME;
params.alpha = alpha;
params.nBoot = NB;

% % save
% disp('saving STRF reliability index');
% save_file_name = strcat(DATE, '_STRFReliability');
% save(save_file_name,'STRFSig','RF1P','params');

disp('done!');
end