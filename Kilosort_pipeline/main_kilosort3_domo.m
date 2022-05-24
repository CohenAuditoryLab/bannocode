%% you need to change most of the paths in this block

addpath(genpath('C:\Users\Cohen\multichannel_sorting\KiloSort3')) % path to kilosort folder
addpath('C:\Users\Cohen\multichannel_sorting\npy-matlab') % for converting to Phy
rootZ = 'G:\Domo\Kilosort\KS1'; % the raw data binary file is in this folder
rootH = 'G:\Domo\Kilosort'; % path to temporary binary file (same size as data, should be on fast SSD)
pathToYourConfigFile = 'G:\Domo\Kilosort\ConfigFiles'; % take from Github folder and put it somewhere else (together with the master_file)
chanMapFile = 'chanMap_16ch.mat';

ops.trange    = [0 Inf]; % time range to sort
ops.NchanTOT  = 16; % total number of channels in your recording

run(fullfile(pathToYourConfigFile, 'config_domo_KS3.m'))
ops.fproc   = fullfile(rootH, 'temp_wh.dat'); % proc file on a fast SSD
ops.chanMap = fullfile(pathToYourConfigFile, chanMapFile);
%% this block runs all the steps of the algorithm
fprintf('Looking for data inside %s \n', rootZ)

% main parameter changes from Kilosort2 to v2.5
ops.sig        = 20;  % spatial smoothness constant for registration
ops.fshigh     = 300; % high-pass more aggresively
ops.nblocks    = 0; %5; % blocks for registration. 0 turns it off, 1 does rigid registration. Replaces "datashift" option. 

% main parameter changes from Kilosort2.5 to v3.0
ops.Th       = [9 9];

% is there a channel map file in this folder?
% fs = dir(fullfile(rootZ, 'chan*.mat'));
% if ~isempty(fs)
%     ops.chanMap = fullfile(rootZ, fs(1).name);
% end

% find the binary file
% fs          = [dir(fullfile(rootZ, '*.bin')) dir(fullfile(rootZ, '*.dat'))];
fs = dir(rootZ);
fs = fs(3:end);
nFiles = length(fs);


for ff=3 %1:nFiles
% ops.fbinary = fullfile(rootZ, fs(1).name);
ops.fbinary = fullfile(rootZ, fs(ff).name, 'continuous.dat');

root_save = 'G:\Domo\Kilosort\KS3';
rootZ_save = [root_save filesep fs(ff).name filesep];
if ~exist(rootZ_save,'dir')
    mkdir(rootZ_save)
end


rez                = preprocessDataSub(ops);
rez                = datashift2(rez, 1);

[rez, st3, tF]     = extract_spikes(rez);

rez                = template_learning(rez, tF, st3);

[rez, st3, tF]     = trackAndSort(rez);

rez                = final_clustering(rez, tF, st3);

rez                = find_merges(rez, 1);

% save result...
% rootZ = fullfile(rootZ, 'kilosort3');
% mkdir(rootZ)
rezToPhy2(rez, rootZ_save);

end
%% 
