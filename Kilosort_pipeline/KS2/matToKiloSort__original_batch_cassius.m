%function matToKiloSort__original(fbinary,fpath,num_channels)
%matToKiloSort  Run a KiloSort sorting reading data from streamer files.
%   matToKiloSort(fbinary,fpath,num_channels) will run KiloSort on fbinary
%   and save all data in fpath, including waveform graphs.
%   num_channels is needed to specify the exact number of channels in the
%   binary file.
%   splits each file into little snippets 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%Jan 25 2019 mod version that eventually will become the GUI that runs kilosort in the folder
%where the continous interleaved binary file lives
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% initialize variables
addpath(genpath('C:\Users\Cohen\multichannel_sorting\KiloSort1')) % path to kilosort folder
addpath(genpath('C:\Users\Cohen\multichannel_sorting\npy-matlab')) % path to npy-matlab scripts
pathToYourConfigFile = 'D:\Cassius\KSSpikeSorting\0_ConfigFiles';
% specify location to store data files for this simulation
% run the config file to build the structure of options (ops)
run(fullfile(pathToYourConfigFile, 'config_original_cassius_24ch.m'));
if ops.GPU, gpuDevice(1); end % initialize GPU
%Where files live
folders = dir('D:\Cassius\KSSpikeSorting\ABBA');
% folders = dir('D:\Cassius\KSSpikeSorting\STRF'); % test
folders=folders(3:end);

list_fileID = 1:length(folders); %specify data that you want to sort
list_fileID = 13;
for nn=list_fileID
    display(folders(nn).name);
    tic
    ops.fbinary             = fullfile(folders(nn).folder,folders(nn).name,'continuous.dat');
    fpath= fullfile(folders(nn).folder,folders(nn).name);
    %% process formatted data with KiloSort
    [rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes
%     [rez, DATA, uproj] = preprocessData_domo(ops); % preprocess data and extract spikes
    rez               = fitTemplates(rez, DATA, uproj); % fit templates iteratively
    rez_nomerge       = fullMPMU(rez, DATA); % extract final spike times (overlapping extraction)
    rez_merged        = merge_posthoc2(rez_nomerge); % use KiloSort's automerge functionality
    %% save files
    rezToPhy(rez_nomerge, [fpath '\']); % save python results file for Phy
    save(fullfile(fpath,  'rez.mat'), 'rez_nomerge', '-v7.3');
    %Merged files saved at merged folder
    folder_path_merged=[fpath '\merged'];
        if ~exist(folder_path_merged,'dir')
            mkdir(folder_path_merged)
        end
    rezToPhy(rez_merged, folder_path_merged); % save python results file for Phy
    save(fullfile(folder_path_merged,  'rez.mat'), 'rez_merged', '-v7.3');
    % final display of total runtime
    fprintf('KiloSort took %2.2f minutes to run \n', floor(toc/0.6)/100);
    clear rez DATA uproj rez_nomerge
   
   
end
