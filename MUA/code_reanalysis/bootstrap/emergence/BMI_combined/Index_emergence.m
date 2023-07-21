% obtain index values for each channel
% code modified from Bootstrap_index_tpos.m
clear all

% path for data
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap\layer\bargraph');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');
% path for function stats_CompLayers.m...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');

% set variables
isSave = 1;
isFigure = 0;

% load data
load MUAResponse_ABB_all; % extended to T+1 triplet

% calculate BMI on triplet combined data
rABB_all  = rALL.ABB; 

% get index values for each channel
[SMI_triplet,BMI_triplet] = get_SMIBMI_channel(rABB_all,area_index,AP_index);

if isSave==1
    save('Index_triplet','SMI_triplet','BMI_triplet');
end

% % % % plot data for checking % % %
if isFigure==1
    tpos = 4:7;
    line_color = [229 0 125; 78 186 25] / 255;
    figure;
    % bmi
    plot_index_v3(tpos,BMI_triplet.core,-0.05,line_color(1,:)); hold on
    plot_index_v3(tpos,BMI_triplet.belt,+0.05,line_color(2,:));
    % plot_index_boot(tpos,SMI_A.boot);
end