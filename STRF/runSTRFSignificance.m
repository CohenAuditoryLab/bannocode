clear all

% set up data directory
% DATA_DIR = 'C:\TDT\Synapse\Tanks\Domo-180813-182551';
% DATA_DIR = 'C:\TDT\Synapse\Tanks\Domo-181210';
DATA_DIR = 'C:\TDT\Synapse\Tanks\Ripple';
% LIST_DATA = {'20180709_Ripple_d02','20180727_Ripple2_d01','20180807_Ripple2_d01', ...
%     '20180907_Ripple2_d01','20181210_Ripple2_d01','20181212_Ripple2_d01','20190123_Ripple_d02','20190125_Ripple2_d01'};
% LIST_DATA = {'20190404_Ripple2_d01','20190409_Ripple2_d01','20190821_RippleF2_d02','20190828_RippleF2_d02', ...
%     '20190830_RippleF2_spk2_d02','20190904_RippleF2_spk2_d02','20190906_RippleF2_spk2_d03','20190910_RippleF2_spk2_d02'};

% LIST_DATA = {'20190125_Ripple2_d01'};
LIST_DATA = {'20190930_RippleF2_d01'};
% SPR_DIR = 'C:\STRF_files\ripple_96k\DNR_Cortex_96k5min.spr';
SPR_DIR = 'C:\STRF_files\ripple_96k_new\DNR_Cortex_96k5min_4_50.spr'; % fast DMR

% set parameters 
display_fig = 0;
alpha = 0.05;
NB = 100; % number of bootstrap

% compute STRF significance
for ff=1:numel(LIST_DATA)
    DATA_FILE_NAME = LIST_DATA{ff};
    % obtain STRF
    getSTRF_fromTDT(DATA_DIR,DATA_FILE_NAME,SPR_DIR,0);
    % obtain shuffled STRF
    getShuffledSTRF_fromTDT(DATA_DIR,DATA_FILE_NAME,SPR_DIR,0);
    % obtain STRF reliability index
    getSTRFSignificance(DATA_FILE_NAME,alpha,NB);
end