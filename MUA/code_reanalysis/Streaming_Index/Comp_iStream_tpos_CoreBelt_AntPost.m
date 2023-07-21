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

% display figure
% dBehav = display_Index(rCORE,rBELT,'Behav');
% dStim = display_Index(rCORE,rBELT,'Stim');

% log transform dSMI just for display
% results of Friedman test should be identical...
% plot comparing CORE vs BELT
figure("Position",[100 100 800 450]);
dBehav_CB = display_streamIndex_figure(rCORE,rBELT);
subplot(2,2,1); title('Core');
subplot(2,2,2); title('Belt');
% dStim_CB  = display_logIndex_figure(rCORE,rBELT,'Stim');
% subplot(2,3,1);
% ylabel('log(CI)');

% plot comparing POSTERIOR vs ANTERIOR
figure("Position",[150 150 800 450]);
dBehav_AP = display_streamIndex_figure(rPOS,rANT);
% dStim_AP  = display_streamIndex_figure(rPOS,rANT,'Stim'); 
subplot(2,2,1); title('Posterior');
subplot(2,2,2); title('Anterior');
% ylabel('log(CI)');


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