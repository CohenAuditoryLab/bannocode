clear all

% path for function stats_CompLayers.m...
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap\layer');

% set variables
% nBoot = 0;
isSave = 1;

% load data
load LayerAssignment;
load MUAResponse_ABB_all; % extended to T+1 triplet

rA_all   = rALL.A;
rBB_all  = rALL.BB;
rABB_all = rALL.ABB;

[SMI_A_layer,BMI_A_layer] = get_SMIBMI_bargraph(rA_all,area_index,AP_index,depth_index);
[SMI_BB_layer,BMI_BB_layer] = get_SMIBMI_bargraph(rBB_all,area_index,AP_index,depth_index);
[SMI_ABB_layer,BMI_ABB_layer] = get_SMIBMI_bargraph(rABB_all,area_index,AP_index,depth_index);

if isSave==1
    save('Index_ABB_Bargraph','SMI_A_layer','SMI_BB_layer','SMI_ABB_layer', ...
                          'BMI_A_layer','BMI_BB_layer','BMI_ABB_layer');
end


