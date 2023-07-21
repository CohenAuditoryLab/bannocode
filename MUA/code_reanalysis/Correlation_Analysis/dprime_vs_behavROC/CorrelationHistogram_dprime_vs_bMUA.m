% correlation between behavioral d-prime and adaptROC
% modified from Correlation_behav_MUAmodulation_ver2.m
clear all
% add path for the function: corr_ROC_vs_DP
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\Correlation_Analysis');

% SET PATH FOR DATA DIRECTORY
path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\reanalysis_code';
path_roc = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB';

% SET PARAMETERS
c = [1 0 0; 0 0.75 0.75; 1 0.75 0; 0.6 0 1]; % line color
c_type = 'Spearman'; %'Kendall'; %'Spearman'; %'Pearson'
tpos = 7; % choose Target triplet position
% trial_type = 'combined'; % 'combined', 'hit', or 'miss'


%% % % % BF sites % % %
BF_Session = 'low'; % data from BF sites
load(fullfile(path_dp,strcat('BehavioralDPrime_',BF_Session,'BF_wIntermDF')));
load(fullfile(path_roc,strcat('ROC_Both_ABB_',BF_Session,'BF_wIntermDF')));

% obtain ROC for target (ch x session x tpos x stdiff x ABB)
tROC_BF_post = squeeze(AUC.post.behav(:,:,tpos,:,1));
tROC_BF_ant  = squeeze(AUC.ant.behav(:,:,tpos,:,1));

% obtain dp
dprime = DP'; % including intermediate dFs
dp_BF_post = dprime(AP_index==1,:);
dp_BF_ant  = dprime(AP_index==0,:);

% correlation between ROC and dp
[r_BFp,p_BFp] = corr_ROC_vs_DP(tROC_BF_post,dp_BF_post,c_type);
[r_BFa,p_BFa] = corr_ROC_vs_DP(tROC_BF_ant,dp_BF_ant,c_type);

%% % % % nonBF sites % % %
BF_Session = 'high'; % data from BF sites
load(fullfile(path_dp,strcat('BehavioralDPrime_',BF_Session,'BF_wIntermDF')));
load(fullfile(path_roc,strcat('ROC_Both_ABB_',BF_Session,'BF_wIntermDF')));


% obtain ROC for target (ch x session x tpos x stdiff x ABB)
tROC_nonBF_post = squeeze(AUC.post.behav(:,:,tpos,:,1));
tROC_nonBF_ant  = squeeze(AUC.ant.behav(:,:,tpos,:,1));

% obtain dp
dprime = DP'; % including intermediate dFs
dp_nonBF_post = dprime(AP_index==1,:);
dp_nonBF_ant  = dprime(AP_index==0,:);

% correlation between ROC and dp
[r_nBFp,p_nBFp] = corr_ROC_vs_DP(tROC_nonBF_post,dp_nonBF_post,c_type);
[r_nBFa,p_nBFa] = corr_ROC_vs_DP(tROC_nonBF_ant,dp_nonBF_ant,c_type);


% mean, median, and standard deviation...
% mean
mR_post = [nanmean(r_BFp.channel(:)); nanmean(r_nBFp.channel(:))];
mR_ant  = [nanmean(r_BFa.channel(:)); nanmean(r_nBFa.channel(:))];

% median
mdR_post = [nanmedian(r_BFp.channel(:)); nanmedian(r_nBFp.channel(:))];
mdR_ant  = [nanmedian(r_BFa.channel(:)); nanmedian(r_nBFa.channel(:))];

% standard error
n_post = [sum(~isnan(r_BFp.channel(:))); sum(~isnan(r_nBFp.channel(:)))];
n_ant  = [sum(~isnan(r_BFa.channel(:))); sum(~isnan(r_nBFa.channel(:)))];
s_post = [nanstd(r_BFp.channel(:),[],1); nanstd(r_nBFp.channel(:),[],1)]; % standard deviation
s_ant  = [nanstd(r_BFa.channel(:),[],1); nanstd(r_nBFa.channel(:),[],1)];
e_post = s_post ./ sqrt(n_post);
e_ant  = s_ant ./ sqrt(n_ant);


%% % % % PLOT % % %
figure('Position',[560,350,790,270]);
bin = -1:0.25:1;
subplot(1,2,1);
histogram(r_BFp.channel(:),bin); hold on
histogram(r_nBFp.channel(:),bin);
xlabel('Correlation'); ylabel('Number of MUA');
title('Posterior');
legend({'BF site','non-BF site'},'Location','NorthWest');
box off

