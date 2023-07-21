% 8/4/22 add laminar boundary
% get area under ROC from trial MUA
clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';
SAVE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AvsB1_v2';

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
    
    % separate trials by frequency separation
    AUC_stdiff = []; AUC_hit = []; AUC_miss = [];
    for ii=1:length(list_st)
        a = A(:,:,stDiff==list_st(ii));
        b = B1(:,:,stDiff==list_st(ii)); % compare A vs B1
        i = index(stDiff==list_st(ii));
        % check data availability
        n_hit = sum(i==0);
        n_miss = sum(i==1);
        % separate hit and miss trials
        a_hit = a(:,:,i==0);
        b_hit = b(:,:,i==0);
        a_miss = a(:,:,i==1);
        b_miss = b(:,:,i==1);
        for ch=1:n_ch % specify channel
            for tpos=1:n_tpos % specify triplet position
                a_tpos = squeeze(a(ch,tpos,:));
                b_tpos = squeeze(b(ch,tpos,:));
                % calculate ROC
                label = [zeros(length(a_tpos),1); ones(length(b_tpos),1)];
                score = [a_tpos; b_tpos];
                [~,~,~,auc(ch,tpos)] = perfcurve(label,score,0); % assume A is larger than B
                clear a_tpos b_tpos label score
                
                if (n_hit*n_miss)==0
                    auc_hit(ch,tpos) = NaN;
                    auc_miss(ch,tpos) = NaN;
                else
                % hit trial
                a_tpos = squeeze(a_hit(ch,tpos,:));
                b_tpos = squeeze(b_hit(ch,tpos,:));
                % calculate ROC
                label = [zeros(length(a_tpos),1); ones(length(b_tpos),1)];
                score = [a_tpos; b_tpos];
                [~,~,~,auc_hit(ch,tpos)] = perfcurve(label,score,0); % assume A is larger than B
                clear a_tpos b_tpos label score

                % miss trial
                a_tpos = squeeze(a_miss(ch,tpos,:));
                b_tpos = squeeze(b_miss(ch,tpos,:));
                % calculate ROC
                label = [zeros(length(a_tpos),1); ones(length(b_tpos),1)];
                score = [a_tpos; b_tpos];
                [~,~,~,auc_miss(ch,tpos)] = perfcurve(label,score,0); % assume A is larger than B
                clear a_tpos b_tpos label score
                end
            end
        end
        AUC_stdiff = cat(3,AUC_stdiff,auc);
        AUC_hit    = cat(3,AUC_hit,auc_hit);
        AUC_miss   = cat(3,AUC_miss,auc_miss);
        clear a b i a_hit a_miss b_hit b_miss n_hit n_miss
        clear auc auc_hit auc_miss
    end
    
%     % separate trials by hit/miss
%     list_id = unique(index);
%     AUC_hitmiss = [];
%     for jj=1:length(list_id)
%     a = A(:,:,index==list_id(jj));
%     b = B1(:,:,index==list_id(jj)); % compare A vs B1
%     for ch=1:n_ch % specify channel
%         for tpos=1:n_tpos % specify triplet position
%             a_tpos = squeeze(a(ch,tpos,:));
%             b_tpos = squeeze(b(ch,tpos,:));
%             % calculate ROC
%             label = [zeros(length(a_tpos),1); ones(length(b_tpos),1)];
%             score = [a_tpos; b_tpos];
%             [~,~,~,auc(ch,tpos)] = perfcurve(label,score,0); % assume A is larger than B
%         end
%     end
%     AUC_hitmiss = cat(3,AUC_hitmiss,auc);
%     clear a b auc label score
%     end
    
%     % trials with smallest and largest frequency separation
%     A_2  = A(:,:,stDiff==list_st(1)|stDiff==list_st(end));
%     B1_2 = B1(:,:,stDiff==list_st(1)|stDiff==list_st(end));
%     B2_2 = B2(:,:,stDiff==list_st(1)|stDiff==list_st(end));
%     index2 = index(stDiff==list_st(1)|stDiff==list_st(end));
%     % separate trials by hit/miss
%     list_id = unique(index2);
%     AUC_hitmiss2 = [];
%     for jj=1:length(list_id)
%     a = A_2(:,:,index2==list_id(jj));
%     b = B1_2(:,:,index2==list_id(jj)); % compare A vs B1
%     for ch=1:n_ch % specify channel
%         for tpos=1:n_tpos % specify triplet position
%             a_tpos = squeeze(a(ch,tpos,:));
%             b_tpos = squeeze(b(ch,tpos,:));
%             % calculate ROC
%             label = [zeros(length(a_tpos),1); ones(length(b_tpos),1)];
%             score = [a_tpos; b_tpos];
%             [~,~,~,auc(ch,tpos)] = perfcurve(label,score,0); % assume A is larger than B
%         end
%     end
%     AUC_hitmiss2 = cat(3,AUC_hitmiss2,auc);
%     clear a b auc label score
%     end

    % variables to save...
    AUC.stdiff = AUC_stdiff; % channel x tpos x stdiff
    AUC.hit = AUC_hit; % channel x tpos x stdiff (hit trials)
    AUC.miss = AUC_miss; % channel x tpos x stdiff (miss trials)

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
    save_file_name = strcat(RecDate,'_ROC_v2');
    save(fullfile(SAVE_DIR,save_file_name),'AUC','sig_ch', ...
        'ch_L3u','ch_L3','ch_L5','uBorder','lBorder','i_area','i_AP', ...
        'sTriplet','list_st');
end