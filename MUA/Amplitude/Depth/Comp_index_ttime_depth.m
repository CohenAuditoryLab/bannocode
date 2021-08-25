clear all

% path for function calculating effect size...
% addpath('C:\MatlabTools\measures-of-effect-size-toolbox');
addpath('../myFunction');

% DATA_PATH = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/';
DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response\Depth';
animal_name = 'Domo'; % either 'Domo', 'Cassius', or 'Both'
% layer = {'Sup','Deep'}; % either 'Deep' or 'Sup'
auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
sTriplet = 'T'; % specify the folder for the analysis...


fName = strcat(animal_name,'_zMUAResp_tpos_',sTriplet,'Triplet');
folder = strcat('zScore_',sTriplet,'Triplet');

% load data from Superficial Layer
load(fullfile(DATA_PATH,'Sup',folder,'TargetPosition',fName));
% channel x tpos x hit-miss x session
rSUP_A  = sigRESP.A;
rSUP_B1 = sigRESP.B1;
rSUP_B2 = sigRESP.B2;

% load data from Deep Layer
load(fullfile(DATA_PATH,'Deep',folder,'TargetPosition',fName));
% channel x tpos x hit-miss x session
rDEEP_A  = sigRESP.A;
rDEEP_B1 = sigRESP.B1;
rDEEP_B2 = sigRESP.B2;

% choose sessions based on the recording sites...
j = 1:length(area_index);
if strcmp(auditory_area,'Core')
    j = j(area_index==1);
elseif strcmp(auditory_area,'Belt')
    j = j(area_index==0);
end
rSUP_A  = rSUP_A(:,:,:,j);
rSUP_B1 = rSUP_B1(:,:,:,j);
rSUP_B2 = rSUP_B2(:,:,:,j);
rDEEP_A  = rDEEP_A(:,:,:,j);
rDEEP_B1 = rDEEP_B1(:,:,:,j);
rDEEP_B2 = rDEEP_B2(:,:,:,j);


% compare behavioral signal in deep vs superfirical layers...
H = figure;
subplot(2,2,1);
dBehav_As = plot_index_tpos_v3(rSUP_A); hold on;
dBehav_Ad = plot_index_tpos_v3(rDEEP_A);
title('A');

subplot(2,2,3);
dBehav_B1s = plot_index_tpos_v3(rSUP_B1); hold on;
dBehav_B1d = plot_index_tpos_v3(rDEEP_B1);
title('B1');

subplot(2,2,4);
dBehav_B2s = plot_index_tpos_v3(rSUP_B2); hold on;
dBehav_B2d = plot_index_tpos_v3(rDEEP_B2);
title('B2');

legend({'Superficial','Deep'},'Location',[0.5 0.82 0.2 0.1]);

% statistical comparison between layers
p_behav(:,1) = stats_CompLayers(dBehav_As,dBehav_Ad);
p_behav(:,2) = stats_CompLayers(dBehav_B1s,dBehav_B1d);
p_behav(:,3) = stats_CompLayers(dBehav_B2s,dBehav_B2d);

% p_stim(:,1) = stats_CompLayers(dStim_Ac,dStim_Ab);
% p_stim(:,2) = stats_CompLayers(dStim_B1c,dStim_B1b);
% p_stim(:,3) = stats_CompLayers(dStim_B2c,dStim_B2b);

% save figures...
save_dir = fullfile(DATA_PATH,'CompLayers','TargetResponse');
save_file_name = strcat('LayerComparison_BehavIndex_',animal_name,'_',auditory_area);
% saveas(H,fullfile(save_dir,save_file_name),'png');

% save_file_name{2} = strcat('AreaComparison_StimIndex_',animal_name);
% for i=1:2
%     saveas(H(i),fullfile(save_dir,save_file_name{i}),'png');
% end