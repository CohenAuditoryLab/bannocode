% set path for Matt's spike sorting pipeline
% addpath(genpath('C:\MatlabTools\SpikesortDataPipeline-master'));
addpath(genpath('/Users/work/Documents/MATLAB/SpikesortDataPipeline'));
animal = 'Cassius';

% list_date = {'20180807','20180820','20180821','20180822','20180823','20180827'};
% list_date = {'20180905_ABBAl_d01'};
list_date = {'20201214_ABBA_d01'};
% data_dir = 'C:\Taku\WCSpikeSorting\20180907_ABBA_d01';
% data_dir = 'C:\Taku\WCSpikeSorting\20180917_Ripple_d01';

for n=1:numel(list_date)
%     data_dir = fullfile('C:\Taku\KSSpikeSorting\',list_date{n},'ks2');
%     data_dir = fullfile('F:\kilosort_Domo',list_date{n});
    data_dir = fullfile('/Volumes/TOSHIBA_EXT/Kilosort',animal,list_date{n});
%     data_dir = 'C:\Taku\KSSpikeSorting\20180711\ks2';
    % data_dir = 'C:\Taku\WCSpikeSorting_resort_20190121\20180820_RippTOSTOSH/?le2_d03';
    data_type = 'kilo';
    new_directory = 'sorting_metrics';
    sampling_rate = 24414.0625;
    just_isi = 0;
    
    cd(data_dir);
    sorting_metrics(data_dir,data_type,new_directory,sampling_rate,just_isi);
end