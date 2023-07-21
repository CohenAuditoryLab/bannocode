% define new index (streaming index) and compare them in hit and miss
% trials
clear all
DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Area';
isSave = 1;

% path for function stats_CompLayers.m...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer'); % layer assignment
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis'); %Recording Date

% load data
fName = 'MUAResponse_area_v1'; % tpos from 1st to T
load(fullfile(DATA_PATH,fName));
% load layer assignment
load('LayerAssignment.mat');
load('RecordingDate_Both.mat')

% separete layer assignment posterior vs anterior
depth_index_post = depth_index(:,AP_index==1);
depth_index_ant  = depth_index(:,AP_index==0);

% separate data into layers
rA_post = parseData_Layer(rPOS.A,depth_index_post); 
rB_post = parseData_Layer(rPOS.B1,depth_index_post);
rA_ant  = parseData_Layer(rANT.A,depth_index_ant); 
rB_ant  = parseData_Layer(rANT.B1,depth_index_ant);

% % concatenate data
rA_all.sup = cat(1,rA_post.sup,rA_ant.sup);
rA_all.mid = cat(1,rA_post.mid,rA_ant.mid);
rA_all.dep = cat(1,rA_post.dep,rA_ant.dep);
rB_all.sup = cat(1,rB_post.sup,rB_ant.sup);
rB_all.mid = cat(1,rB_post.mid,rB_ant.mid);
rB_all.dep = cat(1,rB_post.dep,rB_ant.dep);

AUC_post.sup = get_ROC_v2(rA_post.sup,rB_post.sup);
AUC_post.mid = get_ROC_v2(rA_post.mid,rB_post.mid);
AUC_post.dep = get_ROC_v2(rA_post.dep,rB_post.dep);
AUC_ant.sup  = get_ROC_v2(rA_ant.sup,rB_ant.sup);
AUC_ant.mid  = get_ROC_v2(rA_ant.mid,rB_ant.mid);
AUC_ant.dep  = get_ROC_v2(rA_ant.dep,rB_ant.dep);

AUC_all.sup  = get_ROC_v2(rA_all.sup,rB_all.sup);
AUC_all.mid  = get_ROC_v2(rA_all.mid,rB_all.mid);
AUC_all.dep  = get_ROC_v2(rA_all.dep,rB_all.dep);

% save
if isSave==1
    save_file_name = 'ROC_LvsH1_Layer';
    save(save_file_name,'AUC_post','AUC_ant','AUC_all','sTriplet');
end

