clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
BF_Session = 'low'; % either 'low', 'high', or 'all'
% tpos = [1 2 3 6]; % exclude target
tpos = 4:8; % around target
% tpos = [1 2 3 6 7];
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 1:8; % all
line_color = [153 0 255; 0 204 0] / 255;
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
% line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];

% load Data
fName = strcat('ROC_Both_ABB_',BF_Session,'BF');
load(fullfile(DATA_DIR,fName));


% reshape matrix (sample x tpos x ABB)
ABB_post_stim = reshape(AUC.post.stim,[size(AUC.post.stim,1)*size(AUC.post.stim,2) size(AUC.post.stim,3) size(AUC.post.stim,4)]);
ABB_ant_stim  = reshape(AUC.ant.stim,[size(AUC.ant.stim,1)*size(AUC.ant.stim,2) size(AUC.ant.stim,3) size(AUC.ant.stim,4)]);
% reshape matrix (sample x tpos x stdiff x ABB)
ABB_post_behav = reshape(AUC.post.behav,[size(AUC.post.behav,1)*size(AUC.post.behav,2) size(AUC.post.behav,3) size(AUC.post.behav,4) size(AUC.post.behav,5)]);
ABB_ant_behav  = reshape(AUC.ant.behav,[size(AUC.ant.behav,1)*size(AUC.ant.behav,2) size(AUC.ant.behav,3) size(AUC.ant.behav,4) size(AUC.ant.behav,5)]);

% remove intermediate dF trials from behav
ABB_post_behav = ABB_post_behav(:,:,[1 end],:);
ABB_ant_behav  = ABB_ant_behav(:,:,[1 end],:);
ABB_post_behav = squeeze(nanmean(ABB_post_behav,3)); % average across dF
ABB_ant_behav = squeeze(nanmean(ABB_ant_behav,3)); % average across dF

% separate L, H1, H2
% posterior (stim modulation)
sAUC_post_L  = ABB_post_stim(:,:,1);
sAUC_post_H1 = ABB_post_stim(:,:,2);
sAUC_post_H2 = ABB_post_stim(:,:,3);
% anterior (stim modulation)
sAUC_ant_L  = ABB_ant_stim(:,:,1);
sAUC_ant_H1 = ABB_ant_stim(:,:,2);
sAUC_ant_H2 = ABB_ant_stim(:,:,3);
% posterior (behav modulation)
bAUC_post_L  = ABB_post_behav(:,:,1);
bAUC_post_H1 = ABB_post_behav(:,:,2);
bAUC_post_H2 = ABB_post_behav(:,:,3);
% anterior (behav modulation)
bAUC_ant_L  = ABB_ant_behav(:,:,1);
bAUC_ant_H1 = ABB_ant_behav(:,:,2);
bAUC_ant_H2 = ABB_ant_behav(:,:,3);

% % % Statistical analysis % % %
% Kruskal-Wallis test (Is ROC changing dynamically?) 
pKW_post_stim(1) = kruskalwallis(sAUC_post_L(:,tpos),[],'off');
pKW_post_stim(2) = kruskalwallis(sAUC_post_H1(:,tpos),[],'off');
pKW_post_stim(3) = kruskalwallis(sAUC_post_H2(:,tpos),[],'off');
pKW_ant_stim(1)  = kruskalwallis(sAUC_ant_L(:,tpos),[],'off');
pKW_ant_stim(2)  = kruskalwallis(sAUC_ant_H1(:,tpos),[],'off');
pKW_ant_stim(3)  = kruskalwallis(sAUC_ant_H2(:,tpos),[],'off');

pKW_post_behav(1) = kruskalwallis(bAUC_post_L(:,tpos),[],'off');
pKW_post_behav(2) = kruskalwallis(bAUC_post_H1(:,tpos),[],'off');
pKW_post_behav(3) = kruskalwallis(bAUC_post_H2(:,tpos),[],'off');
pKW_ant_behav(1)  = kruskalwallis(bAUC_ant_L(:,tpos), [],'off');
pKW_ant_behav(2)  = kruskalwallis(bAUC_ant_H1(:,tpos), [],'off');
pKW_ant_behav(3)  = kruskalwallis(bAUC_ant_H2(:,tpos), [],'off');

% SRH test (comparing posterior vs anterior)
% stimulus modulation
pSRH_stim(:,1) = stats_CompArea_SRHtest2(sAUC_post_L,  sAUC_ant_L, tpos);
pSRH_stim(:,2) = stats_CompArea_SRHtest2(sAUC_post_H1, sAUC_ant_H1, tpos);
pSRH_stim(:,3) = stats_CompArea_SRHtest2(sAUC_post_H2, sAUC_ant_H2, tpos);
% behavioral modulation
pSRH_behav(:,1) = stats_CompArea_SRHtest2(bAUC_post_L,  bAUC_ant_L, tpos);
pSRH_behav(:,2) = stats_CompArea_SRHtest2(bAUC_post_H1, bAUC_ant_H1, tpos);
pSRH_behav(:,3) = stats_CompArea_SRHtest2(bAUC_post_H2, bAUC_ant_H2, tpos);

% Wilcoxon signed rank test (whether ROC is deviated from 0.5)
for jj=1:8 % get all p-values
    % stimulus modulation
    pW_post_stim(1,jj) = signrank(sAUC_post_L(:,jj),0.5);
    pW_post_stim(2,jj) = signrank(sAUC_post_H1(:,jj),0.5);
    pW_post_stim(3,jj) = signrank(sAUC_post_H2(:,jj),0.5);
    pW_ant_stim(1,jj) = signrank(sAUC_ant_L(:,jj),0.5);
    pW_ant_stim(2,jj) = signrank(sAUC_ant_H1(:,jj),0.5);
    pW_ant_stim(3,jj) = signrank(sAUC_ant_H2(:,jj),0.5);
    % behavioral modulation
    pW_post_behav(1,jj) = signrank(bAUC_post_L(:,jj),0.5);
    pW_post_behav(2,jj) = signrank(bAUC_post_H1(:,jj),0.5);
    pW_post_behav(3,jj) = signrank(bAUC_post_H2(:,jj),0.5);
    pW_ant_behav(1,jj) = signrank(bAUC_ant_L(:,jj),0.5);
    pW_ant_behav(2,jj) = signrank(bAUC_ant_H1(:,jj),0.5);
    pW_ant_behav(3,jj) = signrank(bAUC_ant_H2(:,jj),0.5);
end

% FDR correction
pWadj_post_stim = get_FDRcorrection(pW_post_stim,tpos);
pWadj_ant_stim = get_FDRcorrection(pW_ant_stim,tpos);
pWadj_post_behav = get_FDRcorrection(pW_post_behav,tpos);
pWadj_ant_behav = get_FDRcorrection(pW_ant_behav,tpos);

pWadj_post_stim2 = get_FDRcorrection(pW_post_stim,tpos);
pWadj_ant_stim2 = get_FDRcorrection(pW_ant_stim,tpos);
pWadj_post_behav2 = get_FDRcorrection(pW_post_behav,tpos);
pWadj_ant_behav2 = get_FDRcorrection(pW_ant_behav,tpos);

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

