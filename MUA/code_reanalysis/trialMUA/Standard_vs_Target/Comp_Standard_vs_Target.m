clear all

% % DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\FreqTuning';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA');

% set parameters...
% tpos = [1 6]; % 1st and T-1 triplet position
tpos = [6 7]; % T-1 and T triplet position
trial_type = 'combined'; % either 'combined', 'hit', or 'miss'
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
% line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];

% % % BF site % % %
% load Data
% load(fullfile(DATA_DIR,'ver2','FreqTuning2_Both_lowBF.mat'));
load RespA_Both_lowBF.mat

% reshape matrix (sample x tpos x stdiff)
% % SPARSENESS INDEX
% R_post_df = reshape(SparseIndex.post.all,[size(SparseIndex.post.all,1)*size(SparseIndex.post.all,2) size(SparseIndex.post.all,3)]);
% R_ant_df  = reshape(SparseIndex.ant.all,[size(SparseIndex.ant.all,1)*size(SparseIndex.ant.all,2) size(SparseIndex.ant.all,3)]);
% SELECTIVITY INDEX
if strcmp(trial_type,'combined')
    % all trials
    R_post_low = reshape(mResp_A.post.all,[size(mResp_A.post.all,1)*size(mResp_A.post.all,2) size(mResp_A.post.all,3)]);
    R_ant_low  = reshape(mResp_A.ant.all,[size(mResp_A.ant.all,1)*size(mResp_A.ant.all,2) size(mResp_A.ant.all,3)]);
elseif strcmp(trial_type,'hit')
    % hit
    R_post_low = reshape(mResp_A.post.hit,[size(mResp_A.post.hit,1)*size(mResp_A.post.hit,2) size(mResp_A.post.hit,3)]);
    R_ant_low  = reshape(mResp_A.ant.hit,[size(mResp_A.ant.hit,1)*size(mResp_A.ant.hit,2) size(mResp_A.ant.hit,3)]);
elseif strcmp(trial_type,'miss')
    % miss
    R_post_low = reshape(mResp_A.post.miss,[size(mResp_A.post.miss,1)*size(mResp_A.post.miss,2) size(mResp_A.post.miss,3)]);
    R_ant_low  = reshape(mResp_A.ant.miss,[size(mResp_A.ant.miss,1)*size(mResp_A.ant.miss,2) size(mResp_A.ant.miss,3)]);
end
IDX_post_low = calc_index(R_post_low);
IDX_ant_low  = calc_index(R_ant_low);

% % % non-BF site % % %
% load Data
% load(fullfile(DATA_DIR,'ver2','FreqTuning2_Both_highBF.mat'));
load RespA_Both_highBF.mat

% reshape matrix (sample x tpos x stdiff)
% % SPARSENESS INDEX
% R_post_df = reshape(SparseIndex.post.all,[size(SparseIndex.post.all,1)*size(SparseIndex.post.all,2) size(SparseIndex.post.all,3)]);
% R_ant_df  = reshape(SparseIndex.ant.all,[size(SparseIndex.ant.all,1)*size(SparseIndex.ant.all,2) size(SparseIndex.ant.all,3)]);
% SELECTIVITY INDEX
if strcmp(trial_type,'combined')
    % all trials
    R_post_high = reshape(mResp_A.post.all,[size(mResp_A.post.all,1)*size(mResp_A.post.all,2) size(mResp_A.post.all,3)]);
    R_ant_high  = reshape(mResp_A.ant.all,[size(mResp_A.ant.all,1)*size(mResp_A.ant.all,2) size(mResp_A.ant.all,3)]);
elseif strcmp(trial_type,'hit')
    % hit
    R_post_high = reshape(mResp_A.post.hit,[size(mResp_A.post.hit,1)*size(mResp_A.post.hit,2) size(mResp_A.post.hit,3)]);
    R_ant_high  = reshape(mResp_A.ant.hit,[size(mResp_A.ant.hit,1)*size(mResp_A.ant.hit,2) size(mResp_A.ant.hit,3)]);
elseif strcmp(trial_type,'miss')
    % miss
    R_post_high = reshape(mResp_A.post.miss,[size(mResp_A.post.miss,1)*size(mResp_A.post.miss,2) size(mResp_A.post.miss,3)]);
    R_ant_high  = reshape(mResp_A.ant.miss,[size(mResp_A.ant.miss,1)*size(mResp_A.ant.miss,2) size(mResp_A.ant.miss,3)]);
end
IDX_post_high = calc_index(R_post_high);
IDX_ant_high  = calc_index(R_ant_high);

% select triplet position
% selectivity index was originally calculated by (L-H) / (L+H)
R_post_low = R_post_low(:,tpos);
R_ant_low = R_ant_low(:,tpos);
R_post_high = R_post_high(:,tpos);
R_ant_high = R_ant_high(:,tpos);
x_label = sTriplet(tpos);

