% combine ROC across sessions
clear all

ROOT_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS';
DATA_DIR = fullfile(ROOT_PATH,'MUA\code_reanlysis\trialMUA\ROC_ABB');

addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% BF_Session = 'low'; % either 'low', 'high', or 'all'
isIntermDF = 'n'; % include ('y') or exclude ('n') intermediate dF trials

load RecordingDate_lowBF.mat
RecDate = list_RecDate;

N = numel(RecDate);
n_pos = sum(AP_index==1);
n_ant = sum(AP_index==0);
% concatenate data across sessions
AUC_post_stim = NaN(24,8,3,n_pos); % channel x tpos x ABB x session
AUC_ant_stim  = NaN(24,8,3,n_ant);
AUC_all_stim  = NaN(24,8,3,N);
AUC_post_behav = NaN(24,8,4,3,n_pos); % ch x tpos x stdiff x ABB x session
AUC_ant_behav  = NaN(24,8,4,3,n_ant); 
AUC_all_behav  = NaN(24,8,4,3,N);
count_pos = 1; count_ant = 1; % counter
for ff=1:length(list_RecDate)
    rec_date = list_RecDate{ff};
    fName = strcat(rec_date,'_ROC_ABB');

    % load data
    load(fullfile(DATA_DIR,fName));
    auc_stim  = AUC.stim;
    auc_behav = AUC.behav; % data including intermediate dF... 
    % choose significant channel
    auc_stim(sig_ch==0,:,:) = NaN; 
    auc_behav(sig_ch==0,:,:,:) = NaN;
    
    n_ch = size(auc_stim,1);
    % separate data into recording areas (Posterior or Anterior)
    if i_AP==1 % posterior
        if size(auc_behav,3)==3 % in case 3 dF levels...
            temp_auc = NaN(n_ch,8,4,3); % ch x tpos x stdiff x ABB
            temp_auc(:,:,1,:) = auc_behav(:,:,1,:);
            temp_auc(:,:,4,:) = auc_behav(:,:,end,:);
            if strcmp(isIntermDF,'y')
                temp_auc(:,:,2,:) = auc_behav(:,:,2,:);
            end
            AUC_post_behav(1:n_ch,:,:,:,count_pos) = temp_auc;
            AUC_post_stim(1:n_ch,:,:,count_pos) = auc_stim;

            AUC_all_behav(1:n_ch,:,:,:,ff) = temp_auc;
            AUC_all_stim(1:n_ch,:,:,ff) = auc_stim;

            clear temp_auc
%             clear temp_hit temp_miss
        else
            AUC_post_behav(1:n_ch,:,:,:,count_pos) = auc_behav;
            AUC_post_stim(1:n_ch,:,:,count_pos) = auc_stim;

            AUC_all_behav(1:n_ch,:,:,:,ff) = auc_behav;
            AUC_all_stim(1:n_ch,:,:,ff) = auc_stim;
        end
        % counter increment
        count_pos = count_pos+1;
    elseif i_AP==0 % anterior
        if size(auc_behav,3)==3
            temp_auc = NaN(n_ch,8,4,3); % ch x tpos x stdiff x ABB
            temp_auc(:,:,1,:) = auc_behav(:,:,1,:);
            temp_auc(:,:,4,:) = auc_behav(:,:,end,:);
            if strcmp(isIntermDF,'y')
                temp_auc(:,:,2,:) = auc_behav(:,:,2,:);
            end
            AUC_ant_behav(1:n_ch,:,:,:,count_ant) = temp_auc;
            AUC_ant_stim(1:n_ch,:,:,count_ant) = auc_stim;

            AUC_all_behav(1:n_ch,:,:,:,ff) = temp_auc;
            AUC_all_stim(1:n_ch,:,:,ff) = auc_stim;

            clear temp_auc 
%             clear temp_hit temp_miss
        else
            AUC_ant_behav(1:n_ch,:,:,:,count_ant) = auc_behav;
            AUC_ant_stim(1:n_ch,:,:,count_ant) = auc_stim;

            AUC_all_behav(1:n_ch,:,:,:,ff) = auc_behav;
            AUC_all_stim(1:n_ch,:,:,ff) = auc_stim;
        end
        % counter increment
        count_ant = count_ant + 1;
    end

end
clear AUC
% re-order matrix (ch x session x tpos x ABB)
AUC.post.stim = permute(AUC_post_stim,[1 4 2 3]);
AUC.ant.stim  = permute(AUC_ant_stim,[1 4 2 3]);
AUC.all.stim  = permute(AUC_all_stim,[1 4 2 3]);
% re-order matrix (ch x session x tpos x stdiff x ABB)
AUC.post.behav = permute(AUC_post_behav,[1 5 2 3 4]); % hit trials
AUC.ant.behav  = permute(AUC_ant_behav,[1 5 2 3 4]);
AUC.all.behav  = permute(AUC_all_behav,[1 5 2 3 4]);

% save
save_file_name = strcat('modROC_ABB_lowBF');
if strcmp(isIntermDF,'y')
    save_file_name = strcat(save_file_name,'_wIntermDF'); % add extension
end
% save_dir = DATA_DIR;
save(fullfile(save_file_name),'AUC','list_RecDate','sTriplet', ...
                              'AP_index','area_index');




