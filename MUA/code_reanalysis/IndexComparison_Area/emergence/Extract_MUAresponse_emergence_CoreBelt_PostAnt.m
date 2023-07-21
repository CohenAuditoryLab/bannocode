% 8/9/22 modified to add area separation based on anterior vs posterior
clear all

% path for function
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
% path for list
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
% path for data...
DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';

animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
sTriplet = {'Tm3','Tm2','Tm1','T','Tp1'};
% sTriplet = {'1st','2nd','3rd'};

sigRESP_A = []; sigRESP_B1 = []; sigRESP_B2 = [];
% rSUP_A = []; rSUP_B1 = []; rSUP_B2 = [];
for i = 1:length(sTriplet)
    fName = strcat(animal_name,'_zMUAResp_',sTriplet{i},'Triplet');
    if strcmp(animal_name,'Both')
        load(fullfile(DATA_PATH,'AllCombined',fName));
        load(strcat('RecordingDate_',animal_name));
    else
        load(fullfile(DATA_PATH,fName));
        load(strcat('RecordingDate_',animal_name));
    end
    % concatenate data across layer
    % channel x easy-hard x hit-miss x session x layer 
    sigRESP_A  = cat(5,sigRESP_A,sigRESP.A);
    sigRESP_B1 = cat(5,sigRESP_B1,sigRESP.B1);
    sigRESP_B2 = cat(5,sigRESP_B2,sigRESP.B2);
end

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

% 8/9/22 modified
j = 1:length(AP_index);
j_post = j(AP_index==1);
j_ant  = j(AP_index==0);
rPOST.A  = sigRESP_A(:,:,:,j_post,:);
rPOST.B1 = sigRESP_B1(:,:,:,j_post,:);
rPOST.B2 = sigRESP_B2(:,:,:,j_post,:);
rANT.A   = sigRESP_A(:,:,:,j_ant,:);
rANT.B1  = sigRESP_B1(:,:,:,j_ant,:);
rANT.B2  = sigRESP_B2(:,:,:,j_ant,:);
clear j

if strcmp(sTriplet{1},'1st')
    save_file_name = 'MUAResponse_early_CoreBelt_PostAnt';
elseif strcmp(sTriplet{1},'Tm3')
    save_file_name = 'MUAResponse_late_CoreBelt_PostAnt';
end
save(save_file_name,'rCORE','rBELT','rPOST','rANT','animal_name','sTriplet');