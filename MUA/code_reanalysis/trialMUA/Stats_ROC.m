clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AvsB1';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
BF_Session = 'high'; % either 'low', 'high', or 'all'
% tpos = [1 2 3 6 7]; % 1st to Target
tpos = [1 2 3 6]; % exclude Target
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 4:8; % around target
% tpos = 1:8; % all
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
              0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];

% load Data
fName = strcat('ROC_Both_',BF_Session,'BF');
load(fullfile(DATA_DIR,fName));
% load(fullfile(DATA_DIR,'ROC_Both_lowBF.mat'));

% reshape matrix (sample x tpos x stdiff)
AUC_post_df = reshape(AUC.post.stdiff,[size(AUC.post.stdiff,1)*size(AUC.post.stdiff,2) size(AUC.post.stdiff,3) size(AUC.post.stdiff,4)]);
AUC_ant_df  = reshape(AUC.ant.stdiff,[size(AUC.ant.stdiff,1)*size(AUC.ant.stdiff,2) size(AUC.ant.stdiff,3) size(AUC.ant.stdiff,4)]);
% hit/miss with intermediate dF trials
AUC_post_hm = reshape(AUC.post.hitmiss,[size(AUC.post.hitmiss,1)*size(AUC.post.hitmiss,2) size(AUC.post.hitmiss,3) size(AUC.post.hitmiss,4)]);
AUC_ant_hm  = reshape(AUC.ant.hitmiss,[size(AUC.ant.hitmiss,1)*size(AUC.ant.hitmiss,2) size(AUC.ant.hitmiss,3) size(AUC.ant.hitmiss,4)]);
% hit/miss intermediate dF trials are REMOVED
AUC_post_hm2 = reshape(AUC.post.hitmiss2,[size(AUC.post.hitmiss2,1)*size(AUC.post.hitmiss2,2) size(AUC.post.hitmiss2,3) size(AUC.post.hitmiss2,4)]);
AUC_ant_hm2  = reshape(AUC.ant.hitmiss2,[size(AUC.ant.hitmiss2,1)*size(AUC.ant.hitmiss2,2) size(AUC.ant.hitmiss2,3) size(AUC.ant.hitmiss2,4)]);

% statistical analysis
% Kruskal-Wallis test (Is ROC changing dynamically?) 
for ii=1:4
    pKW_post_df(ii) = kruskalwallis(AUC_post_df(:,tpos,ii),[],'off');
    pKW_ant_df(ii)  = kruskalwallis(AUC_ant_df(:,tpos,ii),[],'off');
end
for jj=1:2
    pKW_post_hm(jj) = kruskalwallis(AUC_post_hm(:,tpos,jj),[],'off');
    pKW_ant_hm(jj)  = kruskalwallis(AUC_ant_hm(:,tpos,jj), [],'off');
end

% SRH test
[pSRH_post_df,tbl_post_df,~] = stats_CompConditions_SRHtest(AUC_post_df,tpos);
[pSRH_ant_df, tbl_ant_df, ~] = stats_CompConditions_SRHtest(AUC_ant_df,tpos);
[pSRH_post_hm,tbl_post_hm,~] = stats_CompConditions_SRHtest(AUC_post_hm,tpos);
[pSRH_ant_hm, tbl_ant_hm, ~] = stats_CompConditions_SRHtest(AUC_ant_hm,tpos);

% Wilcoxon sined rank test (whether the ROC values are >0.5)
for ii=1:4 % 4 levels of stdiff
    for t=1:8 % 8 levels of tpos
        pW_post_df(ii,t) = signrank(AUC_post_df(:,t,ii),0.5);
        pW_ant_df(ii,t) = signrank(AUC_ant_df(:,t,ii),0.5);
    end
end
for jj=1:2 % 2 levels of hit/miss
    for t=1:8 % 8 levels of tpos
        pW_post_hm(jj,t) = signrank(AUC_post_hm(:,t,jj),0.5);
        pW_ant_hm(jj,t) = signrank(AUC_ant_hm(:,t,jj),0.5);
    end
end

% FDR correction
pWadj_post_df = get_FDRcorrection(pW_post_df,1:8);
pWadj_ant_df  = get_FDRcorrection(pW_ant_df,1:8);
pWadj_post_hm = get_FDRcorrection(pW_post_hm,1:8);
pWadj_ant_hm  = get_FDRcorrection(pW_ant_hm,1:8);

pWadj_post_df2 = get_FDRcorrection(pW_post_df,tpos);
pWadj_ant_df2  = get_FDRcorrection(pW_ant_df,tpos);
pWadj_post_hm2 = get_FDRcorrection(pW_post_hm,tpos);
pWadj_ant_hm2  = get_FDRcorrection(pW_ant_hm,tpos);

% % plot
% figure;
% jitter = [-0.06 -0.02 0.02 0.06];
% subplot(2,2,1); hold on;
% for ii=1:4
%     plot_ROC(tpos,AUC_post_df(:,:,ii),jitter(ii),line_color(ii,:));
% end
% % % small dF
% % plot_ROC(tpos,AUC_post_df(:,:,1),-jitter,line_color(1,:)); hold on;
% % % large dF
% % plot_ROC(tpos,AUC_post_df(:,:,4), jitter,line_color(2,:));
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% box off;
% title('Posterior');
% 
% subplot(2,2,2); hold on;
% for ii=1:4
%     plot_ROC(tpos,AUC_ant_df(:,:,ii),jitter(ii),line_color(ii,:));
% end
% % % small dF
% % plot_ROC(tpos,AUC_ant_df(:,:,1),-jitter,line_color(1,:)); hold on;
% % % large dF
% % plot_ROC(tpos,AUC_ant_df(:,:,4), jitter,line_color(2,:));
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% box off;
% title('Anterior');
% legend({'Smallest dF','Small dF','Large dF','Largest dF'});
% 
% subplot(2,2,3);
% % hit
% plot_ROC(tpos,AUC_post_hm(:,:,1),jitter(1),line_color(2,:)); hold on;
% % miss
% plot_ROC(tpos,AUC_post_hm(:,:,2),jitter(4),line_color(3,:));
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% box off;
% 
% subplot(2,2,4);
% % hit
% plot_ROC(tpos,AUC_ant_hm(:,:,1),jitter(1),line_color(2,:)); hold on;
% % miss
% plot_ROC(tpos,AUC_ant_hm(:,:,2),jitter(4),line_color(3,:));
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% box off;
% legend({'Hit','Miss'});