% define new index (streaming index) and compare them in hit and miss
% trials
clear all
DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Area';
isSave = 1;

% path for function stats_CompLayers.m...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');


% load data
fName = 'MUAResponse_area_v1';
load(fullfile(DATA_PATH,fName));

rA_post = rPOS.A; rB_post = rPOS.B1;
rA_ant  = rANT.A; rB_ant  = rANT.B1;
% concatenate data
rA_all = cat(4,rA_post,rA_ant);
rB_all = cat(4,rB_post,rB_ant);

AUC_post = get_ROC(rA_post,rB_post);
AUC_ant  = get_ROC(rA_ant,rB_ant);
AUC_all  = get_ROC(rA_all,rB_all);

% plot AUC
figure("Position",[150 150 800 450]); jitter = 0.04;
subplot(2,3,1); hold on
X = 1:length(sTriplet);
Y = AUC_post.easy;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
Y = AUC_post.hard;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
ylabel('AUROC');
title('Posterior');

subplot(2,3,2); hold on
X = 1:length(sTriplet);
Y = AUC_ant.easy;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
Y = AUC_ant.hard;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
ylabel('AUROC');
title('Anterior');

subplot(2,3,3); hold on
X = 1:length(sTriplet);
Y = AUC_all.easy;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
Y = AUC_all.hard;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
ylabel('AUROC');
title('All Sites');
legend({'large dF','small dF'});

subplot(2,3,4); hold on
X = 1:length(sTriplet);
Y = AUC_post.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
Y = AUC_post.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlabel('Triplet Position'); ylabel('AUROC');
title('Posterior');

subplot(2,3,5); hold on
X = 1:length(sTriplet);
Y = AUC_ant.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
Y = AUC_ant.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlabel('Triplet Position'); ylabel('AUROC');
title('Anterior');

subplot(2,3,6); hold on
X = 1:length(sTriplet);
Y = AUC_all.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0); 
Y = AUC_all.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0);
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlabel('Triplet Position'); ylabel('AUROC');
title('All Sites');
legend({'miss','hit'});

% Figure 2
figure("Position",[150 150 800 450]);
subplot(2,3,1); hold on
X = 1:length(sTriplet);
Y = AUC_post.eh;
errorbar(X'+0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
Y = AUC_post.em;
errorbar(X'-0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
Y = AUC_post.hh;
errorbar(X'+0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
Y = AUC_post.hm;
errorbar(X'-0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlabel('Triplet Position'); ylabel('AUROC');
title('Posterior');

subplot(2,3,2); hold on
X = 1:length(sTriplet);
Y = AUC_ant.eh;
errorbar(X'+0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
Y = AUC_ant.em;
errorbar(X'-0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
Y = AUC_ant.hh;
errorbar(X'+0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
Y = AUC_ant.hm;
errorbar(X'-0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlabel('Triplet Position'); ylabel('AUROC');
title('Anterior');

subplot(2,3,3); hold on
X = 1:length(sTriplet);
Y = AUC_all.eh;
errorbar(X'+0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
Y = AUC_all.em;
errorbar(X'-0.02,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
Y = AUC_all.hh;
errorbar(X'+0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5); 
Y = AUC_all.hm;
errorbar(X'-0.04,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',1.5);
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlabel('Triplet Position'); ylabel('AUROC');
title('All Sites');
legend({'large dF hit','large dF miss','small dF hit','small dF miss'});

% save
if isSave==1
    save_file_name = 'ROC_LvsH1';
    save(save_file_name,'AUC_post','AUC_ant','AUC_all');
end
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