% re-analyze the data by using redefined area boundary

clear all

% set path for data...
% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% set path for RecordingDate_Both.mat
INFO_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis';
animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% layer = {'Sup','Deep'}; % either 'Deep' or 'Sup'
% auditory_area = 'Belt'; % either 'Core', 'Belt', or 'All'
sTriplet = {'1st','2nd','3rd','Tm1','T','Tp1'};

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

% re-define area (8/3/22)
clear area_index % area_index didn't change but make sure to use the value from RecordingDate_Both.mat
load(fullfile(INFO_PATH,'RecordingDate_Both.mat'));

% choose sessions based on the recording sites...
j = 1:length(area_index);
j_core = j(area_index==1);
j_belt = j(area_index==0);
rCORE.A  = sigRESP_A(:,:,:,j_core,:);
rCORE.B1 = sigRESP_B1(:,:,:,j_core,:);
rCORE.B2 = sigRESP_B2(:,:,:,j_core,:);
rBELT.A  = sigRESP_A(:,:,:,j_belt,:);
rBELT.B1 = sigRESP_B1(:,:,:,j_belt,:);
rBELT.B2 = sigRESP_B2(:,:,:,j_belt,:);
clear j

% 8/3/22 added
j = 1:length(AP_index);
j_pos = j(AP_index==1); % posterior sites
j_ant = j(AP_index==0); % anterior sites
rPOS.A  = sigRESP_A(:,:,:,j_pos,:);
rPOS.B1 = sigRESP_B1(:,:,:,j_pos,:);
rPOS.B2 = sigRESP_B2(:,:,:,j_pos,:);
rANT.A  = sigRESP_A(:,:,:,j_ant,:);
rANT.B1 = sigRESP_B1(:,:,:,j_ant,:);
rANT.B2 = sigRESP_B2(:,:,:,j_ant,:);
clear j

save_file_name = 'MUAResponse_area';
save(save_file_name,'rCORE','rBELT','rPOS','rANT','animal_name','sTriplet');