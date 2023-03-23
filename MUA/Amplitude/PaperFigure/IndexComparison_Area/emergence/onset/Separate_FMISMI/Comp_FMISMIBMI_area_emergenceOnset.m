clear all

% path for function (stats_CompLayers.m)...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area\emergence');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('../'); % path for data and dunn.m

SAVE_DIR = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\5_BMI_target';

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
figure("Position",[100 100 800 450]);
subplot(1,2,1);
dBehav = display_logIndex_emergenceOnset3(rCORE,rBELT,'Behav');
subplot(1,2,2);
dStim  = display_logIndex_emergenceOnset3(rCORE,rBELT,'Stim');

% export figure
exportgraphics(gcf,fullfile(SAVE_DIR,'Index_rTarget.eps'),'Resolution',600);


% % statistical comparison between areas
% perform Friedman test
p_behav = stats_CompLayers_emergenceOnset_Friedman(dBehav.ABB.c,dBehav.ABB.b);
p_stim = stats_CompLayers_emergenceOnset_Friedman(dStim.ABB.c,dStim.ABB.b);


% Dann's test for post-hoc analysis...