% modified from Comp_index_area_emergenceOnset2_1.m
% average ABB triplet in each triplet position then examine the time course
% of the averaged index
clear all

% path for function (stats_CompLayers.m)...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('../'); % path for data and dunn.m
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');

jitter = 0.04;
line_color = [229 0 125; 78 186 25] / 255;


% load data
load SMIBMI_Area_ABB.mat;

% pick data around the target
i_tpos = 4:7; % specify T-3 to T triplet
smi_core = SMI_Area.core(:,i_tpos);
smi_belt = SMI_Area.belt(:,i_tpos);
bmi_core = BMI_Area.core(:,i_tpos);
bmi_belt = BMI_Area.belt(:,i_tpos);


% plot index
figure;
subplot(2,2,1);
plot_IndexAverage_area_emergenceOnset(smi_core,-jitter,'Stim',line_color(1,:));
plot_IndexAverage_area_emergenceOnset(smi_belt,jitter,'Stim',line_color(2,:));

figure;
subplot(2,2,1);
plot_IndexAverage_area_emergenceOnset(bmi_core,-jitter,'Behav',line_color(1,:));
plot_IndexAverage_area_emergenceOnset(bmi_belt,jitter,'Behav',line_color(2,:));

% statistical comparison...
p_behav = stats_CompLayers_emergenceOnset_Friedman(bmi_core,bmi_belt);
p_stim = stats_CompLayers_emergenceOnset_Friedman(smi_core,smi_belt);

% Dann's test for post-hoc analysis...