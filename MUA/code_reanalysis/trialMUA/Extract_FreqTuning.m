% 8/4/22 add laminar boundary
% get area under ROC from trial MUA
clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';
SAVE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\FreqTuning';

% load(fullfile(LIST_DIR,'RecordingDate_Domo.mat'));
load(fullfile(LIST_DIR,'RecordingDate_Cassius.mat'));
% RecDate = '20180709';
% RecDate = '20200110';
% RecDate = '20210220';

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
    
    list_st = unique(stDiff);
    n_ch = size(zMUA_trial,1);
    n_tpos = length(sTriplet);
    
    % % % GET TRIAL MEAN RESPONSE % % %
    % mean A response from all trials
    A_all = mean(A,3); 
    % separate trials by frequency separation
    for ii=1:length(list_st)
        A_stdiff(:,:,ii)  = mean(A(:,:,stDiff==list_st(ii)),3);
        B1_stdiff(:,:,ii) = mean(B1(:,:,stDiff==list_st(ii)),3); 
        B2_stdiff(:,:,ii) = mean(B2(:,:,stDiff==list_st(ii)),3); % not used...
    end
    % obtain selectivity/sparseness index
    % selectivity index version 1
    [sl_index,sp_index] = calc_SLSPindex(A_all,B1_stdiff,1);
    % selectivity index version 2
    [sl_index2,sp_index] = calc_SLSPindex(A_all,B1_stdiff,2);

    % separete hit and miss trials
    A_hit = A(:,:,index==0); A_miss = A(:,:,index==1);
    B1_hit = B1(:,:,index==0); B1_miss = B1(:,:,index==1);
    B2_hit = B2(:,:,index==0); B2_miss = B2(:,:,index==1);
    std_hit = stDiff(index==0); std_miss = stDiff(index==1);
    A_all_h = mean(A_hit,3); A_all_m = mean(A_miss,3);
    for ii=1:length(list_st)
        A_std_h(:,:,ii)  = mean(A_hit(:,:,std_hit==list_st(ii)),3);
        B1_std_h(:,:,ii) = mean(B1_hit(:,:,std_hit==list_st(ii)),3); 
        B2_std_h(:,:,ii) = mean(B2_hit(:,:,std_hit==list_st(ii)),3); % not used...
        A_std_m(:,:,ii)  = mean(A_miss(:,:,std_miss==list_st(ii)),3);
        B1_std_m(:,:,ii) = mean(B1_miss(:,:,std_miss==list_st(ii)),3); 
        B2_std_m(:,:,ii) = mean(B2_miss(:,:,std_miss==list_st(ii)),3); % not used...
    end
    % obtain selectivity/sparseness index
    % version 1
    [sl_index_h,sp_index_h] = calc_SLSPindex(A_all_h,B1_std_h,1);
    [sl_index_m,sp_index_m] = calc_SLSPindex(A_all_m,B1_std_m,1);
    % version 2
    [sl_index2_h,sp_index_h] = calc_SLSPindex(A_all_h,B1_std_h,2);
    [sl_index2_m,sp_index_m] = calc_SLSPindex(A_all_m,B1_std_m,2);


    % variables to save...
    select_index.all  = sl_index; % channel x tpos 
    select_index.hit  = sl_index_h; % channel x tpos 
    select_index.miss = sl_index_m; % channel x tpos 

    select_index2.all  = sl_index2; % channel x tpos 
    select_index2.hit  = sl_index2_h; % channel x tpos 
    select_index2.miss = sl_index2_m; % channel x tpos

    sparse_index.all  = sp_index; % channel x tpos 
    sparse_index.hit  = sp_index_h; % channel x tpos 
    sparse_index.miss = sp_index_m; % channel x tpos 

    sig_ch = sig.Resp; % significant channels
    ch_L3u = L3u_channel(ff);
    ch_L3 = L3_channel(ff); % layer 3b if defined...
    ch_L5 = L5_channel(ff);
    i_area = area_index(ff);
    % 8/4/22 added
    uBorder = Boundary_up(ff); % upper border of thalamorecipient layer
    lBorder = Boundary_low(ff); % lower border of thalamorecipient layer
    i_AP = AP_index(ff); % index for anterior(0) and posteror(1) recording site
    
    % save
    save_file_name = strcat(RecDate,'_FreqTuning');
    save(fullfile(SAVE_DIR,save_file_name),'select_index','select_index2','sparse_index', ...
        'sig_ch','ch_L3u','ch_L3','ch_L5','uBorder','lBorder','i_area','i_AP', ...
        'sTriplet','list_st');
end