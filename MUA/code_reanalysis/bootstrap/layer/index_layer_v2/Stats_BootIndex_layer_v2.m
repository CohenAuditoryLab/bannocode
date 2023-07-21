clear all;

DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap\layer\bargraph';
FUNC_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap';
FUNC_PATH2 = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\Streaming_Index';
addpath(genpath(DATA_PATH));
addpath(FUNC_PATH);
addpath(FUNC_PATH2);
% % load data
% load Index_Boot
% load Index_Layer
load Index_ABB_Bargraph.mat
load Index_ABB_Boot_post.mat
load Index_ABB_Boot_ant.mat

% choose triplet position to show
sTriplet = {'1st','2nd','3rd','T-3','T-2','T-1','T','T+1'};
% tpos = [1 2 3 6 7]; % 1st to T triplet
% tpos = [1 2 3 6 7 8]; % 1st to T+1 triplet
% tpos = 4:8; % T-3 to T_1 triplet
tpos = 1:8; % all periods
% choose Anteior-Posterior or Core-Belt
area_type = 'AP'; % either AP (anterior vs posterior) or CB (core vs belt)
% line_color = [229 0 125; 78 186 25] / 255;
line_color_p = [157 195 230; 46 117 182; 31 78 121] / 255;
line_color_n = [244 177 131; 197 90 17; 132 60 12] / 255;

nTpos = length(sTriplet);
% index values in layers in primary and non-primary areas
[smi_p,smi_n] = get_layerindex(1:nTpos,SMI_A_layer,area_type);
[fsi_p,fsi_n] = get_layerindex(1:nTpos,SMI_BB_layer,area_type);
[bmi_p,bmi_n] = get_layerindex(1:nTpos,BMI_ABB_layer,area_type);

% bootstrapped index values
smi_p.boot = SMI_A_post.boot;
smi_n.boot = SMI_A_ant.boot;
fsi_p.boot = SMI_BB_post.boot;
fsi_n.boot = SMI_BB_ant.boot;
bmi_p.boot = BMI_ABB_post.boot;
bmi_n.boot = BMI_ABB_ant.boot;

%% statistical analysis
% % % perform Kruskal-Wallis test % % %
% SMI posterior: trun the last variable of kruskal wallis 'on' to get chi-sq value 
pSMI_post(1,:) = kruskalwallis(smi_p.s(:,tpos),[],'off'); % superficial layer
pSMI_post(2,:) = kruskalwallis(smi_p.g(:,tpos),[],'off'); % middle layer
pSMI_post(3,:) = kruskalwallis(smi_p.i(:,tpos),[],'off'); % deep layer
% FSI posterior
pFSI_post(1,:) = kruskalwallis(fsi_p.s(:,tpos),[],'off'); % turn it 'on' to get chi-sq value
pFSI_post(2,:) = kruskalwallis(fsi_p.g(:,tpos),[],'off');
pFSI_post(3,:) = kruskalwallis(fsi_p.i(:,tpos),[],'off');
% BMI posterior
pBMI_post(1,:) = kruskalwallis(bmi_p.s(:,tpos),[],'off'); % turn it 'on' to get chi-sq value
pBMI_post(2,:) = kruskalwallis(bmi_p.g(:,tpos),[],'off');
pBMI_post(3,:) = kruskalwallis(bmi_p.i(:,tpos),[],'off');
pKW_post = [pSMI_post pFSI_post pBMI_post];

% SMI anterior
pSMI_ant(1,:) = kruskalwallis(smi_n.s(:,tpos),[],'off'); % superficial layer
pSMI_ant(2,:) = kruskalwallis(smi_n.g(:,tpos),[],'off'); % middle layer
pSMI_ant(3,:) = kruskalwallis(smi_n.i(:,tpos),[],'off'); % deep layer
% FSI anterior
pFSI_ant(1,:) = kruskalwallis(fsi_n.s(:,tpos),[],'off'); % turn it 'on' to get chi-sq value
pFSI_ant(2,:) = kruskalwallis(fsi_n.g(:,tpos),[],'off');
pFSI_ant(3,:) = kruskalwallis(fsi_n.i(:,tpos),[],'off');
% BMI anterior
pBMI_ant(1,:) = kruskalwallis(bmi_n.s(:,tpos),[],'off'); % turn it 'on' to get chi-sq value
pBMI_ant(2,:) = kruskalwallis(bmi_n.g(:,tpos),[],'off');
pBMI_ant(3,:) = kruskalwallis(bmi_n.i(:,tpos),[],'off');
pKW_ant = [pSMI_ant pFSI_ant pBMI_ant];

% % % Friedman test (layer comparison) % % %
pFr_post(:,1)  = stats_CompLayers_Friedman_v2(smi_p,tpos);
pFr_post(:,2)  = stats_CompLayers_Friedman_v2(fsi_p,tpos);
pFr_post(:,3)  = stats_CompLayers_Friedman_v2(bmi_p,tpos);
pFr_ant(:,1)   = stats_CompLayers_Friedman_v2(smi_n,tpos);
pFr_ant(:,2)   = stats_CompLayers_Friedman_v2(fsi_n,tpos);
pFr_ant(:,3)   = stats_CompLayers_Friedman_v2(bmi_n,tpos);
% pFr_behav_cb(:,1) = stats_CompLayers_Friedman(dBehav_CB.A.c,dBehav_CB.A.b);
% pFr_behav_cb(:,2) = stats_CompLayers_Friedman(dBehav_CB.B1.c,dBehav_CB.B1.b);
% pFr_behav_cb(:,3) = stats_CompLayers_Friedman(dBehav_CB.B2.c,dBehav_CB.B2.b);

