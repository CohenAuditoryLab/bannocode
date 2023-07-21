clear all

% path for function stats_CompLayers.m...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
% addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
% addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer');

% ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude';
% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% sTriplet = {'1st','2nd','3rd','Tm1','T'};
% line_color = [229 0 125; 78 186 25] / 255;
% nBoot = 1000;
isSave = 1;

% load data
load LayerAssignment;
load MUAResponse_all; % extended to T+1 triplet

rA_all  = rALL.A;
rB1_all = rALL.B1;
rB2_all = rALL.B2;

[SMI_A_layer,BMI_A_layer] = get_SMIBMI_layer(rA_all,area_index,AP_index,depth_index);
[SMI_B1_layer,BMI_B1_layer] = get_SMIBMI_layer(rB1_all,area_index,AP_index,depth_index);
[SMI_B2_layer,BMI_B2_layer] = get_SMIBMI_layer(rB2_all,area_index,AP_index,depth_index);

if isSave==1
    save('Index_Layer','SMI_A_layer','SMI_B1_layer','SMI_B2_layer', ...
                       'BMI_A_layer','BMI_B1_layer','BMI_B2_layer');
end


