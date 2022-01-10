clear all
close all

% set path to root directory
ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';

% params.RecordingDate = RecDate;
params.SampleRate = 24414; %original SR
params.Baseline = 1000; %baseline correction window in ms

figure('Position',[200 200 450 600]);
% % % % 20180709 ch9 % % % %
RecDate = '20180709';
ch = 9;
subplot(3,1,1);
% specify data directory
DATA_DIR = fullfile(ROOT_DIR,RecDate,'RESP');
% load data
data_file_name = strcat(RecDate,'_zMUAtriplet');
load(fullfile(DATA_DIR,data_file_name));
% plot FFT
meanMUA = zMUA.stdiff;
plot_FFT(meanMUA,t,ch,params);
legend({'8 st','24 st'},'Location',[0.80 0.86 0.1 0.05]);

% % % % 20200110 ch7 % % % %
RecDate = '20200110';
ch = 7;
subplot(3,1,2);
% specify data directory
DATA_DIR = fullfile(ROOT_DIR,RecDate,'RESP');
% load data
data_file_name = strcat(RecDate,'_zMUAtriplet');
load(fullfile(DATA_DIR,data_file_name));
% plot FFT
meanMUA = zMUA.stdiff;
plot_FFT(meanMUA,t,ch,params);
legend({'1 st','8 st'},'Location',[0.80 0.56 0.1 0.05]);

% % % % 20210220 ch5 % % % %
RecDate = '20210220';
ch = 5;
subplot(3,1,3);
% specify data directory
DATA_DIR = fullfile(ROOT_DIR,RecDate,'RESP');
% load data
data_file_name = strcat(RecDate,'_zMUAtriplet');
load(fullfile(DATA_DIR,data_file_name));
% plot FFT
meanMUA = zMUA.stdiff;
plot_FFT(meanMUA,t,ch,params);
legend({'4 st','24 st'},'Location',[0.80 0.26 0.1 0.05]);