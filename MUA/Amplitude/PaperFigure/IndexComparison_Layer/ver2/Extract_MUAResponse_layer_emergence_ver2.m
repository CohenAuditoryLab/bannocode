clear all

ROOT_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
DATA_PATH = 'Depth_ver2';
animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% layer = {'Sup','Deep'}; % either 'Deep' or 'Sup'
% auditory_area = 'Core'; % either 'Core', 'Belt', or 'All'
areas = {'Core','Belt'};
sTriplet = {'Tm3','Tm2','Tm1','T'};

% sigRESP_A = []; sigRESP_B1 = []; sigRESP_B2 = [];
rSUP_A = []; rSUP_B1 = []; rSUP_B2 = [];
for i = 1:length(sTriplet)
    fName = strcat(animal_name,'_zMUAResp_',sTriplet{i},'Triplet');
    load(fullfile(ROOT_PATH,DATA_PATH,'Sup',fName));
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
    load(fullfile(ROOT_PATH,DATA_PATH,'Deep',fName));
    % concatenate data across layer
    % channel x easy-hard x hit-miss x session x layer 
    rDEEP_A  = cat(5,rDEEP_A,sigRESP.A);
    rDEEP_B1 = cat(5,rDEEP_B1,sigRESP.B1);
    rDEEP_B2 = cat(5,rDEEP_B2,sigRESP.B2);
end


for n=1:numel(areas)
    % define auditory area (Core or Belt)...
    auditory_area = areas{n};
    
    % choose sessions based on the recording sites...
    j = 1:length(area_index);
    if strcmp(auditory_area,'Core')
        j = j(area_index==1);
    elseif strcmp(auditory_area,'Belt')
        j = j(area_index==0);
    end
    rSUP.A  = rSUP_A(:,:,:,j,:);
    rSUP.B1 = rSUP_B1(:,:,:,j,:);
    rSUP.B2 = rSUP_B2(:,:,:,j,:);
    rDEEP.A  = rDEEP_A(:,:,:,j,:);
    rDEEP.B1 = rDEEP_B1(:,:,:,j,:);
    rDEEP.B2 = rDEEP_B2(:,:,:,j,:);
    % combine data into struct...
    if strcmp(auditory_area,'Core')
        rCore = struct('rSUP',rSUP,'rDEEP',rDEEP);
    elseif strcmp(auditory_area,'Belt')
        rBelt = struct('rSUP',rSUP,'rDEEP',rDEEP);
    end
end

save_file_name = 'MUAResponse_Layer_emergence_ver2';
save(save_file_name,'rCore','rBelt','animal_name','sTriplet');