clear all
% take log of the SMI to make the distribution close to normal
% the BMI distribution looked symmetric from the biginning and thus no
% modification at all...
% use plot_index_tpos_v2_log.m function!!

% path for function calculating effect size...
% addpath('C:\MatlabTools\measures-of-effect-size-toolbox');
addpath('../myFunction');

% DATA_PATH = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/';
DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% layer = {'Sup','Deep'}; % either 'Deep' or 'Sup'
% auditory_area = 'Belt'; % either 'Core', 'Belt', or 'All'
sTriplet = {'1st','2nd','3rd','Tm1','T'};

sigRESP_A = []; sigRESP_B1 = []; sigRESP_B2 = [];
% rSUP_A = []; rSUP_B1 = []; rSUP_B2 = [];
for i = 1:length(sTriplet)
    fName = strcat(animal_name,'_zMUAResp_',sTriplet{i},'Triplet');
    if strcmp(animal_name,'Both')
        load(fullfile(DATA_PATH,'AllCombined',fName));
    else
        load(fullfile(DATA_PATH,fName));
    end
    % concatenate data across triplet position
    % channel x easy-hard x hit-miss x session x tpos 
    sigRESP_A  = cat(5,sigRESP_A,sigRESP.A);
    sigRESP_B1 = cat(5,sigRESP_B1,sigRESP.B1);
    sigRESP_B2 = cat(5,sigRESP_B2,sigRESP.B2);
end

% choose sessions based on the recording sites...
j = 1:length(area_index);
j_core = j(area_index==1);
j_belt = j(area_index==0);
rCORE_A  = sigRESP_A(:,:,:,j_core,:);
rCORE_B1 = sigRESP_B1(:,:,:,j_core,:);
rCORE_B2 = sigRESP_B2(:,:,:,j_core,:);
rBELT_A  = sigRESP_A(:,:,:,j_belt,:);
rBELT_B1 = sigRESP_B1(:,:,:,j_belt,:);
rBELT_B2 = sigRESP_B2(:,:,:,j_belt,:);

% compare behavioral signal in CORE vs BELT...
H(1) = figure;
subplot(2,2,1);
dBehav_Ac = plot_index_tpos_v2_log(rCORE_A,'Behav'); hold on;
dBehav_Ab = plot_index_tpos_v2_log(rBELT_A,'Behav');
title('A');

subplot(2,2,3);
dBehav_B1c = plot_index_tpos_v2_log(rCORE_B1,'Behav'); hold on;
dBehav_B1b = plot_index_tpos_v2_log(rBELT_B1,'Behav');
title('B1');

subplot(2,2,4);
dBehav_B2c = plot_index_tpos_v2_log(rCORE_B2,'Behav'); hold on;
dBehav_B2b = plot_index_tpos_v2_log(rBELT_B2,'Behav');
title('B2');

legend({'Core','Belt'},'Location',[0.5 0.82 0.2 0.1]);

% compare stimulus signal in CORE vs BELT...
H(2) = figure;
subplot(2,2,1);
dStim_Ac = plot_index_tpos_v2_log(rCORE_A,'Stim'); hold on;
dStim_Ab = plot_index_tpos_v2_log(rBELT_A,'Stim');
title('A');

subplot(2,2,3);
dStim_B1c = plot_index_tpos_v2_log(rCORE_B1,'Stim'); hold on;
dStim_B1b = plot_index_tpos_v2_log(rBELT_B1,'Stim');
title('B1');

subplot(2,2,4);
dStim_B2c = plot_index_tpos_v2_log(rCORE_B2,'Stim'); hold on;
dStim_B2b = plot_index_tpos_v2_log(rBELT_B2,'Stim');
title('B2');

legend({'Core','Belt'},'Location',[0.5 0.82 0.2 0.1]);

% statistical comparison between areas
% the same function comparing layers works!!
p_behav(:,1) = stats_CompLayers(dBehav_Ac,dBehav_Ab);
p_behav(:,2) = stats_CompLayers(dBehav_B1c,dBehav_B1b);
p_behav(:,3) = stats_CompLayers(dBehav_B2c,dBehav_B2b);

p_stim(:,1) = stats_CompLayers(dStim_Ac,dStim_Ab);
p_stim(:,2) = stats_CompLayers(dStim_B1c,dStim_B1b);
p_stim(:,3) = stats_CompLayers(dStim_B2c,dStim_B2b);

% save figures...
save_dir = fullfile(DATA_PATH,'AllCombined','CompAreas');
save_file_name{1} = strcat('AreaComparison_BehavIndex_',animal_name);
save_file_name{2} = strcat('AreaComparison_StimIndex_',animal_name);
for i=1:2
%     saveas(H(i),fullfile(save_dir,save_file_name{i}),'png');
end