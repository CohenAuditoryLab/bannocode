% 3/31/23 replot index ONLY from BF sites

clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\FreqTuning';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA');

% set parameters...
tpos = [1 6]; % 1st and T-1 triplet position
trial_type = 'combined'; % either 'combined', 'hit', or 'miss'
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
% line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];

% % % BF site % % %
% load Data
load(fullfile(DATA_DIR,'ver2','FreqTuning2_Both_lowBF.mat'));

% reshape matrix (sample x tpos x stdiff)
% % SPARSENESS INDEX
% IDX_post_df = reshape(SparseIndex.post.all,[size(SparseIndex.post.all,1)*size(SparseIndex.post.all,2) size(SparseIndex.post.all,3)]);
% IDX_ant_df  = reshape(SparseIndex.ant.all,[size(SparseIndex.ant.all,1)*size(SparseIndex.ant.all,2) size(SparseIndex.ant.all,3)]);
% SELECTIVITY INDEX
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

% % % non-BF site % % %
% load Data
% L tone response are from all trials in 'ver1'
% L tone response are from the largest dF trial in 'ver2'
load(fullfile(DATA_DIR,'ver2','FreqTuning2_Both_highBF.mat'));

% reshape matrix (sample x tpos x stdiff)
% % SPARSENESS INDEX
% IDX_post_df = reshape(SparseIndex.post.all,[size(SparseIndex.post.all,1)*size(SparseIndex.post.all,2) size(SparseIndex.post.all,3)]);
% IDX_ant_df  = reshape(SparseIndex.ant.all,[size(SparseIndex.ant.all,1)*size(SparseIndex.ant.all,2) size(SparseIndex.ant.all,3)]);
% SELECTIVITY INDEX
if strcmp(trial_type,'combined')
    % all trials
    IDX_post_high = reshape(SelectIndex.post.all,[size(SelectIndex.post.all,1)*size(SelectIndex.post.all,2) size(SelectIndex.post.all,3)]);
    IDX_ant_high  = reshape(SelectIndex.ant.all,[size(SelectIndex.ant.all,1)*size(SelectIndex.ant.all,2) size(SelectIndex.ant.all,3)]);
elseif strcmp(trial_type,'hit')
    % hit
    IDX_post_high = reshape(SelectIndex.post.hit,[size(SelectIndex.post.hit,1)*size(SelectIndex.post.hit,2) size(SelectIndex.post.hit,3)]);
    IDX_ant_high  = reshape(SelectIndex.ant.hit,[size(SelectIndex.ant.hit,1)*size(SelectIndex.ant.hit,2) size(SelectIndex.ant.hit,3)]);
elseif strcmp(trial_type,'miss')
    % miss
    IDX_post_high = reshape(SelectIndex.post.miss,[size(SelectIndex.post.miss,1)*size(SelectIndex.post.miss,2) size(SelectIndex.post.miss,3)]);
    IDX_ant_high  = reshape(SelectIndex.ant.miss,[size(SelectIndex.ant.miss,1)*size(SelectIndex.ant.miss,2) size(SelectIndex.ant.miss,3)]);
end

% select triplet position
% selectivity index was originally calculated by (L-H) / (L+H)
% multiplied by -1 to make it (H-L) / (H+L) for non-BF site
IDX_post_low = IDX_post_low(:,tpos);
IDX_ant_low = IDX_ant_low(:,tpos);
% IDX_post_high = -1 * IDX_post_high(:,tpos);
% IDX_ant_high = -1 * IDX_ant_high(:,tpos);
x_label = sTriplet(tpos);

% mean
mIDX_post = nanmean(IDX_post_low,1); %[nanmean(IDX_post_low,1); nanmean(IDX_post_high,1)];
mIDX_ant = nanmean(IDX_ant_low,1); %[nanmean(IDX_ant_low,1); nanmean(IDX_ant_high,1)];

% median
mdIDX_post = nanmedian(IDX_post_low,1); %[nanmedian(IDX_post_low,1); nanmedian(IDX_post_high,1)];
mdIDX_ant = nanmedian(IDX_ant_low,1); %[nanmedian(IDX_ant_low,1); nanmedian(IDX_ant_high,1)];

