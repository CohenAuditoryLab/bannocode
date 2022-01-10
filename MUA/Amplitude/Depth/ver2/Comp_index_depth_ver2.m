clear all

% path for function calculating effect size...
% addpath('C:\MatlabTools\measures-of-effect-size-toolbox');
addpath('../../myFunction');

ROOT_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
DATA_PATH = fullfile(ROOT_PATH,'Depth_ver2');
animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% layer = {'Sup','Deep'}; % either 'Deep' or 'Sup'
auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
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
dBehav_As = plot_index_tpos_v2(rSUP_A,'Behav'); hold on;
dBehav_Ad = plot_index_tpos_v2(rDEEP_A,'Behav');
title('A');

subplot(2,2,3);
dBehav_B1s = plot_index_tpos_v2(rSUP_B1,'Behav'); hold on;
dBehav_B1d = plot_index_tpos_v2(rDEEP_B1,'Behav');
title('B1');

subplot(2,2,4);
dBehav_B2s = plot_index_tpos_v2(rSUP_B2,'Behav'); hold on;
dBehav_B2d = plot_index_tpos_v2(rDEEP_B2,'Behav');
title('B2');

legend({'superficial','deep'},'Location',[0.5 0.82 0.2 0.1]);

% compare stimulus signal in deep vs superfirical layers...
H(2) = figure;
subplot(2,2,1);
dStim_As = plot_index_tpos_v2(rSUP_A,'Stim'); hold on;
dStim_Ad = plot_index_tpos_v2(rDEEP_A,'Stim');
title('A');

subplot(2,2,3);
dStim_B1s = plot_index_tpos_v2(rSUP_B1,'Stim'); hold on;
dStim_B1d = plot_index_tpos_v2(rDEEP_B1,'Stim');
title('B1');

subplot(2,2,4);
dStim_B2s = plot_index_tpos_v2(rSUP_B2,'Stim'); hold on;
dStim_B2d = plot_index_tpos_v2(rDEEP_B2,'Stim');
title('B2');

legend({'superficial','deep'},'Location',[0.5 0.82 0.2 0.1]);

% statistical comparison
p_behav(:,1) = stats_CompLayers(dBehav_As,dBehav_Ad);
p_behav(:,2) = stats_CompLayers(dBehav_B1s,dBehav_B1d);
p_behav(:,3) = stats_CompLayers(dBehav_B2s,dBehav_B2d);

p_stim(:,1) = stats_CompLayers(dStim_As,dStim_Ad);
p_stim(:,2) = stats_CompLayers(dStim_B1s,dStim_B1d);
p_stim(:,3) = stats_CompLayers(dStim_B2s,dStim_B2d);

% save figures...
save_dir = fullfile(DATA_PATH,'CompLayers',animal_name);
save_file_name{1} = strcat('LayerComparison_BehavIndex_',animal_name,'_',auditory_area);
save_file_name{2} = strcat('LayerComparison_StimIndex_',animal_name,'_',auditory_area);
for i=1:2
%     saveas(H(i),fullfile(save_dir,save_file_name{i}),'png');
end

% save data...
dBehav.A.sup = dBehav_As;
dBehav.A.deep = dBehav_Ad;
dBehav.B1.sup = dBehav_B1s;
dBehav.B1.deep = dBehav_B1d;
dBehav.B2.sup = dBehav_B2s;
dBehav.B2.deep = dBehav_B2d;

dStim.A.sup = dStim_As;
dStim.A.deep = dStim_Ad;
dStim.B1.sup = dStim_B1s;
dStim.B1.deep = dStim_B1d;
dStim.B2.sup = dStim_B2s;
dStim.B2.deep = dStim_B2d;

if strcmp(animal_name,'Both')
    save_file_name = strcat('ModulationIndex_',auditory_area);
%     save(fullfile(save_dir,save_file_name),'dBehav','dStim');
%     save(fullfile(save_dir,'v2',strcat(save_file_name,'_v2')),'dBehav','dStim');
end
