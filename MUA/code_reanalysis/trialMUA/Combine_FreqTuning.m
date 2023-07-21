% combine ROC across sessions
clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\FreqTuning\ver1';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer');

% set parameters...
Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
BF_Session = 'all'; % either 'low', 'high', or 'all'
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
SL_post = NaN(24,8,n_pos); SL2_post = NaN(24,8,n_pos); 
SL_ant  = NaN(24,8,n_ant); SL2_ant  = NaN(24,8,n_ant);
SL_post_hit = NaN(24,8,n_pos); SL2_post_hit = NaN(24,8,n_pos); 
SL_ant_hit = NaN(24,8,n_ant); SL2_ant_hit = NaN(24,8,n_ant); 
SL_post_miss = NaN(24,8,n_pos); SL2_post_miss = NaN(24,8,n_pos); 
SL_ant_miss = NaN(24,8,n_ant); SL2_ant_miss = NaN(24,8,n_ant); 
SP_post = NaN(24,8,n_pos); 
SP_ant  = NaN(24,8,n_ant);
SP_post_hit = NaN(24,8,n_pos); 
SP_ant_hit = NaN(24,8,n_ant); 
SP_post_miss = NaN(24,8,n_pos); 
SP_ant_miss = NaN(24,8,n_ant); 

count_pos = 1; count_ant = 1; % counter
for ff=1:length(list_RecDate)
    rec_date = list_RecDate{ff};
    fName = strcat(rec_date,'_FreqTuning');

    % load data
    load(fullfile(DATA_DIR,fName));
    sl   = select_index.all; % hit and miss combined
    sl_h = select_index.hit; % hit trials
    sl_m = select_index.miss; % miss trials
    sl2   = select_index2.all; % hit and miss combined
    sl2_h = select_index2.hit; % hit trials
    sl2_m = select_index2.miss; % miss trials
    sp   = sparse_index.all; % hit and miss combined
    sp_h = sparse_index.hit; % hit trials
    sp_m = sparse_index.miss; % miss trials
    % choose significant channel
    sl(sig_ch==0,:,:) = NaN; 
    sl_h(sig_ch==0,:,:) = NaN;
    sl_m(sig_ch==0,:,:) = NaN;
    sl2(sig_ch==0,:,:) = NaN; 
    sl2_h(sig_ch==0,:,:) = NaN;
    sl2_m(sig_ch==0,:,:) = NaN;
    sp(sig_ch==0,:,:) = NaN; 
    sp_h(sig_ch==0,:,:) = NaN;
    sp_m(sig_ch==0,:,:) = NaN;
    
    n_ch = size(sl,1);
    % separate data into recording areas (Posterior or Anterior)
    if i_AP==1 % posterior
        % selectivity incex
        SL_post(1:n_ch,:,count_pos) = sl;
        SL_post_hit(1:n_ch,:,count_pos)  = sl_h;
        SL_post_miss(1:n_ch,:,count_pos) = sl_m;
        SL2_post(1:n_ch,:,count_pos) = sl2;
        SL2_post_hit(1:n_ch,:,count_pos)  = sl2_h;
        SL2_post_miss(1:n_ch,:,count_pos) = sl2_m;
        % sparseness index
        SP_post(1:n_ch,:,count_pos) = sp;
        SP_post_hit(1:n_ch,:,count_pos)  = sp_h;
        SP_post_miss(1:n_ch,:,count_pos) = sp_m;
        count_pos = count_pos+1;
    elseif i_AP==0 % anterior
        % selectivity index
        SL_ant(1:n_ch,:,count_ant) = sl;
        SL_ant_hit(1:n_ch,:,count_ant)  = sl_h;
        SL_ant_miss(1:n_ch,:,count_ant) = sl_m;
        SL2_ant(1:n_ch,:,count_ant) = sl2;
        SL2_ant_hit(1:n_ch,:,count_ant)  = sl2_h;
        SL2_ant_miss(1:n_ch,:,count_ant) = sl2_m;
        % sparseness index
        SP_ant(1:n_ch,:,count_ant) = sp;
        SP_ant_hit(1:n_ch,:,count_ant)  = sp_h;
        SP_ant_miss(1:n_ch,:,count_ant) = sp_m;
        count_ant = count_ant + 1;
    end

end
% clear AUC
% re-order matrix (ch x session x tpos)
SelectIndex.post.all = permute(SL_post,[1 3 2]); % hit and miss trials combined
SelectIndex.ant.all  = permute(SL_ant,[1 3 2]);
SelectIndex.post.hit = permute(SL_post_hit,[1 3 2]); % hit trials
SelectIndex.ant.hit   = permute(SL_ant_hit,[1 3 2]);
SelectIndex.post.miss = permute(SL_post_miss,[1 3 2]); % miss trials
SelectIndex.ant.miss  = permute(SL_ant_miss,[1 3 2]);

SelectIndex2.post.all = permute(SL2_post,[1 3 2]); % hit and miss trials combined
SelectIndex2.ant.all  = permute(SL2_ant,[1 3 2]);
SelectIndex2.post.hit = permute(SL2_post_hit,[1 3 2]); % hit trials
SelectIndex2.ant.hit   = permute(SL2_ant_hit,[1 3 2]);
SelectIndex2.post.miss = permute(SL2_post_miss,[1 3 2]); % miss trials
SelectIndex2.ant.miss  = permute(SL2_ant_miss,[1 3 2]);

SparseIndex.post.all = permute(SP_post,[1 3 2]); % hit and miss trials combined
SparseIndex.ant.all  = permute(SP_ant,[1 3 2]);
SparseIndex.post.hit = permute(SP_post_hit,[1 3 2]); % hit trials
SparseIndex.ant.hit   = permute(SP_ant_hit,[1 3 2]);
SparseIndex.post.miss = permute(SP_post_miss,[1 3 2]); % miss trials
SparseIndex.ant.miss  = permute(SP_ant_miss,[1 3 2]);

% save
% save_file_name = strcat('ROC_',Animal_Name);
save_file_name = strcat('FreqTuning_',Animal_Name,'_',BF_Session,'BF');
save_dir = DATA_DIR;
save(fullfile(save_dir,save_file_name),'SelectIndex','SelectIndex2','SparseIndex', ...
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