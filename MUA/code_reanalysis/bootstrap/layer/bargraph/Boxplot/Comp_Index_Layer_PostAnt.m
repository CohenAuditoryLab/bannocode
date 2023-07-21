% 1/31/22 re-analyzed the data
% first obtain z-scored index by Get_zIndex_ver3 then plot and compare the
% z-scored data...

clear all;
addpath(genpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap'));
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary\z_score');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary');

% tpos_type = '_Tp1'; %[];
sTriplet = {'1st','2nd','3rd','T-3','T-2','T-1','T','T+1'};
% tpos = [1 6 7]; %[1 2 3 6 7]; % choose triplet position for display
tpos = 1:8; %[1 2 3 6 7]; % choose triplet position for display
area_type = 'AP';

% load file
load Index_ABB_Bargraph.mat
load Index_ABB_Boot_post.mat
load Index_ABB_Boot_ant.mat
list_SMIBMI = {'FSI','SMI','BMI'}; % choose SMI or BMI

for j=1:length(tpos)
    % index values in layers in primary and non-primary areas
    [smi_p,smi_n] = get_layerindex(tpos(j),SMI_A_layer,area_type);
    [fsi_p,fsi_n] = get_layerindex(tpos(j),SMI_BB_layer,area_type);
    [bmi_p,bmi_n] = get_layerindex(tpos(j),BMI_ABB_layer,area_type);

%     smi_layer = combine_index_layer(smi_p,smi_n);
%     fsi_layer = combine_index_layer(fsi_p,fsi_n);
%     bmi_layer = combine_index_layer(bmi_p,bmi_n);

    % Kruskal-Wallis test
%     pSMI(:,j) = stats_CompLayer_KWtest(smi_layer);
%     pFSI(:,j) = stats_CompLayer_KWtest(fsi_layer);
%     pBMI(:,j) = stats_CompLayer_KWtest(bmi_layer);
    [pSMI_post(:,j),ppSMI_post(:,j),xsqSMI_post(:,j),zSMI_post(:,j)] = stats_CompLayer_KWtest(smi_p);
    [pFSI_post(:,j),ppFSI_post(:,j),xsqFSI_post(:,j),zFSI_post(:,j)] = stats_CompLayer_KWtest(fsi_p);
    [pBMI_post(:,j),ppBMI_post(:,j),xsqBMI_post(:,j),zBMI_post(:,j)] = stats_CompLayer_KWtest(bmi_p);

    [pSMI_ant(:,j),ppSMI_ant(:,j),xsqSMI_ant(:,j),zSMI_ant(:,j)] = stats_CompLayer_KWtest(smi_n);
    [pFSI_ant(:,j),ppFSI_ant(:,j),xsqFSI_ant(:,j),zFSI_ant(:,j)] = stats_CompLayer_KWtest(fsi_n);
    [pBMI_ant(:,j),ppBMI_ant(:,j),xsqBMI_ant(:,j),zBMI_ant(:,j)] = stats_CompLayer_KWtest(bmi_n);
end

% % % bootstrapped index values
% % smi_p.boot = SMI_A_post.boot(:,tpos);
% % smi_n.boot = SMI_A_ant.boot(:,tpos);
% % fsi_p.boot = SMI_BB_post.boot(:,tpos);
% % fsi_n.boot = SMI_BB_ant.boot(:,tpos);
% % bmi_p.boot = BMI_ABB_post.boot(:,tpos);
% % bmi_n.boot = BMI_ABB_ant.boot(:,tpos);

% % boxplot data...
% selected_triplet = sTriplet(tpos);
% figure;
% subplot(2,1,1);
% boxplot_index_layer(smi_p,selected_triplet);
% subplot(2,1,2);
% boxplot_index_layer(smi_n,selected_triplet);
% 
% figure;
% subplot(2,1,1);
% boxplot_index_layer(fsi_p,selected_triplet);
% subplot(2,1,2);
% boxplot_index_layer(fsi_n,selected_triplet);
% 
% figure;
% subplot(2,1,1);
% boxplot_index_layer(bmi_p,selected_triplet);
% subplot(2,1,2);
% boxplot_index_layer(bmi_n,selected_triplet);

