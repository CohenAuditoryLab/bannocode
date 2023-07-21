% 1/31/22 re-analyzed the data
% first obtain z-scored index by Get_zIndex_ver3 then plot and compare the
% z-scored data...

clear all;
addpath(genpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap'));
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary\z_score');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary');

% tpos_type = '_Tp1'; %[];
sTriplet = {'1st','2nd','3rd','T-3','T-2','T-1','T','T+1'};
tpos = [1 6 7]; %[1 2 3 6 7]; % choose triplet position for display
area_type = 'AP';

% load file
load Index_ABB_Bargraph.mat
load Index_ABB_Boot_post.mat
load Index_ABB_Boot_ant.mat
list_SMIBMI = {'FSI','SMI','BMI'}; % choose SMI or BMI

% index values in layers in primary and non-primary areas
[smi_p,smi_n] = get_layerindex(tpos,SMI_A_layer,area_type);
[fsi_p,fsi_n] = get_layerindex(tpos,SMI_BB_layer,area_type);
[bmi_p,bmi_n] = get_layerindex(tpos,BMI_ABB_layer,area_type);

% bootstrapped index values
smi_p.boot = SMI_A_post.boot(:,tpos);
smi_n.boot = SMI_A_ant.boot(:,tpos);
fsi_p.boot = SMI_BB_post.boot(:,tpos);
fsi_n.boot = SMI_BB_ant.boot(:,tpos);
bmi_p.boot = BMI_ABB_post.boot(:,tpos);
bmi_n.boot = BMI_ABB_ant.boot(:,tpos);

% boxplot data...
selected_triplet = sTriplet(tpos);
figure;
subplot(2,1,1);
boxplot_index_layer(smi_p,selected_triplet);
ylabel('CI (posterior)');
subplot(2,1,2);
boxplot_index_layer(smi_n,selected_triplet);
ylabel('CI (anterior)');

figure;
subplot(2,1,1);
boxplot_index_layer(fsi_p,selected_triplet);
ylabel('FSI (posterior)');
subplot(2,1,2);
boxplot_index_layer(fsi_n,selected_triplet);
ylabel('FSI (anterior)');

figure;
subplot(2,1,1);
boxplot_index_layer(bmi_p,selected_triplet);
ylabel('BMI (posterior)');
subplot(2,1,2);
boxplot_index_layer(bmi_n,selected_triplet);
ylabel('BMI (anterior)');
