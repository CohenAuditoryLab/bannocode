clear all;
% DATE = '20180727';
DATE = '20190123';

addpath(genpath('C:\MatlabTools\iosr')); % toolbox for boxplot
addpath(DATE);
file_name = strcat(DATE,'_ABBA_FiringRate');
load(file_name)

active_cl = clInfo.active_cluster;
index = 1:length(list_cl);
% cl = 2; % test

% choice probability for target
zfr_target = cell(1,2);
for cl=1:length(active_cl)
    cluster_id = index(list_cl==active_cl(cl));
    fr_target = fr(cluster_id).target; % SemitoneDiff x Behavior
    % firing_rate_b = fr(cl).b; % TargetTime x SemitoneDiff x Behavior
    
    fr_target_all = cell(1,3);
    for j=1:length(list_st)
%         for k=1:3
            if (~isempty(fr_target{j,1}) * ~isempty(fr_target{j,2}))
                temp_hit = fr_target{j,1};
                temp_miss = fr_target{j,2};
                [cp(j,cl),dprime(j,cl)] = compDist(temp_hit,temp_miss);
            else
                cp(j,cl) = NaN;
                dprime(j,cl) = NaN;
            end
            fr_target_all{1} = [fr_target_all{1}; fr_target{j,1}]; % hit
            fr_target_all{2} = [fr_target_all{2}; fr_target{j,2}]; % miss
%         end
    end
    n = length(fr_target_all{1});
    zfr = zscore([fr_target_all{1}; fr_target_all{2}]);
    zfr_target{1} = [zfr_target{1}; zfr(1:n)]; % hit
    zfr_target{2} = [zfr_target{2}; zfr(n+1:end)]; % miss
    clear zfr;
    
    % choice probability for each cluster
    if (~isempty(fr_target_all{1}) * ~isempty(fr_target_all{2}))
        [cp_all(cl),dprime_all(cl)] = compDist(fr_target_all{1},fr_target_all{2});
    else
        cp_all(cl) = NaN;
        dprime_all(cl) = NaN;
    end
end
figure;
subplot(4,2,1);
histogram(zfr_target{1},15);
title('distribution of firing rate');
xlabel('firing rate [z-score]'); ylabel('hit'); box off;
subplot(4,2,3);
histogram(zfr_target{2},15);
xlabel('firing rate [z-score]'); ylabel('miss'); box off;

subplot(2,2,2);
iosr.statistics.boxPlot(cp_all',...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterMarker','o');
hold on;
plot([0.25 1.75],[0.5 0.5],':k');
ylabel('choice probability'); title('target');

% choice probability for non-target toneA
zfr_nontarget = cell(1,2);
for cl=1:length(active_cl)
    cluster_id = index(list_cl==active_cl(cl));
    
    firing_rate_a = fr(cluster_id).a; % TargetTime x SemitoneDiff x Behavior
    fr_nontarget = cell(length(list_st),3);
    fr_nontarget_all = cell(1,3); % across all semitone diffs
    for i=1:length(list_tt)
        for j=1:length(list_st)
            for k=1:3
                fr_a = firing_rate_a{i,j,k};
                t_loc = size(fr_a,2);
                for ii=i+1:length(list_tt)
                    fr_a = firing_rate_a{ii,j,k};
                    fr_nontarget{j,k} = [fr_nontarget{j,k}; fr_a(:,t_loc)];
                    fr_nontarget_all{k} = [fr_nontarget_all{k}; fr_a(:,t_loc)];
                end
            end
        end
    end
    fr_nontarget_all = cell(1,2);
    for j=1:length(list_st)
%         for k=1:3
            if (~isempty(fr_nontarget{j,1}) * ~isempty(fr_nontarget{j,2}))
                temp_hit = fr_nontarget{j,1};
                temp_miss = fr_nontarget{j,2};
                [cp(j,cl),dprime(j,cl)] = compDist(temp_hit,temp_miss);
            else
                cp(j,cl) = NaN;
                dprime(j,cl) = NaN;
            end
            fr_nontarget_all{1} = [fr_nontarget_all{1}; fr_nontarget{j,1}]; % hit
            fr_nontarget_all{2} = [fr_nontarget_all{2}; fr_nontarget{j,2}]; % miss
%         end
    end
    n = length(fr_nontarget_all{1});
    zfr = zscore([fr_nontarget_all{1}; fr_nontarget_all{2}]);
    zfr_nontarget{1} = [zfr_nontarget{1}; zfr(1:n)]; % hit
    zfr_nontarget{2} = [zfr_nontarget{2}; zfr(n+1:end)]; % miss
    clear zfr;
    
    % choice probability for each cluster
    if (~isempty(fr_nontarget_all{1}) * ~isempty(fr_nontarget_all{2}))
        [cp_all(cl),dprime_all(cl)] = compDist(fr_nontarget_all{1},fr_nontarget_all{2});
    else
        cp_all(cl) = NaN;
        dprime_all(cl) = NaN;
    end
end
figure;
subplot(4,2,1);
histogram(zfr_nontarget{1},15);
title('distribution of firing rate');
xlabel('firing rate [z-score]'); ylabel('hit'); box off;
subplot(4,2,3);
histogram(zfr_nontarget{2},15);
xlabel('firing rate [z-score]'); ylabel('miss'); box off;

subplot(2,2,2);
iosr.statistics.boxPlot(cp_all',...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterMarker','o');
hold on;
plot([0.25 1.75],[0.5 0.5],':k');
ylabel('choice probability'); title('nontarget');


% % % % % % % % % % % % % % % 
function [auc,dprime] = compDist(data_s,data_n)
% compute area under the ROC curve and d'
% data_a and data_b should be the data from signa and noise respectively

% ROC analysis
num_bin = 10;
min_data = floor(min([min(data_s) min(data_n)]));
max_data = ceil(max([max(data_s) max(data_n)]));
if max_data<10
    x = 0:9;
else
    x = min_data:diff([min_data max_data])/num_bin:max_data;
end
hist_s = histcounts(data_s,x);
hist_n = histcounts(data_n,x);
for i=1:num_bin
    prob_s(i) = sum(hist_s(i:end)) / sum(hist_s);
    prob_n(i) = sum(hist_n(i:end)) / sum(hist_n);
end
auc = -trapz(prob_n,prob_s);

% calculate d'
mu_s = mean(data_s);
mu_n = mean(data_n);
sigma_s = std(data_s);
sigma_n = std(data_n);
dprime = (mu_s - mu_n) / sqrt((sigma_s^2+sigma_n^2)/2);
end


