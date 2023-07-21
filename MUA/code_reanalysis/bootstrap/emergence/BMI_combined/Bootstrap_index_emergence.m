clear all

% path for data
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap\layer\bargraph');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');
% path for function stats_CompLayers.m...
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');

% set variables
nBoot = 1000;
isSave = 1;
isFigure = 1;

% load data
load MUAResponse_ABB_all; % extended to T+1 triplet

% calculate bootstrapped BMI on triplet combined data
rABB_all  = rALL.ABB; 

% get bootstrapped index values 
[SMI_triplet,BMI_triplet] = get_SMIBMI(rABB_all,area_index,AP_index,nBoot);

if isSave==1
    save('Index_Boot_emergence','SMI_triplet','BMI_triplet','nBoot');
end

% % % % plot data for checking % % %
if isFigure==1
    tpos = 4:7;
    figure;
    % bmi
    plot_index_boot(tpos,BMI_triplet.boot);
end