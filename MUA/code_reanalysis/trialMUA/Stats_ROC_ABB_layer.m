clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
BF_Session = 'high'; % either 'low', 'high', or 'all'
tpos = [1 2 3 6 7];
% tpos = [1 2 3 6]; % exclude Target
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 4:8; % around target
% tpos = 1:8; % all
line_color_p = [157 195 230; 46 117 182; 31 78 121] / 255;
line_color_n = [244 177 131; 197 90 17; 132 60 12] / 255;


% load Data
fName = strcat('ROC_Both_ABB_',BF_Session,'BF');
load(fullfile(DATA_DIR,fName));

% get depth index (posterior/anterior)
iDepth_post = depth_index(:,AP_index==1);
iDepth_ant  = depth_index(:,AP_index==0);
iDepth_post = reshape(iDepth_post,[size(iDepth_post,1)*size(iDepth_post,2) 1]);
iDepth_ant  = reshape(iDepth_ant,[size(iDepth_ant,1)*size(iDepth_ant,2) 1]);

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



% % % STATISTICAL ANALYSIS % % %
% Kruskal-Wallis test (Is ROC changing dynamically?) 
for ii=1:3
    ii_dep = ii - 1; % making the depth id 0 to 2
    pKW_post_stim(ii,1) = kruskalwallis(sAUC_post_L(iDepth_post==ii_dep,tpos),[],'off');
    pKW_post_stim(ii,2) = kruskalwallis(sAUC_post_H1(iDepth_post==ii_dep,tpos),[],'off');
    pKW_post_stim(ii,3) = kruskalwallis(sAUC_post_H2(iDepth_post==ii_dep,tpos),[],'off');
    pKW_ant_stim(ii,1)  = kruskalwallis(sAUC_ant_L(iDepth_ant==ii_dep,tpos),[],'off');
    pKW_ant_stim(ii,2)  = kruskalwallis(sAUC_ant_H1(iDepth_ant==ii_dep,tpos),[],'off');
    pKW_ant_stim(ii,3)  = kruskalwallis(sAUC_ant_H2(iDepth_ant==ii_dep,tpos),[],'off');
end
for jj=1:3
    jj_dep = jj - 1; % making the depth id 0 to 2
    pKW_post_behav(jj,1) = kruskalwallis(bAUC_post_L(iDepth_post==jj_dep,tpos),[],'off');
    pKW_post_behav(jj,2) = kruskalwallis(bAUC_post_H1(iDepth_post==jj_dep,tpos),[],'off');
    pKW_post_behav(jj,3) = kruskalwallis(bAUC_post_H2(iDepth_post==jj_dep,tpos),[],'off');
    pKW_ant_behav(jj,1)  = kruskalwallis(bAUC_ant_L(iDepth_ant==jj_dep,tpos), [],'off');
    pKW_ant_behav(jj,2)  = kruskalwallis(bAUC_ant_H1(iDepth_ant==jj_dep,tpos), [],'off');
    pKW_ant_behav(jj,3)  = kruskalwallis(bAUC_ant_H2(iDepth_ant==jj_dep,tpos), [],'off');
end

% SRH test
pSRH_post_stim(:,1) = stats_CompLayer_SRHtest2(sAUC_post_L,  iDepth_post, tpos);
pSRH_post_stim(:,2) = stats_CompLayer_SRHtest2(sAUC_post_H1, iDepth_post, tpos);
pSRH_post_stim(:,3) = stats_CompLayer_SRHtest2(sAUC_post_H2, iDepth_post, tpos);
pSRH_ant_stim(:,1)  = stats_CompLayer_SRHtest2(sAUC_ant_L,  iDepth_ant, tpos);
pSRH_ant_stim(:,2)  = stats_CompLayer_SRHtest2(sAUC_ant_H1, iDepth_ant, tpos);
pSRH_ant_stim(:,3)  = stats_CompLayer_SRHtest2(sAUC_ant_H2, iDepth_ant, tpos);

