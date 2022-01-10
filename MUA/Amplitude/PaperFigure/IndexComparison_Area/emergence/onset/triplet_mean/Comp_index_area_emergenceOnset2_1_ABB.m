% modified from Comp_index_area_emergenceOnset2_1.m
% average ABB triplet in each triplet position then examine the time course
% of the averaged index
clear all

% path for function (stats_CompLayers.m)...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('../'); % path for data and dunn.m
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');

% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% sTriplet = {'Tm3','Tm2','Tm1','T'};
% line_color = [229 0 125; 78 186 25] / 255;
jitter = 0.04;
line_color = [229 0 125; 78 186 25] / 255;

% load data (baseline)
% load SMIBMI_Area.mat
load SMIBMI_Area_ABB.mat;
% i_baseline = 2:3; % choose baseline triplet
i_baseline = 3; % choose baseline triplet (2 in original code...)
smi_core_bl = mean(SMI_Area.core(:,i_baseline),2);
smi_belt_bl = mean(SMI_Area.belt(:,i_baseline),2);
bmi_core_bl = mean(BMI_Area.core(:,i_baseline),2);
bmi_belt_bl = mean(BMI_Area.belt(:,i_baseline),2);
% clear SMI_Area BMI_Area sTriplet

% load data around the target
i_tpos = 4:7; % specify T-3 to T triplet
smi_core_wBL = [smi_core_bl SMI_Area.core(:,i_tpos)];
smi_belt_wBL = [smi_belt_bl SMI_Area.belt(:,i_tpos)];
bmi_core_wBL = [bmi_core_bl BMI_Area.core(:,i_tpos)];
bmi_belt_wBL = [bmi_belt_bl BMI_Area.belt(:,i_tpos)];

% % get triplet mean
% mSMI_core_wBL = mean(smi_core_wBL,3);
% mSMI_belt_wBL = mean(smi_belt_wBL,3);
% mBMI_core_wBL = mean(bmi_core_wBL,3);
% mBMI_belt_wBL = mean(bmi_belt_wBL,3);

% plot index with baseline
figure;
subplot(2,2,1);
plot_IndexAverage_area_emergenceOnset_wBL(smi_core_wBL,-jitter,'Stim',line_color(1,:));
plot_IndexAverage_area_emergenceOnset_wBL(smi_belt_wBL,jitter,'Stim',line_color(2,:));

figure;
subplot(2,2,1);
plot_IndexAverage_area_emergenceOnset_wBL(bmi_core_wBL,-jitter,'Behav',line_color(1,:));
plot_IndexAverage_area_emergenceOnset_wBL(bmi_belt_wBL,jitter,'Behav',line_color(2,:));

p_behav = stats_CompLayers_emergenceOnset_Friedman(bmi_core_wBL,bmi_belt_wBL);
% p_stim = stats_CompLayers_emergenceOnset_Friedman(smi_core_wBL,smi_belt_wBL);

% Dann's test for post-hoc analysis...