% combine ROC across sessions
clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AvsB1_v2';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer');

% set parameters...
Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
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
% remove sessions with high BF
list_RecDate(i_HighBFSession) = [];
AP_index(i_HighBFSession) = [];
area_index(i_HighBFSession) = [];
depth_index(:,i_HighBFSession) = [];

n_pos = sum(AP_index==1);
n_ant = sum(AP_index==0);
% concatenate data across sessions
AUC_post_df = NaN(24,8,4,n_pos); % channel x tpos x stdiff x session
AUC_ant_df  = NaN(24,8,4,n_ant);
AUC_post_hit = NaN(24,8,4,n_pos); % hit trials
AUC_ant_hit  = NaN(24,8,4,n_ant); 
AUC_post_miss = NaN(24,8,4,n_pos); % miss trials
AUC_ant_miss  = NaN(24,8,4,n_ant);
count_pos = 1; count_ant = 1; % counter
for ff=1:length(list_RecDate)
    rec_date = list_RecDate{ff};
    fName = strcat(rec_date,'_ROC_v2');

    % load data
    load(fullfile(DATA_DIR,fName));
    auc_stdiff = AUC.stdiff;
    auc_hit = AUC.hit; % data including intermediate dF... 
    auc_miss = AUC.miss; % data without intermediate dF... 
    % choose significant channel
    auc_stdiff(sig_ch==0,:,:) = NaN; 
    auc_hit(sig_ch==0,:,:) = NaN;
    auc_miss(sig_ch==0,:,:) = NaN;
    
    n_ch = size(auc_stdiff,1);
    % separate data into recording areas (Posterior or Anterior)
    if i_AP==1 % posterior
        if size(auc_stdiff,3)==3
            temp_auc = NaN(n_ch,8,4);
            temp_auc(:,:,1) = auc_stdiff(:,:,1);
            temp_auc(:,:,4) = auc_stdiff(:,:,end);
            AUC_post_df(1:n_ch,:,:,count_pos) = temp_auc;

            temp_hit = NaN(n_ch,8,4);
            temp_hit(:,:,1) = auc_hit(:,:,1);
            temp_hit(:,:,4) = auc_hit(:,:,end);
            AUC_post_hit(1:n_ch,:,:,count_pos) = temp_hit;

            temp_miss = NaN(n_ch,8,4);
            temp_miss(:,:,1) = auc_miss(:,:,1);
            temp_miss(:,:,4) = auc_miss(:,:,end);
            AUC_post_miss(1:n_ch,:,:,count_pos) = temp_miss;

            clear temp_auc temp_hit temp_miss
        else
            AUC_post_df(1:n_ch,:,:,count_pos) = auc_stdiff;
            AUC_post_hit(1:n_ch,:,:,count_pos) = auc_hit;
            AUC_post_miss(1:n_ch,:,:,count_pos) = auc_miss;
        end
%         AUC_post_hm(1:n_ch,:,:,count_pos)  = auc_hitmiss;
%         AUC_post_hm2(1:n_ch,:,:,count_pos) = auc_hitmiss2;
        count_pos = count_pos+1;
    elseif i_AP==0 % anterior
        if size(auc_stdiff,3)==3
            temp_auc = NaN(n_ch,8,4);
            temp_auc(:,:,1) = auc_stdiff(:,:,1);
            temp_auc(:,:,4) = auc_stdiff(:,:,end);
            AUC_ant_df(1:n_ch,:,:,count_ant) = temp_auc;

            temp_hit = NaN(n_ch,8,4);
            temp_hit(:,:,1) = auc_hit(:,:,1);
            temp_hit(:,:,4) = auc_hit(:,:,end);
            AUC_ant_hit(1:n_ch,:,:,count_ant) = temp_hit;

            temp_miss = NaN(n_ch,8,4);
            temp_miss(:,:,1) = auc_miss(:,:,1);
            temp_miss(:,:,4) = auc_miss(:,:,end);
            AUC_ant_miss(1:n_ch,:,:,count_ant) = temp_miss;

            clear temp_auc temp_hit temp_miss
        else
            AUC_ant_df(1:n_ch,:,:,count_ant) = auc_stdiff;
            AUC_ant_hit(1:n_ch,:,:,count_ant) = auc_hit;
            AUC_ant_miss(1:n_ch,:,:,count_ant) = auc_miss;
        end
%         AUC_ant_hm(1:n_ch,:,:,count_ant)  = auc_hitmiss;
%         AUC_ant_hm2(1:n_ch,:,:,count_ant) = auc_hitmiss2;
        count_ant = count_ant + 1;
    end

end
clear AUC
% re-order matrix (ch x session x tpos x stdiff)
AUC.post.stdiff = permute(AUC_post_df,[1 4 2 3]);
AUC.ant.stdiff  = permute(AUC_ant_df,[1 4 2 3]);
AUC.post.hit = permute(AUC_post_hit,[1 4 2 3]); % hit trials
AUC.ant.hit  = permute(AUC_ant_hit,[1 4 2 3]);
AUC.post.miss = permute(AUC_post_miss,[1 4 2 3]); % miss trials
AUC.ant.miss  = permute(AUC_ant_miss,[1 4 2 3]);

% save
save_file_name = strcat('ROC_',Animal_Name,'_v2');
save_dir = DATA_DIR;
save(fullfile(save_dir,save_file_name),'AUC','list_RecDate','sTriplet', ...
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