pSRH_post_behav(:,1) = stats_CompLayer_SRHtest2(bAUC_post_L,  iDepth_post, tpos);
pSRH_post_behav(:,2) = stats_CompLayer_SRHtest2(bAUC_post_H1, iDepth_post, tpos);
pSRH_post_behav(:,3) = stats_CompLayer_SRHtest2(bAUC_post_H2, iDepth_post, tpos);
pSRH_ant_behav(:,1)  = stats_CompLayer_SRHtest2(bAUC_ant_L,  iDepth_ant, tpos);
pSRH_ant_behav(:,2)  = stats_CompLayer_SRHtest2(bAUC_ant_H1, iDepth_ant, tpos);
pSRH_ant_behav(:,3)  = stats_CompLayer_SRHtest2(bAUC_ant_H2, iDepth_ant, tpos);


% % % % PLOT STIMULUS MODULATION % % % 
% figure("Position",[100 100 800 450]);
% h(1) = subplot(2,3,1); % L tone
% plot_ROC(tpos,sAUC_post_sup(:,:,1),-0.06,line_color_p(1,:)); hold on;
% plot_ROC(tpos,sAUC_post_mid(:,:,1), 0.00,line_color_p(2,:));
% plot_ROC(tpos,sAUC_post_dep(:,:,1), 0.06,line_color_p(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Posterior","L tone"]);
% % legend({'superficial','middle','deep'});
% box off
% yrange(1,:) = get(gca,'YLim');
% 
% h(2) = subplot(2,3,2); % H1 tone
% plot_ROC(tpos,sAUC_post_sup(:,:,2),-0.06,line_color_p(1,:)); hold on;
% plot_ROC(tpos,sAUC_post_mid(:,:,2), 0.00,line_color_p(2,:));
% plot_ROC(tpos,sAUC_post_dep(:,:,2), 0.06,line_color_p(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Posterior","H1 tone"]);
% % legend({'superficial','middle','deep'});
% box off
% yrange(2,:) = get(gca,'YLim');
% 
% h(3) = subplot(2,3,3); % H2 tone
% plot_ROC(tpos,sAUC_post_sup(:,:,3),-0.06,line_color_p(1,:)); hold on;
% plot_ROC(tpos,sAUC_post_mid(:,:,3), 0.00,line_color_p(2,:));
% plot_ROC(tpos,sAUC_post_dep(:,:,3), 0.06,line_color_p(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Posterior","H2 tone"]);
% legend({'superficial','middle','deep'});
% box off
% yrange(3,:) = get(gca,'YLim');
% 
% h(4) = subplot(2,3,4); % L tone
% plot_ROC(tpos,sAUC_ant_sup(:,:,1),-0.06,line_color_n(1,:)); hold on;
% plot_ROC(tpos,sAUC_ant_mid(:,:,1), 0.00,line_color_n(2,:));
% plot_ROC(tpos,sAUC_ant_dep(:,:,1), 0.06,line_color_n(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Anterior","L tone"]);
% % legend({'superficial','middle','deep'});
% box off
% yrange(4,:) = get(gca,'YLim');
% 
% h(5) = subplot(2,3,5); % H1 tone
% plot_ROC(tpos,sAUC_ant_sup(:,:,2),-0.06,line_color_n(1,:)); hold on;
% plot_ROC(tpos,sAUC_ant_mid(:,:,2), 0.00,line_color_n(2,:));
% plot_ROC(tpos,sAUC_ant_dep(:,:,2), 0.06,line_color_n(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Anterior","H1 tone"]);
% % legend({'superficial','middle','deep'});
% box off
% yrange(5,:) = get(gca,'YLim');
% 
% h(6) = subplot(2,3,6); % H2 tone
% plot_ROC(tpos,sAUC_ant_sup(:,:,3),-0.06,line_color_n(1,:)); hold on;
% plot_ROC(tpos,sAUC_ant_mid(:,:,3), 0.00,line_color_n(2,:));
% plot_ROC(tpos,sAUC_ant_dep(:,:,3), 0.06,line_color_n(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Anterior","H2 tone"]);
% legend({'superficial','middle','deep'});
% box off
% yrange(6,:) = get(gca,'YLim');
% 
% % set yaxis
% % yrange_stim = [min(yrange(:,1)) max(yrange(:,2))]
% yrange_stim = [0.3000 0.8020];
% for ii=1:6
%     set(h(ii),'YLim',yrange_stim);
% end
% clear h yrange
% 
% % % % PLOT BEHAVIORAL MODULATION % % % 
% figure("Position",[100 100 800 450]);
% h(1) = subplot(2,3,1); % L tone
% plot_ROC(tpos,bAUC_post_sup(:,:,1),-0.06,line_color_p(1,:)); hold on;
% plot_ROC(tpos,bAUC_post_mid(:,:,1), 0.00,line_color_p(2,:));
% plot_ROC(tpos,bAUC_post_dep(:,:,1), 0.06,line_color_p(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Posterior","L tone"]);
% % legend({'superficial','middle','deep'});
% box off
% yrange(1,:) = get(gca,'YLim');
% 
% h(2) = subplot(2,3,2); % H1 tone
% plot_ROC(tpos,bAUC_post_sup(:,:,2),-0.06,line_color_p(1,:)); hold on;
% plot_ROC(tpos,bAUC_post_mid(:,:,2), 0.00,line_color_p(2,:));
% plot_ROC(tpos,bAUC_post_dep(:,:,2), 0.06,line_color_p(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Posterior","H1 tone"]);
% % legend({'superficial','middle','deep'});
% box off
% yrange(2,:) = get(gca,'YLim');
% 
% h(3) = subplot(2,3,3); % H2 tone
% plot_ROC(tpos,bAUC_post_sup(:,:,3),-0.06,line_color_p(1,:)); hold on;
% plot_ROC(tpos,bAUC_post_mid(:,:,3), 0.00,line_color_p(2,:));
% plot_ROC(tpos,bAUC_post_dep(:,:,3), 0.06,line_color_p(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Posterior","H2 tone"]);
% legend({'superficial','middle','deep'});
% box off
% yrange(3,:) = get(gca,'YLim');
% 
% h(4) = subplot(2,3,4); % L tone
% plot_ROC(tpos,bAUC_ant_sup(:,:,1),-0.06,line_color_n(1,:)); hold on;
% plot_ROC(tpos,bAUC_ant_mid(:,:,1), 0.00,line_color_n(2,:));
% plot_ROC(tpos,bAUC_ant_dep(:,:,1), 0.06,line_color_n(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Anterior","L tone"]);
% % legend({'superficial','middle','deep'});
% box off
% yrange(4,:) = get(gca,'YLim');
% 
% h(5) = subplot(2,3,5); % H1 tone
% plot_ROC(tpos,bAUC_ant_sup(:,:,2),-0.06,line_color_n(1,:)); hold on;
% plot_ROC(tpos,bAUC_ant_mid(:,:,2), 0.00,line_color_n(2,:));
% plot_ROC(tpos,bAUC_ant_dep(:,:,2), 0.06,line_color_n(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Anterior","H1 tone"]);
% % legend({'superficial','middle','deep'});
% box off
% yrange(5,:) = get(gca,'YLim');
% 
% h(6) = subplot(2,3,6); % H2 tone
% plot_ROC(tpos,bAUC_ant_sup(:,:,3),-0.06,line_color_n(1,:)); hold on;
% plot_ROC(tpos,bAUC_ant_mid(:,:,3), 0.00,line_color_n(2,:));
% plot_ROC(tpos,bAUC_ant_dep(:,:,3), 0.06,line_color_n(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% title(["Anterior","H2 tone"]);
% legend({'superficial','middle','deep'});
% box off
% yrange(6,:) = get(gca,'YLim');
% 
% % set yaxis
% % yrange_behav = [min(yrange(:,1)) max(yrange(:,2))]
% yrange_behav = [0.3990 0.6500];
% for ii=1:6
%     set(h(ii),'YLim',yrange_behav);
% end
% clear h yrange