clear all

% path for function (stats_CompLayers.m)...
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area\emergence');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area\emergence\onset');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');

% load data
load MUAResponse_late_CoreBelt_PostAnt;
% load MUAResponse_late_CoreBelt_PostAnt_ext;

% display figures
% dBehav = display_Index_emergence(rCORE,rBELT,'Behav');
% dStim  = display_Index_emergence(rCORE,rBELT,'Stim');

% log transform SMI only for display
% results from Friedman test should be identical...
figure("Position",[100 100 800 450]);
subplot(1,2,1);
dBehav = display_logIndex_emergenceOnset_PostAnt(rPOST,rANT,'Behav');
subplot(1,2,2);
dStim  = display_logIndex_emergenceOnset_PostAnt(rPOST,rANT,'Stim');

% % export figure
% exportgraphics(gcf,fullfile(SAVE_DIR,'Index_rTarget.eps'),'Resolution',600);


% % statistical comparison between areas
% perform Friedman test
% p_behav = stats_CompLayers_emergenceOnset_Friedman(dBehav.ABB.c,dBehav.ABB.b);
% p_stim = stats_CompLayers_emergenceOnset_Friedman(dStim.ABB.c,dStim.ABB.b);

% Kruskal-Wallis test (5/17/22 modified)
pBMI_post = kruskalwallis(dBehav.ABB.p);
pBMI_ant  = kruskalwallis(dBehav.ABB.a);

pSMI_post = kruskalwallis(dStim.ABB.p(:,1:3:end));
pFMI1_post = kruskalwallis(dStim.ABB.p(:,2:3:end));
pFMI2_post = kruskalwallis(dStim.ABB.p(:,3:3:end));
pSMI_ant = kruskalwallis(dStim.ABB.a(:,1:3:end));
pFMI1_ant = kruskalwallis(dStim.ABB.a(:,2:3:end));
pFMI2_ant = kruskalwallis(dStim.ABB.a(:,3:3:end));

% Dann's test for post-hoc analysis...