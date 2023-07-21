% combine ROC across sessions
clear all

ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis';
DATA_DIR = fullfile(ROOT_DIR,'trialMUA','Reorganize_zMUA');
addpath(ROOT_DIR);
addpath(fullfile(ROOT_DIR,'IndexComparison_Layer'));

% set parameters...
Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
BF_Session = 'low'; % either 'low', 'high', or 'all'
isIntermDF = 'n'; % include ('y') or exclude ('n') intermediate dF trials
% specify session ID with high best frequency
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
% AUC_post_stim = NaN(24,8,3,n_pos); % channel x tpos x ABB x session
% AUC_ant_stim  = NaN(24,8,3,n_ant);
zMUA_post = NaN(24,8,4,3,n_pos); % ch x tpos x stdiff x ABB x session
zMUA_ant  = NaN(24,8,4,3,n_ant); 
zMUA_post_hit = NaN(24,8,4,3,n_pos); % ch x tpos x stdiff x ABB x session
zMUA_ant_hit  = NaN(24,8,4,3,n_ant); 
zMUA_post_miss = NaN(24,8,4,3,n_pos); % ch x tpos x stdiff x ABB x session
zMUA_ant_miss  = NaN(24,8,4,3,n_ant); 
count_pos = 1; count_ant = 1; % counter
for ff=1:length(list_RecDate)
    rec_date = list_RecDate{ff};
    fName = strcat(rec_date,'_zMUA');

    % load data
    load(fullfile(DATA_DIR,fName));
    mua_stdiff = zMUA.stdiff; % data including intermediate dF...
    mua_hit  = zMUA.hit;
    mua_miss = zMUA.miss;

    % choose significant channel
    mua_stdiff(sig_ch==0,:,:,:) = NaN; 
    mua_hit(sig_ch==0,:,:,:) = NaN;
    mua_miss(sig_ch==0,:,:,:) = NaN;
    
    n_ch = size(mua_stdiff,1);
    % separate data into recording areas (Posterior or Anterior)
    if i_AP==1 % posterior
        if size(mua_stdiff,3)==3 % in case 3 dF levels...
            temp_mua = NaN(n_ch,8,4,3); % ch x tpos x stdiff x ABB
            temp_mua(:,:,1,:) = mua_stdiff(:,:,1,:);
            temp_mua(:,:,4,:) = mua_stdiff(:,:,end,:);
            temp_hit = NaN(n_ch,8,4,3); % ch x tpos x stdiff x ABB
            temp_hit(:,:,1,:) = mua_hit(:,:,1,:);
            temp_hit(:,:,4,:) = mua_hit(:,:,end,:);
            temp_miss = NaN(n_ch,8,4,3); % ch x tpos x stdiff x ABB
            temp_miss(:,:,1,:) = mua_miss(:,:,1,:);
            temp_miss(:,:,4,:) = mua_miss(:,:,end,:);
            if strcmp(isIntermDF,'y')
                temp_mua(:,:,2,:) = mua_stdiff(:,:,2,:);
                temp_hit(:,:,2,:) = mua_hit(:,:,2,:);
                temp_miss(:,:,2,:) = mua_miss(:,:,2,:);
            end
            zMUA_post(1:n_ch,:,:,:,count_pos) = temp_mua;
            zMUA_post_hit(1:n_ch,:,:,:,count_pos) = temp_hit;
            zMUA_post_miss(1:n_ch,:,:,:,count_pos) = temp_miss;

            clear temp_auc temp_hit temp_miss
        else
            zMUA_post(1:n_ch,:,:,:,count_pos) = mua_stdiff;
            zMUA_post_hit(1:n_ch,:,:,:,count_pos) = mua_hit;
            zMUA_post_miss(1:n_ch,:,:,:,count_pos) = mua_miss;
        end
        % counter increment
        count_pos = count_pos+1;

    elseif i_AP==0 % anterior
        if size(mua_stdiff,3)==3
            temp_mua = NaN(n_ch,8,4,3); % ch x tpos x stdiff x ABB
            temp_mua(:,:,1,:) = mua_stdiff(:,:,1,:);
            temp_mua(:,:,4,:) = mua_stdiff(:,:,end,:);
            temp_hit = NaN(n_ch,8,4,3); % ch x tpos x stdiff x ABB
            temp_hit(:,:,1,:) = mua_hit(:,:,1,:);
            temp_hit(:,:,4,:) = mua_hit(:,:,end,:);
            temp_miss = NaN(n_ch,8,4,3); % ch x tpos x stdiff x ABB
            temp_miss(:,:,1,:) = mua_miss(:,:,1,:);
            temp_miss(:,:,4,:) = mua_miss(:,:,end,:);
            if strcmp(isIntermDF,'y')
                temp_mua(:,:,2,:) = mua_stdiff(:,:,2,:);
                temp_hit(:,:,2,:) = mua_hit(:,:,2,:);
                temp_miss(:,:,2,:) = mua_miss(:,:,2,:);
            end
            zMUA_ant(1:n_ch,:,:,:,count_pos) = temp_mua;
            zMUA_ant_hit(1:n_ch,:,:,:,count_pos) = temp_hit;
            zMUA_ant_miss(1:n_ch,:,:,:,count_pos) = temp_miss;

            clear temp_auc temp_hit temp_miss
        else
            zMUA_ant(1:n_ch,:,:,:,count_pos) = mua_stdiff;
            zMUA_ant_hit(1:n_ch,:,:,:,count_pos) = mua_hit;
            zMUA_ant_miss(1:n_ch,:,:,:,count_pos) = mua_miss;
        end
        % counter increment
        count_ant = count_ant + 1;
    end

end
clear zMUA
% re-order matrix (ch x session x tpos x ABB)
% AUC.post.stim = permute(AUC_post_stim,[1 4 2 3]);
% AUC.ant.stim  = permute(AUC_ant_stim,[1 4 2 3]);

% re-order matrix (ch x session x tpos x stdiff x ABB)
zMUA.post.stdiff = permute(zMUA_post,[1 5 2 3 4]);
zMUA.ant.stdiff  = permute(zMUA_ant,[1 5 2 3 4]);
zMUA.post.hit = permute(zMUA_post_hit,[1 5 2 3 4]); % hit trials
zMUA.ant.hit  = permute(zMUA_ant_hit,[1 5 2 3 4]);
zMUA.post.miss = permute(zMUA_post_miss,[1 5 2 3 4]); % miss trials
zMUA.ant.miss  = permute(zMUA_ant_miss,[1 5 2 3 4]);

% save
save_file_name = strcat('zMUA_',Animal_Name,'_ABB_',BF_Session,'BF');
if strcmp(isIntermDF,'y')
    save_file_name = strcat(save_file_name,'_wIntermDF'); % add extension
end
save_dir = DATA_DIR;
save(fullfile(save_dir,save_file_name),'zMUA','list_RecDate','sTriplet', ...
             'depth_index','AP_index','area_index');




