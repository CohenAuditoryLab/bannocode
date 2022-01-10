clear all

% path for function calculating effect size...
% addpath('C:\MatlabTools\measures-of-effect-size-toolbox');
addpath('../myFunction');

% DATA_PATH = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/';
ROOT_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
DATA_PATH = fullfile(ROOT_PATH,'Depth','CompLayers','Both');
SAVE_PATH = fullfile(ROOT_PATH,'Depth','CompLayers');
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% layer = {'Sup','Deep'}; % either 'Deep' or 'Sup'
% auditory_area = 'Core'; % either 'Core', 'Belt', or 'All'
sTriplet = {'1st','2nd','3rd','Tm1','T'};
tpos = 2; % choose triplet position for analysis...
version = 'v1'; % select index version: 'v1' (taking absolute value)

fName_core = 'ModulationIndex_Core';
fName_belt = 'ModulationIndex_Belt';
if strcmp(version,'v2')
    DATA_PATH = fullfile(DATA_PATH,'v2');
    fName_core = strcat(fName_core,'_v2');
    fName_belt = strcat(fName_belt,'_v2');
end
    
% load CORE data
load(fullfile(DATA_PATH,fName_core));
% Behav_A.core_sup = dBehav.A.sup;
% Behav_A.core_deep = dBehav.A.deep;
% Behav_B1.core_sup = dBehav.B1.sup;
% Behav_B1.core_deep = dBehav.B1.deep;
% Behav_B2.core_sup = dBehav.B2.sup;
% Behav_B2.core_deep = dBehav.B2.deep;

Stim_A.core_sup = dStim.A.sup;
Stim_A.core_deep = dStim.A.deep;
Stim_B1.core_sup = dStim.B1.sup;
Stim_B1.core_deep = dStim.B1.deep;
Stim_B2.core_sup = dStim.B2.sup;
Stim_B2.core_deep = dStim.B2.deep;
clear dBehav dStim

% load BELT data
load(fullfile(DATA_PATH,fName_belt));
% Behav_A.belt_sup = dBehav.A.sup;
% Behav_A.belt_deep = dBehav.A.deep;
% Behav_B1.belt_sup = dBehav.B1.sup;
% Behav_B1.belt_deep = dBehav.B1.deep;
% Behav_B2.belt_sup = dBehav.B2.sup;
% Behav_B2.belt_deep = dBehav.B2.deep;

Stim_A.belt_sup = dStim.A.sup;
Stim_A.belt_deep = dStim.A.deep;
Stim_B1.belt_sup = dStim.B1.sup;
Stim_B1.belt_deep = dStim.B1.deep;
Stim_B2.belt_sup = dStim.B2.sup;
Stim_B2.belt_deep = dStim.B2.deep;
clear dBehav dStim

% plot
% H(1) = figure;
% subplot(2,2,1);
% bargraph_DepthArea(Behav_A,tpos);
% ylabel('dBehavior');
% title('A');
% 
% subplot(2,2,3);
% bargraph_DepthArea(Behav_B1,tpos);
% ylabel('dBehavior');
% title('B1');
% 
% subplot(2,2,4);
% bargraph_DepthArea(Behav_B2,tpos);
% ylabel('dBehavior');
% title('B2');
% 
% legend({'superficial','deep'},'Location',[0.52 0.82 0.1 0.1]);

H(2) = figure;
subplot(2,2,1);
bargraph_DepthArea(Stim_A,tpos);
ylabel('dStimulus');
title('A');

subplot(2,2,3);
bargraph_DepthArea(Stim_B1,tpos);
ylabel('dStimulus');
title('B1');

subplot(2,2,4);
bargraph_DepthArea(Stim_B2,tpos);
ylabel('dStimulus');
title('B2');

legend({'superficial','deep'},'Location',[0.52 0.82 0.1 0.1]);

% save figure...
% fig_name{1} = strcat('CompBehavIndex_DepthArea_',sTriplet{tpos},'Triplet');
fig_name{2} = strcat('CompStimIndex_DepthArea_',sTriplet{tpos},'Triplet');
if strcmp(version,'v2')
    fig_name{1} = strcat(fig_name{1},'_v2');
    fig_name{2} = strcat(fig_name{2},'_v2');
end
for i=1:2
%     saveas(H(i),fullfile(SAVE_PATH,fig_name{i}),'png');
end

% statistical analysis
% two-way ANOVA (factor 1: layer, factor 2: area)

% [p_behav(:,1),~,~] = stats_DepthArea(Behav_A,tpos);
% [p_behav(:,2),~,~] = stats_DepthArea(Behav_B1,tpos);
% [p_behav(:,3),~,~] = stats_DepthArea(Behav_B2,tpos);

[p_stim(:,1),~,~] = stats_DepthArea(Stim_A,tpos);
[p_stim(:,2),~,~] = stats_DepthArea(Stim_B1,tpos);
[p_stim(:,3),~,~] = stats_DepthArea(Stim_B2,tpos);