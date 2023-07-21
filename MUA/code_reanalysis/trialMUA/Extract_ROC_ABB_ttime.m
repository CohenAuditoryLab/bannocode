% replace CI, FSI, BMI by ROC
% get area under ROC from trial MUA
% analyses of target time
clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';
SAVE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB_ttime';

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
%     B1 = squeeze(zMUA_trial(:,2,:,:));
%     B2 = squeeze(zMUA_trial(:,3,:,:)); 
    
    list_st = unique(stDiff); % cannot separate be semitone diff...
    list_tt = unique(targetTime);
    n_ch = size(zMUA_trial,1);
    n_tpos = length(sTriplet);
    
    % trials with smallest and largest frequency separation
    A_2  = A(:,:,stDiff==list_st(1)|stDiff==list_st(end));
    index2 = index(stDiff==list_st(1)|stDiff==list_st(end));
    targetTime2 = targetTime(stDiff==list_st(1)|stDiff==list_st(end));

    % get target response
    T_hit  = squeeze(A(:,7,index==0)); % hit
    T_miss = squeeze(A(:,7,index==1)); % miss
    tt_hit  = targetTime(index==0);
    tt_miss = targetTime(index==1);

    T_hit2  = squeeze(A_2(:,7,index2==0)); % hit
    T_miss2 = squeeze(A_2(:,7,index2==1)); % miss
    tt_hit2  = targetTime2(index2==0);
    tt_miss2 = targetTime2(index2==1);

    for ii=1:length(list_tt) % as a function of ttime...
        % separate target time
        T_h  = T_hit(:,tt_hit==list_tt(ii));
        T_m  = T_miss(:,tt_miss==list_tt(ii));
        T_h2 = T_hit2(:,tt_hit2==list_tt(ii));
        T_m2 = T_miss2(:,tt_miss2==list_tt(ii));
        for ch=1:n_ch
            Tch_h = transpose(T_h(ch,:));
            Tch_m = transpose(T_m(ch,:));
            Tch_h2 = transpose(T_h2(ch,:));
            Tch_m2 = transpose(T_m2(ch,:));
            if length(Tch_h)*length(Tch_m)==0 % in case of missing data...
                AUC_target(ch,ii) = NaN;
            else
                % calculate ROC (from all dF conditions)
                label = [zeros(length(Tch_h),1); ones(length(Tch_m),1)];
                score_T = [Tch_h; Tch_m];
                [~,~,~,AUC_target(ch,ii)] = perfcurve(label,score_T,0); % assume larger response in hit trials
            end
            clear Tch_h Tch_m
            clear label score_T
            if length(Tch_h2)*length(Tch_m2)==0
                AUC_target2(ch,ii) = NaN;
            else
                % calculate ROC (from smallest and largest dF conditions)
                label2 = [zeros(length(Tch_h2),1); ones(length(Tch_m2),1)];
                score_T2 = [Tch_h2; Tch_m2];
                [~,~,~,AUC_target2(ch,ii)] = perfcurve(label2,score_T2,0); % assume larger response in hit trials
            end
            clear Tch_h2 Tch_m2
            clear label2 score_T2
        end
        clear T_h T_m T_h2 T_m2
    end

    

    % variables to save...
    % behavioral modulation on target
    AUC.target  = AUC_target; % channel x ttime (all dF conditions)
    AUC.target2 = AUC_target2; % channel x ttime (smallest and large dF)

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
    save_file_name = strcat(RecDate,'_ROC_target_ttime');
    save(fullfile(SAVE_DIR,save_file_name),'AUC','sig_ch', ...
        'ch_L3u','ch_L3','ch_L5','uBorder','lBorder','i_area','i_AP', ...
        'sTriplet','list_st');
end