clear all

ROC_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA';

load(fullfile(ROC_DIR,'ROC_AvsB1','ROC_Both.mat'));
load SMIBMI_Channel.mat;

tpos = [1 2 3 6 7];
sTriplet = sTriplet(tpos);
SMI_A_post = SMI_A.post;
SMI_B1_post = SMI_B1.post;
SMI_A_ant = SMI_A.ant;
SMI_B1_ant = SMI_B1.ant;

BMI_A_post = BMI_A.post;
BMI_B1_post = BMI_B1.post;
BMI_A_ant = BMI_A.ant;
BMI_B1_ant = BMI_B1.ant;

% reshape matrix (sample x tpos x stdiff)
AUC_post_df = reshape(AUC.post.stdiff,[size(AUC.post.stdiff,1)*size(AUC.post.stdiff,2) size(AUC.post.stdiff,3) size(AUC.post.stdiff,4)]);
AUC_ant_df  = reshape(AUC.ant.stdiff,[size(AUC.ant.stdiff,1)*size(AUC.ant.stdiff,2) size(AUC.ant.stdiff,3) size(AUC.ant.stdiff,4)]);
% hit/miss with intermediate dF trials
AUC_post_hm = reshape(AUC.post.hitmiss,[size(AUC.post.hitmiss,1)*size(AUC.post.hitmiss,2) size(AUC.post.hitmiss,3) size(AUC.post.hitmiss,4)]);
AUC_ant_hm  = reshape(AUC.ant.hitmiss,[size(AUC.ant.hitmiss,1)*size(AUC.ant.hitmiss,2) size(AUC.ant.hitmiss,3) size(AUC.ant.hitmiss,4)]);
% hit/miss intermediate dF trials are REMOVED
AUC_post_hm2 = reshape(AUC.post.hitmiss2,[size(AUC.post.hitmiss2,1)*size(AUC.post.hitmiss2,2) size(AUC.post.hitmiss2,3) size(AUC.post.hitmiss2,4)]);
AUC_ant_hm2  = reshape(AUC.ant.hitmiss2,[size(AUC.ant.hitmiss2,1)*size(AUC.ant.hitmiss2,2) size(AUC.ant.hitmiss2,3) size(AUC.ant.hitmiss2,4)]);

SMI_A_post = SMI_A_post(:,tpos);
SMI_B1_post = SMI_B1_post(:,tpos);
BMI_A_post = BMI_A_post(:,tpos);
BMI_B1_post = BMI_B1_post(:,tpos);
AUC_post_smallDF = AUC_post_df(:,tpos,1);
AUC_post_largeDF = AUC_post_df(:,tpos,end);
dAUC_post = AUC_post_largeDF - AUC_post_smallDF;

SMI_A_ant = SMI_A_ant(:,tpos);
SMI_B1_ant = SMI_B1_ant(:,tpos);
BMI_A_ant = BMI_A_ant(:,tpos);
BMI_B1_ant = BMI_B1_ant(:,tpos);
AUC_ant_smallDF = AUC_ant_df(:,tpos,1);
AUC_ant_largeDF = AUC_ant_df(:,tpos,end);
dAUC_ant = AUC_ant_largeDF - AUC_ant_smallDF;

% figure;
% plot(nanmean(AUC_post_df(:,:,1),1)); hold on;
% plot(nanmean(AUC_post_df(:,:,2),1));
% plot(nanmean(AUC_post_df(:,:,3),1));
% plot(nanmean(AUC_post_df(:,:,4),1));
% 
% plot(nanmean(SMI_A_post,1));


% plot SMI/BMI wrt phase-loking index
list_tpos = sTriplet;
n_tpos = length(list_tpos);
figure('Position',[100 100 900 550]);
for tpos=1:n_tpos
    subplot(3,n_tpos,tpos);
%     plot(AUC_post_smallDF(:,tpos),SMI_A_post(:,tpos),'or','MarkerFaceColor','w');
%     plot(dAUC_post(:,tpos),SMI_A_post(:,tpos),'or','MarkerFaceColor','w');
%     plot(AUC_post_smallDF(:,tpos),BMI_A_post(:,tpos),'or','MarkerFaceColor','w');
    plot(dAUC_post(:,tpos),BMI_A_post(:,tpos),'or','MarkerFaceColor','w');
    xlabel('ROC'); ylabel('log(CI)'); 
    title(list_tpos{tpos});
    grid on;
    subplot(3,n_tpos,tpos+n_tpos);
%     plot(AUC_ant_smallDF(:,tpos),SMI_A_ant(:,tpos),'ob','MarkerFaceColor','w');
%     plot(dAUC_ant(:,tpos),SMI_A_ant(:,tpos),'ob','MarkerFaceColor','w');
%     plot(AUC_ant_smallDF(:,tpos),BMI_A_ant(:,tpos),'ob','MarkerFaceColor','w');
    plot(dAUC_ant(:,tpos),BMI_A_ant(:,tpos),'ob','MarkerFaceColor','w');
    xlabel('ROC'); ylabel('log(CI)'); 
    title(list_tpos{tpos});
    grid on;
    [r_post(tpos),p_post(tpos)] = corr(AUC_post_smallDF(:,tpos),SMI_A_post(:,tpos),'Type','Spearman');
    [r_ant(tpos) ,p_ant(tpos)]  = corr(AUC_ant_smallDF(:,tpos),SMI_A_ant(:,tpos),'type','Spearman');
