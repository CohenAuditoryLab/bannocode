% correlation between behavioral d-prime and sROC
% just plot ROC (A vs B1) at selected tpos vs d-prime
% modified from Correlation_behav_MUAmodulation_ver2.m
clear all

% c = [1 0 0; 0 0.75 0.75]; % line color
c = [1 0 0; 0 0.75 0.75; 1 0.75 0; 0.6 0 1]; % line color
tpos = 1; % choose triplet position
c_type = 'Spearman'; %'Kendall'; %'Spearman'; %'Pearson'
plot_type = 'dev'; % 'raw', 'dev'

% set path for data directory
% path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\code'; % old
path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\reanalysis_code';
path_roc = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AvsB1';


% % % BF sites % % %
BF_Session = 'low'; % data from BF sites
load(fullfile(path_dp,strcat('BehavioralDPrime_',BF_Session,'BF')));
load(fullfile(path_roc,strcat('ROC_Both_',BF_Session,'BF')));

% obtain ROC for target (ch x session x stdiff)
tROC_BF_post = squeeze(AUC.post.stdiff(:,:,tpos,:));
tROC_BF_ant  = squeeze(AUC.ant.stdiff(:,:,tpos,:));
if strcmp(plot_type,'dev')
    % deviation from 0.5
    tROC_BF_post = tROC_BF_post - 0.5;
    tROC_BF_ant  = tROC_BF_ant - 0.5;
end

% obtain dp
dprime = DP'; % including intermediate dFs
dp_BF_post = dprime(AP_index==1,:);
dp_BF_ant  = dprime(AP_index==0,:);


% % % nonBF sites % % %
BF_Session = 'high'; % data from BF sites
load(fullfile(path_dp,strcat('BehavioralDPrime_',BF_Session,'BF')));
load(fullfile(path_roc,strcat('ROC_Both_',BF_Session,'BF')));

% obtain ROC for target (ch x session x stdiff)
tROC_nonBF_post = squeeze(AUC.post.stdiff(:,:,tpos,:));
tROC_nonBF_ant  = squeeze(AUC.ant.stdiff(:,:,tpos,:));
y_range = [0.2 1];
if strcmp(plot_type,'dev')
    % devidation from 0.5
    tROC_nonBF_post = 0.5 - tROC_nonBF_post;
    tROC_nonBF_ant  = 0.5 - tROC_nonBF_ant;
    y_range = [-0.3 0.5];
end

% obtain dp
dprime = DP'; % including intermediate dFs
dp_nonBF_post = dprime(AP_index==1,:);
dp_nonBF_ant  = dprime(AP_index==0,:);


% scatter plot
mtROC_BF_post = squeeze(nanmean(tROC_BF_post,1)); % mean across channels
mtROC_BF_ant = squeeze(nanmean(tROC_BF_ant,1));
mtROC_nonBF_post  = squeeze(nanmean(tROC_nonBF_post,1));
mtROC_nonBF_ant  = squeeze(nanmean(tROC_nonBF_ant,1));

