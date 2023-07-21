clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AvsB1';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% tpos = [1 2 3 6 7];
% tpos = [1 2 3 6 7 8]; % extended
tpos = 4:8; % around target
% tpos = 1:8; % all
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
              0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
line_color_p = [157 195 230; 46 117 182; 31 78 121] / 255;
line_color_n = [244 177 131; 197 90 17; 132 60 12] / 255;

% load Data
load(fullfile(DATA_DIR,'ROC_Both.mat'));

% get depth index (posterior/anterior)
iDepth_post = depth_index(:,AP_index==1);
iDepth_ant  = depth_index(:,AP_index==0);
iDepth_post = reshape(iDepth_post,[size(iDepth_post,1)*size(iDepth_post,2) 1]);
iDepth_ant  = reshape(iDepth_ant,[size(iDepth_ant,1)*size(iDepth_ant,2) 1]);

% reshape matrix (sample x tpos x stdiff)
AUC_post_df = reshape(AUC.post.stdiff,[size(AUC.post.stdiff,1)*size(AUC.post.stdiff,2) size(AUC.post.stdiff,3) size(AUC.post.stdiff,4)]);
AUC_ant_df  = reshape(AUC.ant.stdiff,[size(AUC.ant.stdiff,1)*size(AUC.ant.stdiff,2) size(AUC.ant.stdiff,3) size(AUC.ant.stdiff,4)]);
% hit/miss with intermediate dF trials
AUC_post_hm = reshape(AUC.post.hitmiss,[size(AUC.post.hitmiss,1)*size(AUC.post.hitmiss,2) size(AUC.post.hitmiss,3) size(AUC.post.hitmiss,4)]);
AUC_ant_hm  = reshape(AUC.ant.hitmiss,[size(AUC.ant.hitmiss,1)*size(AUC.ant.hitmiss,2) size(AUC.ant.hitmiss,3) size(AUC.ant.hitmiss,4)]);
% hit/miss intermediate dF trials are REMOVED
AUC_post_hm2 = reshape(AUC.post.hitmiss2,[size(AUC.post.hitmiss2,1)*size(AUC.post.hitmiss2,2) size(AUC.post.hitmiss2,3) size(AUC.post.hitmiss2,4)]);
AUC_ant_hm2  = reshape(AUC.ant.hitmiss2,[size(AUC.ant.hitmiss2,1)*size(AUC.ant.hitmiss2,2) size(AUC.ant.hitmiss2,3) size(AUC.ant.hitmiss2,4)]);

% separate layers
% posterior (stdiff)
AUC_post_df_sup = AUC_post_df(iDepth_post==0,:,:);
AUC_post_df_mid = AUC_post_df(iDepth_post==1,:,:);
AUC_post_df_dep = AUC_post_df(iDepth_post==2,:,:);
% anterior (stdiff)
AUC_ant_df_sup = AUC_ant_df(iDepth_ant==0,:,:);
AUC_ant_df_mid = AUC_ant_df(iDepth_ant==1,:,:);
AUC_ant_df_dep = AUC_ant_df(iDepth_ant==2,:,:);
% posterior (hit/miss including intermediate dF trials)
AUC_post_hm_sup = AUC_post_hm(iDepth_post==0,:,:);
AUC_post_hm_mid = AUC_post_hm(iDepth_post==1,:,:);
AUC_post_hm_dep = AUC_post_hm(iDepth_post==2,:,:);
% anterior (hit/miss including intermediate dF trials)
AUC_ant_hm_sup = AUC_ant_hm(iDepth_ant==0,:,:);
AUC_ant_hm_mid = AUC_ant_hm(iDepth_ant==1,:,:);
AUC_ant_hm_dep = AUC_ant_hm(iDepth_ant==2,:,:);
% posterior (hit/miss smallest and largest dF trials)
AUC_post_hm2_sup = AUC_post_hm2(iDepth_post==0,:,:);
AUC_post_hm2_mid = AUC_post_hm2(iDepth_post==1,:,:);
AUC_post_hm2_dep = AUC_post_hm2(iDepth_post==2,:,:);
% anterior (hit/miss smallest and largest dF trials)
AUC_ant_hm2_sup = AUC_ant_hm2(iDepth_ant==0,:,:);
AUC_ant_hm2_mid = AUC_ant_hm2(iDepth_ant==1,:,:);
AUC_ant_hm2_dep = AUC_ant_hm2(iDepth_ant==2,:,:);

