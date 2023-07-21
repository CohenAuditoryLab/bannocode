% Extract Streaming probability
clear all;

% set data directory as global variable
global DATA_DIR
DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';

% set path...
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

% set triplet position to get ROC criterion (threshold for 1 or 2 stream)
% choose 1 for 1st triplet, 6 for T-1 triplet
cTP = 6; % either 1 or 6
% cTP = [1 2 3 6]; %2:6; %[1 2 3 6]; % across all triplet

% get a list of recording sessions...
load(fullfile(LIST_DIR,'RecordingDate_Both.mat'));
% load(fullfile(LIST_DIR,'RecordingDate_Domo.mat'));
% load(fullfile(LIST_DIR,'RecordingDate_Cassius.mat'));

% get streaming probability for each recording session
for ff=1:length(list_RecDate) % 2;
    RecDate = list_RecDate{ff};
    channel_dir = fullfile(ROOT_DIR,RecDate,'Resp'); % path for significant channel

    % load file
    fName = strcat(RecDate,'_SignificantChannels');
    load(fullfile(channel_dir,fName)); % load sig

    % get streaming probability
%     [pStream, list_st, sTriplet, criterion] = get_StreamingProbability(RecDate, cTP);
    [pStream, list_st, sTriplet, criterion] = get_StreamingProbability_v2(RecDate, cTP);

    % add channel information
    sig_ch = sig.Resp; % significant channels
    ch_L3u = L3u_channel(ff);
    ch_L3 = L3_channel(ff); % layer 3b if defined...
    ch_L5 = L5_channel(ff);
    i_area = area_index(ff);
    % 8/4/22 added
    uBorder = Boundary_up(ff); % upper border of thalamorecipient layer
    lBorder = Boundary_low(ff); % lower border of thalamorecipient layer
    i_AP = AP_index(ff); % index for anterior(0) and posteror(1) recording site

    % save data
    if length(cTP)==1
        if cTP==1
            save_dir = fullfile(pwd,'threshold_1stTriplet');
        elseif cTP==6
            save_dir = fullfile(pwd,'threshold_Tm1Triplet');
        else
            error('cTP must be 1 or 6!!');
        end
    else
        save_dir = fullfile(pwd,'threshold_allTriplet');
    end
    save_file_name = strcat(RecDate,'_StreamingProb');
    save(fullfile(save_dir,save_file_name),'pStream','sig_ch', ...
        'ch_L3u','ch_L3','ch_L5','uBorder','lBorder','i_area','i_AP', ...
        'sTriplet','list_st','cTP', 'criterion');
end