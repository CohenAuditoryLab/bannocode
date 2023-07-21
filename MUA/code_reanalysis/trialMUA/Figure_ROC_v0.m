clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AvsB1';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
Animal_Name = 'Cassius'; % either 'Domo', 'Cassius', or 'Both'
% tpos = [1 2 3 6 7];
% tpos = 4:8;
% tpos = [1 2 3 6 7 8];
tpos = 1:8;
% line_color = [0.0000 0.4470 0.7410; 0.8500 0.3250 0.0980];
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
              0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
% i_domo = [8 13];
i_domo = [7 8 10 13];
% i_cassius = [2 3 5 7 9 10 11 13 16 18 19 21];
i_cassius = [2 3 5 7 9 10 11 12 13 15 16 17 18 19 20 21];


% load Data
if strcmp(Animal_Name,'Domo')
    load RecordingDate_Domo.mat
    i_HighBFSession = i_domo;
elseif strcmp(Animal_Name,'Cassius')
    load RecordingDate_Cassius.mat
    i_HighBFSession = i_cassius;
else % Both
    load RecordingDate_Both.mat
    i_HighBFSession = [i_domo i_cassius+16];
end
% remove sessions with high BF
% i_HighBFSession_Domo = [7 8 10 13];
% i_HighBFSession_Cassius = [2 3 5 7 9 10 11 13 16 18 19 21];
% % i_HighBFSession = [2 3 5 7 9 10 11 12 13 15 16 17 18 19 20 21] + 16;
list_RecDate(i_HighBFSession) = [];
AP_index(i_HighBFSession) = [];

n_pos = sum(AP_index==1);
n_ant = sum(AP_index==0);
AUC_post = NaN(24,8,2,n_pos); % AUC_post = [];
AUC_ant  = NaN(24,8,2,n_ant); % AUC_ant  = [];
AUC_post_hm = NaN(24,8,2,n_pos);
AUC_ant_hm = NaN(24,8,2,n_ant);
count_pos = 1; count_ant = 1; % counter
for ff=1:length(list_RecDate)
    rec_date = list_RecDate{ff};
    fName = strcat(rec_date,'_ROC');

    % load data
    load(fullfile(DATA_DIR,fName));
    auc_stdiff = AUC.stdiff;
%     auc_hitmiss = AUC.hitmiss; % data including intermediate dF... 
    auc_hitmiss = AUC.hitmiss2; % data without intermediate dF... 
    % choose significant channel
    auc_stdiff(sig_ch==0,:,:) = NaN; 
    auc_hitmiss(sig_ch==0,:,:) = NaN;
    
%     auc_stdiff = abs(auc_stdiff-0.5);

    n_ch = size(auc_stdiff,1);
    % separate data into recording areas (Posterior or Anterior)
    if i_AP==1 % posterior
%         AUC_post = cat(4,AUC_post,auc_stdiff(:,:,[1 end])); % small and large dF
        AUC_post(1:n_ch,:,:,count_pos) = auc_stdiff(:,:,[1 end]);
        AUC_post_hm(1:n_ch,:,:,count_pos) = auc_hitmiss;
        count_pos = count_pos+1;
    elseif i_AP==0 % anterior
%         AUC_ant = cat(4,AUC_ant,auc_stdiff(:,:,[1 end])); % small and large dF
        AUC_ant(1:n_ch,:,:,count_ant) = auc_stdiff(:,:,[1 end]);
        AUC_ant_hm(1:n_ch,:,:,count_ant) = auc_hitmiss;
        count_ant = count_ant + 1;
    end

end
% re-order matrix (ch x session x tpos x stdiff)
AUC_post = permute(AUC_post,[1 4 2 3]);
AUC_ant  = permute(AUC_ant,[1 4 2 3]);
AUC_post_hm = permute(AUC_post_hm,[1 4 2 3]);
AUC_ant_hm = permute(AUC_ant_hm,[1 4 2 3]);
% reshape matrix (sample x tpos x stdiff)
AUC_post = reshape(AUC_post,[size(AUC_post,1)*size(AUC_post,2) size(AUC_post,3) size(AUC_post,4)]);
AUC_ant  = reshape(AUC_ant,[size(AUC_ant,1)*size(AUC_ant,2) size(AUC_ant,3) size(AUC_ant,4)]);
AUC_post_hm = reshape(AUC_post_hm,[size(AUC_post_hm,1)*size(AUC_post_hm,2) size(AUC_post_hm,3) size(AUC_post_hm,4)]);
AUC_ant_hm = reshape(AUC_ant_hm,[size(AUC_ant_hm,1)*size(AUC_ant_hm,2) size(AUC_ant_hm,3) size(AUC_ant_hm,4)]);

% plot
figure;
jitter = 0.04;
subplot(2,2,1);
% small dF
plot_ROC(tpos,AUC_post(:,:,1),-jitter,line_color(1,:)); hold on;
% large dF
plot_ROC(tpos,AUC_post(:,:,2), jitter,line_color(4,:));
xlim([0.5 length(tpos)+0.5]);
ylabel('AUROC');
box off;
title('Posterior');

subplot(2,2,2);
% small dF
plot_ROC(tpos,AUC_ant(:,:,1),-jitter,line_color(1,:)); hold on;
% large dF
plot_ROC(tpos,AUC_ant(:,:,2), jitter,line_color(4,:));
xlim([0.5 length(tpos)+0.5]);
ylabel('AUROC');
box off;
title('Anterior');
legend({'Small dF','Large dF'});

subplot(2,2,3);
% hit
plot_ROC(tpos,AUC_post_hm(:,:,1),-jitter,line_color(2,:)); hold on;
% miss
plot_ROC(tpos,AUC_post_hm(:,:,2), jitter,line_color(3,:));
xlim([0.5 length(tpos)+0.5]);
ylabel('AUROC');
box off;

subplot(2,2,4);
% hit
plot_ROC(tpos,AUC_ant_hm(:,:,1),-jitter,line_color(2,:)); hold on;
% miss
plot_ROC(tpos,AUC_ant_hm(:,:,2), jitter,line_color(3,:));
xlim([0.5 length(tpos)+0.5]);
ylabel('AUROC');
box off;
legend({'Hit','Miss'});