% plot
% % % Figure 1 (Laminar comparison small and large dF) % % %
figure;
subplot(2,2,1);
plot_ROC(tpos,AUC_post_df_sup(:,:,1),-0.06,line_color_p(1,:)); hold on;
plot_ROC(tpos,AUC_post_df_mid(:,:,1), 0.00,line_color_p(2,:));
plot_ROC(tpos,AUC_post_df_dep(:,:,1), 0.06,line_color_p(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
title(["Posterior","Small dF"]);
legend({'superficial','middle','deep'});
box off
subplot(2,2,2);
plot_ROC(tpos,AUC_ant_df_sup(:,:,1),-0.06,line_color_n(1,:)); hold on;
plot_ROC(tpos,AUC_ant_df_mid(:,:,1), 0.00,line_color_n(2,:));
plot_ROC(tpos,AUC_ant_df_dep(:,:,1), 0.06,line_color_n(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
title(["Anterior","Small dF"]);
legend({'superficial','middle','deep'});
box off

subplot(2,2,3);
plot_ROC(tpos,AUC_post_df_sup(:,:,4),-0.06,line_color_p(1,:)); hold on;
plot_ROC(tpos,AUC_post_df_mid(:,:,4), 0.00,line_color_p(2,:));
plot_ROC(tpos,AUC_post_df_dep(:,:,4), 0.06,line_color_p(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
title("Large dF");
box off
subplot(2,2,4);
plot_ROC(tpos,AUC_ant_df_sup(:,:,4),-0.06,line_color_n(1,:)); hold on;
plot_ROC(tpos,AUC_ant_df_mid(:,:,4), 0.00,line_color_n(2,:));
plot_ROC(tpos,AUC_ant_df_dep(:,:,4), 0.06,line_color_n(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
title("Large dF");
box off

% % % Figure 2 (Laminar comparison hit and miss) % % %
figure;
subplot(2,2,1);
plot_ROC(tpos,AUC_post_hm2_sup(:,:,1),-0.06,line_color_p(1,:)); hold on;
plot_ROC(tpos,AUC_post_hm2_mid(:,:,1), 0.00,line_color_p(2,:));
plot_ROC(tpos,AUC_post_hm2_dep(:,:,1), 0.06,line_color_p(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
title(["Posterior","Hit"]);
legend({'superficial','middle','deep'});
box off
subplot(2,2,2);
plot_ROC(tpos,AUC_ant_hm2_sup(:,:,1),-0.06,line_color_n(1,:)); hold on;
plot_ROC(tpos,AUC_ant_hm2_mid(:,:,1), 0.00,line_color_n(2,:));
plot_ROC(tpos,AUC_ant_hm2_dep(:,:,1), 0.06,line_color_n(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
title(["Anterior","Hit"]);
legend({'superficial','middle','deep'});
box off

subplot(2,2,3);
plot_ROC(tpos,AUC_post_hm2_sup(:,:,2),-0.06,line_color_p(1,:)); hold on;
plot_ROC(tpos,AUC_post_hm2_mid(:,:,2), 0.00,line_color_p(2,:));
plot_ROC(tpos,AUC_post_hm2_dep(:,:,2), 0.06,line_color_p(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
title("Miss");
box off
subplot(2,2,4);
plot_ROC(tpos,AUC_ant_hm2_sup(:,:,2),-0.06,line_color_n(1,:)); hold on;
plot_ROC(tpos,AUC_ant_hm2_mid(:,:,2), 0.00,line_color_n(2,:));
plot_ROC(tpos,AUC_ant_hm2_dep(:,:,2), 0.06,line_color_n(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
title("Miss");
box off

% % % Figure 3 (comp. stdiff across layers) % % %
figure("Position",[100 100 550 650]);
jitter = [-0.06 -0.02 0.02 0.06];
subplot(3,2,1); hold on;
for ii=1:4
    plot_ROC(tpos,AUC_post_df_sup(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title(["Posterior","Superficial"]);
subplot(3,2,2); hold on;
for ii=1:4
    plot_ROC(tpos,AUC_ant_df_sup(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title(["Anterior","Superficial"]);
legend({'Smallest dF','','','Largest dF'});

subplot(3,2,3); hold on;
for ii=1:4
    plot_ROC(tpos,AUC_post_df_mid(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Middle');
subplot(3,2,4); hold on;
for ii=1:4
    plot_ROC(tpos,AUC_ant_df_mid(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Middle');

subplot(3,2,5); hold on;
for ii=1:4
    plot_ROC(tpos,AUC_post_df_dep(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Deep');
subplot(3,2,6); hold on;
for ii=1:4
    plot_ROC(tpos,AUC_ant_df_dep(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Deep');

% % % Figure 4 (comp. hit/miss across layers) % % %
figure("Position",[100 100 550 650]);
subplot(3,2,1); hold on;
plot_ROC(tpos,AUC_post_hm_sup(:,:,1),jitter(1),line_color(2,:));
plot_ROC(tpos,AUC_post_hm_sup(:,:,2),jitter(4),line_color(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title(["Posterior","Superficial"]);
subplot(3,2,2); hold on;
plot_ROC(tpos,AUC_ant_hm_sup(:,:,1),jitter(1),line_color(2,:));
plot_ROC(tpos,AUC_ant_hm_sup(:,:,2),jitter(4),line_color(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title(["Anterior","Superficial"]);
legend({'Hit','Miss'});

subplot(3,2,3); hold on;
plot_ROC(tpos,AUC_post_hm_mid(:,:,1),jitter(1),line_color(2,:));
plot_ROC(tpos,AUC_post_hm_mid(:,:,2),jitter(4),line_color(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Middle');
subplot(3,2,4); hold on;
plot_ROC(tpos,AUC_ant_hm_mid(:,:,1),jitter(1),line_color(2,:));
plot_ROC(tpos,AUC_ant_hm_mid(:,:,2),jitter(4),line_color(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Middle');

subplot(3,2,5); hold on;
plot_ROC(tpos,AUC_post_hm_dep(:,:,1),jitter(1),line_color(2,:));
plot_ROC(tpos,AUC_post_hm_dep(:,:,2),jitter(4),line_color(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Deep');
subplot(3,2,6); hold on;
plot_ROC(tpos,AUC_ant_hm_dep(:,:,1),jitter(1),line_color(2,:));
plot_ROC(tpos,AUC_ant_hm_dep(:,:,2),jitter(4),line_color(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Deep');

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
% ylabel('AUROC');
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
% ylabel('AUROC');
% box off;
% title('Anterior');
% legend({'Small dF','','','Large dF'});
% 
% subplot(2,2,3);
% % hit
% plot_ROC(tpos,AUC_post_hm(:,:,1),jitter(1),line_color(2,:)); hold on;
% % miss
% plot_ROC(tpos,AUC_post_hm(:,:,2),jitter(4),line_color(3,:));
% xlim([0.5 length(tpos)+0.5]);
% ylabel('AUROC');
% box off;
% 
% subplot(2,2,4);
% % hit
% plot_ROC(tpos,AUC_ant_hm(:,:,1),jitter(1),line_color(2,:)); hold on;
% % miss
% plot_ROC(tpos,AUC_ant_hm(:,:,2),jitter(4),line_color(3,:));
% xlim([0.5 length(tpos)+0.5]);
% ylabel('AUROC');
% box off;
% legend({'Hit','Miss'});