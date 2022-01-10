clear all

% path for function (stats_CompLayers.m)...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('../'); % path for data and dunn.m
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');

% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% sTriplet = {'Tm3','Tm2','Tm1','T'};
% line_color = [229 0 125; 78 186 25] / 255;

% load data (baseline)
load MUAResponse_area;
i_baseline = 2; % choose baseline triplet
core_bl.A  = rCORE.A(:,:,:,:,i_baseline);
core_bl.B1 = rCORE.B1(:,:,:,:,i_baseline);
core_bl.B2 = rCORE.B2(:,:,:,:,i_baseline);
belt_bl.A  = rBELT.A(:,:,:,:,i_baseline);
belt_bl.B1 = rBELT.B1(:,:,:,:,i_baseline);
belt_bl.B2 = rBELT.B2(:,:,:,:,i_baseline);
clear rCORE rBELT sTriplet

% load data around the target
load MUAResponse_area_emergence;

rCORE_wBL.A  = cat(5,core_bl.A,rCORE.A);
rCORE_wBL.B1 = cat(5,core_bl.B1,rCORE.B1);
rCORE_wBL.B2 = cat(5,core_bl.B2,rCORE.B2);
rBELT_wBL.A  = cat(5,belt_bl.A,rBELT.A);
rBELT_wBL.B1 = cat(5,belt_bl.B1,rBELT.B1);
rBELT_wBL.B2 = cat(5,belt_bl.B2,rBELT.B2);

% log transform SMI only for display
% results from Friedman test should be identical...
dBehav = display_logIndex_emergenceOnset2_1(rCORE_wBL,rBELT_wBL,'Behav');
dStim  = display_logIndex_emergenceOnset2_1(rCORE_wBL,rBELT_wBL,'Stim');

% % statistical comparison between areas
% perform Friedman test
p_behav = stats_CompLayers_emergenceOnset_Friedman(dBehav.ABB.c,dBehav.ABB.b);
p_stim = stats_CompLayers_emergenceOnset_Friedman(dStim.ABB.c,dStim.ABB.b);


% Dann's test for post-hoc analysis...