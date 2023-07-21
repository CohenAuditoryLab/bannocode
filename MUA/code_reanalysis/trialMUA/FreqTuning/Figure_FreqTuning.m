clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\FreqTuning';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
tpos = [1 6]; % 1st and T-1 triplet position
% tpos = [1 2 3 6 7];
% tpos = [1 2 3 6]; % omit Target because it is louder...
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 4:8; % around target
% tpos = 1:8; % all
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
              0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];

% % % BF site % % %
% load Data
load(fullfile(DATA_DIR,'ver2','FreqTuning2_Both_lowBF.mat'));
% load(fullfile(DATA_DIR,'FreqTuning_Both_highBF.mat'));
ii = 1;

% reshape matrix (sample x tpos x stdiff)
% % SPARSENESS INDEX
% AUC_post_df = reshape(SparseIndex.post.all,[size(SparseIndex.post.all,1)*size(SparseIndex.post.all,2) size(SparseIndex.post.all,3)]);
% AUC_ant_df  = reshape(SparseIndex.ant.all,[size(SparseIndex.ant.all,1)*size(SparseIndex.ant.all,2) size(SparseIndex.ant.all,3)]);
% SELECTIVITY INDEX
% all trials
AUC_post_df = reshape(SelectIndex.post.all,[size(SelectIndex.post.all,1)*size(SelectIndex.post.all,2) size(SelectIndex.post.all,3)]);
AUC_ant_df  = reshape(SelectIndex.ant.all,[size(SelectIndex.ant.all,1)*size(SelectIndex.ant.all,2) size(SelectIndex.ant.all,3)]);
% % hit
% AUC_post_df = reshape(SelectIndex.post.hit,[size(SelectIndex.post.hit,1)*size(SelectIndex.post.hit,2) size(SelectIndex.post.hit,3)]);
% AUC_ant_df  = reshape(SelectIndex.ant.hit,[size(SelectIndex.ant.hit,1)*size(SelectIndex.ant.hit,2) size(SelectIndex.ant.hit,3)]);
% % miss
% AUC_post_df = reshape(SelectIndex.post.miss,[size(SelectIndex.post.miss,1)*size(SelectIndex.post.miss,2) size(SelectIndex.post.miss,3)]);
% AUC_ant_df  = reshape(SelectIndex.ant.miss,[size(SelectIndex.ant.miss,1)*size(SelectIndex.ant.miss,2) size(SelectIndex.ant.miss,3)]);

% plot
figure;
jitter = [-0.06 -0.02 0.02 0.06];
h(1) = subplot(2,2,1); hold on;
plot_ROC(tpos,AUC_post_df,jitter(ii),line_color(ii,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Posterior');
% yrange(1,:) = get(gca,'YLim');

h(2) = subplot(2,2,2); hold on;
plot_ROC(tpos,AUC_ant_df,jitter(ii),line_color(ii,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Anterior');
% legend({'Smallest dF','Small dF','Large dF','Largest dF'});
% yrange(2,:) = get(gca,'YLim');

% % % non-BF site % % %
% load Data
% load(fullfile(DATA_DIR,'FreqTuning_Both_lowBF.mat'));
load(fullfile(DATA_DIR,'ver2','FreqTuning2_Both_highBF.mat'));
ii = 4;

% reshape matrix (sample x tpos x stdiff)
% % SPARSENESS INDEX
% AUC_post_df = reshape(SparseIndex.post.all,[size(SparseIndex.post.all,1)*size(SparseIndex.post.all,2) size(SparseIndex.post.all,3)]);
% AUC_ant_df  = reshape(SparseIndex.ant.all,[size(SparseIndex.ant.all,1)*size(SparseIndex.ant.all,2) size(SparseIndex.ant.all,3)]);
% SELECTIVITY INDEX
% all trials
AUC_post_df = reshape(SelectIndex.post.all,[size(SelectIndex.post.all,1)*size(SelectIndex.post.all,2) size(SelectIndex.post.all,3)]);
AUC_ant_df  = reshape(SelectIndex.ant.all,[size(SelectIndex.ant.all,1)*size(SelectIndex.ant.all,2) size(SelectIndex.ant.all,3)]);
% % hit
% AUC_post_df = reshape(SelectIndex.post.hit,[size(SelectIndex.post.hit,1)*size(SelectIndex.post.hit,2) size(SelectIndex.post.hit,3)]);
% AUC_ant_df  = reshape(SelectIndex.ant.hit,[size(SelectIndex.ant.hit,1)*size(SelectIndex.ant.hit,2) size(SelectIndex.ant.hit,3)]);
% % miss
% AUC_post_df = reshape(SelectIndex.post.miss,[size(SelectIndex.post.miss,1)*size(SelectIndex.post.miss,2) size(SelectIndex.post.miss,3)]);
% AUC_ant_df  = reshape(SelectIndex.ant.miss,[size(SelectIndex.ant.miss,1)*size(SelectIndex.ant.miss,2) size(SelectIndex.ant.miss,3)]);

% plot
% figure;
jitter = [-0.06 -0.02 0.02 0.06];
h(1) = subplot(2,2,1); hold on;
% making index (H-L)/(H+L)
plot_ROC(tpos,-1*AUC_post_df,jitter(ii),line_color(ii,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');

h(2) = subplot(2,2,2); hold on;
% making index (H-L)/(H+L)
plot_ROC(tpos,-1*AUC_ant_df,jitter(ii),line_color(ii,:));
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('AUROC');
box off;
title('Anterior');
yrange(2,:) = get(gca,'YLim');
legend({'BF site','non-BF site'});

% % % equate y-axis % % %
for ii=1:2
    set(h,'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
end

% h(3) = subplot(2,2,3);
% % hit
% plot_ROC(tpos,AUC_post_hm(:,:,1),jitter(1),line_color(2,:)); hold on;
% % miss
% plot_ROC(tpos,AUC_post_hm(:,:,2),jitter(4),line_color(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% box off;
% yrange(3,:) = get(gca,'YLim');
% 
% h(4) = subplot(2,2,4);
% % hit
% plot_ROC(tpos,AUC_ant_hm(:,:,1),jitter(1),line_color(2,:)); hold on;
% % miss
% plot_ROC(tpos,AUC_ant_hm(:,:,2),jitter(4),line_color(3,:));
% plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% box off;
% legend({'Hit','Miss'});
% yrange(4,:) = get(gca,'YLim');
% 
% % equate y-axis
% for ii=1:4
%     set(h,'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
% end