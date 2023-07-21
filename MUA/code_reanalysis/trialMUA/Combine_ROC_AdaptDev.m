% combine ROC across sessions
clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AdaptDev';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer');

% set parameters...
Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
BF_Session = 'low'; % either 'low', 'high', or 'all'
tone = 'B1'; % 'A' or 'B1'
isIntermDF = 'y'; % include ('y') or exclude ('n') intermediate dF trials
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

n_pos = sum(AP_index==1);
n_ant = sum(AP_index==0);
% concatenate data across sessions
% channel x stdiff x all-hit-miss x session 
AUC_post_adaptation = NaN(24,4,3,n_pos); 
AUC_ant_adaptation  = NaN(24,4,3,n_ant);
AUC_post_deviance = NaN(24,4,3,n_pos); 
AUC_ant_deviance  = NaN(24,4,3,n_ant); 
count_pos = 1; count_ant = 1; % counter
for ff=1:length(list_RecDate)
    rec_date = list_RecDate{ff};
    fName = strcat(rec_date,'_ROC_AdaptDev_',tone);

    % load data
    load(fullfile(DATA_DIR,strcat('tone_',tone),fName));
    auc_adapt = AUC.adapt;
    auc_dev   = AUC.deviance; 
    % choose significant channel
    auc_adapt(sig_ch==0,:,:) = NaN; 
    auc_dev(sig_ch==0,:,:) = NaN;
    
    n_ch = size(auc_adapt,1);
    % separate data into recording areas (Posterior or Anterior)
    if i_AP==1 % posterior
        if size(auc_adapt,2)==3
            temp_adapt = NaN(n_ch,4,3);
            temp_adapt(:,1,:) = auc_adapt(:,1,:);
            temp_adapt(:,4,:) = auc_adapt(:,end,:);
            if strcmp(isIntermDF,'y')
                temp_adapt(:,2,:) = auc_adapt(:,2,:); % intermediate dF
            end
            AUC_post_adaptation(1:n_ch,:,:,count_pos) = temp_adapt;

            temp_dev = NaN(n_ch,4,3);
            temp_dev(:,1,:) = auc_dev(:,1,:);
            temp_dev(:,4,:) = auc_dev(:,end,:);
            if strcmp(isIntermDF,'y')
                temp_dev(:,2,:) = auc_dev(:,2,:); % intermediate dF
            end
            AUC_post_deviance(1:n_ch,:,:,count_pos) = temp_dev;

            clear temp_adapt temp_dev
        else
            AUC_post_adaptation(1:n_ch,:,:,count_pos) = auc_adapt;
            AUC_post_deviance(1:n_ch,:,:,count_pos) = auc_dev;
        end
        % count up
        count_pos = count_pos+1;
    elseif i_AP==0 % anterior
        if size(auc_adapt,2)==3
            temp_adapt = NaN(n_ch,4,3);
            temp_adapt(:,1,:) = auc_adapt(:,1,:);
            temp_adapt(:,4,:) = auc_adapt(:,end,:);
            if strcmp(isIntermDF,'y')
                temp_adapt(:,2,:) = auc_adapt(:,2,:); % intermediate dF
            end
            AUC_ant_adaptation(1:n_ch,:,:,count_ant) = temp_adapt;

            temp_dev = NaN(n_ch,4,3);
            temp_dev(:,1,:) = auc_dev(:,1,:);
            temp_dev(:,4,:) = auc_dev(:,end,:);
            if strcmp(isIntermDF,'y')
                temp_dev(:,2,:) = auc_dev(:,2,:); % intermediate dF
            end
            AUC_ant_deviance(1:n_ch,:,:,count_ant) = temp_dev;

            clear temp_adapt temp_dev
        else
            AUC_ant_adaptation(1:n_ch,:,:,count_ant) = auc_adapt;
            AUC_ant_deviance(1:n_ch,:,:,count_ant) = auc_dev;
        end
        % count up
        count_ant = count_ant + 1;
    end

end
clear AUC
% re-order matrix (ch x session x stdiff x all-hit-miss)
AUC.post.adaptation = permute(AUC_post_adaptation,[1 4 2 3]);
AUC.ant.adaptation  = permute(AUC_ant_adaptation,[1 4 2 3]);
AUC.post.deviance = permute(AUC_post_deviance,[1 4 2 3]);
AUC.ant.deviance  = permute(AUC_ant_deviance,[1 4 2 3]);


% save
save_file_name = strcat('ROC_',Animal_Name,'_AdaptDev_',tone,'_',BF_Session,'BF');
if strcmp(isIntermDF,'y')
    save_file_name = strcat(save_file_name,'_wIntermDF'); % add extension
end
save_dir = DATA_DIR;
save(fullfile(save_dir,save_file_name),'AUC','list_RecDate', ...
             'depth_index','AP_index','area_index');




