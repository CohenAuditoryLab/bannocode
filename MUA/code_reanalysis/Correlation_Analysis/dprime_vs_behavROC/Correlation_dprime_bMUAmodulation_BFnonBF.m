% correlation between behavioral d-prime and bROC
clear all

% c = [153 0 255; 0 204 0] / 255; % line color
c = [1 0 0; 0 0.75 0.75]; % line color
tpos = 7; % choose Target triplet
c_type = 'Pearson'; %'Kendall'; %'Spearman'; %'Pearson'

% set path for data directory
% path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\code'; % old
path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\reanalysis_code';
path_roc = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB';


% % % BF sites % % %
BF_Session = 'low'; % data from BF sites
load(fullfile(path_dp,strcat('BehavioralDPrime_',BF_Session,'BF')));
load(fullfile(path_roc,strcat('ROC_Both_ABB_',BF_Session,'BF')));

% obtain ROC for target (ch x session x stdiff)
tROC_post = squeeze(AUC.post.behav(:,:,tpos,:,1));
tROC_ant  = squeeze(AUC.ant.behav(:,:,tpos,:,1));
% concatenate data 
tROC_BF = cat(2,tROC_post,tROC_ant);
clear tROC_post tROC_ant

% obtain dp
dprime = DP'; % including intermediate dFs
dp_post = dprime(AP_index==1,:);
dp_ant  = dprime(AP_index==0,:);
% concatenate data
dp_BF = cat(1,dp_post,dp_ant);
clear dp_post dp_ant


% % % nonBF sites % % %
BF_Session = 'high'; % data from BF sites
load(fullfile(path_dp,strcat('BehavioralDPrime_',BF_Session,'BF')));
load(fullfile(path_roc,strcat('ROC_Both_ABB_',BF_Session,'BF')));

% obtain ROC for target (ch x session x stdiff)
tROC_post = squeeze(AUC.post.behav(:,:,tpos,:,1));
tROC_ant  = squeeze(AUC.ant.behav(:,:,tpos,:,1));
% concatenate data 
tROC_nonBF = cat(2,tROC_post,tROC_ant);
clear tROC_post tROC_ant

% obtain dp
dprime = DP'; % including intermediate dFs
dp_post = dprime(AP_index==1,:);
dp_ant  = dprime(AP_index==0,:);
% concatenate data
dp_nonBF = cat(1,dp_post,dp_ant);
clear dp_post dp_ant

% % make a matrix of d-prime in the same size as ROC (ch x session x
% % stdiff)
% DP_post = []; DP_ant = [];
% for ii=1:24
%     DP_post = cat(3,DP_post,dp_post);
%     DP_ant  = cat(3,DP_ant,dp_ant);
% end
% DP_post = permute(DP_post,[3 1 2]);
% DP_ant  = permute(DP_ant,[3 1 2]);

% scatter plot
mtROC_BF = squeeze(nanmean(tROC_BF,1)); % mean across channels
mtROC_nonBF  = squeeze(nanmean(tROC_nonBF,1));

% PLOT 
x_range = [-1 2];
y_range = [0.4 0.7];
% figure('Position',[680,480,560,500]);
figure('Position',[440,480,1190,500]);
subplot(1,2,1); % all
dp_BF_all = dp_BF(:); dp_nonBF_all = dp_nonBF(:);
roc_BF_all = mtROC_BF(:); roc_nonBF_all = mtROC_nonBF(:);
h_BF(1) = plot(dp_BF_all,roc_BF_all,'o'); hold on
h_nonBF(1) = plot(dp_nonBF_all,roc_nonBF_all,'^');
% h_post(1) = scatter(dp_BF_all,roc_BF_all,[],'filled','o'); hold on
% h_ant(1) = scatter(dp_nonBF_all,roc_nonBF_all,[],'filled','^');
xlim(x_range); ylim(y_range);
xlabel('d prime'); ylabel('bROC');
title('all dF levels combined');
legend({'BF sites','non-BF sites'});
dp_all = [dp_BF_all; dp_nonBF_all];
roc_all = [roc_BF_all; roc_nonBF_all];
% remove NaN...
DP_all = dp_all(~isnan(roc_all));
ROC_all = roc_all(~isnan(roc_all));
DP_BF_all = dp_BF_all(~isnan(roc_BF_all));
ROC_BF_all = roc_BF_all(~isnan(roc_BF_all));
DP_nonBF_all = dp_nonBF_all(~isnan(roc_nonBF_all));
ROC_nonBF_all = roc_nonBF_all(~isnan(roc_nonBF_all));

