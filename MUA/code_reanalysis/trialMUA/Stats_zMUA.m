clear all

ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis';
DATA_DIR = fullfile(ROOT_DIR,'trialMUA','Reorganize_zMUA');
addpath(ROOT_DIR);

% set parameters...
BF_Session = 'low'; % either 'low', 'high', or 'all'
% tpos = [1 2 3 6 7]; % 1st to Target
tpos = [1 2 3 6]; % exclude Target
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 4:8; % around target
% tpos = 1:8; % all


% load Data
fName = strcat('zMUA_Both_ABB_',BF_Session,'BF');
load(fullfile(DATA_DIR,fName));

% reshape matrix (sample x tpos x stdiff x ABB)
ABB_post_df = reshape(zMUA.post.stdiff,[size(zMUA.post.stdiff,1)*size(zMUA.post.stdiff,2) size(zMUA.post.stdiff,3) size(zMUA.post.stdiff,4) size(zMUA.post.stdiff,5)]);
ABB_ant_df  = reshape(zMUA.ant.stdiff,[size(zMUA.ant.stdiff,1)*size(zMUA.ant.stdiff,2) size(zMUA.ant.stdiff,3) size(zMUA.ant.stdiff,4) size(zMUA.ant.stdiff,5)]);
% hit and miss trials separated...
ABB_post_hit = reshape(zMUA.post.hit,[size(zMUA.post.hit,1)*size(zMUA.post.hit,2) size(zMUA.post.hit,3) size(zMUA.post.hit,4) size(zMUA.post.hit,5)]);
ABB_ant_hit  = reshape(zMUA.ant.hit,[size(zMUA.ant.hit,1)*size(zMUA.ant.hit,2) size(zMUA.ant.hit,3) size(zMUA.ant.hit,4) size(zMUA.ant.hit,5)]);
ABB_post_miss = reshape(zMUA.post.miss,[size(zMUA.post.miss,1)*size(zMUA.post.miss,2) size(zMUA.post.miss,3) size(zMUA.post.miss,4) size(zMUA.post.miss,5)]);
ABB_ant_miss  = reshape(zMUA.ant.miss,[size(zMUA.ant.miss,1)*size(zMUA.ant.miss,2) size(zMUA.ant.miss,3) size(zMUA.ant.miss,4) size(zMUA.ant.miss,5)]);

% statistical analysis
% Kruskal-Wallis test (Is ROC changing dynamically?) 
for ii=1:4
    for jj=1:3 % separate ABB
        pKW_post_df(ii,jj) = kruskalwallis(ABB_post_df(:,tpos,ii,jj),[],'off');
        pKW_ant_df(ii,jj)  = kruskalwallis(ABB_ant_df(:,tpos,ii,jj),[],'off');
        % hit and miss trials separated
        pKW_post_hit(ii,jj) = kruskalwallis(ABB_post_hit(:,tpos,ii,jj),[],'off');
        pKW_ant_hit(ii,jj)  = kruskalwallis(ABB_ant_hit(:,tpos,ii,jj),[],'off');
        pKW_post_miss(ii,jj) = kruskalwallis(ABB_post_miss(:,tpos,ii,jj),[],'off');
        pKW_ant_miss(ii,jj)  = kruskalwallis(ABB_ant_miss(:,tpos,ii,jj),[],'off');
    end
end


% SRH test
for jj=1:3
    [pSRH_post_df(:,jj),tbl_post_df{jj},~] = stats_CompConditions_SRHtest(ABB_post_df(:,:,:,jj),tpos);
    [pSRH_ant_df(:,jj), tbl_ant_df{jj}, ~] = stats_CompConditions_SRHtest(ABB_ant_df(:,:,:,jj),tpos);
    % hit and miss trials separated
    [pSRH_post_hit(:,jj),tbl_post_hit{jj},~] = stats_CompConditions_SRHtest(ABB_post_hit(:,:,:,jj),tpos);
    [pSRH_ant_hit(:,jj), tbl_ant_hit{jj}, ~] = stats_CompConditions_SRHtest(ABB_ant_hit(:,:,:,jj),tpos);
    [pSRH_post_miss(:,jj),tbl_post_miss{jj},~] = stats_CompConditions_SRHtest(ABB_post_miss(:,:,:,jj),tpos);
    [pSRH_ant_miss(:,jj), tbl_ant_miss{jj}, ~] = stats_CompConditions_SRHtest(ABB_ant_miss(:,:,:,jj),tpos);
end

% Wilcoxon sined rank test (whether the ROC values are >0.0)
for ii=1:4 % 4 levels of stdiff
    for jj=1:3 % separate ABB
        for t=1:8 % 8 levels of tpos
            pW_post_df(ii,t,jj) = signrank(ABB_post_df(:,t,ii,jj),0.0);
            pW_ant_df(ii,t,jj)  = signrank(ABB_ant_df(:,t,ii,jj),0.0);
            % hit and miss trials
            pW_post_hit(ii,t,jj) = signrank(ABB_post_hit(:,t,ii,jj),0.0);
            pW_ant_hit(ii,t,jj)  = signrank(ABB_ant_hit(:,t,ii,jj),0.0);
            pW_post_miss(ii,t,jj) = signrank(ABB_post_miss(:,t,ii,jj),0.0);
            pW_ant_miss(ii,t,jj)  = signrank(ABB_ant_miss(:,t,ii,jj),0.0);
        end
    end
end


% FDR correction
for jj=1:3
    pWadj_post_df(:,:,jj) = get_FDRcorrection(pW_post_df(:,:,jj),1:8);
    pWadj_ant_df(:,:,jj)  = get_FDRcorrection(pW_ant_df(:,:,jj),1:8);
    pWadj_post_hit(:,:,jj) = get_FDRcorrection(pW_post_hit(:,:,jj),1:8);
    pWadj_ant_hit(:,:,jj)  = get_FDRcorrection(pW_ant_hit(:,:,jj),1:8);
    pWadj_post_miss(:,:,jj) = get_FDRcorrection(pW_post_miss(:,:,jj),1:8);
    pWadj_ant_miss(:,:,jj)  = get_FDRcorrection(pW_ant_miss(:,:,jj),1:8);

    pWadj_post_df2(:,:,jj) = get_FDRcorrection(pW_post_df(:,:,jj),tpos);
    pWadj_ant_df2(:,:,jj)  = get_FDRcorrection(pW_ant_df(:,:,jj),tpos);
    pWadj_post_hit2(:,:,jj) = get_FDRcorrection(pW_post_hit(:,:,jj),tpos);
    pWadj_ant_hit2(:,:,jj)  = get_FDRcorrection(pW_ant_hit(:,:,jj),tpos);
    pWadj_post_miss2(:,:,jj) = get_FDRcorrection(pW_post_miss(:,:,jj),tpos);
    pWadj_ant_miss2(:,:,jj)  = get_FDRcorrection(pW_ant_miss(:,:,jj),tpos);
end

% % plot
% line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
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