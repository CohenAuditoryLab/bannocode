% evaluate adaptation and deviance detection by ROC
% get area under ROC from trial MUA
clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';
SAVE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AdaptDev';

load(fullfile(LIST_DIR,'RecordingDate_Domo.mat'));
% load(fullfile(LIST_DIR,'RecordingDate_Cassius.mat'));
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
    % separete A tone resp by triplet position
    A  = squeeze(zMUA_trial(:,1,:,:));
    a_1st = A(:,1,:); % 1st triplet position
    a_Tm1 = A(:,6,:); % T-1 triplet position
    a_Tgt = A(:,7,:); % Target

    list_st = unique(stDiff);
    n_ch = size(zMUA_trial,1);
    n_tpos = length(sTriplet);
    
    
    % separate trials by frequency separation
    AUC_adapt = []; AUC_deviance = []; % initialize
    for ii=1:length(list_st)
        aa_1st = a_1st(:,:,stDiff==list_st(ii));
        aa_Tm1 = a_Tm1(:,:,stDiff==list_st(ii));
        aa_Tgt = a_Tgt(:,:,stDiff==list_st(ii));
        i = index(stDiff==list_st(ii));
        % check data availability
        n_hit = sum(i==0);
        n_miss = sum(i==1);
        % separate hit and miss trials
        h_1st = aa_1st(:,:,i==0);
        h_Tm1 = aa_Tm1(:,:,i==0);
        h_Tgt = aa_Tgt(:,:,i==0);
        m_1st = aa_1st(:,:,i==1);
        m_Tm1 = aa_Tm1(:,:,i==1);
        m_Tgt = aa_Tgt(:,:,i==1);
        for ch=1:n_ch % specify channel
            a_1st_ch = squeeze(aa_1st(ch,:,:));
            a_Tm1_ch = squeeze(aa_Tm1(ch,:,:));
            a_Tgt_ch = squeeze(aa_Tgt(ch,:,:));
            % calculate ROC
            label = [zeros(length(a_1st_ch),1); ones(length(a_Tm1_ch),1)];
            score = [a_1st_ch; a_Tm1_ch];
            [~,~,~,auc_adapt(ch,1)] = perfcurve(label,score,0); % assume 1st is larger than (T-1)
            clear label score
            label = [zeros(length(a_Tm1_ch),1); ones(length(a_Tgt_ch),1)];
            score = [a_Tm1_ch; a_Tgt_ch];
            [~,~,~,auc_deviance(ch,1)] = perfcurve(label,score,1); % assume Target is larger than (T-1)
            clear a_1st_ch a_Tm1_ch a_Tgt_ch label score

            if (n_hit*n_miss)==0
                auc_adapt_hit(ch,1) = NaN;
                auc_deviance_hit(ch,1) = NaN;
                auc_adapt_miss(ch,1) = NaN;
                auc_deviance_miss(ch,1) = NaN;
            else
                % hit trial
                h_1st_ch = squeeze(h_1st(ch,:,:));
                h_Tm1_ch = squeeze(h_Tm1(ch,:,:));
                h_Tgt_ch = squeeze(h_Tgt(ch,:,:));
                % calculate ROC
                label = [zeros(length(h_1st_ch),1); ones(length(h_Tm1_ch),1)];
                score = [h_1st_ch; h_Tm1_ch];
                [~,~,~,auc_adapt_hit(ch,1)] = perfcurve(label,score,0); % assume 1st is larger than (T-1)
                clear label score
                label = [zeros(length(h_Tm1_ch),1); ones(length(h_Tgt_ch),1)];
                score = [h_Tm1_ch; h_Tgt_ch];
                [~,~,~,auc_deviance_hit(ch,1)] = perfcurve(label,score,1); % assume T is larger than (T-1)
                clear h_1st_ch h_Tm1_ch h_Tgt_ch label score

                % miss trial
                m_1st_ch = squeeze(m_1st(ch,:,:));
                m_Tm1_ch = squeeze(m_Tm1(ch,:,:));
                m_Tgt_ch = squeeze(m_Tgt(ch,:,:));
                % calculate ROC
                label = [zeros(length(m_1st_ch),1); ones(length(m_Tm1_ch),1)];
                score = [m_1st_ch; m_Tm1_ch];
                [~,~,~,auc_adapt_miss(ch,1)] = perfcurve(label,score,0); % assume 1st is larger than (T-1)
                clear label score
                label = [zeros(length(m_Tm1_ch),1); ones(length(m_Tgt_ch),1)];
                score = [m_Tm1_ch; m_Tgt_ch];
                [~,~,~,auc_deviance_miss(ch,1)] = perfcurve(label,score,1); % assume T is larger than (T-1)
                clear m_1st_ch m_Tm1_ch m_Tgt_ch label score
            end
        end
        % combine data [all hit miss]
        temp_auc_adapt    = [auc_adapt auc_adapt_hit auc_adapt_miss];
        temp_auc_deviance = [auc_deviance auc_deviance_hit auc_deviance_miss];
        % concatenate data across stdiff
        AUC_adapt    = cat(3,AUC_adapt,temp_auc_adapt);
        AUC_deviance = cat(3,AUC_deviance,temp_auc_deviance);
        
        clear aa_1st aa_Tm1 aa_Tgt i n_hit n_miss
        clear h_1st h_Tm1 h_Tgt m_1st m_Tm1 m_Tgt
        clear auc_adapt auc_adapt_hit auc_adapt_miss temp_auc_adapt
        clear auc_deviance auc_deviance_hit auc_deviance_miss temp_auc_deviance
    end
    % reshape matrix (ch x stdiff x all-hit-miss)
    AUC_adapt    = permute(AUC_adapt,[1 3 2]);
    AUC_deviance = permute(AUC_deviance,[1 3 2]);
    

    % variables to save...
    AUC.adapt    = AUC_adapt; % channel x stdiff x all-hit-miss
    AUC.deviance = AUC_deviance; % channel x stdiff x all-hit-miss

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
    save_file_name = strcat(RecDate,'_ROC_AdaptDev_A');
    save(fullfile(SAVE_DIR,'tone_A',save_file_name),'AUC','sig_ch', ...
        'ch_L3u','ch_L3','ch_L5','uBorder','lBorder','i_area','i_AP', ...
        'sTriplet','list_st');
end