% mean
mR_post = [nanmean(R_post_low,1); nanmean(R_post_high,1)];
mR_ant = [nanmean(R_ant_low,1); nanmean(R_ant_high,1)];

% median
mdR_post = [nanmedian(R_post_low,1); nanmedian(R_post_high,1)];
mdR_ant = [nanmedian(R_ant_low,1); nanmedian(R_ant_high,1)];

% standard error
n_post = [sum(~isnan(R_post_low),1); sum(~isnan(R_post_high),1)];
n_ant  = [sum(~isnan(R_ant_low)); sum(~isnan(R_ant_high),1)];
s_post = [nanstd(R_post_low,[],1); nanstd(R_post_high,[],1)]; % standard deviation
s_ant  = [nanstd(R_ant_low,[],1); nanstd(R_ant_high,[],1)];
e_post = s_post ./ sqrt(n_post);
e_ant  = s_ant ./ sqrt(n_ant);

% transpose matrix for bargraph
mR_post = mR_post'; mR_ant = mR_ant';
mdR_post = mdR_post'; mdR_ant = mdR_ant';
s_post = s_post'; s_ant = s_ant';
e_post = e_post'; e_ant = e_ant';

% bar graph...
figure('Position',[610,400,790,270]);
subplot(1,2,1);
bar(mR_post,'grouped'); 
hold on
% errorbar(mR_post,e_post);
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(mR_post);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, mR_post(:,i), e_post(:,i), 'k', 'linestyle', 'none');
%     errorbar(x, mR_post(:,i), e_post(:,i), 'k','LineStyle',':');
    X(i,:) = x;