pos = [3 4 7 8]; % figure position
t_label = {'smallest dF','small dF','large dF','largest dF'};
for i=1:4
    subplot(2,4,pos(i));
    dp_BF_stdiff = dp_BF(:,i); dp_nonBF_stdiff = dp_nonBF(:,i);
    roc_BF_stdiff = mtROC_BF(:,i); roc_nonBF_stdiff = mtROC_nonBF(:,i);
    h_BF(i+1) = plot(dp_BF_stdiff,roc_BF_stdiff,'o'); hold on
    h_nonBF(i+1) = plot(dp_nonBF_stdiff,roc_nonBF_stdiff,'^');
    xlim(x_range); ylim(y_range);
    xlabel('d prime'); ylabel('bROC');
    title(t_label(i));
    dp_stdiff = [dp_BF_stdiff; dp_nonBF_stdiff];
    roc_stdiff = [roc_BF_stdiff; roc_nonBF_stdiff];
    % remove NaN...
    DP_stdiff{i} = dp_stdiff(~isnan(roc_stdiff));
    ROC_stdiff{i} = roc_stdiff(~isnan(roc_stdiff));
    DP_BF_stdiff{i} = dp_BF_stdiff(~isnan(roc_BF_stdiff));
    ROC_BF_stdiff{i} = roc_BF_stdiff(~isnan(roc_BF_stdiff));
    DP_nonBF_stdiff{i} = dp_nonBF_stdiff(~isnan(roc_nonBF_stdiff));
    ROC_nonBF_stdiff{i} = roc_nonBF_stdiff(~isnan(roc_nonBF_stdiff));
    clear dp_stdiff dp_BF_stdiff dp_nonBF_stdiff
    clear roc_stdiff roc_BF_stdiff roc_nonBF_stdiff
end

% SET LINE PROPERTIES...
set(h_BF,'LineWidth',1.5,'Color',c(1,:),'MarkerFaceColor',[1 1 1]);
set(h_nonBF,'LineWidth',1.5,'Color',c(2,:),'MarkerFaceColor',[1 1 1]);
% set(h_post,'MarkerFaceColor',c(1,:),'MarkerFaceAlpha',.8);
% set(h_ant,'MarkerFaceColor',c(2,:),'MarkerFaceAlpha',.8);



% % % % calculate correlation % % %
% small and large dF trials combined
[r_all(1),p_all(1)] = corr(DP_all,ROC_all,'type',c_type);
[r_all(2),p_all(2)] = corr(DP_BF_all,ROC_BF_all,'type',c_type);
[r_all(3),p_all(3)] = corr(DP_nonBF_all,ROC_nonBF_all,'type',c_type);

for i=1:4
    [r_stdiff(i,1),p_stdiff(i,1)] = corr(DP_stdiff{i},ROC_stdiff{i},'type',c_type);
    [r_stdiff(i,2),p_stdiff(i,2)] = corr(DP_BF_stdiff{i},ROC_BF_stdiff{i},'type',c_type);
    [r_stdiff(i,3),p_stdiff(i,3)] = corr(DP_nonBF_stdiff{i},ROC_nonBF_stdiff{i},'type',c_type);
end
% % small dF trials
% [r_sdf(1),p_sdf(1)] = corr(dp_sdf,roc_sdf,'type',c_type);
% [r_sdf(2),p_sdf(2)] = corr(dp_post_sdf,roc_post_sdf,'type',c_type);
% [r_sdf(3),p_sdf(3)] = corr(dp_ant_sdf,roc_ant_sdf,'type',c_type);
% % small dF trials
% [r_ldf(1),p_ldf(1)] = corr(dp_ldf,roc_ldf,'type',c_type);
% [r_ldf(2),p_ldf(2)] = corr(dp_post_ldf,roc_post_ldf,'type',c_type);
% [r_ldf(3),p_ldf(3)] = corr(dp_ant_ldf,roc_ant_ldf,'type',c_type);