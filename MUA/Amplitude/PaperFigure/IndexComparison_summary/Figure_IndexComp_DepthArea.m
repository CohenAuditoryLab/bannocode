clear all

% path for function calculating effect size...
% addpath('C:\MatlabTools\measures-of-effect-size-toolbox');
addpath('../myFunction');

% DATA_PATH = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/';
ROOT_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
DATA_PATH = fullfile(ROOT_PATH,'Depth','CompLayers','Both');
SAVE_PATH = 'E:\03_Research_Paper\Streaming\Figures\IndexComp';
sTriplet = {'1st','2nd','3rd','Tm1','T'};
fName_core = 'ModulationIndex_Core';
fName_belt = 'ModulationIndex_Belt';

% % % Stimulus modulation index % % %
tpos = 2;
version = 'v1'; % select index version: 'v1' (taking absolute value)
if strcmp(version,'v2')
    DATA_PATH = fullfile(DATA_PATH,'v2');
    fName_core = strcat(fName_core,'_v2');
    fName_belt = strcat(fName_belt,'_v2');
end

% load CORE data
load(fullfile(DATA_PATH,fName_core));
SMI_core = dStim; clear dStim dBehav;
% load BELT data
load(fullfile(DATA_PATH,fName_belt));
SMI_belt = dStim; clear dStim dBehav;

% plot
[sp_anova,sp_factor,sp] = display_IndexSummary(SMI_core,SMI_belt,tpos);

% % % Behavioral modulation index % % %
% set variables...
tpos = 4:5; % choose triplet position for analysis...
version = 'v2'; % select index version: 'v2' (no absolute value)
if strcmp(version,'v2')
    DATA_PATH = fullfile(DATA_PATH,'v2');
    fName_core = strcat(fName_core,'_v2');
    fName_belt = strcat(fName_belt,'_v2');
end

% load CORE data
load(fullfile(DATA_PATH,fName_core));
BMI_core = dBehav; clear dStim dBehav;
% load BELT data
load(fullfile(DATA_PATH,fName_belt));
BMI_belt = dBehav; clear dStim dBehav;

% plot
[bp_anova,bp_factor,bp] = display_IndexSummary(BMI_core,BMI_belt,tpos);




% % save figure...
% fig_name{1} = strcat('CompBehavIndex_DepthArea_',sTriplet{tpos},'Triplet');
% % fig_name{2} = strcat('CompStimIndex_DepthArea_',sTriplet{tpos},'Triplet');
% if strcmp(version,'v2')
%     fig_name{1} = strcat(fig_name{1},'_v2');
%     fig_name{2} = strcat(fig_name{2},'_v2');
% end
% for i=1:2
% %     saveas(H(i),fullfile(SAVE_PATH,fig_name{i}),'png');
% end

