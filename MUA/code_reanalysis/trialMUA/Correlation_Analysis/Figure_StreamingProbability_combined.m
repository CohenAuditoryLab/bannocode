clear all

thFrom = 'allTriplet1'; % either '1stTriplet', 'Tm1Triplet', or 'allTriplet'
% DATA_DIR = fullfile('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\Streaming_Probability',strcat('threshold_',thFrom));
DATA_DIR = pwd;
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA');

% set parameters...
% tpos = [1 2 3 6 7];
tpos = [1 2 3 6]; % omit Target because it is louder...
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 4:8; % around target
% tpos = 1:8; % all
line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
              0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
jitter = [-0.09 -0.03 0.03 0.09];

% load Data
% load(fullfile(DATA_DIR,'StreamingProb_Both_lowBF.mat'));
load(fullfile(DATA_DIR,'StreamingProb_lowBF.mat'));

% reshape matrix (sample x tpos x stdiff)
p1srm_post = reshape(pStream.post.single_stream,[size(pStream.post.single_stream,1)*size(pStream.post.single_stream,2) size(pStream.post.single_stream,3) size(pStream.post.single_stream,4)]);
p1srm_ant  = reshape(pStream.ant.single_stream,[size(pStream.ant.single_stream,1)*size(pStream.ant.single_stream,2) size(pStream.ant.single_stream,3) size(pStream.ant.single_stream,4)]);
p2srm_post = reshape(pStream.post.dual_stream,[size(pStream.post.dual_stream,1)*size(pStream.post.dual_stream,2) size(pStream.post.dual_stream,3) size(pStream.post.dual_stream,4)]);
p2srm_ant  = reshape(pStream.ant.dual_stream,[size(pStream.ant.dual_stream,1)*size(pStream.ant.dual_stream,2) size(pStream.ant.dual_stream,3) size(pStream.ant.dual_stream,4)]);
% adjusted streaming probability
prob_post = p2srm_post ./ (p1srm_post + p2srm_post);
prob_ant = p2srm_ant ./ (p1srm_ant + p2srm_ant);
clear pStream

% hit trials
% load(fullfile(DATA_DIR,'StreamingProb_Both_lowBF_hit.mat'));
load(fullfile(DATA_DIR,'StreamingProb_lowBF_hit.mat'));
p1srm_post_h = reshape(pStream.post.single_stream,[size(pStream.post.single_stream,1)*size(pStream.post.single_stream,2) size(pStream.post.single_stream,3) size(pStream.post.single_stream,4)]);
p1srm_ant_h  = reshape(pStream.ant.single_stream,[size(pStream.ant.single_stream,1)*size(pStream.ant.single_stream,2) size(pStream.ant.single_stream,3) size(pStream.ant.single_stream,4)]);
p2srm_post_h = reshape(pStream.post.dual_stream,[size(pStream.post.dual_stream,1)*size(pStream.post.dual_stream,2) size(pStream.post.dual_stream,3) size(pStream.post.dual_stream,4)]);
p2srm_ant_h  = reshape(pStream.ant.dual_stream,[size(pStream.ant.dual_stream,1)*size(pStream.ant.dual_stream,2) size(pStream.ant.dual_stream,3) size(pStream.ant.dual_stream,4)]);
% adjusted streaming probability
prob_post_hit = p2srm_post_h ./ (p1srm_post_h + p2srm_post_h);
prob_ant_hit = p2srm_ant_h ./ (p1srm_ant_h + p2srm_ant_h);
clear pStream

% miss trials
% load(fullfile(DATA_DIR,'StreamingProb_Both_lowBF_miss.mat'));
load(fullfile(DATA_DIR,'StreamingProb_lowBF_miss.mat'));
p1srm_post_m = reshape(pStream.post.single_stream,[size(pStream.post.single_stream,1)*size(pStream.post.single_stream,2) size(pStream.post.single_stream,3) size(pStream.post.single_stream,4)]);
p1srm_ant_m  = reshape(pStream.ant.single_stream,[size(pStream.ant.single_stream,1)*size(pStream.ant.single_stream,2) size(pStream.ant.single_stream,3) size(pStream.ant.single_stream,4)]);
p2srm_post_m = reshape(pStream.post.dual_stream,[size(pStream.post.dual_stream,1)*size(pStream.post.dual_stream,2) size(pStream.post.dual_stream,3) size(pStream.post.dual_stream,4)]);
p2srm_ant_m  = reshape(pStream.ant.dual_stream,[size(pStream.ant.dual_stream,1)*size(pStream.ant.dual_stream,2) size(pStream.ant.dual_stream,3) size(pStream.ant.dual_stream,4)]);
% recalculate streaming probability
prob_post_miss = p2srm_post_m ./ (p1srm_post_m + p2srm_post_m);
prob_ant_miss = p2srm_ant_m ./ (p1srm_ant_m + p2srm_ant_m);
clear pStream

% % plot adjusted probability % % 
figure;
h(1) = subplot(2,2,1); hold on;
for ii=1:4
    plot_ROC(tpos,prob_post(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel({'Probability of'; '2 Streams Response'});
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');

h(2) = subplot(2,2,2); hold on;
for ii=1:4
    plot_ROC(tpos,prob_ant(:,:,ii),jitter(ii),line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel({'Probability of'; '2 Streams Response'});
box off;
title('Anterior');
legend({'Smallest dF','Small dF','Large dF','Largest dF'});
yrange(2,:) = get(gca,'YLim');


% hit and miss trials separated
h(3) = subplot(2,2,3); hold on;
for ii=1:4
    plot_ROC(tpos,prob_post_hit(:,:,ii),jitter(ii)-0.03,line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('Prob 2 Streams');
% box off;
% title('Posterior');
yrange(1,:) = get(gca,'YLim');

h(4) = subplot(2,2,4); hold on;
for ii=1:4
    plot_ROC(tpos,prob_ant_hit(:,:,ii),jitter(ii)-0.03,line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('Prob 2 Streams');
% box off;
% title('Anterior');
yrange(2,:) = get(gca,'YLim');

h(3) = subplot(2,2,3); hold on;
for ii=1:4
    hh(ii) = plot_ROC(tpos,prob_post_miss(:,:,ii),jitter(ii)+0.03,line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel({'Probability of'; '2 Streams Response'});
box off;
title('Posterior');
yrange(1,:) = get(gca,'YLim');
set(hh,'LineWidth',1,'LineStyle','--');

h(4) = subplot(2,2,4); hold on;
for ii=1:4
    hh(ii) = plot_ROC(tpos,prob_ant_miss(:,:,ii),jitter(ii)+0.03,line_color(ii,:));
end
xlim([0.5 length(tpos)+0.5]);
xlabel('Triplet Position'); ylabel({'Probability of'; '2 Streams Response'});
box off;
title('Anterior');
yrange(2,:) = get(gca,'YLim');
% legend({'Smallest dF','Small dF','Large dF','Largest dF'});
set(hh,'LineWidth',1,'LineStyle','--');



% equate y-axis
for ii=1:4
    set(h,'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
end