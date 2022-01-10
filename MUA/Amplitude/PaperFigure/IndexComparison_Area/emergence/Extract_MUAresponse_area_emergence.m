clear all

% path for function calculating effect size...
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');

% DATA_PATH = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/';
DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% layer = {'Sup','Deep'}; % either 'Deep' or 'Sup'
% auditory_area = 'Belt'; % either 'Core', 'Belt', or 'All'
sTriplet = {'Tm3','Tm2','Tm1','T'};

sigRESP_A = []; sigRESP_B1 = []; sigRESP_B2 = [];
% rSUP_A = []; rSUP_B1 = []; rSUP_B2 = [];
for i = 1:length(sTriplet)
    fName = strcat(animal_name,'_zMUAResp_',sTriplet{i},'Triplet');
    if strcmp(animal_name,'Both')
        load(fullfile(DATA_PATH,'AllCombined',fName));
    else
        load(fullfile(DATA_PATH,fName));
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


save_file_name = 'MUAResponse_area_emergence';
save(save_file_name,'rCORE','rBELT','animal_name','sTriplet');