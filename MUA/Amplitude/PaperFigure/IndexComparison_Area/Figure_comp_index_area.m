clear all

SAVE_DIR = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\4_IndexComparison_area';

% path for function stats_CompLayers.m...
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');

% ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude';
% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% sTriplet = {'1st','2nd','3rd','Tm1','T'};
% line_color = [229 0 125; 78 186 25] / 255;


% load data
load MUAResponse_area;


% log transform dSMI just for display
% results of Friedman test should be identical...
figure("Position",[100 100 800 450]);
dStim = display_logIndex_figure(rCORE,rBELT,'Stim'); 
dBehav = display_logIndex_figure(rCORE,rBELT,'Behav'); 
legend({'Core','Belt'},'Location',[0.85 0.82 0.1 0.1]);
subplot(2,3,1); % rename label...
ylabel('log(CI)');

exportgraphics(gcf,fullfile(SAVE_DIR,'IndexComp_Area.eps'),'Resolution',600);

% 
% % 11/9/21 modified
% % perform Friedman test
% [p_behav(:,1)] = stats_CompLayers_Friedman(dBehav.A.c,dBehav.A.b);
% [p_behav(:,2)] = stats_CompLayers_Friedman(dBehav.B1.c,dBehav.B1.b);
% [p_behav(:,3)] = stats_CompLayers_Friedman(dBehav.B2.c,dBehav.B2.b);
% 
% [p_stim(:,1)]  = stats_CompLayers_Friedman(dStim.A.c,dStim.A.b);
% [p_stim(:,2)]  = stats_CompLayers_Friedman(dStim.B1.c,dStim.B1.b);
% [p_stim(:,3)]  = stats_CompLayers_Friedman(dStim.B2.c,dStim.B2.b);