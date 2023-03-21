clear all

% specify data 
ANIMAL = 'Domo';
LIST_DATA = {'20181210_Ripple2_d01'}; % test
% LIST_DATA = {'20180709_Ripple_d02','20180727_Ripple2_d01','20180807_Ripple2_d01', ...
%     '20180907_Ripple2_d01','20181210_Ripple2_d01','20181212_Ripple2_d01', ...
%     '20190123_Ripple_d02','20190125_Ripple2_d01'}; % slow DMR
% LIST_DATA = {'20190404_Ripple2_d01','20190409_Ripple2_d01','20190821_RippleF2_d02', ...
%     '20190828_RippleF2_d02','20190830_RippleF2_spk2_d02','20190904_RippleF2_spk2_d02', ...
%     '20190906_RippleF2_spk2_d03','20190910_RippleF2_spk2_d02','20190930_RippleF2_d01'};
% LIST_DATA = {'20191009_RippleF2_d03','20191210_RippleF2_d02','20191220_RippleF2_d01', ...
%     '20200103_RippleF2_spk2_d01','20200110_RippleF2_spk2_d01','20200114_RippleF2_spk2_d02'};

% ANIMAL = 'Cassius';
% LIST_DATA = {'20201123_RippleF2_d01','20201127_RippleF2_d01','20201202_RippleF2_d01', ...
%     '20201214_RippleF2_d01','20201221_RippleF2_d01','20210104_RippleF2_d03','20210106_RippleF2_d03', ...
%     '20210111_RippleF2_d01','20210208_RippleF2_d01','20210210_RippleF2_d04','20210213_RippleF2_d03', ...
%     '20210220_RippleF2_d02','20210222_RippleF2_d03','20210224_RippleF2_d01','20210306_RippleF2_d01', ...
%     '20210308_RippleF2_d02','20210310_RippleF2_d03','20210313_RippleF2_d03','20210317_RippleF2_d02', ...
%     '20210324_RippleF2_d01','20210331_RippleF2_d01','20210403_RippleF2_d02'};

% speciry directory
TOOLBOX_DIR = 'C:\Users\Cohen\Documents\MATLAB\STRF_files\matlab';
TANK_DIR = 'G:\Domo\Tanks';
% TANK_DIR = 'G:\Cassius\Tanks';
SPR_DIR = 'C:\Users\Cohen\Documents\MATLAB\STRF_files\ripple_96k\DNR_Cortex_96k5min.spr'; % slow DMR
% SPR_DIR = 'C:\Users\Cohen\Documents\MATLAB\STRF_files\ripple_96k_4\DNR_Cortex_96k5min_4_50.spr'; % fast DMR

% set path for Monty's toolbox
addpath(fullfile(TOOLBOX_DIR,'keck'));
addpath(fullfile(TOOLBOX_DIR,'infotheory'));
addpath(fullfile(TOOLBOX_DIR,'STRF_ReliabilityIndex'));


% set parameters for strf reliability (wstrfreliability.m)
display_fig = 0;
alpha = 0.05;
NB = 100; % number of bootstrap

% compute STRF significance
for ff=1:numel(LIST_DATA)
    fName = LIST_DATA{ff};
    Block = strcat(ANIMAL,'-',fName(3:8));
    data_path = fullfile(TANK_DIR,Block);
    % obtain STRF
    STRF = getSTRF_fromTDT(ANIMAL,data_path,fName,SPR_DIR,0);
    % obtain shuffled STRF
    STRFsh = getShuffledSTRF_fromTDT(ANIMAL,data_path,fName,SPR_DIR,0);
    % obtain STRF reliability index
    [STRFSig,RF1P,params] = getSTRFSignificance(ANIMAL,STRF,STRFsh,alpha,NB);
    params.data_file_name = fName;
    
    save_file_name = strcat(fName(1:8),'_STRFReliability');
    save(save_file_name,'STRFSig','RF1P','params');
    clear STRF STRFsh STRFSig RF1P params
end