end
% plot individual data...
% plot(X(1,:),R_post_low,'ko');
% plot(X(2,:),R_post_high,'ko');
hold off
set(gca,'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('zMUA response');
title('Posterior');

subplot(1,2,2);
bar(mR_ant,'grouped');
hold on
% errorbar(mR_post,e_post);
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(mR_ant);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, mR_ant(:,i), e_ant(:,i), 'k', 'linestyle', 'none');
%     errorbar(x, mR_ant(:,i), e_ant(:,i), 'k','LineStyle',':');
end
% plot individual data...
% plot(X(1,:),R_ant_low,'ko');
% plot(X(2,:),R_ant_high,'ko');
hold off
set(gca,'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('zMUA response');
title('Anterior');
legend({'BF site','non-BF site'});

% % % VIOLIN PLOT % % %
figure('Position',[660,450,790,270]);
N_post = [size(R_post_low,1) size(R_post_high,1)];
xx_post = [X(1)*ones(N_post(1),1); X(2)*ones(N_post(2),1); X(3)*ones(N_post(1),1); X(4)*ones(N_post(2),1);];
yy_post = [R_post_low(:,1); R_post_high(:,1); R_post_low(:,2); R_post_high(:,2)];
subplot(1,2,1);
swarmchart(xx_post,yy_post,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3); hold on
% add median
% plot(X,mdR_post','+');
% plot(X,mR_post','+');
h_bf(1)  = plot(X([1 3]),mdR_post(:,1),':+');
h_nbf(1) = plot(X([2 4]),mdR_post(:,2),':+');
% h_bf(1)  = plot(X([1 3]),mR_post(:,1),':+'); % plot mean
% h_nbf(1) = plot(X([2 4]),mR_post(:,2),':+');
% plot(X([1 3]),mR_post(:,1),'x','MarkerSize',10); % plot mean
% plot(X([2 4]),mR_post(:,2),'x','MarkerSize',10);
set(gca,'XTick',[1 2],'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('zMUA Response');
title('Posterior');

N_ant = [size(R_ant_low,1) size(R_ant_high,1)];
xx_ant = [X(1)*ones(N_ant(1),1); X(2)*ones(N_ant(2),1); X(3)*ones(N_ant(1),1); X(4)*ones(N_ant(2),1);];
yy_ant = [R_ant_low(:,1); R_ant_high(:,1); R_ant_low(:,2); R_ant_high(:,2)];
subplot(1,2,2);
swarmchart(xx_ant,yy_ant,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3); hold on
% add median
% plot(X,mdR_ant','+');
% plot(X,mR_ant','+');
h_bf(2)  = plot(X([1 3]),mdR_ant(:,1),':+');
h_nbf(2) = plot(X([2 4]),mdR_ant(:,2),':+');
% h_bf(2)  = plot(X([1 3]),mR_ant(:,1),'+'); % mean
% h_nbf(2) = plot(X([2 4]),mR_ant(:,2),'+');
% plot(X([1 3]),mR_ant(:,1),'x','MarkerSize',10); % mean
% plot(X([2 4]),mR_ant(:,2),'x','MarkerSize',10);
set(gca,'XTick',[1 2],'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('zMUA Response');
title('Anterior');

% change line setting
% set(h_bf,'Color',[0, 0.4470, 0.7410],'MarkerSize',10,'LineWidth',2);
% set(h_nbf,'Color',[0.8500, 0.3250, 0.0980],'MarkerSize',10,'LineWidth',2);
set(h_bf,'Color',[1, 0, 0],'MarkerSize',12,'LineWidth',2);
set(h_nbf,'Color',[0, 0.75, 0.75],'MarkerSize',12,'LineWidth',2);
% add legend
legend({'','BF site','non-BF site'});

% % % plot index % % %
XX = [1 2];
xx_label = {'BF sites','non-BF sites'};
figure('Position',[660,450,790,270]);
N_post = [size(IDX_post_low,1) size(IDX_post_high,1)];
xx_post = [XX(1)*ones(N_post(1),1); XX(2)*ones(N_post(2),1)];
yy_post = [IDX_post_low(:); IDX_post_high(:)];
subplot(1,2,1);
swarmchart(xx_post,yy_post,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3); hold on
hh_bf(1)  = plot(1,nanmedian(IDX_post_low),'+');
hh_nbf(1) = plot(2,nanmedian(IDX_post_high),'+');
set(gca,'XTick',[1 2],'XTickLabel',xx_label);
xlabel('Triplet Position'); ylabel('zMUA Response');
title('Posterior');

N_ant = [size(IDX_ant_low,1) size(IDX_ant_high,1)];
xx_ant = [XX(1)*ones(N_ant(1),1); XX(2)*ones(N_ant(2),1)];
yy_ant = [IDX_ant_low(:); IDX_ant_high(:)];
subplot(1,2,2);
swarmchart(xx_ant,yy_ant,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3); hold on
hh_bf(2)  = plot(1,nanmedian(IDX_ant_low),'+');
hh_nbf(2) = plot(2,nanmedian(IDX_ant_high),'+');
set(gca,'XTick',[1 2],'XTickLabel',xx_label);
xlabel('Triplet Position'); ylabel('zMUA Response');
title('Anterior');

set(hh_bf,'Color',[1, 0, 0],'MarkerSize',12,'LineWidth',2);
set(hh_nbf,'Color',[0, 0.75, 0.75],'MarkerSize',12,'LineWidth',2);

% % % % STATISTICAL COMPARISON % % %
% % evaluate whether the index is different from zero
% % posterior
% p_post(1,:) = signrank(R_post_low(:,1),0);
% p_post(2,:) = signrank(R_post_high(:,1),0);
% p_post(3,:) = signrank(R_post_low(:,2),0);
% p_post(4,:) = signrank(R_post_high(:,2),0);
% % anterior
% p_ant(1,:) = signrank(R_ant_low(:,1),0);
% p_ant(2,:) = signrank(R_ant_high(:,1),0);
% p_ant(3,:) = signrank(R_ant_low(:,2),0);
% p_ant(4,:) = signrank(R_ant_high(:,2),0);
% 
% % SRH test
% [pSRH_post,tbl_post,m_post] = stats_Index_SRHtest(R_post_low,R_post_high);
% [pSRH_ant,tbl_ant,m_ant] = stats_Index_SRHtest(R_ant_low,R_ant_high);
% 
% % examine whether the index is significantly different from zero
% for i=1:2
%     pWC_post(1,i) = signrank(R_post_low(:,i),0);
%     pWC_post(2,i) = signrank(R_post_high(:,i),0);
%     pWC_ant(1,i) = signrank(R_ant_low(:,i),0);
%     pWC_ant(2,i) = signrank(R_ant_high(:,i),0);
% end
% pWC_post = pWC_post(:);
% pWC_ant  = pWC_ant(:);
% 
% % post-hoc comparisons were performed in the following order...
% % p_post(1,:) = signrank(R_post_low(:,1),R_post_low(:,2));
% % p_post(2,:) = signrank(R_post_high(:,1),R_post_high(:,2));
% % p_post(3,:) = ranksum(R_post_low(:,1),R_post_high(:,1));
% % p_post(4,:) = ranksum(R_post_low(:,2),R_post_high(:,2));
% % p_post(5,:) = ranksum(R_post_low(:,1),R_post_high(:,2));
% % p_post(6,:) = ranksum(R_post_low(:,2),R_post_high(:,1));
% % 
% % p_ant(1,:) = signrank(R_ant_low(:,1),R_ant_low(:,2));
% % p_ant(2,:) = signrank(R_ant_high(:,1),R_ant_high(:,2));
% % p_ant(3,:) = ranksum(R_ant_low(:,1),R_ant_high(:,1));
% % p_ant(4,:) = ranksum(R_ant_low(:,2),R_ant_high(:,2));
% % p_ant(5,:) = ranksum(R_ant_low(:,1),R_ant_high(:,2));
% % p_ant(6,:) = ranksum(R_ant_low(:,2),R_ant_high(:,1));