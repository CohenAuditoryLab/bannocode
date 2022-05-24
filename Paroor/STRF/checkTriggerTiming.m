

%% Housekeeping
% Clear workspace and close existing figures. Add SDK directories to Matlab
% path.
close all; clear all; clc;
DATE = '20210504';
SDK_PATH = 'C:\TDT\TDTMatlabSDK'; % path to the functions accessing the Tank files
DATA_PATH = fullfile('D:\TDT\Tanks',['Cassius-' DATE(3:end)]);
BLOCK_PATH = fullfile(DATA_PATH,[DATE '_TriggerCheck']);
% [MAINEXAMPLEPATH,name,ext] = fileparts(cd); % \TDTMatlabSDK\Examples
% [SDKPATH,name,ext] = fileparts(MAINEXAMPLEPATH); % \TDTMatlabSDK
addpath(genpath(SDK_PATH));
% saving_dir = fullfile('D:\Cassius\02_TUNING_TEST',DATE);

% load data
data = TDTbin2mat(BLOCK_PATH, 'TYPE', {'epocs', 'streams'});

% get trigger from readtank_mua_input.m
% must be identical to data.epocs.TTrg.onset
Block = strcat(DATE,'_TriggerCheck');
ch = 1;
Data = readtank_mwa_input_tb(DATA_PATH,Block,ch,'local');
TTrg2 = Data.Trig;

TTrg = data.epocs.TTrg;
STMM = data.streams.STMM;

% check trigger timing
% trg_onset = TTrg.onset;
% trg_from_readtank = TTrg2;
% trg_analog = STMM.data;

% set temporal window
EpochStart = -0.005; % -5 ms
EpochEnd = 0.030; % 30 ms
fs = STMM.fs; % sampling frequency of analog data
SampPeriod = 1/fs;
time = EpochStart:SampPeriod:EpochEnd; 
time = time' * 1000; % convert time in ms

EpochDuration = EpochEnd - EpochStart;
tempdata = TDTfilter(data, 'TTrg', 'TIME', [EpochStart, EpochDuration]);
STMM = tempdata.streams.STMM;

% plot
nTrig = numel(TTrg2); % number of trigger
figure; hold on
for i=1:nTrig
    plot(time,STMM.filtered{i}(1:end-1));
end
plot([0 0],[-1 6],':k');
xlabel('Time from Digital Trigger [ms]');
ylabel('Voltage');
title('Analog Trigger');

% save data
save_file_name = strcat(DATE,'_TriggerCheck');
% save(save_file_name,'TTrg','STMM','TTrg2');