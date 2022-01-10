clear all

% path for function (stats_CompLayers.m)...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('../'); % path for data and dunn.m

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
dBehav = display_logIndex_emergenceOnset(rCORE,rBELT,'Behav');
dStim  = display_logIndex_emergenceOnset(rCORE,rBELT,'Stim');

% % statistical comparison between areas
% perform Friedman test
p_behav = stats_CompLayers_emergenceOnset_Friedman(dBehav.ABB.c,dBehav.ABB.b);
p_stim = stats_CompLayers_emergenceOnset_Friedman(dStim.ABB.c,dStim.ABB.b);


% Dann's test for post-hoc analysis...