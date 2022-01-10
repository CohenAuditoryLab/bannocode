clear all

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
H(1) = figure; % CORE
subplot(2,2,1);
[iCORE_Ah,iCORE_Am] = plot_SMI_hitmiss(rCORE_A);
title('L');

subplot(2,2,3);
[iCORE_B1h,iCORE_B1m] = plot_SMI_hitmiss(rCORE_B1);
title('H1');

subplot(2,2,4);
[iCORE_B2h,iCORE_B2m] = plot_SMI_hitmiss(rCORE_B2);
title('H2');

legend({'Hit','Miss'},'Location',[0.5 0.82 0.2 0.1]);

% compare stimulus signal in CORE vs BELT...
H(2) = figure; % BELT
subplot(2,2,1);
[iBELT_Ah,iBELT_Am] = plot_SMI_hitmiss(rBELT_A);
title('L');

subplot(2,2,3);
[iBELT_B1h,iBELT_B1m] = plot_SMI_hitmiss(rBELT_B1);
title('H1');

subplot(2,2,4);
[iBELT_B2h,iBELT_B2m] = plot_SMI_hitmiss(rBELT_B2);
title('H2');

legend({'Hit','Miss'},'Location',[0.5 0.82 0.2 0.1]);

% % statistical comparison between areas
% % the same function comparing layers works!!
% p_core(:,1) = stats_CompLayers(iCORE_Ah,iCORE_Am);
% p_core(:,2) = stats_CompLayers(iCORE_B1h,iCORE_B1m);
% p_core(:,3) = stats_CompLayers(iCORE_B2h,iCORE_B2m);
% 
% p_belt(:,1) = stats_CompLayers(iBELT_Ah,iBELT_Am);
% p_belt(:,2) = stats_CompLayers(iBELT_B1h,iBELT_B1m);
% p_belt(:,3) = stats_CompLayers(iBELT_B2h,iBELT_B2m);

% 09/22/21 modified
% performe repeated measures ANOVA
[p_core(:,1), pc(:,1)] = stats_CompAreas_rm(iCORE_Ah,iCORE_Am);
[p_core(:,2), pc(:,2)] = stats_CompAreas_rm(iCORE_B1h,iCORE_B1m);
[p_core(:,3), pc(:,3)] = stats_CompAreas_rm(iCORE_B2h,iCORE_B2m);

[p_belt(:,1), pb(:,1)] = stats_CompAreas_rm(iBELT_Ah,iBELT_Am);
[p_belt(:,2), pb(:,2)] = stats_CompAreas_rm(iBELT_B1h,iBELT_B1m);
[p_belt(:,3), pb(:,3)] = stats_CompAreas_rm(iBELT_B2h,iBELT_B2m);

% save figures...
save_dir = fullfile(DATA_PATH,'AllCombined','CompAreas','CompSMI');
save_file_name{1} = strcat('SMIComparison_',animal_name,'_CORE');
save_file_name{2} = strcat('SMIComparison_',animal_name,'_BELT');
for i=1:2
%     saveas(H(i),fullfile(save_dir,save_file_name{i}),'png');
end