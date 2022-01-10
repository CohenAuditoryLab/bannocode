% create matrix of grid coordinate

LIST_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

animal = 'Cassius';
f_name = strcat('RecordingDate_',animal);
load(fullfile(LIST_PATH,f_name));

if strcmp(animal,'Domo')
    AP = [-4 -4 -4 -4 -1 -1 5 3 -3 2 -4 -4 -4 -3 -2 0];
    LM = [0 0 0 0 3 3 5 3 2 2 -1 0 0 1 1 1];
    grid = [AP' LM'];
elseif strcmp(animal,'Cassius')
    AP = [-3 0 -4 -4 0 -1 1 2 -6 -4 -6 -2 0 -3 0 -3 -5 -4 1 -6 -6 -5];
    LM = [2 1 1 0 3 0 1 1 1 1 0 3 3 1 2 -1 -1 -1 0 -1 2 1];
    grid = [AP' LM'];
end

save_file_name = strcat('Grid_', animal);
save(save_file_name,'list_RecDate','grid');