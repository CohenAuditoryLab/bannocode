% correlation between behavioral d-prime and bROC
clear all

c = [153 0 255; 0 204 0] / 255; % line color
tpos = 7; % choose Target triplet
% % c = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410]; % line color

% set path for data directory
% path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\code'; % old
path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\reanalysis_code';
path_roc = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB';

% load data
load(fullfile(path_dp,'BehavioralDPrime.mat'));
load(fullfile(path_roc,'ROC_Both_ABB_allBF.mat'));

% obtain ROC for target (ch x session x hard-easy)
tROC_post = squeeze(AUC.post.behav(:,:,tpos,[1 4],1));
tROC_ant  = squeeze(AUC.ant.behav(:,:,tpos,[1 4],1));

% obtain dp
dprime = [dp_hard' dp_easy'];
dp_post = dprime(AP_index==1,:);
dp_ant  = dprime(AP_index==0,:);

% make a matrix of d-prime in the same size as ROC (ch x session x
% hard-easy)
DP_post = []; DP_ant = [];
for ii=1:24
    DP_post = cat(3,DP_post,dp_post);
    DP_ant  = cat(3,DP_ant,dp_ant);
end
DP_post = permute(DP_post,[3 1 2]);
DP_ant  = permute(DP_ant,[3 1 2]);

% scatter plot
mtROC_post = squeeze(nanmean(tROC_post,1)); % mean across channels
mtROC_ant  = squeeze(nanmean(tROC_ant,1));

% PLOT 
figure('Position',[680,480,560,500]);
subplot(2,2,1); % all
dp_post_all = dp_post(:); dp_ant_all = dp_ant(:);
roc_post_all = mtROC_post(:); roc_ant_all = mtROC_ant(:);
h_post(1) = plot(dp_post_all,roc_post_all,'o'); hold on
h_ant(1) = plot(dp_ant_all,roc_ant_all,'^');
% h_post(1) = scatter(dp_post_all,roc_post_all,[],'filled','o'); hold on
% h_ant(1) = scatter(dp_ant_all,roc_ant_all,[],'filled','^');
xlim([-1 2]); ylim([0.4 0.7]);
xlabel('d prime'); ylabel('bROC');
title('small and large dF combined');
legend({'Posterior','Anterior'});
dp_all = [dp_post_all; dp_ant_all];
roc_all = [roc_post_all; roc_ant_all];
% remove NaN...
dp_all = dp_all(~isnan(roc_all));
roc_all = roc_all(~isnan(roc_all));
dp_post_all = dp_post_all(~isnan(roc_post_all));
roc_post_all = roc_post_all(~isnan(roc_post_all));
dp_ant_all = dp_ant_all(~isnan(roc_ant_all));
roc_ant_all = roc_ant_all(~isnan(roc_ant_all));

subplot(2,2,3); % SMALL dF trial
dp_post_sdf = dp_post(:,1); dp_ant_sdf = dp_ant(:,1);
roc_post_sdf = mtROC_post(:,1); roc_ant_sdf = mtROC_ant(:,1);
h_post(2) = plot(dp_post_sdf,roc_post_sdf,'o'); hold on
h_ant(2) = plot(dp_ant_sdf,roc_ant_sdf,'^');
% h_post(2) = scatter(dp_post_sdf,roc_post_sdf,[],'filled','o'); hold on
% h_ant(2) = scatter(dp_ant_sdf,roc_ant_sdf,[],'filled','^');
xlim([-1 2]); ylim([0.4 0.7]);
xlabel('d prime'); ylabel('bROC');
title('small dF trials');
dp_sdf = [dp_post_sdf; dp_ant_sdf];
roc_sdf = [roc_post_sdf; roc_ant_sdf];
% remove NaN...
dp_sdf = dp_sdf(~isnan(roc_sdf));
roc_sdf = roc_sdf(~isnan(roc_sdf));
dp_post_sdf = dp_post_sdf(~isnan(roc_post_sdf));
roc_post_sdf = roc_post_sdf(~isnan(roc_post_sdf));
dp_ant_sdf = dp_ant_sdf(~isnan(roc_ant_sdf));
roc_ant_sdf = roc_ant_sdf(~isnan(roc_ant_sdf));

subplot(2,2,4); % LARGE dF trial
dp_post_ldf = dp_post(:,2); dp_ant_ldf = dp_ant(:,2);
roc_post_ldf = mtROC_post(:,2); roc_ant_ldf = mtROC_ant(:,2);
h_post(3) = plot(dp_post_ldf,roc_post_ldf,'o'); hold on
h_ant(3) = plot(dp_ant_ldf,roc_ant_ldf,'^');
% h_post(3) = scatter(dp_post_ldf,roc_post_ldf,[],'filled','o'); hold on
% h_ant(3) = scatter(dp_ant_ldf,roc_ant_ldf,[],'filled','^');
xlim([-1 2]); ylim([0.4 0.7]);
xlabel('d prime'); ylabel('bROC');
title('large dF trials');
dp_ldf = [dp_post_ldf; dp_ant_ldf];
roc_ldf = [roc_post_ldf; roc_ant_ldf];
% remove NaN...
dp_ldf = dp_ldf(~isnan(roc_ldf));
roc_ldf = roc_ldf(~isnan(roc_ldf));
dp_post_ldf = dp_post_ldf(~isnan(roc_post_ldf));
roc_post_ldf = roc_post_ldf(~isnan(roc_post_ldf));
dp_ant_ldf = dp_ant_ldf(~isnan(roc_ant_ldf));
roc_ant_ldf = roc_ant_ldf(~isnan(roc_ant_ldf));

% SET LINE PROPERTIES...
set(h_post,'LineWidth',1.5,'Color',c(1,:),'MarkerFaceColor',[1 1 1]);
set(h_ant,'LineWidth',1.5,'Color',c(2,:),'MarkerFaceColor',[1 1 1]);
% set(h_post,'MarkerFaceColor',c(1,:),'MarkerFaceAlpha',.8);
% set(h_ant,'MarkerFaceColor',c(2,:),'MarkerFaceAlpha',.8);

% % % calculate correlation % % %
c_type = 'Pearson'; %'Kendall'; %'Spearman'; %'Pearson'
% small and large dF trials combined
[r_all(1),p_all(1)] = corr(dp_all,roc_all,'type',c_type);
[r_all(2),p_all(2)] = corr(dp_post_all,roc_post_all,'type',c_type);
[r_all(3),p_all(3)] = corr(dp_ant_all,roc_ant_all,'type',c_type);
% small dF trials
[r_sdf(1),p_sdf(1)] = corr(dp_sdf,roc_sdf,'type',c_type);
[r_sdf(2),p_sdf(2)] = corr(dp_post_sdf,roc_post_sdf,'type',c_type);
[r_sdf(3),p_sdf(3)] = corr(dp_ant_sdf,roc_ant_sdf,'type',c_type);
% small dF trials
[r_ldf(1),p_ldf(1)] = corr(dp_ldf,roc_ldf,'type',c_type);
[r_ldf(2),p_ldf(2)] = corr(dp_post_ldf,roc_post_ldf,'type',c_type);
[r_ldf(3),p_ldf(3)] = corr(dp_ant_ldf,roc_ant_ldf,'type',c_type);