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
fName1 = 'SMIBMI_Area';
load(fullfile(DATA_PATH,fName1));
i_baseline = 2; % choose baseline triplet
smi_core_bl = SMI_Area.core(:,i_baseline,:);
smi_belt_bl = SMI_Area.belt(:,i_baseline,:);
bmi_core_bl = BMI_Area.core(:,i_baseline,:);
bmi_belt_bl = BMI_Area.belt(:,i_baseline,:);
st_baseline = sTriplet{i_baseline}; 
clear SMI_Area BMI_Area sTriplet

% load data around the target
fName2 = 'SMIBMI_Area_emergence';
load(fullfile(DATA_PATH,fName2));
smi_core_wBL = cat(2,smi_core_bl,SMI_Area.core);
smi_belt_wBL = cat(2,smi_belt_bl,SMI_Area.belt);
bmi_core_wBL = cat(2,bmi_core_bl,BMI_Area.core);
bmi_belt_wBL = cat(2,bmi_belt_bl,BMI_Area.belt);
sTriplet = [st_baseline,sTriplet];

nUnit_core = size(smi_core_wBL,1); 
nUnit_belt = size(smi_belt_wBL,1);
nTpos = length(sTriplet);

tpos_core = ones(nUnit_core,1) * (1:nTpos);
tpos_belt = ones(nUnit_belt,1) * (1:nTpos); 
area_core = zeros(nUnit_core,nTpos);
area_belt = ones(nUnit_belt,nTpos);
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
    smi_abb_core = transpose(smi_core_wBL(:,:,ABB));
    bmi_abb_core = transpose(bmi_core_wBL(:,:,ABB));
    X_core = [smi_abb_core(:) bmi_abb_core(:) area_core(:) tpos_core(:) unit_core(:) ...
        electrode_core(:) layer_core(:) animal_core(:)];

    % belt
    smi_abb_belt = transpose(smi_belt_wBL(:,:,ABB));
    bmi_abb_belt = transpose(bmi_belt_wBL(:,:,ABB));
    X_belt = [smi_abb_belt(:) bmi_abb_belt(:) area_belt(:) tpos_belt(:) unit_belt(:) ...
        electrode_belt(:) layer_belt(:) animal_belt(:)];

    Data(:,:,ABB) = [X_core; X_belt];
end

var_name = {'SMI','BMI','Area','Tpos','unit_id','electrode_id','layer_id','animal_id'};
% layer_id: 1--supragranular, 2--granular, 3--infragranular
% animal_id: 0--Domo, 1--Cassius

% save
save_file_name = 'IndexTable_emergence';
save(save_file_name,'Data','var_name','sTriplet');