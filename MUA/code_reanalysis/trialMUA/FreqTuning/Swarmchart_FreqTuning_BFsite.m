% 3/31/23 replot index ONLY from BF sites

clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\FreqTuning';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA');

% set parameters...
tpos = [1 6]; % 1st and T-1 triplet position
trial_type = 'combined'; % either 'combined', 'hit', or 'miss'
line_color = [153 0 255; 0 204 0] / 255; % purple/green
% line_color = [1, 0, 0; 0, 0.75, 0.75]; % red/cyan
% line_color = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980]; % blue/red

% % % BF site % % %
% load Data
load(fullfile(DATA_DIR,'ver2','FreqTuning2_Both_lowBF.mat'));

% SELECTIVITY INDEX
% reshape matrix (sample x tpos x stdiff)
if strcmp(trial_type,'combined')
    % all trials
    IDX_post_low = reshape(SelectIndex.post.all,[size(SelectIndex.post.all,1)*size(SelectIndex.post.all,2) size(SelectIndex.post.all,3)]);
    IDX_ant_low  = reshape(SelectIndex.ant.all,[size(SelectIndex.ant.all,1)*size(SelectIndex.ant.all,2) size(SelectIndex.ant.all,3)]);
elseif strcmp(trial_type,'hit')
    % hit
    IDX_post_low = reshape(SelectIndex.post.hit,[size(SelectIndex.post.hit,1)*size(SelectIndex.post.hit,2) size(SelectIndex.post.hit,3)]);
    IDX_ant_low  = reshape(SelectIndex.ant.hit,[size(SelectIndex.ant.hit,1)*size(SelectIndex.ant.hit,2) size(SelectIndex.ant.hit,3)]);
elseif strcmp(trial_type,'miss')
    % miss
    IDX_post_low = reshape(SelectIndex.post.miss,[size(SelectIndex.post.miss,1)*size(SelectIndex.post.miss,2) size(SelectIndex.post.miss,3)]);
    IDX_ant_low  = reshape(SelectIndex.ant.miss,[size(SelectIndex.ant.miss,1)*size(SelectIndex.ant.miss,2) size(SelectIndex.ant.miss,3)]);
end
% % SPARSENESS INDEX
% IDX_post_df = reshape(SparseIndex.post.all,[size(SparseIndex.post.all,1)*size(SparseIndex.post.all,2) size(SparseIndex.post.all,3)]);
% IDX_ant_df  = reshape(SparseIndex.ant.all,[size(SparseIndex.ant.all,1)*size(SparseIndex.ant.all,2) size(SparseIndex.ant.all,3)]);

% select triplet position
% selectivity index was originally calculated by (L-H) / (L+H)
% multiplied by -1 to make it (H-L) / (H+L) for non-BF site
IDX_post_low = IDX_post_low(:,tpos);
IDX_ant_low = IDX_ant_low(:,tpos);
x_label = sTriplet(tpos);
% IDX_post_high = -1 * IDX_post_high(:,tpos);
% IDX_ant_high = -1 * IDX_ant_high(:,tpos);


% mean
mIDX_BF = [nanmean(IDX_post_low,1); nanmean(IDX_ant_low,1)]; % combine BF site
% median
mdIDX_BF = [nanmedian(IDX_post_low,1); nanmedian(IDX_ant_low,1)];
% standard error
n_BF = [sum(~isnan(IDX_post_low),1); sum(~isnan(IDX_ant_low),1)];
s_BF = [nanstd(IDX_post_low,[],1); nanstd(IDX_ant_low,[],1)]; % standard deviation
e_BF = s_BF ./ sqrt(n_BF);

% transpose matrix for bargraph
mIDX_BF = mIDX_BF'; % mIDX_ant = mIDX_ant';
mdIDX_BF = mdIDX_BF'; % mdIDX_ant = mdIDX_ant';
s_BF = s_BF'; % s_ant = s_ant';
e_BF = e_BF'; % e_ant = e_ant';

% bar graph...
figure('Position',[610,400,790,270]);
subplot(1,2,1);
bar(mIDX_BF,'grouped'); 
hold on
% errorbar(mIDX_post,e_post);
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(mIDX_BF);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, mIDX_BF(:,i), e_BF(:,i), 'k', 'linestyle', 'none');
%     errorbar(x, mIDX_post(:,i), e_post(:,i), 'k','LineStyle',':');
    X(i,:) = x;
