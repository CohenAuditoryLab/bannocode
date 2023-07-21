clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB_ttime';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% BF_Session = 'high'; % either 'low', 'high', or 'all'
tt_version = 2; % 1 for all dF conditions, 2 for without intermediate dF
tpos = 1:4; % fixed!!
% line_color = [153 0 255; 0 204 0] / 255;


% % % load Data (BF site) % % %
BF_Session = 'low';
fName = strcat('ROC_Both_target_',BF_Session,'BF');
load(fullfile(DATA_DIR,fName));
if tt_version==1
    % reshape matrix (sample x ttime)
    AUC_post_tt = reshape(AUC.post.target,[size(AUC.post.target,1)*size(AUC.post.target,2) size(AUC.post.target,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target,[size(AUC.ant.target,1)*size(AUC.ant.target,2) size(AUC.ant.target,3)]);
elseif tt_version==2
    % intermediate dF trials are REMOVED
    AUC_post_tt = reshape(AUC.post.target2,[size(AUC.post.target2,1)*size(AUC.post.target2,2) size(AUC.post.target2,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target2,[size(AUC.ant.target2,1)*size(AUC.ant.target2,2) size(AUC.ant.target2,3)]);
end

% % % Statistical analysis % % %
% Kruskal-Wallis test (Is ROC changing dynamically?) 
pKW_post_ttime(1) = kruskalwallis(AUC_post_tt,[],'off');
pKW_ant_ttime(1)  = kruskalwallis(AUC_ant_tt,[],'off');
% SRH test (comparing posterior vs anterior)
pSRH_ttime(:,1) = stats_CompArea_SRHtest2(AUC_post_tt,  AUC_ant_tt, tpos);
% Wilcoxon signed rank test (whether ROC is deviated from 0.5)
for jj=1:4
    pW_post_ttime(1,jj) = signrank(AUC_post_tt(:,jj),0.5);
    pW_ant_ttime(1,jj)  = signrank(AUC_ant_tt(:,jj),0.5);
end

% % % load Data (non-BF site) % % %
BF_Session = 'high';
fName = strcat('ROC_Both_target_',BF_Session,'BF');
load(fullfile(DATA_DIR,fName));
if tt_version==1
    % reshape matrix (sample x ttime)
    AUC_post_tt = reshape(AUC.post.target,[size(AUC.post.target,1)*size(AUC.post.target,2) size(AUC.post.target,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target,[size(AUC.ant.target,1)*size(AUC.ant.target,2) size(AUC.ant.target,3)]);
elseif tt_version==2
    % intermediate dF trials are REMOVED
    AUC_post_tt = reshape(AUC.post.target2,[size(AUC.post.target2,1)*size(AUC.post.target2,2) size(AUC.post.target2,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target2,[size(AUC.ant.target2,1)*size(AUC.ant.target2,2) size(AUC.ant.target2,3)]);
end

% % % Statistical analysis % % %
% Kruskal-Wallis test (Is ROC changing dynamically?) 
pKW_post_ttime(2) = kruskalwallis(AUC_post_tt,[],'off');
pKW_ant_ttime(2)  = kruskalwallis(AUC_ant_tt,[],'off');
% SRH test (comparing posterior vs anterior)
pSRH_ttime(:,2) = stats_CompArea_SRHtest2(AUC_post_tt,  AUC_ant_tt, tpos);
% Wilcoxon signed rank test (whether ROC is deviated from 0.5)
for jj=1:4
    pW_post_ttime(2,jj) = signrank(AUC_post_tt(:,jj),0.5);
    pW_ant_ttime(2,jj)  = signrank(AUC_ant_tt(:,jj),0.5);
end

% % % load Data (all site) % % %
BF_Session = 'all';
fName = strcat('ROC_Both_target_',BF_Session,'BF');
load(fullfile(DATA_DIR,fName));
if tt_version==1
    % reshape matrix (sample x ttime)
    AUC_post_tt = reshape(AUC.post.target,[size(AUC.post.target,1)*size(AUC.post.target,2) size(AUC.post.target,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target,[size(AUC.ant.target,1)*size(AUC.ant.target,2) size(AUC.ant.target,3)]);
elseif tt_version==2
    % intermediate dF trials are REMOVED
    AUC_post_tt = reshape(AUC.post.target2,[size(AUC.post.target2,1)*size(AUC.post.target2,2) size(AUC.post.target2,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target2,[size(AUC.ant.target2,1)*size(AUC.ant.target2,2) size(AUC.ant.target2,3)]);
end

% % % Statistical analysis % % %
% Kruskal-Wallis test (Is ROC changing dynamically?) 
pKW_post_ttime(3) = kruskalwallis(AUC_post_tt,[],'off');
pKW_ant_ttime(3)  = kruskalwallis(AUC_ant_tt,[],'off');
% SRH test (comparing posterior vs anterior)
pSRH_ttime(:,3) = stats_CompArea_SRHtest2(AUC_post_tt,  AUC_ant_tt, tpos);
% Wilcoxon signed rank test (whether ROC is deviated from 0.5)
for jj=1:4
    pW_post_ttime(3,jj) = signrank(AUC_post_tt(:,jj),0.5);
    pW_ant_ttime(3,jj)  = signrank(AUC_ant_tt(:,jj),0.5);
end

% FDR correction
for ii=1:3
    pWadj_post_ttime(ii,:) = get_FDRcorrection(pW_post_ttime(ii,:),1:4);
    pWadj_ant_ttime(ii,:)  = get_FDRcorrection(pW_ant_ttime(ii,:),1:4);
end

% % % % plot % % %
% list_title = {'L','H1','H2'};
% figure("Position",[100 100 800 450]);
% for ii=1:3
%     h(ii) = subplot(2,3,ii); hold on;
%     plot_ROC(tpos,ABB_post_stim(:,:,ii),-0.04,line_color(1,:));
%     plot_ROC(tpos,ABB_ant_stim(:,:,ii),0.04,line_color(2,:));
%     plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
%     xlim([0.5 length(tpos)+0.5]);
%     xlabel('Triplet Position'); ylabel('AUROC');
%     box off;
%     title(list_title{ii});
%     yrange(ii,:) = get(gca,'YLim');
% end
% % set yaxis
% for ii=1:3
%     set(h(ii),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
% end
% clear h yrange
% 
% for jj=1:3
%     h(jj) = subplot(2,3,jj+3); hold on;
%     plot_ROC(tpos,ABB_post_behav(:,:,jj),-0.04,line_color(1,:));
%     plot_ROC(tpos,ABB_ant_behav(:,:,jj),0.04,line_color(2,:));
%     plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
%     xlim([0.5 length(tpos)+0.5]);
%     xlabel('Triplet Position'); ylabel('AUROC');
%     box off;
%     title(list_title{jj});
%     yrange(jj,:) = get(gca,'YLim');
% end
% % set yaxis
% for jj=1:3
%     set(h(jj),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
% end
% clear h yrange
% 
% legend({'posterior','anterior'});

