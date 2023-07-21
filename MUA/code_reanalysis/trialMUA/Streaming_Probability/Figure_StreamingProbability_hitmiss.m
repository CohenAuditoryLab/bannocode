clear all

thFrom = 'Tm1Triplet'; % either '1stTriplet', 'Tm1Triplet', or 'allTriplet'
DATA_DIR = fullfile(pwd,strcat('threshold_',thFrom));
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA');

% set parameters...
tpos = [1 2 3 6]; % omit Target because it is louder...
% tpos = [1 2 3 6 7]; % standard
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 4:8; % around target
% tpos = 1:8; % all
line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
              0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];

% load Data (hit trials)
load(fullfile(DATA_DIR,'StreamingProb_Both_lowBF_hit.mat'));
% reshape matrix (sample x tpos x stdiff)
p1srm_post_h = reshape(pStream.post.single_stream,[size(pStream.post.single_stream,1)*size(pStream.post.single_stream,2) size(pStream.post.single_stream,3) size(pStream.post.single_stream,4)]);
p1srm_ant_h  = reshape(pStream.ant.single_stream,[size(pStream.ant.single_stream,1)*size(pStream.ant.single_stream,2) size(pStream.ant.single_stream,3) size(pStream.ant.single_stream,4)]);
p2srm_post_h = reshape(pStream.post.dual_stream,[size(pStream.post.dual_stream,1)*size(pStream.post.dual_stream,2) size(pStream.post.dual_stream,3) size(pStream.post.dual_stream,4)]);
p2srm_ant_h  = reshape(pStream.ant.dual_stream,[size(pStream.ant.dual_stream,1)*size(pStream.ant.dual_stream,2) size(pStream.ant.dual_stream,3) size(pStream.ant.dual_stream,4)]);
% recalculate streaming probability
prob_post_hit = p2srm_post_h ./ (p1srm_post_h + p2srm_post_h);
prob_ant_hit = p2srm_ant_h ./ (p1srm_ant_h + p2srm_ant_h);
clear pStream

% load Data (miss trials)
load(fullfile(DATA_DIR,'StreamingProb_Both_lowBF_miss.mat'));
% reshape matrix (sample x tpos x stdiff)
p1srm_post_m = reshape(pStream.post.single_stream,[size(pStream.post.single_stream,1)*size(pStream.post.single_stream,2) size(pStream.post.single_stream,3) size(pStream.post.single_stream,4)]);
p1srm_ant_m  = reshape(pStream.ant.single_stream,[size(pStream.ant.single_stream,1)*size(pStream.ant.single_stream,2) size(pStream.ant.single_stream,3) size(pStream.ant.single_stream,4)]);
p2srm_post_m = reshape(pStream.post.dual_stream,[size(pStream.post.dual_stream,1)*size(pStream.post.dual_stream,2) size(pStream.post.dual_stream,3) size(pStream.post.dual_stream,4)]);
p2srm_ant_m  = reshape(pStream.ant.dual_stream,[size(pStream.ant.dual_stream,1)*size(pStream.ant.dual_stream,2) size(pStream.ant.dual_stream,3) size(pStream.ant.dual_stream,4)]);
% recalculate streaming probability
prob_post_miss = p2srm_post_m ./ (p1srm_post_m + p2srm_post_m);
prob_ant_miss = p2srm_ant_m ./ (p1srm_ant_m + p2srm_ant_m);
clear pStream

% plot Figure(1) hit trials
figure;
jitter = [-0.06 -0.02 0.02 0.06];
h(1) = subplot(2,2,1); hold on;
for ii=1:4
    plot_ROC(tpos,p1srm_post_h(:,:,ii),jitter(ii),line_color(ii,:));
%     plot_ROC(tpos,prob_post(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 1 Stream');
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');
legend({'Smallest dF','Small dF','Large dF','Largest dF'});

h(2) = subplot(2,2,2); hold on;
for ii=1:4
    plot_ROC(tpos,p1srm_ant_h(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 1 Stream');
box off;
title('Anterior');
yrange(2,:) = get(gca,'YLim');

h(3) = subplot(2,2,3); hold on;
for ii=1:4
    plot_ROC(tpos,p2srm_post_h(:,:,ii),jitter(ii),line_color(ii,:));
%     plot_ROC(tpos,prob_post(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');

h(4) = subplot(2,2,4); hold on;
for ii=1:4
    plot_ROC(tpos,p2srm_ant_h(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Anterior');
yrange(2,:) = get(gca,'YLim');

% Plot Figure(2) miss trials
figure; 
jitter = [-0.06 -0.02 0.02 0.06];
h(1) = subplot(2,2,1); hold on;
for ii=1:4
    plot_ROC(tpos,p1srm_post_m(:,:,ii),jitter(ii),line_color(ii,:));
%     plot_ROC(tpos,prob_post(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 1 Stream');
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');
legend({'Smallest dF','Small dF','Large dF','Largest dF'});

h(2) = subplot(2,2,2); hold on;
for ii=1:4
    plot_ROC(tpos,p1srm_ant_m(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 1 Stream');
box off;
title('Anterior');
yrange(2,:) = get(gca,'YLim');

h(3) = subplot(2,2,3); hold on;
for ii=1:4
    plot_ROC(tpos,p2srm_post_m(:,:,ii),jitter(ii),line_color(ii,:));
%     plot_ROC(tpos,prob_post(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');

h(4) = subplot(2,2,4); hold on;
for ii=1:4
    plot_ROC(tpos,p2srm_ant_m(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Anterior');
yrange(2,:) = get(gca,'YLim');


% % adjusted probability % %
% plot Figure(3) hit and miss trials
figure;
h(1) = subplot(2,2,1); hold on;
for ii=1:4
    plot_ROC(tpos,prob_post_hit(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Posterior (Hit)');
yrange(1,:) = get(gca,'YLim');

h(2) = subplot(2,2,2); hold on;
for ii=1:4
    plot_ROC(tpos,prob_ant_hit(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Anterior (Hit)');
yrange(2,:) = get(gca,'YLim');
% legend({'Smallest dF','Small dF','Large dF','Largest dF'});

h(3) = subplot(2,2,3); hold on;
for ii=1:4
    plot_ROC(tpos,prob_post_miss(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Posterior (Miss)');
yrange(1,:) = get(gca,'YLim');

h(4) = subplot(2,2,4); hold on;
for ii=1:4
    plot_ROC(tpos,prob_ant_miss(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Anterior (Miss)');
yrange(2,:) = get(gca,'YLim');
% legend({'Smallest dF','Small dF','Large dF','Largest dF'});

% % adjusted probability % % 
% plot Figure(4) hit and miss trials
figure;
h(1) = subplot(2,2,1); hold on;
for ii=1:4
    plot_ROC(tpos,prob_post_hit(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');

h(2) = subplot(2,2,2); hold on;
for ii=1:4
    plot_ROC(tpos,prob_ant_hit(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Anterior');
yrange(2,:) = get(gca,'YLim');
% legend({'Smallest dF','Small dF','Large dF','Largest dF'});

h(3) = subplot(2,2,1); hold on;
for ii=1:4
    hh(ii) = plot_ROC(tpos,prob_post_miss(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');
set(hh,'LineWidth',1,'LineStyle','--');

h(4) = subplot(2,2,2); hold on;
for ii=1:4
    hh(ii) = plot_ROC(tpos,prob_ant_miss(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel('Prob 2 Streams');
box off;
title('Anterior');
yrange(2,:) = get(gca,'YLim');
% legend({'Smallest dF','Small dF','Large dF','Largest dF'});
set(hh,'LineWidth',1,'LineStyle','--');

