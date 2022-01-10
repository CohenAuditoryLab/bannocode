clear all


% set path for data directory
DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% layer = {'Sup','Deep'}; % either 'Deep' or 'Sup'
% auditory_area = 'Belt'; % either 'Core', 'Belt', or 'All'
sTriplet = 'T'; % specify the folder for the analysis...

% sigRESP_A = []; sigRESP_B1 = []; sigRESP_B2 = [];
fName = strcat(animal_name,'_zMUAResp_tpos_',sTriplet,'Triplet');
folder = strcat('zScore_',sTriplet,'Triplet');
load(fullfile(DATA_PATH,folder,'TargetPosition',fName));
% concatenate data across layer
% channel x easy-hard x hit-miss x session x layer
% sigRESP_A  = cat(5,sigRESP_A,sigRESP.A);
% sigRESP_B1 = cat(5,sigRESP_B1,sigRESP.B1);
% sigRESP_B2 = cat(5,sigRESP_B2,sigRESP.B2);
sigRESP_A  = sigRESP.A;
sigRESP_B1 = sigRESP.B1;
sigRESP_B2 = sigRESP.B2;


% choose sessions based on the recording sites...
j = 1:length(area_index);
j_core = j(area_index==1);
j_belt = j(area_index==0);
rCORE.A  = sigRESP_A(:,:,:,j_core);
rCORE.B1 = sigRESP_B1(:,:,:,j_core);
rCORE.B2 = sigRESP_B2(:,:,:,j_core);
rBELT.A  = sigRESP_A(:,:,:,j_belt);
rBELT.B1 = sigRESP_B1(:,:,:,j_belt);
rBELT.B2 = sigRESP_B2(:,:,:,j_belt);

save_file_name = 'MUAResponse_area_ttime';
save(save_file_name,'rCORE','rBELT','animal_name','sTriplet');