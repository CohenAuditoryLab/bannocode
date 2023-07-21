clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AvsB1_v2';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
tpos = [1 2 3 6 7];
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 4:8; % around target
% tpos = 1:8; % all
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
              0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];

% load Data
load(fullfile(DATA_DIR,'ROC_Both_v2.mat'));

% reshape matrix (sample x tpos x stdiff)
AUC_post_df = reshape(AUC.post.stdiff,[size(AUC.post.stdiff,1)*size(AUC.post.stdiff,2) size(AUC.post.stdiff,3) size(AUC.post.stdiff,4)]);
AUC_ant_df  = reshape(AUC.ant.stdiff,[size(AUC.ant.stdiff,1)*size(AUC.ant.stdiff,2) size(AUC.ant.stdiff,3) size(AUC.ant.stdiff,4)]);
% hit/miss with intermediate dF trials
AUC_post_hit = reshape(AUC.post.hit,[size(AUC.post.hit,1)*size(AUC.post.hit,2) size(AUC.post.hit,3) size(AUC.post.hit,4)]);
AUC_ant_hit  = reshape(AUC.ant.hit,[size(AUC.ant.hit,1)*size(AUC.ant.hit,2) size(AUC.ant.hit,3) size(AUC.ant.hit,4)]);
% hit/miss intermediate dF trials are REMOVED
AUC_post_miss = reshape(AUC.post.miss,[size(AUC.post.miss,1)*size(AUC.post.miss,2) size(AUC.post.miss,3) size(AUC.post.miss,4)]);
AUC_ant_miss  = reshape(AUC.ant.miss,[size(AUC.ant.miss,1)*size(AUC.ant.miss,2) size(AUC.ant.miss,3) size(AUC.ant.miss,4)]);

% plot
figure;
jitter = [-0.06 -0.02 0.02 0.06];
subplot(2,2,1); hold on;
for ii=1:4
    plot_ROC(tpos,AUC_post_df(:,:,ii),jitter(ii),line_color(ii,:));
end
% % small dF
% plot_ROC(tpos,AUC_post_df(:,:,1),-jitter,line_color(1,:)); hold on;
% % large dF
% plot_ROC(tpos,AUC_post_df(:,:,4), jitter,line_color(2,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Posterior');

subplot(2,2,2); hold on;
for ii=1:4
    plot_ROC(tpos,AUC_ant_df(:,:,ii),jitter(ii),line_color(ii,:));
end
% % small dF
% plot_ROC(tpos,AUC_ant_df(:,:,1),-jitter,line_color(1,:)); hold on;
% % large dF
% plot_ROC(tpos,AUC_ant_df(:,:,4), jitter,line_color(2,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Anterior');
legend({'Smallest dF','Small dF','Large dF','Largest dF'});

subplot(2,2,3);
% small dF
plot_ROC(tpos,AUC_post_hit(:,:,1),jitter(1),line_color(1,:)); hold on;
plot_ROC(tpos,AUC_post_miss(:,:,1),jitter(3),line_color(2,:));
% large dF
plot_ROC(tpos,AUC_post_hit(:,:,4),jitter(2),line_color(4,:));
plot_ROC(tpos,AUC_post_miss(:,:,4),jitter(4),line_color(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;

subplot(2,2,4);
% small dF
plot_ROC(tpos,AUC_ant_hit(:,:,1),jitter(1),line_color(1,:)); hold on;
plot_ROC(tpos,AUC_ant_miss(:,:,1),jitter(3),line_color(2,:));
% large dF
plot_ROC(tpos,AUC_ant_hit(:,:,4),jitter(2),line_color(4,:));
plot_ROC(tpos,AUC_ant_miss(:,:,4),jitter(4),line_color(3,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
% legend({'Hit','Miss'});
legend({'Hit small dF','Miss small dF','Hit large dF' 'Miss large dF'});