clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AvsB1_ttime';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
tpos = 1:4;
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 4:8; % around target
% tpos = 1:8; % all
% line_color_area = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [229 0 125; 78 186 25] / 255;
line_color_area = [153 0 255; 0 204 0] / 255;

% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
              0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];

% load Data
load(fullfile(DATA_DIR,'ROC_Both_ttime.mat'));

% reshape matrix (sample x tpos x stdiff)
AUC_post_tt = reshape(AUC.post.ttime,[size(AUC.post.ttime,1)*size(AUC.post.ttime,2) size(AUC.post.ttime,3)]);
AUC_ant_tt  = reshape(AUC.ant.ttime,[size(AUC.ant.ttime,1)*size(AUC.ant.ttime,2) size(AUC.ant.ttime,3)]);
% hit/miss with intermediate dF trials
AUC_post_hm = reshape(AUC.post.hitmiss,[size(AUC.post.hitmiss,1)*size(AUC.post.hitmiss,2) size(AUC.post.hitmiss,3) size(AUC.post.hitmiss,4)]);
AUC_ant_hm  = reshape(AUC.ant.hitmiss,[size(AUC.ant.hitmiss,1)*size(AUC.ant.hitmiss,2) size(AUC.ant.hitmiss,3) size(AUC.ant.hitmiss,4)]);
% hit/miss intermediate dF trials are REMOVED
AUC_post_hm2 = reshape(AUC.post.hitmiss2,[size(AUC.post.hitmiss2,1)*size(AUC.post.hitmiss2,2) size(AUC.post.hitmiss2,3) size(AUC.post.hitmiss2,4)]);
AUC_ant_hm2  = reshape(AUC.ant.hitmiss2,[size(AUC.ant.hitmiss2,1)*size(AUC.ant.hitmiss2,2) size(AUC.ant.hitmiss2,3) size(AUC.ant.hitmiss2,4)]);

% plot
figure;
jitter = [-0.06 -0.02 0.02 0.06];
y_range = [0.4925 0.7000]; % set y-axis 
% plot ROC posterior vs anterior
subplot(2,2,1); hold on;
% posterior
plot_ROC(tpos,AUC_post_tt,jitter(1),line_color_area(1,:));
% anterior
plot_ROC(tpos,AUC_ant_tt, jitter(4),line_color_area(2,:));
set(gca,'XTick',tpos,'XTickLabel',{'early','','','late'});
xlim([tpos(1)-0.5 tpos(end)+0.5]);
ylim(y_range);
xlabel('Target Position'); ylabel('AUROC');
legend({'Posterior','Anterior'});

% % plot posterior ROC in hit and miss trials
subplot(2,2,3);
% hit
plot_ROC(tpos,AUC_post_hm(:,:,1),jitter(1),line_color(2,:)); hold on;
% miss
plot_ROC(tpos,AUC_post_hm(:,:,2),jitter(4),line_color(3,:));
set(gca,'XTick',tpos,'XTickLabel',{'early','','','late'});
xlim([0.5 length(tpos)+0.5]);
ylim(y_range);
xlabel('Target Position'); ylabel('AUROC');
box off;

% % plot anterior ROC in hit and miss trials
subplot(2,2,4);
% hit
plot_ROC(tpos,AUC_ant_hm(:,:,1),jitter(1),line_color(2,:)); hold on;
% miss
plot_ROC(tpos,AUC_ant_hm(:,:,2),jitter(4),line_color(3,:));
set(gca,'XTick',tpos,'XTickLabel',{'early','','','late'});
xlim([0.5 length(tpos)+0.5]);
ylim(y_range);
xlabel('Target Position'); ylabel('AUROC');
box off;
legend({'Hit','Miss'});
