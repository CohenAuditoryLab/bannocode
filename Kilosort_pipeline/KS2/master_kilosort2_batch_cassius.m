%% you need to change most of the paths in this block
addpath(genpath('C:\Users\Cohen\multichannel_sorting\KiloSort2')) % path to kilosort2 folder
addpath(genpath('C:\Users\Cohen\multichannel_sorting\npy-matlab')) % path to npy-matlab scripts

% pathToYourConfigFile = 'C:\Users\Cohen\multichannel_sorting\configFiles\'; % take from Github folder and put it somewhere else (together with the master_file)
% run(fullfile(pathToYourConfigFile, 'Config_KS2_24ch.m')) %Lalitta used this??

pathToYourConfigFile = 'D:\Cassius\KSSpikeSorting\0_ConfigFiles';
run(fullfile(pathToYourConfigFile, 'config_cassius_24ch_KS2.m'));

% rootH = 'H:\kiloSorted\MrCassius-190324\AudiResp_24_24-190324-173909\';
rootH = 'D:\Cassius\KSSpikeSorting';
ops.fproc       = fullfile(rootH, 'temp_wh.dat'); % proc file on a fast SSD
ops.chanMap = fullfile(pathToYourConfigFile, 'chanMap_sprobe24ch.mat');

ops.trange = [0 Inf]; % time range to sort
ops.NchanTOT    = 24; % total number of channels in your recording

% the binary file is in this folder
rootZ = 'D:\Cassius\KSSpikeSorting\ABBA';

%% this block runs all the steps of the algorithm
fprintf('Looking for data inside %s \n', rootZ)

% % is there a channel map file in this folder?
% fs = dir(fullfile(rootZ, 'chan*.mat'));
% if ~isempty(fs)
%     ops.chanMap = fullfile(rootZ, fs(1).name);
% end

% find the binary file
% fs          = [dir(fullfile(rootZ, '*.bin')) dir(fullfile(rootZ, 'con*.dat'))];
fs = dir('D:\Cassius\KSSpikeSorting\ABBA');
fs=fs(3:end);
nFiles = length(fs);
for ff = nFiles %1:nFiles
ops.fbinary = fullfile(rootZ, fs(ff).name, 'continuous.dat');

% rootZ_save = [rootZ filesep num2str(ff) filesep];
rootZ_save = [rootZ filesep fs(ff).name filesep];
if ~exist(rootZ_save,'dir')
    mkdir(rootZ_save)
end

% preprocess data to create temp_wh.dat
rez = preprocessDataSub(ops);

% time-reordering as a function of drift
rez = clusterSingleBatches(rez);
save(fullfile(rootZ_save, 'rez.mat'), 'rez', '-v7.3');

% main tracking and template matching algorithm
rez = learnAndSolve8b(rez);

% final merges
rez = find_merges(rez, 1);

% final splits by SVD
rez = splitAllClusters(rez, 1);

% final splits by amplitudes
rez = splitAllClusters(rez, 0);

% decide on cutoff
rez = set_cutoff(rez);

fprintf('found %d good units \n', sum(rez.good>0))

% write to Phy
fprintf('Saving results to Phy  \n')
rezToPhy(rez, rootZ_save);

%% if you want to save the results to a Matlab file... 

% discard features in final rez file (too slow to save)
rez.cProj = [];
rez.cProjPC = [];

% save final results as rez2
fprintf('Saving final results in rez2  \n')
fname = fullfile(rootZ_save, 'rez2.mat');
save(fname, 'rez', '-v7.3');

end