% combine ROC across sessions
clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB_ttime';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer');

% set parameters...
Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
BF_Session = 'all'; % either 'low', 'high', or 'all'
% i_domo = [8 13];
i_domo = [7 8 10 13];
% i_cassius = [2 3 5 7 9 10 11 13 16 18 19 21];
i_cassius = [2 3 5 7 9 10 11 12 13 15 16 17 18 19 20 21];


% load Data
load LayerAssignment.mat;
if strcmp(Animal_Name,'Domo')
    load RecordingDate_Domo.mat
    depth_index(:,17:end) = [];
    i_HighBFSession = i_domo;
elseif strcmp(Animal_Name,'Cassius')
    load RecordingDate_Cassius.mat
    depth_index(:,1:16) = [];
    i_HighBFSession = i_cassius;
else % Both
    load RecordingDate_Both.mat
    i_HighBFSession = [i_domo i_cassius+16];
end

% select session by BF
if strcmp(BF_Session,'low')
    % remove sessions with high BF
    list_RecDate(i_HighBFSession) = [];
    AP_index(i_HighBFSession) = [];
    area_index(i_HighBFSession) = [];
    depth_index(:,i_HighBFSession) = [];
elseif strcmp(BF_Session,'high')
    % remove sessions with low BF
    list_RecDate = list_RecDate(i_HighBFSession);
    AP_index = AP_index(i_HighBFSession);
    area_index = area_index(i_HighBFSession);
    depth_index = depth_index(:,i_HighBFSession);
end

% % remove sessions with high BF
% list_RecDate(i_HighBFSession) = [];
% AP_index(i_HighBFSession) = [];
% area_index(i_HighBFSession) = [];
% depth_index(:,i_HighBFSession) = [];

n_pos = sum(AP_index==1);
n_ant = sum(AP_index==0);
% concatenate data across sessions
AUC_post_tt = NaN(24,4,n_pos); % channel x ttime x session
AUC_ant_tt  = NaN(24,4,n_ant);
AUC_post_tt2 = NaN(24,4,n_pos); % channel x ttime x session
AUC_ant_tt2  = NaN(24,4,n_ant);
% AUC_post_ttdf = NaN(24,4,4,n_pos); % channel x ttime x stdiff x session
% AUC_ant_ttdf  = NaN(24,4,4,n_ant);
% AUC_post_hm = NaN(24,4,2,n_pos); % all dF trials
% AUC_ant_hm = NaN(24,4,2,n_ant); % all dF trials
% AUC_post_hm2 = NaN(24,4,2,n_pos); % small and large dF trials
% AUC_ant_hm2 = NaN(24,4,2,n_ant); % small and large dF trials
count_pos = 1; count_ant = 1; % counter
for ff=1:length(list_RecDate)
    rec_date = list_RecDate{ff};
    fName = strcat(rec_date,'_ROC_target_ttime');

    % load data
    load(fullfile(DATA_DIR,fName));
    auc_target = AUC.target; % data including intermediate dF... 
    auc_target2  = AUC.target2; % data without intermediate dF... 
%     auc_hitmiss = AUC.hitmiss; % data including intermediate dF... 
%     auc_hitmiss2 = AUC.hitmiss2; % data without intermediate dF... 
    % choose significant channel
    auc_target(sig_ch==0,:) = NaN;
    auc_target2(sig_ch==0,:,:) = NaN;
%     auc_hitmiss(sig_ch==0,:,:) = NaN;
%     auc_hitmiss2(sig_ch==0,:,:) = NaN;
    
    n_ch = size(auc_target,1);
    % separate data into recording areas (Posterior or Anterior)
    if i_AP==1 % posterior
%         if size(auc_ttdf,3)==3
%             temp_auc = NaN(n_ch,4,4); % ch x target pos x stdiff
%             temp_auc(:,:,1) = auc_ttdf(:,:,1);
%             temp_auc(:,:,4) = auc_ttdf(:,:,end);
%             AUC_post_ttdf(1:n_ch,:,:,count_pos) = temp_auc;
%             clear temp_auc
%         else
%             AUC_post_ttdf(1:n_ch,:,:,count_pos) = auc_ttdf;
%         end

        AUC_post_tt(1:n_ch,:,count_pos)    = auc_target;
        AUC_post_tt2(1:n_ch,:,count_pos)   = auc_target2;
%         AUC_post_hm(1:n_ch,:,:,count_pos)  = auc_hitmiss;
%         AUC_post_hm2(1:n_ch,:,:,count_pos) = auc_hitmiss2;
        count_pos = count_pos+1;
    elseif i_AP==0 % anterior
%         if size(auc_ttdf,3)==3
%             temp_auc = NaN(n_ch,4,4); % ch x target pos x stdiff
%             temp_auc(:,:,1) = auc_ttdf(:,:,1);
%             temp_auc(:,:,4) = auc_ttdf(:,:,end);
%             AUC_ant_ttdf(1:n_ch,:,:,count_ant) = temp_auc;
%             clear temp_auc
%         else
%             AUC_ant_ttdf(1:n_ch,:,:,count_ant) = auc_ttdf;
%         end

        AUC_ant_tt(1:n_ch,:,count_ant)    = auc_target;
        AUC_ant_tt2(1:n_ch,:,count_ant)   = auc_target2;
%         AUC_ant_hm(1:n_ch,:,:,count_ant)  = auc_hitmiss;
%         AUC_ant_hm2(1:n_ch,:,:,count_ant) = auc_hitmiss2;
        count_ant = count_ant + 1;
    end
    
    clear AUC
end

% re-order matrix
% (ch x session x ttime) for ttime
% (ch x session x ttime x hit-miss) for hitmiss
AUC.post.target = permute(AUC_post_tt,[1 3 2]);
AUC.ant.target  = permute(AUC_ant_tt,[1 3 2]);
AUC.post.target2 = permute(AUC_post_tt2,[1 3 2]);
AUC.ant.target2  = permute(AUC_ant_tt2,[1 3 2]);
% AUC.post.ttdf = permute(AUC_post_ttdf,[1 4 2 3]);
% AUC.ant.ttdf  = permute(AUC_ant_ttdf,[1 4 2 3]);
% AUC.post.hitmiss = permute(AUC_post_hm,[1 4 2 3]); % all dF trials
% AUC.ant.hitmiss  = permute(AUC_ant_hm,[1 4 2 3]);
% AUC.post.hitmiss2 = permute(AUC_post_hm2,[1 4 2 3]); % small and large dF trials
% AUC.ant.hitmiss2  = permute(AUC_ant_hm2,[1 4 2 3]);

% save
save_file_name = strcat('ROC_',Animal_Name,'_target_',BF_Session,'BF');
save_dir = DATA_DIR;
save(fullfile(save_dir,save_file_name),'AUC','list_RecDate', ...
             'depth_index','AP_index','area_index');