% PLOT 
x_range = [-1 2];
% y_range = [-0.3 0.5];
% y_range = [0.2 1];
% figure('Position',[680,480,560,500]);
figure('Position',[440,480,1190,500]);
subplot(1,2,1); % all
dp_BF_post_all = dp_BF_post(:); dp_nonBF_post_all = dp_nonBF_post(:);
dp_BF_ant_all = dp_BF_ant(:); dp_nonBF_ant_all = dp_nonBF_ant(:);
roc_BF_post_all = mtROC_BF_post(:); roc_nonBF_post_all = mtROC_nonBF_post(:);
roc_BF_ant_all = mtROC_BF_ant(:); roc_nonBF_ant_all = mtROC_nonBF_ant(:);
h_BF_post(1) = plot(dp_BF_post_all,roc_BF_post_all,'o'); hold on
h_BF_ant(1) = plot(dp_BF_ant_all,roc_BF_ant_all,'^');
h_nonBF_post(1) = plot(dp_nonBF_post_all,roc_nonBF_post_all,'o');
h_nonBF_ant(1) = plot(dp_nonBF_ant_all,roc_nonBF_ant_all,'^');
% h_post(1) = scatter(dp_BF_all,roc_BF_all,[],'filled','o'); hold on
% h_ant(1) = scatter(dp_nonBF_all,roc_nonBF_all,[],'filled','^');
xlim(x_range); ylim(y_range);
xlabel('d prime'); ylabel('sROC');
title('all dF levels combined');
legend({'BF posterior','BF anterior','non-BF posterior','non-BF anterior'});
dp_all = [dp_BF_post_all; dp_nonBF_post_all; dp_BF_ant_all; dp_nonBF_ant_all];
roc_all = [roc_BF_post_all; roc_nonBF_post_all; roc_BF_ant_all; roc_nonBF_ant_all];
% remove NaN...
DP_all = dp_all(~isnan(roc_all));
ROC_all = roc_all(~isnan(roc_all));
DP_BF_post_all = dp_BF_post_all(~isnan(roc_BF_post_all));
DP_BF_ant_all = dp_BF_ant_all(~isnan(roc_BF_ant_all));
ROC_BF_post_all = roc_BF_post_all(~isnan(roc_BF_post_all));
ROC_BF_ant_all = roc_BF_ant_all(~isnan(roc_BF_ant_all));
DP_nonBF_post_all = dp_nonBF_post_all(~isnan(roc_nonBF_post_all));
DP_nonBF_ant_all = dp_nonBF_ant_all(~isnan(roc_nonBF_ant_all));
ROC_nonBF_post_all = roc_nonBF_post_all(~isnan(roc_nonBF_post_all));
ROC_nonBF_ant_all = roc_nonBF_ant_all(~isnan(roc_nonBF_ant_all));

pos = [3 4 7 8]; % figure position
t_label = {'smallest dF','small dF','large dF','largest dF'};
for i=1:4
    subplot(2,4,pos(i));
    dp_BF_post_stdiff = dp_BF_post(:,i); dp_nonBF_post_stdiff = dp_nonBF_post(:,i);
    dp_BF_ant_stdiff = dp_BF_ant(:,i); dp_nonBF_ant_stdiff = dp_nonBF_ant(:,i);
    roc_BF_post_stdiff = mtROC_BF_post(:,i); roc_nonBF_post_stdiff = mtROC_nonBF_post(:,i);
    roc_BF_ant_stdiff = mtROC_BF_ant(:,i); roc_nonBF_ant_stdiff = mtROC_nonBF_ant(:,i);
    h_BF_post(i+1) = plot(dp_BF_post_stdiff,roc_BF_post_stdiff,'o'); hold on
    h_BF_ant(i+1) = plot(dp_BF_ant_stdiff,roc_BF_ant_stdiff,'^');
    h_nonBF_post(i+1) = plot(dp_nonBF_post_stdiff,roc_nonBF_post_stdiff,'o');
    h_nonBF_ant(i+1) = plot(dp_nonBF_ant_stdiff,roc_nonBF_ant_stdiff,'^');
    xlim(x_range); ylim(y_range);
    xlabel('d prime'); ylabel('sROC');
    title(t_label(i));
    dp_stdiff = [dp_BF_post_stdiff; dp_nonBF_post_stdiff; dp_BF_ant_stdiff; dp_nonBF_ant_stdiff];
    roc_stdiff = [roc_BF_post_stdiff; roc_nonBF_post_stdiff; roc_BF_ant_stdiff; roc_nonBF_ant_stdiff];
    % remove NaN...
    DP_stdiff{i} = dp_stdiff(~isnan(roc_stdiff));
    ROC_stdiff{i} = roc_stdiff(~isnan(roc_stdiff));
    DP_BF_post_stdiff{i} = dp_BF_post_stdiff(~isnan(roc_BF_post_stdiff));
    DP_BF_ant_stdiff{i} = dp_BF_ant_stdiff(~isnan(roc_BF_ant_stdiff));
    ROC_BF_post_stdiff{i} = roc_BF_post_stdiff(~isnan(roc_BF_post_stdiff));
    ROC_BF_ant_stdiff{i} = roc_BF_ant_stdiff(~isnan(roc_BF_ant_stdiff));
    DP_nonBF_post_stdiff{i} = dp_nonBF_post_stdiff(~isnan(roc_nonBF_post_stdiff));
    DP_nonBF_ant_stdiff{i} = dp_nonBF_ant_stdiff(~isnan(roc_nonBF_ant_stdiff));
    ROC_nonBF_post_stdiff{i} = roc_nonBF_post_stdiff(~isnan(roc_nonBF_post_stdiff));
    ROC_nonBF_ant_stdiff{i} = roc_nonBF_ant_stdiff(~isnan(roc_nonBF_ant_stdiff));
    clear dp_stdiff dp_BF_post_stdiff dp_nonBF_post_stdiff dp_BF_ant_stdiff dp_nonBF_ant_stdiff
    clear roc_stdiff roc_BF_post_stdiff roc_nonBF_post_stdiff roc_BF_ant_stdiff roc_nonBF_ant_stdiff
