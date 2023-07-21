% redo the BMI comparison limiting to T-1 and T period
clear all

% path for function stats_CompLayers.m...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');

% ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude';
% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% sTriplet = {'1st','2nd','3rd','Tm1','T'};
% line_color = [229 0 125; 78 186 25] / 255;


% load data
load MUAResponse_area_v1;

% display figure
% dBehav = display_Index(rCORE,rBELT,'Behav');
% dStim = display_Index(rCORE,rBELT,'Stim');

% log transform dSMI just for display
% results of Friedman test should be identical...
% plot comparing CORE vs BELT
figure("Position",[100 100 800 450]);
dBehav_CB = display_logIndex_figure(rCORE,rBELT,'Behav'); 
dStim_CB  = display_logIndex_figure(rCORE,rBELT,'Stim');
subplot(2,3,1);
ylabel('log(CI)');

% plot comparing POSTERIOR vs ANTERIOR
figure("Position",[150 150 800 450]);
dBehav_AP = display_logIndex_figure(rPOS,rANT,'Behav');
dStim_AP  = display_logIndex_figure(rPOS,rANT,'Stim'); 
subplot(2,3,1);
ylabel('log(CI)');

% % statistical comparison between areas
% % the same function comparing layers works!!
% p_behav(:,1) = stats_CompLayers(dBehav.A.c,dBehav.A.b);
% p_behav(:,2) = stats_CompLayers(dBehav.B1.c,dBehav.B1.b);
% p_behav(:,3) = stats_CompLayers(dBehav.B2.c,dBehav.B2.b);
% 
% p_stim(:,1) = stats_CompLayers(dStim.A.c,dStim.A.b);
% p_stim(:,2) = stats_CompLayers(dStim.B1.c,dStim.B1.b);
% p_stim(:,3) = stats_CompLayers(dStim.B2.c,dStim.B2.b);

% % 9/22/21 modified 
% % perform repeated measures ANOVA...
% [p_behav(:,1), pb(:,1)] = stats_CompAreas_rm(dBehav.A.c,dBehav.A.b);
% [p_behav(:,2), pb(:,2)]= stats_CompAreas_rm(dBehav.B1.c,dBehav.B1.b);
% [p_behav(:,3), pb(:,3)] = stats_CompAreas_rm(dBehav.B2.c,dBehav.B2.b);
% 
% [p_stim(:,1), ps(:,1)]= stats_CompAreas_rm(dStim.A.c,dStim.A.b);
% [p_stim(:,2), ps(:,2)]= stats_CompAreas_rm(dStim.B1.c,dStim.B1.b);
% [p_stim(:,3), ps(:,3)]= stats_CompAreas_rm(dStim.B2.c,dStim.B2.b);

% % 11/9/21 modified
% % perform Friedman test
% [p_behav(:,1)] = stats_CompLayers_Friedman(dBehav.A.c,dBehav.A.b);
% [p_behav(:,2)] = stats_CompLayers_Friedman(dBehav.B1.c,dBehav.B1.b);
% [p_behav(:,3)] = stats_CompLayers_Friedman(dBehav.B2.c,dBehav.B2.b);
% 
% [p_stim(:,1)]  = stats_CompLayers_Friedman(dStim.A.c,dStim.A.b);
% [p_stim(:,2)]  = stats_CompLayers_Friedman(dStim.B1.c,dStim.B1.b);
% [p_stim(:,3)]  = stats_CompLayers_Friedman(dStim.B2.c,dStim.B2.b);

% 5/13/22 modified
% % % perform Kruskal-Wallis test (CORE vs BELT) % % %
pStim_core(1) = kruskalwallis(dStim_CB.A.c,[],'off'); % turn it 'on' to get chi-sq value
pStim_core(2) = kruskalwallis(dStim_CB.B1.c,[],'off');
pStim_core(3) = kruskalwallis(dStim_CB.B2.c,[],'off');

pStim_belt(1) = kruskalwallis(dStim_CB.A.b,[],'off');
pStim_belt(2) = kruskalwallis(dStim_CB.B1.b,[],'off');
pStim_belt(3) = kruskalwallis(dStim_CB.B2.b,[],'off');

pBehav_core(1) = kruskalwallis(dBehav_CB.A.c,[],'off');
pBehav_core(2) = kruskalwallis(dBehav_CB.B1.c,[],'off');
pBehav_core(3) = kruskalwallis(dBehav_CB.B2.c,[],'off');

pBehav_belt(1) = kruskalwallis(dBehav_CB.A.b,[],'off');
pBehav_belt(2) = kruskalwallis(dBehav_CB.B1.b,[],'off');
pBehav_belt(3) = kruskalwallis(dBehav_CB.B2.b,[],'off');