% % % Scheirer-Ray-Hare test % % %
pSRH_post(:,1) = stats_CompLayers_SRHtest_v2(smi_p,tpos);
pSRH_post(:,2) = stats_CompLayers_SRHtest_v2(fsi_p,tpos);
pSRH_post(:,3) = stats_CompLayers_SRHtest_v2(bmi_p,tpos);
pSRH_ant(:,1)  = stats_CompLayers_SRHtest_v2(smi_n,tpos);
pSRH_ant(:,2)  = stats_CompLayers_SRHtest_v2(fsi_n,tpos);
pSRH_ant(:,3)  = stats_CompLayers_SRHtest_v2(bmi_n,tpos);
% to get more info, try
% [p,tbl,mc] = stats_CompLayers_SRHtest_v2(smi_p, tpos);




% %% plot data smi
% % figure("Position",[100 100 800 450]);
% figure("Position",[100 100 550 650]);
% subplot(3,2,1);
% plot_index_boot(tpos,smi_p.boot); hold on
% h(1) = plot_errorbar(smi_p.s(:,tpos),-0.04); 
% h(2) = plot_errorbar(smi_p.g(:,tpos), 0.00);
% h(3) = plot_errorbar(smi_p.i(:,tpos), 0.04);
% for i=1:3
%     set(h(i),'Color',line_color_p(i,:));
% end
% % set(gca,'XTick',1:length(tpos),'XTickLabel',sTriplet(tpos));
% xlabel('triplet position'); ylabel('log(CI)');
% xlim([0.5 length(tpos)+0.5]);
% title('Posterior');
% box off
% 
% subplot(3,2,2);
% plot_index_boot(tpos,smi_n.boot); hold on
% h(1) = plot_errorbar(smi_n.s(:,tpos),-0.04); 
% h(2) = plot_errorbar(smi_n.g(:,tpos), 0.00);
% h(3) = plot_errorbar(smi_n.i(:,tpos), 0.04);
% for i=1:3
%     set(h(i),'Color',line_color_n(i,:));
% end
% % set(gca,'XTick',1:length(tpos),'XTickLabel',sTriplet(tpos));
% xlabel('triplet position'); ylabel('log(CI)');
% xlim([0.5 length(tpos)+0.5]);
% title('Anterior');
% box off
% 
% subplot(3,2,3);
% plot_index_boot(tpos,fsi_p.boot); hold on
% h(1) = plot_errorbar(fsi_p.s(:,tpos),-0.04); 
% h(2) = plot_errorbar(fsi_p.g(:,tpos), 0.00);
% h(3) = plot_errorbar(fsi_p.i(:,tpos), 0.04);
% for i=1:3
%     set(h(i),'Color',line_color_p(i,:));
% end
% % set(gca,'XTick',1:length(tpos),'XTickLabel',sTriplet(tpos));
% xlabel('triplet position'); ylabel('log(FSI)');
% xlim([0.5 length(tpos)+0.5]);
% title('Posterior');
% box off
% % legend({'','','superficial','middle','deep'});
% 
% subplot(3,2,4);
% plot_index_boot(tpos,fsi_n.boot); hold on
% h(1) = plot_errorbar(fsi_n.s(:,tpos),-0.04); 
% h(2) = plot_errorbar(fsi_n.g(:,tpos), 0.00);
% h(3) = plot_errorbar(fsi_n.i(:,tpos), 0.04);
% for i=1:3
%     set(h(i),'Color',line_color_n(i,:));
% end
% % set(gca,'XTick',1:length(tpos),'XTickLabel',sTriplet(tpos));
% xlabel('triplet position'); ylabel('log(FSI)');
% xlim([0.5 length(tpos)+0.5]);
% title('Anterior');
% box off
% % legend({'','','superficial','middle','deep'});
% 
% %% plot data bmi
% % figure("Position",[100 100 800 450]);
% subplot(3,2,5);
% plot_index_boot(tpos,bmi_p.boot); hold on
% h(1) = plot_errorbar(bmi_p.s(:,tpos),-0.04); 
% h(2) = plot_errorbar(bmi_p.g(:,tpos), 0.00);
% h(3) = plot_errorbar(bmi_p.i(:,tpos), 0.04);
% for i=1:3
%     set(h(i),'Color',line_color_p(i,:));
% end
% % set(gca,'XTick',1:length(tpos),'XTickLabel',sTriplet(tpos));
% xlabel('triplet position'); ylabel('BMI');
% xlim([0.5 length(tpos)+0.5]);
% title('Posterior');
% box off
% legend({'','','superficial','middle','deep'},'Location','northwest');
% 
% subplot(3,2,6);
% plot_index_boot(tpos,bmi_n.boot); hold on
% h(1) = plot_errorbar(bmi_n.s(:,tpos),-0.04); 
% h(2) = plot_errorbar(bmi_n.g(:,tpos), 0.00);
% h(3) = plot_errorbar(bmi_n.i(:,tpos), 0.04);
% for i=1:3
%     set(h(i),'Color',line_color_n(i,:));
% end
% % set(gca,'XTick',1:length(tpos),'XTickLabel',sTriplet(tpos));
% xlabel('triplet position'); ylabel('BMI');
% xlim([0.5 length(tpos)+0.5]);
% title('Anterior');
% box off
% legend({'','','superficial','middle','deep'},'Location','northwest');

