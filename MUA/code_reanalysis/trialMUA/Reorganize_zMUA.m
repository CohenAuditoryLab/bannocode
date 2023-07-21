% 8/4/22 add laminar boundary
% get area under ROC from trial MUA
clear all

ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA';
DATA_DIR = fullfile(ROOT_DIR,'code_reanlysis','trialMUA','zMUA_trial');
RSLT_DIR = fullfile(ROOT_DIR,'Results');
LIST_DIR = fullfile(ROOT_DIR,'code');
SAVE_DIR = fullfile(ROOT_DIR,'code_reanlysis','trialMUA','Reorganize_zMUA');

% load(fullfile(LIST_DIR,'RecordingDate_Domo.mat'));
load(fullfile(LIST_DIR,'RecordingDate_Cassius.mat'));
% RecDate = '20180709';
% RecDate = '20200110';
% RecDate = '20210220';

for ff=1:numel(list_RecDate)
    RecDate = list_RecDate{ff};
    channel_dir = fullfile(RSLT_DIR,RecDate,'Resp'); % path for significant channel
    
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
    
    % separate trials by frequency separation
%     zMUA_stdiff = cell(1,length(list_st));
%     zMUA_hit  = cell(1,length(list_st)); % separate hit trials
%     zMUA_miss = cell(1,length(list_st)); % separate miss trials
%     sigMUA_stdiff = cell(1,length(list_st));
%     sigMUA_hit  = cell(1,length(list_st)); % separate hit trials
%     sigMUA_miss = cell(1,length(list_st)); % separate miss trials

    zMUA_stdiff = [];
    zMUA_hit = [];
    zMUA_miss = [];
    for ii=1:length(list_st)
        a  = A(:,:,stDiff==list_st(ii));
        b1 = B1(:,:,stDiff==list_st(ii));
        b2 = B2(:,:,stDiff==list_st(ii));
        % concatenate triplet
        % channel x tpos x trial x abb
        abb = cat(4,a,b1,b2);
        % choose significant channels...
        abb_sig = abb;
        abb_sig(sig.Resp==0,:,:,:) = NaN;
        
        % separate hit and miss trials
        temp_index  = index(stDiff==list_st(ii));
        abb_hit  = abb(:,:,temp_index==0,:);
        abb_miss = abb(:,:,temp_index==1,:);
        abb_hit_sig  = abb_sig(:,:,temp_index==0,:);
        abb_miss_sig = abb_sig(:,:,temp_index==1,:);
        
        % trial mean
        mabb = squeeze(nanmean(abb,3));
        mabb_hit = squeeze(nanmean(abb_hit,3));
        mabb_miss = squeeze(nanmean(abb_miss,3));
%         mabb = squeeze(nanmean(abb_sig,3));
%         mabb_hit = squeeze(nanmean(abb_hit_sig,3));
%         mabb_miss = squeeze(nanmean(abb_miss_sig,3));

%         zMUA_stdiff{ii} = abb;
%         zMUA_hit{ii}  = abb_hit;
%         zMUA_miss{ii} = abb_miss;
%         sigMUA_stdiff{ii} = abb_sig;
%         sigMUA_hit{ii}  = abb_hit_sig;
%         sigMUA_miss{ii} = abb_miss_sig;

        zMUA_stdiff(:,:,:,ii) = mabb;
        zMUA_hit(:,:,:,ii)  = mabb_hit;
        zMUA_miss(:,:,:,ii) = mabb_miss;

        clear a b1 b2 temp_index
        clear abb abb_hit abb_miss
        clear abb_sig abb_hit_sig abb_miss_sig
        clear mabb mabb_hit mabb_miss
    end
    
    % variables to save...
    zMUA.stdiff = permute(zMUA_stdiff,[1 2 4 3]); % channel x tpos x stdiff x abb
    zMUA.hit  = permute(zMUA_hit,[1 2 4 3]); % channel x tpos x stdiff x abb
    zMUA.miss = permute(zMUA_miss,[1 2 4 3]); % channel x tpos x stdif x abb

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
    
    % save
    save_file_name = strcat(RecDate,'_zMUA');
    save(fullfile(SAVE_DIR,save_file_name), 'zMUA', ...
        'sig_ch','ch_L3u','ch_L3','ch_L5','uBorder','lBorder','i_area','i_AP', ...
        'sTriplet','list_st');
%     save(fullfile(SAVE_DIR,save_file_name), ...
%         'zMUA_stdiff','zMUA_hit','zMUA_miss', ...
%         'sigMUA_stdiff','sigMUA_hit','sigMUA_miss', ...
%         'sig_ch','ch_L3u','ch_L3','ch_L5','uBorder','lBorder','i_area','i_AP', ...
%         'sTriplet','list_st');
end