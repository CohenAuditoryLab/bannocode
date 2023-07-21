% define new index (streaming index) and compare them in hit and miss
% trials
clear all
DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Area';

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

iStream_post = get_streaming_index(rA_post,rB_post);
iStream_ant = get_streaming_index(rA_ant,rB_ant);
iStream_all = get_streaming_index(rA_all,rB_all);

% % plot comparing CORE vs BELT
% figure("Position",[100 100 800 450]);
% dBehav_CB = display_streamIndex_figure(rCORE,rBELT);
% subplot(2,2,1); title('Core');
% subplot(2,2,2); title('Belt');
% % dStim_CB  = display_logIndex_figure(rCORE,rBELT,'Stim');
% % subplot(2,3,1);
% % ylabel('log(CI)');

% plot comparing POSTERIOR vs ANTERIOR
figure("Position",[150 150 800 450]); jitter = 0.04;
subplot(2,3,1);
plot_errorbar(iStream_post.easy, jitter); hold on;
plot_errorbar(iStream_post.hard,-jitter);
set(gca,'XTick',1:5,'XTickLabel',sTriplet);
ylabel('Streaming Index');
title('Posterior');
box off

subplot(2,3,2);
plot_errorbar(iStream_ant.easy, jitter); hold on;
plot_errorbar(iStream_ant.hard,-jitter);
set(gca,'XTick',1:5,'XTickLabel',sTriplet);
ylabel('Streaming Index');
title('Anterior');
box off

subplot(2,3,3);
plot_errorbar(iStream_all.easy, jitter); hold on;
plot_errorbar(iStream_all.hard,-jitter);
set(gca,'XTick',1:5,'XTickLabel',sTriplet);
ylabel('Streaming Index');
title('All Sites');
box off
legend({'large dF','small dF'});

subplot(2,3,4);
plot_errorbar(iStream_post.miss,jitter); hold on;
plot_errorbar(iStream_post.hit,-jitter);
set(gca,'XTick',1:5,'XTickLabel',sTriplet);
xlabel('Triplet Position'); ylabel('Streaming Index');
box off

subplot(2,3,5);
plot_errorbar(iStream_ant.miss,jitter); hold on;
plot_errorbar(iStream_ant.hit,-jitter);
set(gca,'XTick',1:5,'XTickLabel',sTriplet);
xlabel('Triplet Position'); ylabel('Streaming Index');
box off

subplot(2,3,6);
plot_errorbar(iStream_all.miss,jitter); hold on;
plot_errorbar(iStream_all.hit,-jitter);
set(gca,'XTick',1:5,'XTickLabel',sTriplet);
xlabel('Triplet Position'); ylabel('Streaming Index');
legend({'miss','hit'});
box off

% Figure2
figure("Position",[150 150 800 450]); 
subplot(2,3,1);
plot_errorbar(iStream_post.eh, 0.02); hold on;
plot_errorbar(iStream_post.em,-0.02);
plot_errorbar(iStream_post.hh, 0.04);
plot_errorbar(iStream_post.hm,-0.04);
set(gca,'XTick',1:5,'XTickLabel',sTriplet);
ylabel('Streaming Index');
title('Posterior');
box off

subplot(2,3,2);
plot_errorbar(iStream_ant.eh, 0.02); hold on;
plot_errorbar(iStream_ant.em,-0.02);
plot_errorbar(iStream_ant.hh, 0.04);
plot_errorbar(iStream_ant.hm,-0.04);
set(gca,'XTick',1:5,'XTickLabel',sTriplet);
ylabel('Streaming Index');
title('Anterior');
box off

subplot(2,3,3);
plot_errorbar(iStream_all.eh, 0.02); hold on;
plot_errorbar(iStream_all.em,-0.02);
plot_errorbar(iStream_all.hh, 0.04);
plot_errorbar(iStream_all.hm,-0.04);
set(gca,'XTick',1:5,'XTickLabel',sTriplet);
ylabel('Streaming Index');
title('All Sites');
box off
% legend({'large dF','small dF'});
legend({'large dF hit','large dF miss','small dF hit','small dF miss'});


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