end

% SET LINE PROPERTIES...
set(h_BF_post,'LineWidth',1.5,'Color',c(1,:),'MarkerFaceColor',[1 1 1]);
set(h_BF_ant,'LineWidth',1.5,'Color',c(2,:),'MarkerFaceColor',[1 1 1]);
set(h_nonBF_post,'LineWidth',1.5,'Color',c(3,:),'MarkerFaceColor',[1 1 1]);
set(h_nonBF_ant,'LineWidth',1.5,'Color',c(4,:),'MarkerFaceColor',[1 1 1]);




% % % % calculate correlation % % %
% small and large dF trials combined
[r_all(1),p_all(1)] = corr(DP_all,ROC_all,'type',c_type);
[r_all(2),p_all(2)] = corr(DP_BF_post_all,ROC_BF_post_all,'type',c_type);
[r_all(3),p_all(3)] = corr(DP_BF_ant_all,ROC_BF_ant_all,'type',c_type);
[r_all(4),p_all(4)] = corr(DP_nonBF_post_all,ROC_nonBF_post_all,'type',c_type);
[r_all(5),p_all(5)] = corr(DP_nonBF_ant_all,ROC_nonBF_ant_all,'type',c_type);

for i=1:4
    [r_stdiff(i,1),p_stdiff(i,1)] = corr(DP_stdiff{i},ROC_stdiff{i},'type',c_type);
    [r_stdiff(i,2),p_stdiff(i,2)] = corr(DP_BF_post_stdiff{i},ROC_BF_post_stdiff{i},'type',c_type);
    [r_stdiff(i,3),p_stdiff(i,3)] = corr(DP_BF_ant_stdiff{i},ROC_BF_ant_stdiff{i},'type',c_type);
    [r_stdiff(i,4),p_stdiff(i,4)] = corr(DP_nonBF_post_stdiff{i},ROC_nonBF_post_stdiff{i},'type',c_type);
    [r_stdiff(i,5),p_stdiff(i,5)] = corr(DP_nonBF_ant_stdiff{i},ROC_nonBF_ant_stdiff{i},'type',c_type);
end

% % FDR correction (not sure if need it)...
% p_stdiff_adj = reshape(mafdr(p_stdiff(:),'BHFDR',true),size(p_stdiff));


% % small dF trials
% [r_sdf(1),p_sdf(1)] = corr(dp_sdf,roc_sdf,'type',c_type);
% [r_sdf(2),p_sdf(2)] = corr(dp_post_sdf,roc_post_sdf,'type',c_type);
% [r_sdf(3),p_sdf(3)] = corr(dp_ant_sdf,roc_ant_sdf,'type',c_type);
% % small dF trials
% [r_ldf(1),p_ldf(1)] = corr(dp_ldf,roc_ldf,'type',c_type);
% [r_ldf(2),p_ldf(2)] = corr(dp_post_ldf,roc_post_ldf,'type',c_type);
% [r_ldf(3),p_ldf(3)] = corr(dp_ant_ldf,roc_ant_ldf,'type',c_type);