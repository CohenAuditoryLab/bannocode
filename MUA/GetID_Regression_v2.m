% modified from GetID_Regression_v2
% add channel_id
clear all;

% set path
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

% ABB = 'A'; % either A, B1 or B2
% layer = 'I'; % choose depth, either 'S' or 'G' or 'I'
animal_name = 'Both'; %'Cassius';

fName = strcat('RecordingDate_',animal_name);
load(fullfile(LIST_DIR,fName));
% load(fullfile(LIST_DIR,'RecordingDate_Both'));

% initialize variables
electrode_id.core = []; electrode_id.belt = [];
channel_id.core = []; channel_id.belt = [];
layer_id.core = []; layer_id.belt = [];
session.core = []; session.belt = [];
eCount_core = 0; eCount_belt = 0; % electrode counter...
for ff=1:numel(list_RecDate)
    RecDate = list_RecDate{ff};
    
    % load data
    data_dir = fullfile(ROOT_DIR,RecDate,'RESP');
    fName = strcat(RecDate,'_MUAProperty2_emergence');
    load(fullfile(data_dir,fName));
    
    e_id = ones(size(sig_ch)); % electrode id
    
    c_id = transpose(1:length(sig_ch)); % channel id

    % assign layer id; 1--supra, 2--granular, 3--infra
    l_id = NaN(length(sig_ch),1); % initialize layer id
%     if strcmp(layer,'S') % supragranular layer
        if ~isnan(ch_L3)
            l_id(1:ch_L3-1) = 1;
        end
%     elseif strcmp(layer,'I') % infragranular layer
        if ~isnan(ch_L5)
            l_id(ch_L5:end) = 3;
        end
%     elseif strcmp(layer,'G') % granular layer
        if ~isnan(ch_L3*ch_L5)
            l_id(ch_L3:ch_L5-1) = 2;
        end
%     end
    e_id(sig_ch==0) = [];
    c_id(sig_ch==0) = [];
    l_id(sig_ch==0) = [];
    

    if ~isempty(e_id)
    if i_area == 1
        eCount_core = eCount_core + 1; % count up
        e_id_core = e_id * eCount_core;
        electrode_id.core = [electrode_id.core; e_id_core];
        channel_id.core = [channel_id.core; c_id];
        layer_id.core = [layer_id.core; l_id];
        session.core = [session.core; RecDate];
    elseif i_area == 0
        eCount_belt = eCount_belt + 1;
        e_id_belt = e_id * eCount_belt;
        electrode_id.belt = [electrode_id.belt; e_id_belt];
        channel_id.belt = [channel_id.belt; c_id];
        layer_id.belt = [layer_id.belt; l_id];
        session.belt = [session.belt; RecDate];
    end
    end

    clear e_id l_id c_id
end

nUnit.core = length(electrode_id.core);
nUnit.belt = length(electrode_id.belt);
nUnit.total = nUnit.core + nUnit.belt;

save_file_name = strcat('MUA_ID_',animal_name);
save(fullfile(LIST_DIR,save_file_name),'electrode_id','channel_id','layer_id','session','nUnit');



% end