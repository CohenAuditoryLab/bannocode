% combine ROC across sessions
clear all

ROOT_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS';
DATA_DIR = fullfile(ROOT_PATH,'MUA\code_reanlysis\trialMUA\Streaming_Probability\threshold_allTriplet1');


% thFrom = 'Tm1Triplet'; % either '1stTriplet', 'Tm1Triplet', or 'allTriplet'
% DATA_DIR = fullfile(pwd,strcat('threshold_',thFrom));
behavOut = 'miss'; % either 'all', 'hit', or 'miss'
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer');

load RecordingDate_lowBF.mat
RecDate = list_RecDate;

N = numel(RecDate);
n_pos = sum(AP_index==1);
n_ant = sum(AP_index==0);
% concatenate data across sessions
pStream_post_df1 = NaN(24,8,4,n_pos); % channel x tpos x stdiff x session
pStream_ant_df1  = NaN(24,8,4,n_ant);
pStream_post_df2 = NaN(24,8,4,n_pos); % all dF trials
pStream_ant_df2  = NaN(24,8,4,n_ant); % all dF trials
pStream_df1 = NaN(24,8,4,N);
pStream_df2 = NaN(24,8,4,N); % all dF trials
count_pos = 1; count_ant = 1; % counter
for ff=1:length(list_RecDate)
    rec_date = list_RecDate{ff};
    fName = strcat(rec_date,'_StreamingProb');

    % load data
    load(fullfile(DATA_DIR,fName));
%     p_1srm = pStream.single_stream; % old version
%     p_2srm = pStream.dual_stream;
    if strcmp(behavOut,'all')
        p_1srm = pStream.single.all;
        p_2srm = pStream.dual.all;
    elseif strcmp(behavOut,'hit')
        p_1srm = pStream.single.hit;
        p_2srm = pStream.dual.hit;
    elseif strcmp(behavOut,'miss')
        p_1srm = pStream.single.miss;
        p_2srm = pStream.dual.miss;
    end
%     auc_hitmiss = AUC.hitmiss; % data including intermediate dF... 
%     auc_hitmiss2 = AUC.hitmiss2; % data without intermediate dF... 
    % choose significant channel
    p_1srm(sig_ch==0,:,:) = NaN;
    p_2srm(sig_ch==0,:,:) = NaN;

%     auc_hitmiss(sig_ch==0,:,:) = NaN;
%     auc_hitmiss2(sig_ch==0,:,:) = NaN;
    
    n_ch = size(p_1srm,1);
    % separate data into recording areas (Posterior or Anterior)
    if i_AP==1 % posterior
        if size(p_1srm,3)==3
            temp_ps1 = NaN(n_ch,8,4);
            temp_ps1(:,:,1) = p_1srm(:,:,1);
            temp_ps1(:,:,4) = p_1srm(:,:,end);
            pStream_post_df1(1:n_ch,:,:,count_pos) = temp_ps1;
            pStream_df1(1:n_ch,:,:,ff) = temp_ps1;

            temp_ps2 = NaN(n_ch,8,4);
            temp_ps2(:,:,1) = p_2srm(:,:,1);
            temp_ps2(:,:,4) = p_2srm(:,:,end);
            pStream_post_df2(1:n_ch,:,:,count_pos) = temp_ps2;
            pStream_df2(1:n_ch,:,:,ff) = temp_ps2;

            clear temp_ps1 temp_ps2
        else
            pStream_post_df1(1:n_ch,:,:,count_pos) = p_1srm;
            pStream_post_df2(1:n_ch,:,:,count_pos) = p_2srm;
            pStream_df1(1:n_ch,:,:,ff) = p_1srm;
            pStream_df2(1:n_ch,:,:,ff) = p_2srm;
        end
%         AUC_post_hm(1:n_ch,:,:,count_pos)  = auc_hitmiss;
%         AUC_post_hm2(1:n_ch,:,:,count_pos) = auc_hitmiss2;
        count_pos = count_pos+1;
    elseif i_AP==0 % anterior
        if size(p_1srm,3)==3
%             temp_auc = NaN(n_ch,8,4);
%             temp_auc(:,:,1) = auc_stdiff(:,:,1);
%             temp_auc(:,:,4) = auc_stdiff(:,:,end);
%             AUC_ant_df(1:n_ch,:,:,count_ant) = temp_auc;
            temp_ps1 = NaN(n_ch,8,4);
            temp_ps1(:,:,1) = p_1srm(:,:,1);
            temp_ps1(:,:,4) = p_1srm(:,:,end);
            pStream_ant_df1(1:n_ch,:,:,count_ant) = temp_ps1;
            pStream_df1(1:n_ch,:,:,ff) = temp_ps1;

            temp_ps2 = NaN(n_ch,8,4);
            temp_ps2(:,:,1) = p_2srm(:,:,1);
            temp_ps2(:,:,4) = p_2srm(:,:,end);
            pStream_ant_df2(1:n_ch,:,:,count_ant) = temp_ps2;
            pStream_df2(1:n_ch,:,:,ff) = temp_ps2;
            
            clear temp_ps1 temp_ps2
        else
            pStream_ant_df1(1:n_ch,:,:,count_ant) = p_1srm;
            pStream_ant_df2(1:n_ch,:,:,count_ant) = p_2srm;
            pStream_df1(1:n_ch,:,:,ff) = p_1srm;
            pStream_df2(1:n_ch,:,:,ff) = p_2srm;
        end
%         AUC_ant_hm(1:n_ch,:,:,count_ant)  = auc_hitmiss;
%         AUC_ant_hm2(1:n_ch,:,:,count_ant) = auc_hitmiss2;
        count_ant = count_ant + 1;
    end

end
clear pStream
% re-order matrix (ch x session x tpos x stdiff)
pStream.post.single_stream = permute(pStream_post_df1,[1 4 2 3]);
pStream.ant.single_stream  = permute(pStream_ant_df1,[1 4 2 3]);
pStream.all.single_stream  = permute(pStream_df1,[1 4 2 3]);
pStream.post.dual_stream = permute(pStream_post_df2,[1 4 2 3]);
pStream.ant.dual_stream  = permute(pStream_ant_df2,[1 4 2 3]);
pStream.all.dual_stream  = permute(pStream_df2,[1 4 2 3]);
% AUC.post.hitmiss = permute(AUC_post_hm,[1 4 2 3]); % all dF trials
% AUC.ant.hitmiss  = permute(AUC_ant_hm,[1 4 2 3]);
% AUC.post.hitmiss2 = permute(AUC_post_hm2,[1 4 2 3]); % small and large dF trials
% AUC.ant.hitmiss2  = permute(AUC_ant_hm2,[1 4 2 3]);

% save
save_file_name = 'StreamingProb_lowBF';
if strcmp(behavOut,'hit')
    save_file_name = strcat(save_file_name,'_hit');
elseif strcmp(behavOut,'miss')
    save_file_name = strcat(save_file_name,'_miss');
end
save(save_file_name,'pStream','list_RecDate','sTriplet', ...
                    'AP_index','area_index');
