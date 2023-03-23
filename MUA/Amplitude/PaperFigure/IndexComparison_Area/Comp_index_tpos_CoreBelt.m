clear all

% path for function stats_CompLayers.m...
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');

% ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude';
% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% sTriplet = {'1st','2nd','3rd','Tm1','T'};
% line_color = [229 0 125; 78 186 25] / 255;


% load data
load MUAResponse_area;

% display figure
% dBehav = display_Index(rCORE,rBELT,'Behav');
% dStim = display_Index(rCORE,rBELT,'Stim');

% log transform dSMI just for display
% results of Friedman test should be identical...
dBehav = display_logIndex(rCORE,rBELT,'Behav'); 
dStim = display_logIndex(rCORE,rBELT,'Stim'); 

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
% perform Kruskal-Wallis test
pStim_core(1) = kruskalwallis(dStim.A.c,[],'off');
pStim_core(2) = kruskalwallis(dStim.B1.c,[],'off');
pStim_core(3) = kruskalwallis(dStim.B2.c,[],'off');

pStim_belt(1) = kruskalwallis(dStim.A.b,[],'off');
pStim_belt(2) = kruskalwallis(dStim.B1.b,[],'off');
pStim_belt(3) = kruskalwallis(dStim.B2.b,[],'off');

pBehav_core(1) = kruskalwallis(dBehav.A.c,[],'off');
pBehav_core(2) = kruskalwallis(dBehav.B1.c,[],'off');
pBehav_core(3) = kruskalwallis(dBehav.B2.c,[],'off');

pBehav_belt(1) = kruskalwallis(dBehav.A.b,[],'off');
pBehav_belt(2) = kruskalwallis(dBehav.B1.b,[],'off');
pBehav_belt(3) = kruskalwallis(dBehav.B2.b,[],'off');