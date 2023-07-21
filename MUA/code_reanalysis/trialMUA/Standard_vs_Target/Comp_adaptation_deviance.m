clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AdaptDev';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA');

% set parameters...
trial_type = 'miss'; % either 'combined', 'hit', or 'miss'
adapt_or_dev = 'adaptation'; % either 'adaptation' or 'deviance'
% set version
% v = 1 to choose B1 response for non-BF site
% v = 2 to choose A response for non-BF site
% in either case, used A tone response for BF site
v = 2;

% set numbers based on trial_type
if strcmp(trial_type,'combined')
    ii = 1;
elseif strcmp(trial_type,'hit')
    ii = 2;
elseif strcmp(trial_type,'miss')
    ii = 3;
end

% % % BF site % % %
% load Data
% load(fullfile(DATA_DIR,'ROC_Both_AdaptDev_A_lowBF.mat'));
if strcmp(adapt_or_dev,'adaptation')
    % load data (should be from A tone in BF site)
    load(fullfile(DATA_DIR,'ROC_Both_AdaptDev_A_lowBF.mat'));
    AUC_post_low = AUC.post.adaptation(:,:,:,ii);
    AUC_ant_low  = AUC.ant.adaptation(:,:,:,ii);
elseif strcmp(adapt_or_dev,'deviance')
    % load data (deviance should be from A tone)
    load(fullfile(DATA_DIR,'ROC_Both_AdaptDev_A_lowBF.mat'));
    AUC_post_low = AUC.post.deviance(:,:,:,ii);
    AUC_ant_low  = AUC.ant.deviance(:,:,:,ii);
end
% reshape matrix (sample x tpos x stdiff)
AUC_post_low = reshape(AUC_post_low,[size(AUC_post_low,1)*size(AUC_post_low,2) size(AUC_post_low,3)]);
AUC_ant_low  = reshape(AUC_ant_low,[size(AUC_ant_low,1)*size(AUC_ant_low,2) size(AUC_ant_low,3)]);


% % % non-BF site % % %
% load Data
% load(fullfile(DATA_DIR,'ROC_Both_AdaptDev_A_highBF.mat'));

if strcmp(adapt_or_dev,'adaptation')
    % load data (should be from B tone in non-BF site)
    if v==1 % version 1
        disp('version 1: choose B1 for non-BF site...')
        load(fullfile(DATA_DIR,'ROC_Both_AdaptDev_B1_highBF.mat'));
    elseif v==2
        disp('version 2: choose A for non-BF site...')
        load(fullfile(DATA_DIR,'ROC_Both_AdaptDev_A_highBF.mat'));
    end
    AUC_post_high = AUC.post.adaptation(:,:,:,ii);
    AUC_ant_high  = AUC.ant.adaptation(:,:,:,ii);
elseif strcmp(adapt_or_dev,'deviance')
    % load data (deviance should be from A tone)
    load(fullfile(DATA_DIR,'ROC_Both_AdaptDev_A_highBF.mat'));
    AUC_post_high = AUC.post.deviance(:,:,:,ii);
    AUC_ant_high  = AUC.ant.deviance(:,:,:,ii);
end
% reshape matrix (sample x tpos x stdiff)
AUC_post_high = reshape(AUC_post_high,[size(AUC_post_high,1)*size(AUC_post_high,2) size(AUC_post_high,3)]);
AUC_ant_high  = reshape(AUC_ant_high,[size(AUC_ant_high,1)*size(AUC_ant_high,2) size(AUC_ant_high,3)]);


% mean
mAUC_post = [nanmean(AUC_post_low,1); nanmean(AUC_post_high,1)];
mAUC_ant = [nanmean(AUC_ant_low,1); nanmean(AUC_ant_high,1)];

% median
mdAUC_post = [nanmedian(AUC_post_low,1); nanmedian(AUC_post_high,1)];
mdAUC_ant = [nanmedian(AUC_ant_low,1); nanmedian(AUC_ant_high,1)];

% standard error
n_post = [sum(~isnan(AUC_post_low),1); sum(~isnan(AUC_post_high),1)];
n_ant  = [sum(~isnan(AUC_ant_low)); sum(~isnan(AUC_ant_high),1)];
s_post = [nanstd(AUC_post_low,[],1); nanstd(AUC_post_high,[],1)]; % standard deviation
s_ant  = [nanstd(AUC_ant_low,[],1); nanstd(AUC_ant_high,[],1)];
e_post = s_post ./ sqrt(n_post);
e_ant  = s_ant ./ sqrt(n_ant);


x_label = {'BF site','non-BF site'};
% bar graph...
figure('Position',[610,400,790,270]);
subplot(1,2,1);
bar(mAUC_post,'grouped'); 
hold on
% errorbar(mR_post,e_post);
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(mAUC_post);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     errorbar(x, mAUC_post(:,i), e_post(:,i), 'k', 'linestyle', 'none');
    errorbar(x, mAUC_post(:,i), s_post(:,i), 'k', 'linestyle', 'none');
    X(i,:) = x;
