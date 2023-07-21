clear all

thFrom = 'allTriplet1'; % either '1stTriplet', 'Tm1Triplet', or 'allTriplet'
DATA_DIR = fullfile(pwd,strcat('threshold_',thFrom));
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% tpos = [1 2 3 6 7];
tpos = [1 2 3 6]; % omit Target because it is louder...
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 4:8; % around target
% tpos = 1:8; % all
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
              0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];

% load Data
load(fullfile(DATA_DIR,'StreamingProb_Both_lowBF.mat'));

% reshape matrix (sample x tpos x stdiff)
p1srm_post = reshape(pStream.post.single_stream,[size(pStream.post.single_stream,1)*size(pStream.post.single_stream,2) size(pStream.post.single_stream,3) size(pStream.post.single_stream,4)]);
p1srm_ant  = reshape(pStream.ant.single_stream,[size(pStream.ant.single_stream,1)*size(pStream.ant.single_stream,2) size(pStream.ant.single_stream,3) size(pStream.ant.single_stream,4)]);
p2srm_post = reshape(pStream.post.dual_stream,[size(pStream.post.dual_stream,1)*size(pStream.post.dual_stream,2) size(pStream.post.dual_stream,3) size(pStream.post.dual_stream,4)]);
p2srm_ant  = reshape(pStream.ant.dual_stream,[size(pStream.ant.dual_stream,1)*size(pStream.ant.dual_stream,2) size(pStream.ant.dual_stream,3) size(pStream.ant.dual_stream,4)]);
% % hit/miss with intermediate dF trials
% AUC_post_hm = reshape(AUC.post.hitmiss,[size(AUC.post.hitmiss,1)*size(AUC.post.hitmiss,2) size(AUC.post.hitmiss,3) size(AUC.post.hitmiss,4)]);
% AUC_ant_hm  = reshape(AUC.ant.hitmiss,[size(AUC.ant.hitmiss,1)*size(AUC.ant.hitmiss,2) size(AUC.ant.hitmiss,3) size(AUC.ant.hitmiss,4)]);
% % hit/miss intermediate dF trials are REMOVED
% AUC_post_hm2 = reshape(AUC.post.hitmiss2,[size(AUC.post.hitmiss2,1)*size(AUC.post.hitmiss2,2) size(AUC.post.hitmiss2,3) size(AUC.post.hitmiss2,4)]);
% AUC_ant_hm2  = reshape(AUC.ant.hitmiss2,[size(AUC.ant.hitmiss2,1)*size(AUC.ant.hitmiss2,2) size(AUC.ant.hitmiss2,3) size(AUC.ant.hitmiss2,4)]);

prob_post = p2srm_post ./ (p1srm_post + p2srm_post);
prob_ant = p2srm_ant ./ (p1srm_ant + p2srm_ant);

% plot
figure;
jitter = [-0.06 -0.02 0.02 0.06];
h(1) = subplot(2,2,1); hold on;
for ii=1:4
    plot_ROC(tpos,p1srm_post(:,:,ii),jitter(ii),line_color(ii,:));
%     plot_ROC(tpos,prob_post(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 1 Stream');
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');

h(2) = subplot(2,2,2); hold on;
for ii=1:4
    plot_ROC(tpos,p1srm_ant(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 1 Stream');
box off;
title('Anterior');
legend({'Smallest dF','Small dF','Large dF','Largest dF'});
yrange(2,:) = get(gca,'YLim');

h(3) = subplot(2,2,3); hold on;
for ii=1:4
    plot_ROC(tpos,p2srm_post(:,:,ii),jitter(ii),line_color(ii,:));
%     plot_ROC(tpos,prob_post(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');

h(4) = subplot(2,2,4); hold on;
for ii=1:4
    plot_ROC(tpos,p2srm_ant(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Anterior');
legend({'Smallest dF','Small dF','Large dF','Largest dF'});
yrange(2,:) = get(gca,'YLim');

% % plot adjusted probability % % 
figure;
h(1) = subplot(2,2,1); hold on;
for ii=1:4
    plot_ROC(tpos,prob_post(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');

h(2) = subplot(2,2,2); hold on;
for ii=1:4
    plot_ROC(tpos,prob_ant(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Anterior');
legend({'Smallest dF','Small dF','Large dF','Largest dF'});
yrange(2,:) = get(gca,'YLim');


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