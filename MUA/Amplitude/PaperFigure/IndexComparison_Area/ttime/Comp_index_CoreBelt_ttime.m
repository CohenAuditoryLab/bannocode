clear all

% path for function (stats_CompLayers.m)...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');


% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% sTriplet = 'T'; % specify the folder for the analysis...
% line_color = [229 0 125; 78 186 25] / 255;


% load data...
load MUAResponse_area_ttime;

% plot figure
dBehav = display_Index_area_ttime(rCORE,rBELT);


% % statistical comparison between areas
% % the same function comparing layers works!!
% p_behav(:,1) = stats_CompLayers(dBehav.A.c,dBehav.A.b);
% p_behav(:,2) = stats_CompLayers(dBehav.B1.c,dBehav.B1.b);
% p_behav(:,3) = stats_CompLayers(dBehav.B2.c,dBehav.B2.b);

% % 09/22/21 modified
% % perform two-way repeated measures ANOVA
% [p_behav(:,1), pb(:,1)] = stats_CompAreas_ttime_rm(dBehav.A.c,dBehav.A.b);
% [p_behav(:,2), pb(:,2)] = stats_CompAreas_ttime_rm(dBehav.B1.c,dBehav.B1.b);
% [p_behav(:,3), pb(:,3)] = stats_CompAreas_ttime_rm(dBehav.B2.c,dBehav.B2.b);

% % 11/9/21 modified
% % perform Friedman test
% [p_behav(:,1)] = stats_CompLayers_Friedman(dBehav.A.c,dBehav.A.b);
% [p_behav(:,2)] = stats_CompLayers_Friedman(dBehav.B1.c,dBehav.B1.b);
% [p_behav(:,3)] = stats_CompLayers_Friedman(dBehav.B2.c,dBehav.B2.b);

% 5/16/22 modified
% perform Kruskal-Wallis test
pBehav_core(1) = kruskalwallis(dBehav.A.c,[],'off');
pBehav_core(2) = kruskalwallis(dBehav.B1.c,[],'off');
pBehav_core(3) = kruskalwallis(dBehav.B2.c,[],'off');

pBehav_belt(1) = kruskalwallis(dBehav.A.b,[],'off');
pBehav_belt(2) = kruskalwallis(dBehav.B1.b,[],'off');
pBehav_belt(3) = kruskalwallis(dBehav.B2.b,[],'off');

[~,tbl_core] = kruskalwallis(dBehav.A.c,[],'off');
[~,tbl_belt] = kruskalwallis(dBehav.A.b,[],'off');