clear all

% path for function (stats_CompLayers.m)...
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('../');

% load data
% load MUAResponse_Layer.mat; % original layer assignment
load MUAResponse_Layer_emergence;

% Core
BMI_core = display_Index(rCore,'Behav');
SMI_core = display_Index(rCore,'Stim');
% Belt
BMI_belt = display_Index(rBelt,'Behav');
SMI_belt = display_Index(rBelt,'Stim');
close all;

figure;
subplot(2,2,1);
smi_a = display_Index_LayerArea_emergence(SMI_core.A,SMI_belt.A,'Stim');
[p_stim(:,1)]  = stats_CompLayerArea_Friedman(smi_a); % Friedman test
title('A');
subplot(2,2,3);
smi_b1 = display_Index_LayerArea_emergence(SMI_core.B1,SMI_belt.B1,'Stim');
[p_stim(:,2)]  = stats_CompLayerArea_Friedman(smi_b1); % Friedman test
title('B1');
subplot(2,2,4);
smi_b2 = display_Index_LayerArea_emergence(SMI_core.B2,SMI_belt.B2,'Stim');
[p_stim(:,3)]  = stats_CompLayerArea_Friedman(smi_b2); % Friedman test
title('B2');
legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);

figure;
subplot(2,2,1);
bmi_a = display_Index_LayerArea_emergence(BMI_core.A,BMI_belt.A,'Behav');
[p_behav(:,1)]  = stats_CompLayerArea_Friedman(bmi_a); % Friedman test
title('A');
subplot(2,2,3);
bmi_b1 = display_Index_LayerArea_emergence(BMI_core.B1,BMI_belt.B1,'Behav');
[p_behav(:,2)]  = stats_CompLayerArea_Friedman(bmi_b1); % Friedman test
title('B1');
subplot(2,2,4);
bmi_b2 = display_Index_LayerArea_emergence(BMI_core.B2,BMI_belt.B2,'Behav');
[p_behav(:,3)]  = stats_CompLayerArea_Friedman(bmi_b2); % Friedman test
title('B2');
legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);


