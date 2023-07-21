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
sTriplet = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};

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

load(fullfile(INFO_PATH,'RecordingDate_Both.mat'));
rALL.A  = sigRESP_A;
rALL.B1 = sigRESP_B1;
rALL.B2 = sigRESP_B2;

% save data...
save_file_name = 'MUAResponse_all';
save(save_file_name,'rALL','animal_name','sTriplet','area_index','AP_index');