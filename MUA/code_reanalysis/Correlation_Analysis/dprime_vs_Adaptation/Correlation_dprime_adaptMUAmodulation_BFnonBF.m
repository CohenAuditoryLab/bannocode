% correlation between behavioral d-prime and adaptROC
% modified from Correlation_behav_MUAmodulation_ver2.m
clear all

% SET PATH FOR DATA DIRECTORY
% path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\code'; % old
path_dp = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\reanalysis_code';
path_roc = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_AdaptDev';

% SET PARAMETERS
c = [1 0 0; 0 0.75 0.75]; % line color
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

mtROC_BF = []; mtROC_nonBF = [];
dp_BF = []; dp_nonBF = [];
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

% conbine data BF/non-BF
mtROC_BF = cat(1,mtROC_BF_post,mtROC_BF_ant);
mtROC_nonBF  = cat(1,mtROC_nonBF_post,mtROC_nonBF_ant);
dp_BF = cat(1,dp_BF_post,dp_BF_ant);
dp_nonBF  = cat(1,dp_nonBF_post,dp_nonBF_ant);

% PLOT 
x_range = [-1 2];
y_range = [0.1 0.9];
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


%% % % % CORRELATION ANALYSIS % % %
% small and large dF trials combined
[r_all(1),p_all(1)] = corr(DP_all,ROC_all,'type',c_type);
[r_all(2),p_all(2)] = corr(DP_BF_all,ROC_BF_all,'type',c_type);
[r_all(3),p_all(3)] = corr(DP_nonBF_all,ROC_nonBF_all,'type',c_type);

for i=1:4
    [r_stdiff(i,1),p_stdiff(i,1)] = corr(DP_stdiff{i},ROC_stdiff{i},'type',c_type);
    [r_stdiff(i,2),p_stdiff(i,2)] = corr(DP_BF_stdiff{i},ROC_BF_stdiff{i},'type',c_type);
    [r_stdiff(i,3),p_stdiff(i,3)] = corr(DP_nonBF_stdiff{i},ROC_nonBF_stdiff{i},'type',c_type);
end
% % FDR correction (not sure if need it)...
% p_stdiff_adj = reshape(mafdr(p_stdiff(:),'BHFDR',true),size(p_stdiff));