% standard error
n_post = sum(~isnan(IDX_post_low),1); %[sum(~isnan(IDX_post_low),1); sum(~isnan(IDX_post_high),1)];
n_ant  = sum(~isnan(IDX_ant_low)); %[sum(~isnan(IDX_ant_low)); sum(~isnan(IDX_ant_high),1)];
s_post = nanstd(IDX_post_low,[],1); %[nanstd(IDX_post_low,[],1); nanstd(IDX_post_high,[],1)]; % standard deviation
s_ant  = nanstd(IDX_ant_low,[],1); %[nanstd(IDX_ant_low,[],1); nanstd(IDX_ant_high,[],1)];
e_post = s_post ./ sqrt(n_post);
e_ant  = s_ant ./ sqrt(n_ant);

% transpose matrix for bargraph
mIDX_post = mIDX_post'; mIDX_ant = mIDX_ant';
mdIDX_post = mdIDX_post'; mdIDX_ant = mdIDX_ant';
s_post = s_post'; s_ant = s_ant';
e_post = e_post'; e_ant = e_ant';

% bar graph...
figure('Position',[610,400,790,270]);
subplot(1,2,1);
bar(mIDX_post,'grouped'); 
hold on
% errorbar(mIDX_post,e_post);
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(mIDX_post);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, mIDX_post(:,i), e_post(:,i), 'k', 'linestyle', 'none');
%     errorbar(x, mIDX_post(:,i), e_post(:,i), 'k','LineStyle',':');
    X(i,:) = x;