% % plot AUC
% figure("Position",[150 150 800 450]); jitter = 0.04;
% subplot(2,3,1); hold on
% X = 1:length(sTriplet);
% Y = AUC_post.easy;
% errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
% Y = AUC_post.hard;
% errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% ylabel('AUROC');
% title('Posterior');
% 
% subplot(2,3,2); hold on
% X = 1:length(sTriplet);
% Y = AUC_ant.easy;
% errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
% Y = AUC_ant.hard;
% errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% ylabel('AUROC');
% title('Anterior');
% 
% subplot(2,3,3); hold on
% X = 1:length(sTriplet);
% Y = AUC_all.easy;
% errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
% Y = AUC_all.hard;
% errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% ylabel('AUROC');
% title('All Sites');
% legend({'large dF','small dF'});
% 
% subplot(2,3,4); hold on
% X = 1:length(sTriplet);
% Y = AUC_post.miss;
% errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
% Y = AUC_post.hit;
% errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% xlabel('Triplet Position'); ylabel('AUROC');
% title('Posterior');
% 
% subplot(2,3,5); hold on
% X = 1:length(sTriplet);
% Y = AUC_ant.miss;
% errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
% Y = AUC_ant.hit;
% errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% xlabel('Triplet Position'); ylabel('AUROC');
% title('Anterior');
% 
% subplot(2,3,6); hold on
% X = 1:length(sTriplet);
% Y = AUC_all.miss;
% errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
% Y = AUC_all.hit;
% errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% xlabel('Triplet Position'); ylabel('AUROC');
% title('All Sites');
% legend({'miss','hit'});
% 
% % Figure 2
% figure("Position",[150 150 800 450]);
% subplot(2,3,1); hold on
% X = 1:length(sTriplet);
% Y = AUC_post.eh;
% errorbar(X'+0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
% Y = AUC_post.em;
% errorbar(X'-0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
% Y = AUC_post.hh;
% errorbar(X'+0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
% Y = AUC_post.hm;
% errorbar(X'-0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% xlabel('Triplet Position'); ylabel('AUROC');
% title('Posterior');
% 
% subplot(2,3,2); hold on
% X = 1:length(sTriplet);
% Y = AUC_ant.eh;
% errorbar(X'+0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
% Y = AUC_ant.em;
% errorbar(X'-0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
% Y = AUC_ant.hh;
% errorbar(X'+0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
% Y = AUC_ant.hm;
% errorbar(X'-0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% xlabel('Triplet Position'); ylabel('AUROC');
% title('Anterior');
% 
% subplot(2,3,3); hold on
% X = 1:length(sTriplet);
% Y = AUC_all.eh;
% errorbar(X'+0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
% Y = AUC_all.em;
% errorbar(X'-0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
% Y = AUC_all.hh;
% errorbar(X'+0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
% Y = AUC_all.hm;
% errorbar(X'-0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% xlabel('Triplet Position'); ylabel('AUROC');
% title('All Sites');
% legend({'large dF hit','large dF miss','small dF hit','small dF miss'});





% statistical test pending now...
% % 5/13/22 modified
% % % % perform Kruskal-Wallis test (CORE vs BELT) % % %
% pStim_core(1) = kruskalwallis(dStim_CB.A.c,[],'off'); % turn it 'on' to get chi-sq value
% pStim_core(2) = kruskalwallis(dStim_CB.B1.c,[],'off');
% pStim_core(3) = kruskalwallis(dStim_CB.B2.c,[],'off');
% 
% pStim_belt(1) = kruskalwallis(dStim_CB.A.b,[],'off');
% pStim_belt(2) = kruskalwallis(dStim_CB.B1.b,[],'off');
% pStim_belt(3) = kruskalwallis(dStim_CB.B2.b,[],'off');
% 
% pBehav_core(1) = kruskalwallis(dBehav_CB.A.c,[],'off');
% pBehav_core(2) = kruskalwallis(dBehav_CB.B1.c,[],'off');
% pBehav_core(3) = kruskalwallis(dBehav_CB.B2.c,[],'off');
% 
% pBehav_belt(1) = kruskalwallis(dBehav_CB.A.b,[],'off');
% pBehav_belt(2) = kruskalwallis(dBehav_CB.B1.b,[],'off');
% pBehav_belt(3) = kruskalwallis(dBehav_CB.B2.b,[],'off');
% 
% % friedman test
% pFr_stim_cb(:,1)  = stats_CompLayers_Friedman(dStim_CB.A.c,dStim_CB.A.b);
% pFr_stim_cb(:,2)  = stats_CompLayers_Friedman(dStim_CB.B1.c,dStim_CB.B1.b);
% pFr_stim_cb(:,3)  = stats_CompLayers_Friedman(dStim_CB.B2.c,dStim_CB.B2.b);
% pFr_behav_cb(:,1) = stats_CompLayers_Friedman(dBehav_CB.A.c,dBehav_CB.A.b);
% pFr_behav_cb(:,2) = stats_CompLayers_Friedman(dBehav_CB.B1.c,dBehav_CB.B1.b);
% pFr_behav_cb(:,3) = stats_CompLayers_Friedman(dBehav_CB.B2.c,dBehav_CB.B2.b);
% 
% % Scheirer-Ray-Hare test
% pSRH_stim_cb(:,1) = stats_CompLayers_SRHtest(dStim_CB.A.c, dStim_CB.A.b);
% pSRH_stim_cb(:,2) = stats_CompLayers_SRHtest(dStim_CB.B1.c, dStim_CB.B1.b);
% pSRH_stim_cb(:,3) = stats_CompLayers_SRHtest(dStim_CB.B2.c, dStim_CB.B2.b);
% pSRH_behav_cb(:,1) = stats_CompLayers_SRHtest(dBehav_CB.A.c,dBehav_CB.A.b);
% pSRH_behav_cb(:,2) = stats_CompLayers_SRHtest(dBehav_CB.B1.c,dBehav_CB.B1.b);
% pSRH_behav_cb(:,3) = stats_CompLayers_SRHtest(dBehav_CB.B2.c,dBehav_CB.B2.b);
% 
% % % % perform Kruskal-Wallis test (POSTERIOR vs ANTERIOR) % % %
% pStim_post(1) = kruskalwallis(dStim_AP.A.c,[],'off');
% pStim_post(2) = kruskalwallis(dStim_AP.B1.c,[],'off');
% pStim_post(3) = kruskalwallis(dStim_AP.B2.c,[],'off');
% 
% pStim_ant(1) = kruskalwallis(dStim_AP.A.b,[],'off');
% pStim_ant(2) = kruskalwallis(dStim_AP.B1.b,[],'off');
% pStim_ant(3) = kruskalwallis(dStim_AP.B2.b,[],'off');
% 
% pBehav_post(1) = kruskalwallis(dBehav_AP.A.c,[],'off');
% pBehav_post(2) = kruskalwallis(dBehav_AP.B1.c,[],'off');
% pBehav_post(3) = kruskalwallis(dBehav_AP.B2.c,[],'off');
% 
% pBehav_ant(1) = kruskalwallis(dBehav_AP.A.b,[],'off');
% pBehav_ant(2) = kruskalwallis(dBehav_AP.B1.b,[],'off');
% pBehav_ant(3) = kruskalwallis(dBehav_AP.B2.b,[],'off');
% 
% % friedman test
% pFr_stim_ap(:,1)  = stats_CompLayers_Friedman(dStim_AP.A.c,dStim_AP.A.b);
% pFr_stim_ap(:,2)  = stats_CompLayers_Friedman(dStim_AP.B1.c,dStim_AP.B1.b);
% pFr_stim_ap(:,3)  = stats_CompLayers_Friedman(dStim_AP.B2.c,dStim_AP.B2.b);
% pFr_behav_ap(:,1) = stats_CompLayers_Friedman(dBehav_AP.A.c,dBehav_AP.A.b);
% pFr_behav_ap(:,2) = stats_CompLayers_Friedman(dBehav_AP.B1.c,dBehav_AP.B1.b);
% pFr_behav_ap(:,3) = stats_CompLayers_Friedman(dBehav_AP.B2.c,dBehav_AP.B2.b);
% 
% % Scheirer-Ray-Hare test
% pSRH_stim_ap(:,1) = stats_CompLayers_SRHtest(dStim_AP.A.c, dStim_AP.A.b);
% pSRH_stim_ap(:,2) = stats_CompLayers_SRHtest(dStim_AP.B1.c, dStim_AP.B1.b);
% pSRH_stim_ap(:,3) = stats_CompLayers_SRHtest(dStim_AP.B2.c, dStim_AP.B2.b);
% pSRH_behav_ap(:,1) = stats_CompLayers_SRHtest(dBehav_AP.A.c,dBehav_AP.A.b);
% pSRH_behav_ap(:,2) = stats_CompLayers_SRHtest(dBehav_AP.B1.c,dBehav_AP.B1.b);
% pSRH_behav_ap(:,3) = stats_CompLayers_SRHtest(dBehav_AP.B2.c,dBehav_AP.B2.b);
% % to get more info, try
% % [p,tbl,mc] = stats_CompLayers_SRHtest(dStim_AP.A.c, dStim_AP.A.b);