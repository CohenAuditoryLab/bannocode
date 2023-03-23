% modified from Comp_index_area_emergenceOnset2_1.m
% average ABB triplet in each triplet position then examine the time course
% of the averaged index
clear all
DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area\emergence\onset\triplet_mean';
LIST_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

% % path for function (stats_CompLayers.m)...
% % addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
% addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
% addpath('../'); % path for data and dunn.m
% addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');
% 
% % DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% % animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% % sTriplet = {'Tm3','Tm2','Tm1','T'};
% % line_color = [229 0 125; 78 186 25] / 255;
% jitter = 0.04;
% line_color = [229 0 125; 78 186 25] / 255;

% load data (baseline)
fName = 'SMIBMI_Area';
load(fullfile(DATA_PATH,fName));
smi_core = SMI_Area.core;
smi_belt = SMI_Area.belt;
bmi_core = BMI_Area.core;
bmi_belt = BMI_Area.belt;


nUnit_core = size(smi_core,1); 
nUnit_belt = size(smi_belt,1);
nTpos = length(sTriplet);

tpos_core = ones(nUnit_core,1) * (1:nTpos);
tpos_belt = ones(nUnit_belt,1) * (1:nTpos); 
area_core = zeros(nUnit_core,nTpos); % make core 0
area_belt = ones(nUnit_belt,nTpos);  % make belt 1
unit_core = (1:nUnit_core)' * ones(1,nTpos);
unit_belt = (1:nUnit_belt)' * ones(1,nTpos);
% unit id should not overlap between core and belt...
unit_belt = unit_belt + nUnit_core;

% add electrode and layer information
load(fullfile(LIST_PATH,'MUA_ID_Both.mat'));
electrode_core = electrode_id.core * ones(1,nTpos);
electrode_belt = electrode_id.belt * ones(1,nTpos);
% electrode id should not overlap between core and belt...
nPenetration_core = max(unique(electrode_core));
electrode_belt = electrode_belt + nPenetration_core;
layer_core = layer_id.core * ones(1,nTpos);
layer_belt = layer_id.belt * ones(1,nTpos);
% channel
channel_core = channel_id.core * ones(1,nTpos);
channel_belt = channel_id.belt * ones(1,nTpos);

% transpose matrix
tpos_core = tpos_core';
tpos_belt = tpos_belt';
area_core = area_core';
area_belt = area_belt';
unit_core = unit_core';
unit_belt = unit_belt';
electrode_core = electrode_core';
electrode_belt = electrode_belt';
layer_core = layer_core';
layer_belt = layer_belt';
channel_core = channel_core';
channel_belt = channel_belt';

% get animal id...
nBoth_core = nUnit.core;
nBoth_belt = nUnit.belt;
load(fullfile(LIST_PATH,'MUA_ID_Domo'));
nDomo_core = nUnit.core;
nDomo_belt = nUnit.belt;
load(fullfile(LIST_PATH,'MUA_ID_Cassius'));
nCassius_core = nUnit.core;
nCassius_belt = nUnit.belt;
animal_core = [zeros(nDomo_core,1); ones(nCassius_core,1)] * ones(1,nTpos);
animal_belt = [zeros(nDomo_belt,1); ones(nCassius_belt,1)] * ones(1,nTpos);
% transpose
animal_core = animal_core';
animal_belt = animal_belt';

for ABB = 1:3
    % core
    smi_abb_core = transpose(smi_core(:,:,ABB));
    bmi_abb_core = transpose(bmi_core(:,:,ABB));
%     X_core = [smi_abb_core(:) bmi_abb_core(:) area_core(:) tpos_core(:) unit_core(:) ...
%         electrode_core(:) layer_core(:) animal_core(:)];
    X_core = [smi_abb_core(:) bmi_abb_core(:) area_core(:) tpos_core(:) channel_core(:) ...
        electrode_core(:) layer_core(:) animal_core(:)];

    % belt
    smi_abb_belt = transpose(smi_belt(:,:,ABB));
    bmi_abb_belt = transpose(bmi_belt(:,:,ABB));
%     X_belt = [smi_abb_belt(:) bmi_abb_belt(:) area_belt(:) tpos_belt(:) unit_belt(:) ...
%         electrode_belt(:) layer_belt(:) animal_belt(:)];
    X_belt = [smi_abb_belt(:) bmi_abb_belt(:) area_belt(:) tpos_belt(:) channel_belt(:) ...
        electrode_belt(:) layer_belt(:) animal_belt(:)];

    Data(:,:,ABB) = [X_core; X_belt];
end

% var_name = {'SMI','BMI','Area','Tpos','unit_id','electrode_id','layer_id','animal_id'};
var_name = {'SMI','BMI','Area','Tpos','channel_id','electrode_id','layer_id','animal_id'};
% layer_id: 1--supragranular, 2--granular, 3--infragranular
% animal_id: 0--Domo, 1--Cassius

% % save
% save_file_name = 'IndexTable';
% save(save_file_name,'Data','var_name','sTriplet');