end
% plot individual data...
% plot(X(1,:),IDX_post_low,'ko');
% plot(X(2,:),IDX_post_high,'ko');
hold off
set(gca,'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('Selectivity Index');
title('Posterior');

subplot(1,2,2);
bar(mIDX_ant,'grouped');
hold on
% errorbar(mIDX_post,e_post);
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(mIDX_ant);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, mIDX_ant(:,i), e_ant(:,i), 'k', 'linestyle', 'none');
%     errorbar(x, mIDX_ant(:,i), e_ant(:,i), 'k','LineStyle',':');
end
% plot individual data...
% plot(X(1,:),IDX_ant_low,'ko');
% plot(X(2,:),IDX_ant_high,'ko');
hold off
set(gca,'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('Selectivity Index');
title('Anterior');
legend({'BF site','non-BF site'});

% % % VIOLIN PLOT % % %
figure('Position',[660,450,790,270]);
% N_post = [size(IDX_post_low,1) size(IDX_post_high,1)];
% xx_post = [X(1)*ones(N_post(1),1); X(2)*ones(N_post(2),1); X(3)*ones(N_post(1),1); X(4)*ones(N_post(2),1);];
% yy_post = [IDX_post_low(:,1); IDX_post_high(:,1); IDX_post_low(:,2); IDX_post_high(:,2)];
N_post = [size(IDX_post_low,1) size(IDX_post_low,1)];
xx_post = [X(1)*ones(N_post(1),1); X(2)*ones(N_post(2),1)];
yy_post = [IDX_post_low(:,1); IDX_post_low(:,2)];
subplot(1,2,1);
swarmchart(xx_post,yy_post,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3); hold on
% add median
% plot(X,mdIDX_post','+');
% plot(X,mIDX_post','+');
h_bf(1)  = plot(X([1 2]),mdIDX_post(:,1),':+');
% h_bf(1)  = plot(X([1 3]),mdIDX_post(:,1),':+');
% h_nbf(1) = plot(X([2 4]),mdIDX_post(:,2),':+');
set(gca,'XTick',[1 2],'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('Selectivity Index');
title('Posterior');

N_ant = [size(IDX_ant_low,1) size(IDX_ant_low,1)];
xx_ant = [X(1)*ones(N_ant(1),1); X(2)*ones(N_ant(2),1)];
yy_ant = [IDX_ant_low(:,1); IDX_ant_low(:,2)];
% N_ant = [size(IDX_ant_low,1) size(IDX_ant_high,1)];
% xx_ant = [X(1)*ones(N_ant(1),1); X(2)*ones(N_ant(2),1); X(3)*ones(N_ant(1),1); X(4)*ones(N_ant(2),1);];
% yy_ant = [IDX_ant_low(:,1); IDX_ant_high(:,1); IDX_ant_low(:,2); IDX_ant_high(:,2)];
subplot(1,2,2);
swarmchart(xx_ant,yy_ant,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3); hold on
% add median
% plot(X,mdIDX_ant','+');
% plot(X,mIDX_ant','+');
h_bf(2)  = plot(X([1 2]),mdIDX_ant(:,1),':+');
% h_bf(2)  = plot(X([1 3]),mdIDX_ant(:,1),':+');
% h_nbf(2) = plot(X([2 4]),mdIDX_ant(:,2),':+');

% plot(X([1 3]),mIDX_ant(:,1),'x','MarkerSize',10); % mean
% plot(X([2 4]),mIDX_ant(:,2),'x','MarkerSize',10);
set(gca,'XTick',[1 2],'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('Selectivity Index');
title('Anterior');

% change line setting
% set(h_bf,'Color',[0, 0.4470, 0.7410],'MarkerSize',10,'LineWidth',2);
% set(h_nbf,'Color',[0.8500, 0.3250, 0.0980],'MarkerSize',10,'LineWidth',2);
set(h_bf,'Color',[1, 0, 0],'MarkerSize',12,'LineWidth',2);
% set(h_nbf,'Color',[0, 0.75, 0.75],'MarkerSize',12,'LineWidth',2);
% add legend
% legend({'','BF site','non-BF site'});


% % % % STATISTICAL COMPARISON % % %
% % evaluate whether the index is different from zero
% % posterior
% p_post(1,:) = signrank(IDX_post_low(:,1),0);
% p_post(2,:) = signrank(IDX_post_high(:,1),0);
% p_post(3,:) = signrank(IDX_post_low(:,2),0);
% p_post(4,:) = signrank(IDX_post_high(:,2),0);
% % anterior
% p_ant(1,:) = signrank(IDX_ant_low(:,1),0);
% p_ant(2,:) = signrank(IDX_ant_high(:,1),0);
% p_ant(3,:) = signrank(IDX_ant_low(:,2),0);
% p_ant(4,:) = signrank(IDX_ant_high(:,2),0);
% 
% % SRH test
% [pSRH_post,tbl_post,m_post] = stats_Index_SRHtest(IDX_post_low,IDX_post_high);
% [pSRH_ant,tbl_ant,m_ant] = stats_Index_SRHtest(IDX_ant_low,IDX_ant_high);
% 
% % examine whether the index is significantly different from zero
% for i=1:2
%     pWC_post(1,i) = signrank(IDX_post_low(:,i),0);
%     pWC_post(2,i) = signrank(IDX_post_high(:,i),0);
%     pWC_ant(1,i) = signrank(IDX_ant_low(:,i),0);
%     pWC_ant(2,i) = signrank(IDX_ant_high(:,i),0);
% end
% pWC_post = pWC_post(:);
% pWC_ant  = pWC_ant(:);
% 
% % post-hoc comparisons were performed in the following order...
% % p_post(1,:) = signrank(IDX_post_low(:,1),IDX_post_low(:,2));
% % p_post(2,:) = signrank(IDX_post_high(:,1),IDX_post_high(:,2));
% % p_post(3,:) = ranksum(IDX_post_low(:,1),IDX_post_high(:,1));
% % p_post(4,:) = ranksum(IDX_post_low(:,2),IDX_post_high(:,2));
% % p_post(5,:) = ranksum(IDX_post_low(:,1),IDX_post_high(:,2));
% % p_post(6,:) = ranksum(IDX_post_low(:,2),IDX_post_high(:,1));
% % 
% % p_ant(1,:) = signrank(IDX_ant_low(:,1),IDX_ant_low(:,2));
% % p_ant(2,:) = signrank(IDX_ant_high(:,1),IDX_ant_high(:,2));
% % p_ant(3,:) = ranksum(IDX_ant_low(:,1),IDX_ant_high(:,1));
% % p_ant(4,:) = ranksum(IDX_ant_low(:,2),IDX_ant_high(:,2));
% % p_ant(5,:) = ranksum(IDX_ant_low(:,1),IDX_ant_high(:,2));
% % p_ant(6,:) = ranksum(IDX_ant_low(:,2),IDX_ant_high(:,1));