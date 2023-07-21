% modified from Extract_ROC_ttime.m
% data were further separated by frequency separation
clear all

% % % set path...
DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';
SAVE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AvsB1_ttime2';

% % % get list of recording date...
% load(fullfile(LIST_DIR,'RecordingDate_Domo.mat'));
load(fullfile(LIST_DIR,'RecordingDate_Cassius.mat'));


for ff=1:numel(list_RecDate)
    RecDate = list_RecDate{ff};
    channel_dir = fullfile(ROOT_DIR,RecDate,'Resp'); % path for significant channel
    
    fName1 = strcat(RecDate,'_zMUA_trial');
    fName2 = strcat(RecDate,'_SignificantChannels');
    
    load(fullfile(DATA_DIR,fName1));
    load(fullfile(channel_dir,fName2));
    
    % remove FA trial
    zMUA_trial(:,:,:,index==2) = [];
    stDiff(index==2) = [];
    targetTime(index==2) = [];
    index(index==2) = [];
    % separete data into tone burst (A, B1 and B2)
    A  = squeeze(zMUA_trial(:,1,:,:));
    B1 = squeeze(zMUA_trial(:,2,:,:));
    B2 = squeeze(zMUA_trial(:,3,:,:)); % not used..
    
    n_ch = size(zMUA_trial,1);    % number of channels
    list_st = unique(stDiff);     % stdiff
    list_tt = unique(targetTime); % target time
    
    % get ROC value
    AUC_ttime = calc_ROC_ttime(A,B1,targetTime,list_tt);
    
    % % % separate trials by hit/miss
    list_id = unique(index);
    AUC_hitmiss = [];
    for jj=1:length(list_id)
        a_hm = A(:,:,index==list_id(jj));
        b_hm = B1(:,:,index==list_id(jj)); % compare A vs B1
        tt_hm = targetTime(index==list_id(jj));
        % get ROC value
        auc_hm = calc_ROC_ttime(a_hm,b_hm,tt_hm,list_tt);

        AUC_hitmiss = cat(3,AUC_hitmiss,auc_hm);
        clear a_hm b_hm auc_hm label score
    end
    
    % trials with smallest and largest frequency separation
    A_2  = A(:,:,stDiff==list_st(1)|stDiff==list_st(end));
    B1_2 = B1(:,:,stDiff==list_st(1)|stDiff==list_st(end));
    B2_2 = B2(:,:,stDiff==list_st(1)|stDiff==list_st(end));
    index2 = index(stDiff==list_st(1)|stDiff==list_st(end));
    targetTime2 = targetTime(stDiff==list_st(1)|stDiff==list_st(end));
    % separate trials by hit/miss
    list_id = unique(index2);
    AUC_hitmiss2 = [];
    for jj=1:length(list_id)
        a_hm2 = A_2(:,:,index2==list_id(jj));
        b_hm2 = B1_2(:,:,index2==list_id(jj)); % compare A vs B1
        tt_hm2 = targetTime2(index2==list_id(jj));
        % get ROC value
        auc_hm2 = calc_ROC_ttime(a_hm2,b_hm2,tt_hm2,list_tt);

        AUC_hitmiss2 = cat(3,AUC_hitmiss2,auc_hm2);
        clear a_hm2 b_hm2 auc_hm2 label score
    end

    
    
    % % % separate trials by frequency separation (added 12/21/22)
    for ii=1:length(list_st)
        a = A(:,:,stDiff==list_st(ii));
        b = B1(:,:,stDiff==list_st(ii)); % compare A vs B1
        ttime = targetTime(stDiff==list_st(ii));
        % get ROC value
        AUC_ttime_df(:,:,ii) = calc_ROC_ttime(a,b,ttime,list_tt);

        clear a b ttime
    end

    % % % variables to save...
    AUC.ttime    = AUC_ttime; % channel x ttime
    AUC.ttime_df = AUC_ttime_df; % channel x ttime x stdiff
    AUC.hitmiss  = AUC_hitmiss; % channel x ttime x hit-miss
    AUC.hitmiss2 = AUC_hitmiss2; % channel x ttime x hit-miss

    sig_ch = sig.Resp; % significant channels
    ch_L3u = L3u_channel(ff);
    ch_L3 = L3_channel(ff); % layer 3b if defined...
    ch_L5 = L5_channel(ff);
    i_area = area_index(ff);
    % 8/4/22 added
    uBorder = Boundary_up(ff); % upper border of thalamorecipient layer
    lBorder = Boundary_low(ff); % lower border of thalamorecipient layer
    i_AP = AP_index(ff); % index for anterior(0) and posteror(1) recording site
    
    % % % save
    save_file_name = strcat(RecDate,'_ROC_ttime2');
    save(fullfile(SAVE_DIR,save_file_name),'AUC','sig_ch', ...
        'ch_L3u','ch_L3','ch_L5','uBorder','lBorder','i_area','i_AP', ...
        'sTriplet','list_st','list_tt');
end