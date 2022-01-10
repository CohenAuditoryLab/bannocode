clear all

% path for function calculating effect size...
% addpath('C:\MatlabTools\measures-of-effect-size-toolbox');
addpath('../myFunction');

% DATA_PATH = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/';
DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response\Depth';
animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% layer = {'Sup','Deep'}; % either 'Deep' or 'Sup'
auditory_area = 'Belt'; % either 'Core', 'Belt', or 'All'
sTriplet = {'1st','2nd','3rd','Tm1','T'};

% sigRESP_A = []; sigRESP_B1 = []; sigRESP_B2 = [];
rSUP_A = []; rSUP_B1 = []; rSUP_B2 = [];
for i = 1:length(sTriplet)
    fName = strcat(animal_name,'_zMUAResp_',sTriplet{i},'Triplet');
    load(fullfile(DATA_PATH,'Sup',fName));
    % concatenate data across layer
    % channel x easy-hard x hit-miss x session x layer 
    rSUP_A  = cat(5,rSUP_A,sigRESP.A);
    rSUP_B1 = cat(5,rSUP_B1,sigRESP.B1);
    rSUP_B2 = cat(5,rSUP_B2,sigRESP.B2);
%     sigRESP_A  = cat(5,sigRESP_A,sigRESP.A);
%     sigRESP_B1 = cat(5,sigRESP_B1,sigRESP.B1);
%     sigRESP_B2 = cat(5,sigRESP_B2,sigRESP.B2);
end

rDEEP_A = []; rDEEP_B1 = []; rDEEP_B2 = [];
for i = 1:length(sTriplet)
    fName = strcat(animal_name,'_zMUAResp_',sTriplet{i},'Triplet');
    load(fullfile(DATA_PATH,'Deep',fName));
    % concatenate data across layer
    % channel x easy-hard x hit-miss x session x layer 
    rDEEP_A  = cat(5,rDEEP_A,sigRESP.A);
    rDEEP_B1 = cat(5,rDEEP_B1,sigRESP.B1);
    rDEEP_B2 = cat(5,rDEEP_B2,sigRESP.B2);
end

% choose sessions based on the recording sites...
j = 1:length(area_index);
if strcmp(auditory_area,'Core')
    j = j(area_index==1);
elseif strcmp(auditory_area,'Belt')
    j = j(area_index==0);
end
rSUP_A  = rSUP_A(:,:,:,j,:);
rSUP_B1 = rSUP_B1(:,:,:,j,:);
rSUP_B2 = rSUP_B2(:,:,:,j,:);
rDEEP_A  = rDEEP_A(:,:,:,j,:);
rDEEP_B1 = rDEEP_B1(:,:,:,j,:);
rDEEP_B2 = rDEEP_B2(:,:,:,j,:);

% compare behavioral signal in deep vs superfirical layers...
H(1) = figure;
subplot(2,2,1);
[iSUP_Ah,iSUP_Am] = plot_SMI_hitmiss(rSUP_A);
% dBehav_As = plot_index_tpos_v2(rSUP_A,'Behav'); hold on;
% dBehav_Ad = plot_index_tpos_v2(rDEEP_A,'Behav');
title('A');

subplot(2,2,3);
[iSUP_B1h,iSUP_B1m] = plot_SMI_hitmiss(rSUP_B1);
% dBehav_B1s = plot_index_tpos_v2(rSUP_B1,'Behav'); hold on;
% dBehav_B1d = plot_index_tpos_v2(rDEEP_B1,'Behav');
title('B1');

subplot(2,2,4);
[iSUP_B2h,iSUP_B2m] = plot_SMI_hitmiss(rSUP_B2);
% dBehav_B2s = plot_index_tpos_v2(rSUP_B2,'Behav'); hold on;
% dBehav_B2d = plot_index_tpos_v2(rDEEP_B2,'Behav');
title('B2');

legend({'Hit','Miss'},'Location',[0.5 0.82 0.2 0.1]);

% compare stimulus signal in deep vs superfirical layers...
H(2) = figure;
subplot(2,2,1);
[iDEEP_Ah,iDEEP_Am] = plot_SMI_hitmiss(rDEEP_A);
% dStim_As = plot_index_tpos_v2(rSUP_A,'Stim'); hold on;
% dStim_Ad = plot_index_tpos_v2(rDEEP_A,'Stim');
title('A');

subplot(2,2,3);
[iDEEP_B1h,iDEEP_B1m] = plot_SMI_hitmiss(rDEEP_B1);
% dStim_B1s = plot_index_tpos_v2(rSUP_B1,'Stim'); hold on;
% dStim_B1d = plot_index_tpos_v2(rDEEP_B1,'Stim');
title('B1');

subplot(2,2,4);
[iDEEP_B2h,iDEEP_B2m] = plot_SMI_hitmiss(rDEEP_B2);
% dStim_B2s = plot_index_tpos_v2(rSUP_B2,'Stim'); hold on;
% dStim_B2d = plot_index_tpos_v2(rDEEP_B2,'Stim');
title('B2');

legend({'Hit','Miss'},'Location',[0.5 0.82 0.2 0.1]);

% statistical comparison
p_sup(:,1) = stats_CompLayers(iSUP_Ah,iSUP_Am);
p_sup(:,2) = stats_CompLayers(iSUP_B1h,iSUP_B1m);
p_sup(:,3) = stats_CompLayers(iSUP_B2h,iSUP_B2m);

p_deep(:,1) = stats_CompLayers(iDEEP_Ah,iDEEP_Am);
p_deep(:,2) = stats_CompLayers(iDEEP_B1h,iDEEP_B1m);
p_deep(:,3) = stats_CompLayers(iDEEP_B2h,iDEEP_B2m);

% save figures...
save_dir = fullfile(DATA_PATH,'CompLayers','CompSIM');
save_file_name{1} = strcat('LayerComparison_BehavIndex_',animal_name,'_',auditory_area);
save_file_name{2} = strcat('LayerComparison_StimIndex_',animal_name,'_',auditory_area);
for i=1:2
%     saveas(H(i),fullfile(save_dir,save_file_name{i}),'png');
end

% % save data...
iSUP.A.hit = iSUP_Ah;
iSUP.A.miss = iSUP_Am;
iSUP.B1.hit = iSUP_B1h;
iSUP.B1.miss = iSUP_B1m;
iSUP.B2.hit = iSUP_B2h;
iSUP.B2.miss = iSUP_B2m;

iDEEP.A.hit = iDEEP_Ah;
iDEEP.A.miss = iDEEP_Am;
iDEEP.B1.hit = iDEEP_B1h;
iDEEP.B1.miss = iDEEP_B1m;
iDEEP.B2.hit = iDEEP_B2h;
iDEEP.B2.miss = iDEEP_B2m;

if strcmp(animal_name,'Both')
    save_file_name = strcat('ModulationIndex_',auditory_area);
%     save(fullfile(save_dir,save_file_name),'dBehav','dStim');
%     save(fullfile(save_dir,'v2',strcat(save_file_name,'_v2')),'dBehav','dStim');
end