end
subplot(3,2,5);
plot(1:n_tpos,r_post,'-or','LineWidth',2); hold on;
plot(1:n_tpos,r_ant, '-ob','LineWidth',2);
plot([0.5 n_tpos+0.5],[0 0],':k');
for tpos=1:n_tpos % fill circle if correlation is significant
    if p_post(tpos) < 0.05
        plot(tpos,r_post(tpos),'or','MarkerFaceColor','r');
    end
    if p_ant(tpos) < 0.05
        plot(tpos,r_ant(tpos),'ob','MarkerFaceColor','b');
    end
end
set(gca,'XLim',[0.5 n_tpos+0.5],'XTick',1:n_tpos,'XTickLabel',list_tpos);
xlabel('triplet posiion'); ylabel('correlation');
title('ROC vs CI');
box off;

% figure('Position',[150 150 900 550]);
% for tpos=1:n_tpos
%     subplot(3,n_tpos,tpos);
%     plot(logPL_core(:,i_selectPL),BMI_core(:,tpos),'or','MarkerFaceColor','w');
%     xlabel('log(FFT)'); ylabel('BMI'); 
%     title(list_tpos{tpos});
%     grid on;
%     subplot(3,n_tpos,tpos+n_tpos);
%     plot(logPL_belt(:,i_selectPL),BMI_belt(:,tpos),'ob','MarkerFaceColor','w');
%     xlabel('log(FFT)'); ylabel('BMI'); 
%     title(list_tpos{tpos});
%     grid on;
%     [r_core(tpos),p_core(tpos)] = corr(logPL_core(:,i_selectPL),BMI_core(:,tpos));
%     [r_belt(tpos),p_belt(tpos)] = corr(logPL_belt(:,i_selectPL),BMI_belt(:,tpos));
% end
% subplot(3,2,5);
% plot(1:n_tpos,r_core,'-or','LineWidth',2); hold on;
% plot(1:n_tpos,r_belt,'-ob','LineWidth',2);
% plot([0.5 n_tpos+0.5],[0 0],':k');
% for tpos=1:5 % fill circle if correlation is significant
%     if p_core(tpos) < 0.05
%         plot(tpos,r_core(tpos),'or','MarkerFaceColor','r');
%     end
%     if p_belt(tpos) < 0.05
%         plot(tpos,r_belt(tpos),'ob','MarkerFaceColor','b');
%     end
% end
% set(gca,'XLim',[0.5 n_tpos+0.5],'XTick',1:5,'XTickLabel',list_tpos);
% xlabel('triplet position'); ylabel('correlation');
% title('FFT vs BMI');
% box off;
% 
% % SMI vs BMI
% figure('Position',[200 200 900 550]);
% for tpos=1:n_tpos
%     subplot(3,n_tpos,tpos);
%     plot(logSMI_core(:,tpos),BMI_core(:,tpos),'or','MarkerFaceColor','w');
%     xlabel('log(SMI)'); ylabel('BMI'); 
%     title(list_tpos{tpos});
%     grid on;
%     subplot(3,n_tpos,tpos+n_tpos);
%     plot(logSMI_belt(:,tpos),BMI_belt(:,tpos),'ob','MarkerFaceColor','w');
%     xlabel('log(SMI)'); ylabel('BMI'); 
%     title(list_tpos{tpos});
%     grid on;
%     [r_core(tpos),p_core(tpos)] = corr(logSMI_core(:,tpos),BMI_core(:,tpos));
%     [r_belt(tpos),p_belt(tpos)] = corr(logSMI_belt(:,tpos),BMI_belt(:,tpos));
% end
% subplot(3,2,5);
% plot(1:n_tpos,r_core,'-or','LineWidth',2); hold on;
% plot(1:n_tpos,r_belt,'-ob','LineWidth',2);
% plot([0.5 n_tpos+0.5],[0 0],':k');
% for tpos=1:5 % fill circle if correlation is significant
%     if p_core(tpos) < 0.05
%         plot(tpos,r_core(tpos),'or','MarkerFaceColor','r');
%     end
%     if p_belt(tpos) < 0.05
%         plot(tpos,r_belt(tpos),'ob','MarkerFaceColor','b');
%     end
% end
% set(gca,'XLim',[0.5 n_tpos+0.5],'XTick',1:5,'XTickLabel',list_tpos);
% xlabel('triplet position'); ylabel('correlation');
% title('SMI vs BMI');
% box off;
% 
% % % log transform
% % ilProp_core = log10(iMUAprop_core);
% % ilProp_belt = log10(iMUAprop_belt);
% % 
% % ilProp_all = [ilProp_core; ilProp_belt];
% % 
% % [coeff,score] = pca(ilProp_all);
% % n = size(ilProp_core,1);
% % score_core = score(1:n,:);
% % score_belt = score(n+1:end,:);
% % plot3(score_core(:,1),score_core(:,2),score_core(:,3),'or'); hold on
% % plot3(score_belt(:,1),score_belt(:,2),score_belt(:,3),'^b'); 
% % grid on;