subplot(1,2,2);
histogram(r_BFa.channel(:),bin); hold on
histogram(r_nBFa.channel(:),bin);
xlabel('Correlation'); ylabel('Number of MUA');
title('Anterior');
box off

% subplot(2,2,3);
% histogram(r_BFp.session,8); hold on
% histogram(r_BFa.session,8);
% 
% subplot(2,2,4);
% histogram(r_nBFp.session,8); hold on
% histogram(r_nBFa.session,8);

x_label = {'BF site','non-BF site'};
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
%     errorbar(x, mR_post(:,i), s_post(:,i), 'k', 'linestyle', 'none');
    X(i,:) = x;
end
hold off
set(gca,'XTickLabel',x_label);
% xlabel('Triplet Position'); 
ylabel('Correlation');
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
%     errorbar(x, mR_ant(:,i), s_ant(:,i), 'k', 'linestyle', 'none');
end
hold off
set(gca,'XTickLabel',x_label);
% xlabel('Triplet Position'); 
ylabel('Correlation');
title('Anterior');
% legend({'BF site','non-BF site'});

% % % VIOLIN PLOT % % %
figure('Position',[660,450,790,270]);
N_post = [size(r_BFp.channel(:),1) size(r_nBFp.channel(:),1)];
xx_post = [X(1)*ones(N_post(1),1); X(2)*ones(N_post(2),1)];
yy_post = [r_BFp.channel(:); r_nBFp.channel(:)];
subplot(1,2,1);
swarmchart(xx_post,yy_post,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3,'XJitterWidth',0.5); hold on
xrange = get(gca,'XLim');
plot(xrange,[0.0 0.0],':k');
% add median
% plot(X,mdAUC_post','+');
% plot(X,mAUC_post','+');
h_bf(1)  = plot(X(1),mdR_post(1,:),':+');
h_nbf(1) = plot(X(2),mdR_post(2,:),':+');
set(gca,'XTick',[1 2],'XTickLabel',x_label,'YLim',[-1.2 1.2]);
% xlabel('Triplet Position'); 
ylabel('Correlation');
title('Posterior');


N_ant = [size(r_BFa.channel(:),1) size(r_nBFa.channel(:),1)];
xx_ant = [X(1)*ones(N_ant(1),1); X(2)*ones(N_ant(2),1)];
yy_ant = [r_BFa.channel(:); r_nBFa.channel(:)];
% xx_ant = [X(1)*ones(N_ant(1),1); X(2)*ones(N_ant(1),1); X(3)*ones(N_ant(1),1); X(4)*ones(N_ant(1),1); ...
%           X(5)*ones(N_ant(2),1); X(6)*ones(N_ant(2),1); X(7)*ones(N_ant(2),1); X(8)*ones(N_ant(2),1)];
% yy_ant = [AUC_ant_low(:,1); AUC_ant_low(:,2); AUC_ant_low(:,3); AUC_ant_low(:,4); ...
%           AUC_ant_high(:,1); AUC_ant_high(:,2); AUC_ant_high(:,3); AUC_ant_high(:,4)];
subplot(1,2,2);
swarmchart(xx_ant,yy_ant,'k','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3,'XJitterWidth',0.5); hold on
xrange = [0.5 2.5]; % get(gca,'XLim');
plot(xrange,[0.0 0.0],':k');
% add median
plot(X,mdR_ant','+');
% plot(X,mAUC_ant','+');
h_bf(2)  = plot(X(1),mdR_ant(1,:),':+'); % median
h_nbf(2) = plot(X(2),mdR_ant(2,:),':+');
set(gca,'XTick',[1 2],'XTickLabel',x_label,'XLim',[0.5 2.5],'YLim',[-1.2 1.2]);
xlabel('Triplet Position'); ylabel('Correlation');
title('Anterior');


% change line setting
% set(h_bf,'Color',[0, 0.4470, 0.7410],'MarkerSize',10,'LineWidth',2);
% set(h_nbf,'Color',[0.8500, 0.3250, 0.0980],'MarkerSize',10,'LineWidth',2);
set(h_bf,'Color',[1, 0, 0],'MarkerSize',8,'LineWidth',1.5);
set(h_nbf,'Color',[0, 0.75, 0.75],'MarkerSize',8,'LineWidth',1.5);
% add legend
% legend({'','BF site','non-BF site'});


p_post(1) = signrank(r_BFp.channel(:),0);
p_post(2) = signrank(r_nBFp.channel(:),0);
p_ant(1)  = signrank(r_BFa.channel(:),0);
p_ant(2)  = signrank(r_nBFa.channel(:),0);