% correlation between behavioral d-prime and adaptROC
% modified from Correlation_behav_MUAmodulation_ver2.m
clear all

% SET PATH FOR DATA DIRECTORY
% path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\code'; % old
path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\reanalysis_code';
path_roc = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AdaptDev';

% SET PARAMETERS
c = [153 0 255; 0 204 0] / 255; % line color
c_type = 'Pearson'; %'Kendall'; %'Spearman'; %'Pearson'
trial_type = 'combined'; % 'combined', 'hit', or 'miss'

% SET VERSION
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

mtROC_post = []; mtROC_ant = [];
dp_post = []; dp_ant = [];
%% % % % BF sites % % %
BF_Session = 'low'; % data from BF sites
load(fullfile(path_dp,strcat('BehavioralDPrime_',BF_Session,'BF')));
load(fullfile(path_roc,strcat('ROC_Both_AdaptDev_A_',BF_Session,'BF')));

% obtain ROC for target (ch x session x stdiff x all-hit-miss)
tROC_BF_post = squeeze(AUC.post.adaptation(:,:,:,ii));
tROC_BF_ant  = squeeze(AUC.ant.adaptation(:,:,:,ii));

% obtain dp
dprime = DP'; % including intermediate dFs
dp_BF_post = dprime(AP_index==1,:);
dp_BF_ant  = dprime(AP_index==0,:);


%% % % % nonBF sites % % %
BF_Session = 'high'; % data from BF sites
load(fullfile(path_dp,strcat('BehavioralDPrime_',BF_Session,'BF')));
if v==1
    disp('version 1: choose B1 for non-BF sites');
    load(fullfile(path_roc,strcat('ROC_Both_AdaptDev_B1_',BF_Session,'BF')));
elseif v==2
    disp('version 2: choose A for non-BF sites');
    load(fullfile(path_roc,strcat('ROC_Both_AdaptDev_A_',BF_Session,'BF')));
end


% obtain ROC for target (ch x session x stdiff x all-hit-miss)
tROC_nonBF_post = squeeze(AUC.post.adaptation(:,:,:,ii));
tROC_nonBF_ant  = squeeze(AUC.ant.adaptation(:,:,:,ii));

% obtain dp
dprime = DP'; % including intermediate dFs
dp_nonBF_post = dprime(AP_index==1,:);
dp_nonBF_ant  = dprime(AP_index==0,:);

%% % % % PLOT % % %
% take the mean across channels
mtROC_BF_post = squeeze(nanmean(tROC_BF_post,1));
mtROC_BF_ant = squeeze(nanmean(tROC_BF_ant,1));
mtROC_nonBF_post  = squeeze(nanmean(tROC_nonBF_post,1));
mtROC_nonBF_ant  = squeeze(nanmean(tROC_nonBF_ant,1));

% conbine data posterior/anterior
mtROC_post = cat(1,mtROC_BF_post,mtROC_nonBF_post);
mtROC_ant  = cat(1,mtROC_BF_ant,mtROC_nonBF_ant);
dp_post = cat(1,dp_BF_post,dp_nonBF_post);
dp_ant  = cat(1,dp_BF_ant,dp_nonBF_ant);

% PLOT 
x_range = [-1 2];
y_range = [0.1 0.9];
% figure('Position',[680,480,560,500]);
figure('Position',[440,480,1190,500]);
subplot(1,2,1); % all
dp_post_all = dp_post(:); dp_ant_all = dp_ant(:);
roc_post_all = mtROC_post(:); roc_ant_all = mtROC_ant(:);
h_post(1) = plot(dp_post_all,roc_post_all,'o'); hold on
h_ant(1) = plot(dp_ant_all,roc_ant_all,'^');
% h_post(1) = scatter(dp_post_all,roc_post_all,[],'filled','o'); hold on
% h_ant(1) = scatter(dp_ant_all,roc_ant_all,[],'filled','^');
xlim(x_range); ylim(y_range);
xlabel('d prime'); ylabel('bROC');
title('all dF levels combined');
legend({'Posterior','Anterior'});
dp_all = [dp_post_all; dp_ant_all];
roc_all = [roc_post_all; roc_ant_all];
% remove NaN...
DP_all = dp_all(~isnan(roc_all));
ROC_all = roc_all(~isnan(roc_all));
DP_post_all = dp_post_all(~isnan(roc_post_all));
ROC_post_all = roc_post_all(~isnan(roc_post_all));
DP_ant_all = dp_ant_all(~isnan(roc_ant_all));
ROC_ant_all = roc_ant_all(~isnan(roc_ant_all));

pos = [3 4 7 8]; % figure position
t_label = {'smallest dF','small dF','large dF','largest dF'};
for i=1:4
    subplot(2,4,pos(i));
    dp_post_stdiff = dp_post(:,i); dp_ant_stdiff = dp_ant(:,i);
    roc_post_stdiff = mtROC_post(:,i); roc_ant_stdiff = mtROC_ant(:,i);
    h_post(i+1) = plot(dp_post_stdiff,roc_post_stdiff,'o'); hold on
    h_ant(i+1) = plot(dp_ant_stdiff,roc_ant_stdiff,'^');
    xlim(x_range); ylim(y_range);
    xlabel('d prime'); ylabel('bROC');
    title(t_label(i));
    dp_stdiff = [dp_post_stdiff; dp_ant_stdiff];
    roc_stdiff = [roc_post_stdiff; roc_ant_stdiff];
    % remove NaN...
    DP_stdiff{i} = dp_stdiff(~isnan(roc_stdiff));
    ROC_stdiff{i} = roc_stdiff(~isnan(roc_stdiff));
    DP_post_stdiff{i} = dp_post_stdiff(~isnan(roc_post_stdiff));
    ROC_post_stdiff{i} = roc_post_stdiff(~isnan(roc_post_stdiff));
    DP_ant_stdiff{i} = dp_ant_stdiff(~isnan(roc_ant_stdiff));
    ROC_ant_stdiff{i} = roc_ant_stdiff(~isnan(roc_ant_stdiff));
    clear dp_stdiff dp_post_stdiff dp_ant_stdiff
    clear roc_stdiff roc_post_stdiff roc_ant_stdiff
end

% SET LINE PROPERTIES...
set(h_post,'LineWidth',1.5,'Color',c(1,:),'MarkerFaceColor',[1 1 1]);
set(h_ant,'LineWidth',1.5,'Color',c(2,:),'MarkerFaceColor',[1 1 1]);




%% % % % CORRELATION ANALYSIS % % %
% small and large dF trials combined
[r_all(1),p_all(1)] = corr(DP_all,ROC_all,'type',c_type);
[r_all(2),p_all(2)] = corr(DP_post_all,ROC_post_all,'type',c_type);
[r_all(3),p_all(3)] = corr(DP_ant_all,ROC_ant_all,'type',c_type);

for i=1:4
    [r_stdiff(i,1),p_stdiff(i,1)] = corr(DP_stdiff{i},ROC_stdiff{i},'type',c_type);
    [r_stdiff(i,2),p_stdiff(i,2)] = corr(DP_post_stdiff{i},ROC_post_stdiff{i},'type',c_type);
    [r_stdiff(i,3),p_stdiff(i,3)] = corr(DP_ant_stdiff{i},ROC_ant_stdiff{i},'type',c_type);
end
% % FDR correction (not sure if need it)...
% p_stdiff_adj = reshape(mafdr(p_stdiff(:),'BHFDR',true),size(p_stdiff));