end
hold off
set(gca,'XTickLabel',x_label);
% xlabel('Triplet Position'); 
ylabel('ROC');
title('Posterior');

subplot(1,2,2);
bar(mAUC_ant,'grouped');
hold on
% errorbar(mR_post,e_post);
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(mAUC_ant);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     errorbar(x, mAUC_ant(:,i), e_ant(:,i), 'k', 'linestyle', 'none');
    errorbar(x, mAUC_ant(:,i), s_ant(:,i), 'k', 'linestyle', 'none');
end
hold off
set(gca,'XTickLabel',x_label);
% xlabel('Triplet Position'); 
ylabel('ROC');
title('Anterior');
% legend({'BF site','non-BF site'});

% % % VIOLIN PLOT % % %
figure('Position',[660,450,790,270]);
N_post = [size(AUC_post_low,1) size(AUC_post_high,1)];
% xx_post = [X(1)*ones(N_post(1),1); X(2)*ones(N_post(2),1); X(3)*ones(N_post(1),1); X(4)*ones(N_post(2),1);];
% yy_post = [AUC_post_low(:,1); AUC_post_high(:,1); AUC_post_low(:,2); AUC_post_high(:,2)];
xx_post = [X(1)*ones(N_post(1),1); X(2)*ones(N_post(1),1); X(3)*ones(N_post(1),1); X(4)*ones(N_post(1),1); ...
           X(5)*ones(N_post(2),1); X(6)*ones(N_post(2),1); X(7)*ones(N_post(2),1); X(8)*ones(N_post(2),1)];
yy_post = [AUC_post_low(:,1); AUC_post_low(:,2); AUC_post_low(:,3); AUC_post_low(:,4); ...
           AUC_post_high(:,1); AUC_post_high(:,2); AUC_post_high(:,3); AUC_post_high(:,4)];
subplot(1,2,1);
swarmchart(xx_post,yy_post,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3); hold on
xrange = get(gca,'XLim');
plot(xrange,[0.5 0.5],':k');
% add median
% plot(X,mdAUC_post','+');
% plot(X,mAUC_post','+');
h_bf(1)  = plot(X(1:4),mdAUC_post(1,:),':+');
h_nbf(1) = plot(X(5:8),mdAUC_post(2,:),':+');
set(gca,'XTick',[1 2],'XTickLabel',x_label);
% xlabel('Triplet Position'); 
ylabel('auROC');
title('Posterior');

N_ant = [size(AUC_ant_low,1) size(AUC_ant_high,1)];
% xx_ant = [X(1)*ones(N_ant(1),1); X(2)*ones(N_ant(2),1); X(3)*ones(N_ant(1),1); X(4)*ones(N_ant(2),1);];
% yy_ant = [R_ant_low(:,1); R_ant_high(:,1); R_ant_low(:,2); R_ant_high(:,2)];
xx_ant = [X(1)*ones(N_ant(1),1); X(2)*ones(N_ant(1),1); X(3)*ones(N_ant(1),1); X(4)*ones(N_ant(1),1); ...
          X(5)*ones(N_ant(2),1); X(6)*ones(N_ant(2),1); X(7)*ones(N_ant(2),1); X(8)*ones(N_ant(2),1)];
yy_ant = [AUC_ant_low(:,1); AUC_ant_low(:,2); AUC_ant_low(:,3); AUC_ant_low(:,4); ...
          AUC_ant_high(:,1); AUC_ant_high(:,2); AUC_ant_high(:,3); AUC_ant_high(:,4)];
subplot(1,2,2);
swarmchart(xx_ant,yy_ant,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3); hold on
xrange = get(gca,'XLim');
plot(xrange,[0.5 0.5],':k');
% add median
plot(X,mdAUC_ant','+');
% plot(X,mAUC_ant','+');
h_bf(2)  = plot(X(1:4),mdAUC_ant(1,:),':+'); % median
h_nbf(2) = plot(X(5:8),mdAUC_ant(2,:),':+');
set(gca,'XTick',[1 2],'XTickLabel',x_label);
xlabel('Triplet Position'); ylabel('auROC');
title('Anterior');

% change line setting
% set(h_bf,'Color',[0, 0.4470, 0.7410],'MarkerSize',10,'LineWidth',2);
% set(h_nbf,'Color',[0.8500, 0.3250, 0.0980],'MarkerSize',10,'LineWidth',2);
set(h_bf,'Color',[1, 0, 0],'MarkerSize',8,'LineWidth',1.5);
set(h_nbf,'Color',[0, 0.75, 0.75],'MarkerSize',8,'LineWidth',1.5);
% add legend
% legend({'','BF site','non-BF site'});



% % % STATISTICAL COMPARISON % % %
% Kruskal-Wallis test
% whether the value depends on stdiff
p_post(1) = kruskalwallis(AUC_post_low,[],'off');  % BF site
p_post(2) = kruskalwallis(AUC_post_high,[],'off'); % non-BF site
p_ant(1) = kruskalwallis(AUC_ant_low,[],'off');  % BF site
p_ant(2) = kruskalwallis(AUC_ant_high,[],'off'); % non-BF site


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