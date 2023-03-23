clear all

animal_name = 'Both'; % either 'Domo', 'Cassius' or 'Both'
% auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
isSave = 0; % 1 for saving figure...



% addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
addpath('../');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code');
load(strcat('RecordingDate_',animal_name));
root_dir = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';

% initialization...
nSig_core = 0; nSig_belt = 0;
N_core = 0; N_belt = 0;
for ff=1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
%     L3_ch = L3_channel(ff);
    
    f_dir = fullfile(root_dir,rec_date,'RESP');
    f_name = strcat(rec_date,'_SignificantChannels');
    load(fullfile(f_dir,f_name));

    area_id = area_index(ff); % core - 1; belt - 0; 
    if area_id==1 % count core
        s = sig.Resp;
        nSig_core = nSig_core + sum(s);
        N_core = N_core + length(s);
    elseif area_id==0 % count belt
        s = sig.Resp;
        nSig_belt = nSig_belt + sum(s);
        N_belt = N_belt + length(s);
    end

end

