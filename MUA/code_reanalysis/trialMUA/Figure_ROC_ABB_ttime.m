clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB_ttime';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
tt_version = 2; % 1 for all dF conditions, 2 for removing intermid dF
tpos = 1:4;
% line_color_area = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [229 0 125; 78 186 25] / 255;
line_color_area = [153 0 255; 0 204 0] / 255;

% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
% line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];


% load Data (BF sites)
load(fullfile(DATA_DIR,'ROC_Both_target_lowBF.mat'));
if tt_version==1
    % reshape matrix (sample x ttime)
    AUC_post_tt = reshape(AUC.post.target,[size(AUC.post.target,1)*size(AUC.post.target,2) size(AUC.post.target,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target,[size(AUC.ant.target,1)*size(AUC.ant.target,2) size(AUC.ant.target,3)]);
elseif tt_version==2
    % intermediate dF trials are REMOVED
    AUC_post_tt = reshape(AUC.post.target2,[size(AUC.post.target2,1)*size(AUC.post.target2,2) size(AUC.post.target2,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target2,[size(AUC.ant.target2,1)*size(AUC.ant.target2,2) size(AUC.ant.target2,3)]);
end

% plot
figure;
jitter = [-0.06 -0.02 0.02 0.06];
y_range = [0.4925 0.7000]; % set y-axis 
% plot ROC posterior vs anterior
h(1) = subplot(2,2,1); hold on;
% posterior
plot_ROC(tpos,AUC_post_tt,jitter(1),line_color_area(1,:));
% anterior
plot_ROC(tpos,AUC_ant_tt, jitter(4),line_color_area(2,:));
plot([0.5 4.5],[0.5 0.5],':k');
set(gca,'XTick',tpos,'XTickLabel',{'early','','','late'});
xlim([tpos(1)-0.5 tpos(end)+0.5]);
yrange(1,:) = get(gca,'YLim');
xlabel('Target Position'); ylabel('AUROC');
title('BF sites');
% legend({'Posterior','Anterior'});

% load Data (non-BF sites)
load(fullfile(DATA_DIR,'ROC_Both_target_highBF.mat'));
if tt_version==1
    % reshape matrix (sample x ttime)
    AUC_post_tt = reshape(AUC.post.target,[size(AUC.post.target,1)*size(AUC.post.target,2) size(AUC.post.target,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target,[size(AUC.ant.target,1)*size(AUC.ant.target,2) size(AUC.ant.target,3)]);
elseif tt_version==2
    % intermediate dF trials are REMOVED
    AUC_post_tt = reshape(AUC.post.target2,[size(AUC.post.target2,1)*size(AUC.post.target2,2) size(AUC.post.target2,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target2,[size(AUC.ant.target2,1)*size(AUC.ant.target2,2) size(AUC.ant.target2,3)]);
end
% plot
h(2) = subplot(2,2,2); hold on;
% posterior
plot_ROC(tpos,AUC_post_tt,jitter(1),line_color_area(1,:));
% anterior
plot_ROC(tpos,AUC_ant_tt, jitter(4),line_color_area(2,:));
plot([0.5 4.5],[0.5 0.5],':k');
set(gca,'XTick',tpos,'XTickLabel',{'early','','','late'});
xlim([tpos(1)-0.5 tpos(end)+0.5]);
yrange(2,:) = get(gca,'YLim');
xlabel('Target Position'); ylabel('AUROC');
title('non-BF sites');
% legend({'Posterior','Anterior'});

% load Data (non-BF sites)
load(fullfile(DATA_DIR,'ROC_Both_target_allBF.mat'));
if tt_version==1
    % reshape matrix (sample x ttime)
    AUC_post_tt = reshape(AUC.post.target,[size(AUC.post.target,1)*size(AUC.post.target,2) size(AUC.post.target,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target,[size(AUC.ant.target,1)*size(AUC.ant.target,2) size(AUC.ant.target,3)]);
elseif tt_version==2
    % intermediate dF trials are REMOVED
    AUC_post_tt = reshape(AUC.post.target2,[size(AUC.post.target2,1)*size(AUC.post.target2,2) size(AUC.post.target2,3)]);
    AUC_ant_tt  = reshape(AUC.ant.target2,[size(AUC.ant.target2,1)*size(AUC.ant.target2,2) size(AUC.ant.target2,3)]);
end
% plot
h(3) = subplot(2,2,3); hold on;
% posterior
plot_ROC(tpos,AUC_post_tt,jitter(1),line_color_area(1,:));
% anterior
plot_ROC(tpos,AUC_ant_tt, jitter(4),line_color_area(2,:));
plot([0.5 4.5],[0.5 0.5],':k');
set(gca,'XTick',tpos,'XTickLabel',{'early','','','late'});
xlim([tpos(1)-0.5 tpos(end)+0.5]);
yrange(3,:) = get(gca,'YLim');
xlabel('Target Position'); ylabel('AUROC');
title('all sites');
legend({'Posterior','Anterior'});

% equate axis
for ii=1:3
    set(h(ii),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
end

% % % plot posterior ROC in hit and miss trials
% subplot(2,2,3);
% % hit
% plot_ROC(tpos,AUC_post_hm(:,:,1),jitter(1),line_color(2,:)); hold on;
% % miss
% plot_ROC(tpos,AUC_post_hm(:,:,2),jitter(4),line_color(3,:));
% set(gca,'XTick',tpos,'XTickLabel',{'early','','','late'});
% xlim([0.5 length(tpos)+0.5]);
% ylim(y_range);
% xlabel('Target Position'); ylabel('AUROC');
% box off;
% 
% % % plot anterior ROC in hit and miss trials
% subplot(2,2,4);
% % hit
% plot_ROC(tpos,AUC_ant_hm(:,:,1),jitter(1),line_color(2,:)); hold on;
% % miss
% plot_ROC(tpos,AUC_ant_hm(:,:,2),jitter(4),line_color(3,:));
% set(gca,'XTick',tpos,'XTickLabel',{'early','','','late'});
% xlim([0.5 length(tpos)+0.5]);
% ylim(y_range);
% xlabel('Target Position'); ylabel('AUROC');
% box off;
% legend({'Hit','Miss'});
