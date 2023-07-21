% combine ROC across sessions
clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer');

% set parameters...
Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
BF_Session = 'high'; % either 'low', 'high', or 'all'
% i_domo = [8 13];
i_domo = [7 8 10 13];
% i_cassius = [2 3 5 7 9 10 11 13 16 18 19 21];
i_cassius = [2 3 5 7 9 10 11 12 13 15 16 17 18 19 20 21];
% tpos = [1 2 3 6 7];
% tpos = 4:8;
% tpos = [1 2 3 6 7 8];
% tpos = 1:8;
% line_color = [0.0000 0.4470 0.7410; 0.8500 0.3250 0.0980];
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];

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
% channel x tpos x session
zA_post = NaN(24,8,n_pos); 
zA_ant  = NaN(24,8,n_ant); 
zA_post_hit = NaN(24,8,n_pos);
zA_ant_hit = NaN(24,8,n_ant); 
zA_post_miss = NaN(24,8,n_pos); 
zA_ant_miss = NaN(24,8,n_ant); 


count_pos = 1; count_ant = 1; % counter
for ff=1:length(list_RecDate)
    rec_date = list_RecDate{ff};
    channel_dir = fullfile(ROOT_DIR,rec_date,'Resp'); % path for significant channel
    i_AP = AP_index(ff); % index for anterior(0) and posteror(1) recording site
    % specify file name
    fName1 = strcat(rec_date,'_zMUA_trial');
    fName2 = strcat(rec_date,'_SignificantChannels');

    % load data
    load(fullfile(DATA_DIR,fName1));
    load(fullfile(channel_dir,fName2));
    % choose largest dF trials
    list_st = unique(stDiff);
    zMUA_trial = zMUA_trial(:,:,:,stDiff==max(list_st));
    targetTime = targetTime(stDiff==max(list_st));
    index = index(stDiff==max(list_st));
    stDiff = stDiff(stDiff==max(list_st));
    % separate hit and miss trial
    zA_hit  = squeeze(zMUA_trial(:,1,:,index==0));
    zA_miss = squeeze(zMUA_trial(:,1,:,index==1));
    zA_all  = cat(3,zA_hit,zA_miss);
    % average across trials
    mR_hit  = mean(zA_hit,3);
    mR_miss = mean(zA_miss,3);
    mR_all  = mean(zA_all,3);
    sig_ch = sig.Resp; % significant channels
    % choose significant channel
    mR_hit(sig_ch==0,:,:) = NaN; 
    mR_miss(sig_ch==0,:,:) = NaN;
    mR_all(sig_ch==0,:,:) = NaN;
    
    
    n_ch = size(mR_all,1);
    % separate data into recording areas (Posterior or Anterior)
    if i_AP==1 % posterior
        % mean MUA response to A tone
        zA_post(1:n_ch,:,count_pos) = mR_all;
        zA_post_hit(1:n_ch,:,count_pos) = mR_hit;
        zA_post_miss(1:n_ch,:,count_pos) = mR_miss;

        count_pos = count_pos+1;
    elseif i_AP==0 % anterior
        % mean MUA response to A tone
        zA_ant(1:n_ch,:,count_ant) = mR_all;
        zA_ant_hit(1:n_ch,:,count_ant) = mR_hit;
        zA_ant_miss(1:n_ch,:,count_ant) = mR_miss;

        count_ant = count_ant + 1;
    end

end
% clear AUC
% re-order matrix (ch x session x tpos)
mResp_A.post.all = permute(zA_post,[1 3 2]); % hit and miss trials combined
mResp_A.ant.all  = permute(zA_ant,[1 3 2]);
mResp_A.post.hit = permute(zA_post_hit,[1 3 2]); % hit trials
mResp_A.ant.hit   = permute(zA_ant_hit,[1 3 2]);
mResp_A.post.miss = permute(zA_post_miss,[1 3 2]); % miss trials
mResp_A.ant.miss  = permute(zA_ant_miss,[1 3 2]);



% save
save_file_name = strcat('RespA_',Animal_Name,'_',BF_Session,'BF');
% save_dir = DATA_DIR;
save_dir = pwd;
save(fullfile(save_dir,save_file_name),'mResp_A', ...
             'list_RecDate','sTriplet', ...
             'depth_index','AP_index','area_index');

% % reshape matrix (sample x tpos x stdiff)
% AUC_post = reshape(AUC_post,[size(AUC_post,1)*size(AUC_post,2) size(AUC_post,3) size(AUC_post,4)]);
% AUC_ant  = reshape(AUC_ant,[size(AUC_ant,1)*size(AUC_ant,2) size(AUC_ant,3) size(AUC_ant,4)]);
% AUC_post_hm = reshape(AUC_post_hm,[size(AUC_post_hm,1)*size(AUC_post_hm,2) size(AUC_post_hm,3) size(AUC_post_hm,4)]);
% AUC_ant_hm = reshape(AUC_ant_hm,[size(AUC_ant_hm,1)*size(AUC_ant_hm,2) size(AUC_ant_hm,3) size(AUC_ant_hm,4)]);

% % plot
% figure;
% jitter = 0.04;
% subplot(2,2,1);
% % small dF
% plot_ROC(tpos,AUC_post(:,:,1),-jitter,line_color(1,:)); hold on;
% % large dF
% plot_ROC(tpos,AUC_post(:,:,2), jitter,line_color(2,:));
% xlim([0.5 length(tpos)+0.5]);
% ylabel('AUROC');
% box off;
% title('Posterior');
% 
% subplot(2,2,2);
% % small dF
% plot_ROC(tpos,AUC_ant(:,:,1),-jitter,line_color(1,:)); hold on;
% % large dF
% plot_ROC(tpos,AUC_ant(:,:,2), jitter,line_color(2,:));
% xlim([0.5 length(tpos)+0.5]);
% ylabel('AUROC');
% box off;
% title('Anterior');
% legend({'Small dF','Large dF'});
% 
% subplot(2,2,3);
% % hit
% plot_ROC(tpos,AUC_post_hm(:,:,1),-jitter,line_color(1,:)); hold on;
% % miss
% plot_ROC(tpos,AUC_post_hm(:,:,2), jitter,line_color(2,:));
% xlim([0.5 length(tpos)+0.5]);
% ylabel('AUROC');
% box off;
% 
% subplot(2,2,4);
% % hit
% plot_ROC(tpos,AUC_ant_hm(:,:,1),-jitter,line_color(1,:)); hold on;
% % miss
% plot_ROC(tpos,AUC_ant_hm(:,:,2), jitter,line_color(2,:));
% xlim([0.5 length(tpos)+0.5]);
% ylabel('AUROC');
% box off;
% legend({'Hit','Miss'});