end
% plot individual data...
% plot(X(1,:),IDX_post_low,'ko');
% plot(X(2,:),IDX_post_high,'ko');
hold off
set(gca,'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('Selectivity Index');
title('BF sites');


% % % VIOLIN PLOT % % %
figure('Position',[660,450,790,270]);
N_BF = [size(IDX_post_low,1) size(IDX_ant_low,1)];
xx_BF = [X(1)*ones(N_BF(1),1); X(2)*ones(N_BF(2),1); X(3)*ones(N_BF(1),1); X(4)*ones(N_BF(2),1);];
yy_BF = [IDX_post_low(:,1); IDX_ant_low(:,1); IDX_post_low(:,2); IDX_ant_low(:,2)];
% yy_BF = [IDX_post_low(:,1); IDX_post_high(:,1); IDX_post_low(:,2); IDX_post_high(:,2)];
subplot(1,2,1);
swarmchart(xx_BF,yy_BF,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3); hold on
% add median
h_post(1) = plot(X([1 3]),mdIDX_BF(:,1),':+'); % post
h_ant(1)  = plot(X([2 4]),mdIDX_BF(:,2),':+'); % ant
set(gca,'XTick',[1 2],'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('Selectivity Index');
title('BF site');


% change line setting
% set(h_bf,'Color',[0, 0.4470, 0.7410],'MarkerSize',10,'LineWidth',2);
% set(h_nbf,'Color',[0.8500, 0.3250, 0.0980],'MarkerSize',10,'LineWidth',2);
set(h_post,'Color',line_color(1,:),'MarkerSize',12,'LineWidth',2);
set(h_ant,'Color',line_color(2,:),'MarkerSize',12,'LineWidth',2);
% add legend
legend({'','Posterior','Anterior'});


% % % STATISTICAL COMPARISON % % %
% SRH test
[pSRH_BF,tbl_BF,m_BF] = stats_Index_SRHtest(IDX_post_low,IDX_ant_low);
% [pSRH_post,tbl_post,m_post] = stats_Index_SRHtest(IDX_post_low,IDX_post_high);
% [pSRH_ant,tbl_ant,m_ant] = stats_Index_SRHtest(IDX_ant_low,IDX_ant_high);

% Wilcoxon signed-rank test
% examine whether the index is significantly different from zero
for i=1:2
    pWC_post(1,i) = signrank(IDX_post_low(:,i),0);
    pWC_ant(1,i) = signrank(IDX_ant_low(:,i),0);
%     pWC_post(2,i) = signrank(IDX_post_high(:,i),0);
%     pWC_ant(2,i) = signrank(IDX_ant_high(:,i),0);
end
pWC_post = pWC_post(:);
pWC_ant  = pWC_ant(:);

% post-hoc comparisons were performed in the following order...
p_BF(1,:) = signrank(IDX_post_low(:,1),IDX_post_low(:,2));
p_BF(2,:) = signrank(IDX_ant_low(:,1),IDX_ant_low(:,2));
p_BF(3,:) = ranksum(IDX_post_low(:,1),IDX_ant_low(:,1));
p_BF(4,:) = ranksum(IDX_post_low(:,2),IDX_ant_low(:,2));
p_BF(5,:) = ranksum(IDX_post_low(:,1),IDX_ant_low(:,2));
p_BF(6,:) = ranksum(IDX_post_low(:,2),IDX_ant_low(:,1));
% % 
% % p_ant(1,:) = signrank(IDX_ant_low(:,1),IDX_ant_low(:,2));
% % p_ant(2,:) = signrank(IDX_ant_high(:,1),IDX_ant_high(:,2));
% % p_ant(3,:) = ranksum(IDX_ant_low(:,1),IDX_ant_high(:,1));
% % p_ant(4,:) = ranksum(IDX_ant_low(:,2),IDX_ant_high(:,2));
% % p_ant(5,:) = ranksum(IDX_ant_low(:,1),IDX_ant_high(:,2));
% % p_ant(6,:) = ranksum(IDX_ant_low(:,2),IDX_ant_high(:,1));