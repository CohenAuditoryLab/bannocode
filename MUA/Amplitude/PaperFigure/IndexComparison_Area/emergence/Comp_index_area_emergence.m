clear all

% path for function (stats_CompLayers.m)...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');

% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% sTriplet = {'Tm3','Tm2','Tm1','T'};
% line_color = [229 0 125; 78 186 25] / 255;

% load data
load MUAResponse_area_emergence;

% display figures
% dBehav = display_Index_emergence(rCORE,rBELT,'Behav');
% dStim  = display_Index_emergence(rCORE,rBELT,'Stim');

% log transform SMI only for display
% results from Friedman test should be identical...
dBehav = display_logIndex_emergence(rCORE,rBELT,'Behav');
dStim  = display_logIndex_emergence(rCORE,rBELT,'Stim');

% % statistical comparison between areas
% % the same function comparing layers works!!
% p_behav(:,1) = stats_CompLayers(dBehav.A.c,dBehav.A.b);
% p_behav(:,2) = stats_CompLayers(dBehav.B1.c,dBehav.B1.b);
% p_behav(:,3) = stats_CompLayers(dBehav.B2.c,dBehav.B2.b);
% 
% p_stim(:,1) = stats_CompLayers(dStim.A.c,dStim.A.b);
% p_stim(:,2) = stats_CompLayers(dStim.B1.c,dStim.B1.b);
% p_stim(:,3) = stats_CompLayers(dStim.B2.c,dStim.B2.b);

% % 09/22/21 modified
% % perform two-way repeated measures ANOVA
% [p_behav(:,1), pb(:,1)] = stats_CompAreas_emergence_rm(dBehav.A.c,dBehav.A.b);
% [p_behav(:,2), pb(:,2)] = stats_CompAreas_emergence_rm(dBehav.B1.c,dBehav.B1.b);
% [p_behav(:,3), pb(:,3)] = stats_CompAreas_emergence_rm(dBehav.B2.c,dBehav.B2.b);
% 
% [p_stim(:,1), ps(:,1)] = stats_CompAreas_emergence_rm(dStim.A.c,dStim.A.b);
% [p_stim(:,2), ps(:,2)] = stats_CompAreas_emergence_rm(dStim.B1.c,dStim.B1.b);
% [p_stim(:,3), ps(:,3)] = stats_CompAreas_emergence_rm(dStim.B2.c,dStim.B2.b);

% 11/10/21 modified
% perform Friedman test
[p_behav(:,1)] = stats_CompLayers_emergence_Friedman(dBehav.A.c,dBehav.A.b);
[p_behav(:,2)] = stats_CompLayers_emergence_Friedman(dBehav.B1.c,dBehav.B1.b);
[p_behav(:,3)] = stats_CompLayers_emergence_Friedman(dBehav.B2.c,dBehav.B2.b);

[p_stim(:,1)] = stats_CompLayers_emergence_Friedman(dStim.A.c,dStim.A.b);
[p_stim(:,2)] = stats_CompLayers_emergence_Friedman(dStim.B1.c,dStim.B1.b);
[p_stim(:,3)] = stats_CompLayers_emergence_Friedman(dStim.B2.c,dStim.B2.b);

% Dann's test for post-hoc analysis...