% friedman test
pFr_stim_cb(:,1)  = stats_CompLayers_Friedman(dStim_CB.A.c,dStim_CB.A.b);
pFr_stim_cb(:,2)  = stats_CompLayers_Friedman(dStim_CB.B1.c,dStim_CB.B1.b);
pFr_stim_cb(:,3)  = stats_CompLayers_Friedman(dStim_CB.B2.c,dStim_CB.B2.b);
pFr_behav_cb(:,1) = stats_CompLayers_Friedman(dBehav_CB.A.c,dBehav_CB.A.b);
pFr_behav_cb(:,2) = stats_CompLayers_Friedman(dBehav_CB.B1.c,dBehav_CB.B1.b);
pFr_behav_cb(:,3) = stats_CompLayers_Friedman(dBehav_CB.B2.c,dBehav_CB.B2.b);

% Scheirer-Ray-Hare test
pSRH_stim_cb(:,1) = stats_CompLayers_SRHtest(dStim_CB.A.c, dStim_CB.A.b);
pSRH_stim_cb(:,2) = stats_CompLayers_SRHtest(dStim_CB.B1.c, dStim_CB.B1.b);
pSRH_stim_cb(:,3) = stats_CompLayers_SRHtest(dStim_CB.B2.c, dStim_CB.B2.b);
pSRH_behav_cb(:,1) = stats_CompLayers_SRHtest(dBehav_CB.A.c,dBehav_CB.A.b);
pSRH_behav_cb(:,2) = stats_CompLayers_SRHtest(dBehav_CB.B1.c,dBehav_CB.B1.b);
pSRH_behav_cb(:,3) = stats_CompLayers_SRHtest(dBehav_CB.B2.c,dBehav_CB.B2.b);

% % % perform Kruskal-Wallis test (POSTERIOR vs ANTERIOR) % % %
pStim_post(1) = kruskalwallis(dStim_AP.A.c,[],'off');
pStim_post(2) = kruskalwallis(dStim_AP.B1.c,[],'off');
pStim_post(3) = kruskalwallis(dStim_AP.B2.c,[],'off');

pStim_ant(1) = kruskalwallis(dStim_AP.A.b,[],'off');
pStim_ant(2) = kruskalwallis(dStim_AP.B1.b,[],'off');
pStim_ant(3) = kruskalwallis(dStim_AP.B2.b,[],'off');

pBehav_post(1) = kruskalwallis(dBehav_AP.A.c,[],'off');
pBehav_post(2) = kruskalwallis(dBehav_AP.B1.c,[],'off');
pBehav_post(3) = kruskalwallis(dBehav_AP.B2.c,[],'off');

pBehav_ant(1) = kruskalwallis(dBehav_AP.A.b,[],'off');
pBehav_ant(2) = kruskalwallis(dBehav_AP.B1.b,[],'off');
pBehav_ant(3) = kruskalwallis(dBehav_AP.B2.b,[],'off');

% friedman test
pFr_stim_ap(:,1)  = stats_CompLayers_Friedman(dStim_AP.A.c,dStim_AP.A.b);
pFr_stim_ap(:,2)  = stats_CompLayers_Friedman(dStim_AP.B1.c,dStim_AP.B1.b);
pFr_stim_ap(:,3)  = stats_CompLayers_Friedman(dStim_AP.B2.c,dStim_AP.B2.b);
pFr_behav_ap(:,1) = stats_CompLayers_Friedman(dBehav_AP.A.c,dBehav_AP.A.b);
pFr_behav_ap(:,2) = stats_CompLayers_Friedman(dBehav_AP.B1.c(:,4:5),dBehav_AP.B1.b(:,4:5)); % T-1 and T period
pFr_behav_ap(:,3) = stats_CompLayers_Friedman(dBehav_AP.B2.c(:,4:5),dBehav_AP.B2.b(:,4:5)); % T-1 and T period

% Scheirer-Ray-Hare test
pSRH_stim_ap(:,1) = stats_CompLayers_SRHtest(dStim_AP.A.c, dStim_AP.A.b);
pSRH_stim_ap(:,2) = stats_CompLayers_SRHtest(dStim_AP.B1.c, dStim_AP.B1.b);
pSRH_stim_ap(:,3) = stats_CompLayers_SRHtest(dStim_AP.B2.c, dStim_AP.B2.b);
pSRH_behav_ap(:,1) = stats_CompLayers_SRHtest(dBehav_AP.A.c,dBehav_AP.A.b);
pSRH_behav_ap(:,2) = stats_CompLayers_SRHtest(dBehav_AP.B1.c(:,4:5),dBehav_AP.B1.b(:,4:5)); % T-1 and T period
pSRH_behav_ap(:,3) = stats_CompLayers_SRHtest(dBehav_AP.B2.c(:,4:5),dBehav_AP.B2.b(:,4:5)); % T-1 and T period
% to get more info, try
% [p,tbl,mc] = stats_CompLayers_SRHtest(dStim_AP.A.c, dStim_AP.A.b);