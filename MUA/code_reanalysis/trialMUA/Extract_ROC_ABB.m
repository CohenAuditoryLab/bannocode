% replace CI, FSI, BMI by ROC
% get area under ROC from trial MUA
clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';
SAVE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB';

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
    B2 = squeeze(zMUA_trial(:,3,:,:)); 
    
    list_st = unique(stDiff);
    n_ch = size(zMUA_trial,1);
    n_tpos = length(sTriplet);
    
    a_sdf = A(:,:,stDiff==list_st(1)); % small dF trial
    a_ldf = A(:,:,stDiff==list_st(end)); % large dF trial
    b1_sdf = B1(:,:,stDiff==list_st(1));
    b1_ldf = B1(:,:,stDiff==list_st(end));
    b2_sdf = B2(:,:,stDiff==list_st(1));
    b2_ldf = B2(:,:,stDiff==list_st(end));
    
    AUC_stim = []; AUC_behav = []; % initialize
    % compare small dF vs large dF
    for ch = 1:n_ch
        for tpos = 1:n_tpos
            sA_tpos = squeeze(a_sdf(ch,tpos,:));
            lA_tpos = squeeze(a_ldf(ch,tpos,:));
            sB1_tpos = squeeze(b1_sdf(ch,tpos,:));
            lB1_tpos = squeeze(b1_ldf(ch,tpos,:));
            sB2_tpos = squeeze(b2_sdf(ch,tpos,:));
            lB2_tpos = squeeze(b2_ldf(ch,tpos,:));
            % calculate ROC
            label = [zeros(length(sA_tpos),1); ones(length(lA_tpos),1)];
            score_a = [sA_tpos; lA_tpos];
            score_b1 = [sB1_tpos; lB1_tpos];
            score_b2 = [sB2_tpos; lB2_tpos];
            [~,~,~,AUC_stim(ch,tpos,1)] = perfcurve(label,score_a,0); % assume larger response in small dF
            [~,~,~,AUC_stim(ch,tpos,2)] = perfcurve(label,score_b1,0); 
            [~,~,~,AUC_stim(ch,tpos,3)] = perfcurve(label,score_b2,0); 
            clear sA_tpos lA_tpos sB1_tpos lB1_tpos sB2_tpos lB2_tpos
            clear label score_a score_b1 score_b2
        end
    end

    % compare hit vs miss (separately for each dF)
    for ii=1:length(list_st)
        A_hitmiss  = A(:,:,stDiff==list_st(ii));
        B1_hitmiss = B1(:,:,stDiff==list_st(ii));
        B2_hitmiss = B2(:,:,stDiff==list_st(ii));
        i = index(stDiff==list_st(ii));
        % check data availability
        n_hit = sum(i==0);
        n_miss = sum(i==1);
        % separate hit and miss trials
        a_h  = A_hitmiss(:,:,i==0);
        b1_h = B1_hitmiss(:,:,i==0);
        b2_h = B2_hitmiss(:,:,i==0);
        a_m  = A_hitmiss(:,:,i==1);
        b1_m = B1_hitmiss(:,:,i==1);
        b2_m = B2_hitmiss(:,:,i==1);

        for ch=1:n_ch
            for tpos=1:n_tpos
                if (n_hit*n_miss)==0
                    auc_hit(ch,tpos) = NaN;
                    auc_miss(ch,tpos) = NaN;
                else
                    % hit trial
                    hA_tpos = squeeze(a_h(ch,tpos,:)); % hit
                    mA_tpos = squeeze(a_m(ch,tpos,:)); % miss
                    hB1_tpos = squeeze(b1_h(ch,tpos,:));
                    mB1_tpos = squeeze(b1_m(ch,tpos,:));
                    hB2_tpos = squeeze(b2_h(ch,tpos,:));
                    mB2_tpos = squeeze(b2_m(ch,tpos,:));
                    % calculate ROC
                    label = [zeros(length(hA_tpos),1); ones(length(mA_tpos),1)];
                    score_a = [hA_tpos; mA_tpos];
                    score_b1 = [hB1_tpos; mB1_tpos];
                    score_b2 = [hB2_tpos; mB2_tpos];
                    [~,~,~,AUC_behav(ch,tpos,ii,1)] = perfcurve(label,score_a,0); % assume larger response in hit trials
                    [~,~,~,AUC_behav(ch,tpos,ii,2)] = perfcurve(label,score_b1,0);
                    [~,~,~,AUC_behav(ch,tpos,ii,3)] = perfcurve(label,score_b2,0);
                    clear hA_tpos mA_tpos hB1_tpos mB1_tpos hB2_tpos mB2_tpos
                    clear label score_a score_b1 score_b2
                end
            end
        end
    end
    

    % variables to save...
    AUC.stim  = AUC_stim; % channel x tpos x ABB
    AUC.behav = AUC_behav; % channel x tpos x stdiff x ABB

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
    save_file_name = strcat(RecDate,'_ROC_ABB');
    save(fullfile(SAVE_DIR,save_file_name),'AUC','sig_ch', ...
        'ch_L3u','ch_L3','ch_L5','uBorder','lBorder','i_area','i_AP', ...
        'sTriplet','list_st');
end