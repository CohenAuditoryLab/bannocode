clear all;
DATE = '20200114';
% DATE = '20190409';
% PATH_TO_FREQ_SELECTIVITY = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Domo\NeuralData\vProbe\02_TUNING_TEST\selectivity';
addpath(genpath('/Users/work/Documents/MATLAB/iosr')); % toollbox for boxplot % toolbox for boxplot
addpath(DATE);
% addpath(PATH_TO_FREQ_SELECTIVITY);
file_name = strcat(DATE,'_ABBA_FiringRate');
load(file_name);
% load(strcat(DATE,'_FrequencySelectivity'));

% Isp = Summary(:,3); % sparseness index
active_cl = clInfo.active_cluster;
active_channel = clInfo.active_channel;
index = 1:length(list_cl);
% cl = 2; % test
for cl=1:length(active_cl)
    cluster_id = index(list_cl==active_cl(cl));
    firing_rate_a = fr(cluster_id).a; % TargetTime x SemitoneDiff x Behavior
    % firing_rate_b = fr(cl).b; % TargetTime x SemitoneDiff x Behavior
    frFA_a = fr_tsRT(cluster_id).a; % TargetTime x Semitone Diff
    
    fr_target = cell(length(list_st),3);
    fr_nontarget = cell(length(list_st),3);
    fr_target_all = cell(1,3); % across all semitone diffs
    fr_nontarget_all = cell(1,3); % across all semitone diffs
    for i=1:length(list_tt)
        for j=1:length(list_st)
            for k=1:2 % hit and miss trials
                fr_a = firing_rate_a{i,j,k}; % hit
                t_loc = size(fr_a,2);
                fr_target{j,k} = [fr_target{j,k}; fr_a(:,t_loc)];
                fr_target_all{k} = [fr_target_all{k}; fr_a(:,t_loc)];
                for ii=i+1:length(list_tt)
                    fr_a = firing_rate_a{ii,j,k};
                    fr_nontarget{j,k} = [fr_nontarget{j,k}; fr_a(:,t_loc)];
                    fr_nontarget_all{k} = [fr_nontarget_all{k}; fr_a(:,t_loc)];
                end
            end
            
            % false alarm trials
            fr_a = frFA_a{i,j};
            t_loc = size(fr_a,2);
            fr_target{j,3} = [fr_target{j,3}; fr_a(:,t_loc)];
            fr_target_all{3} = [fr_target_all{3}; fr_a(:,t_loc)];
            for ii=i+1:length(list_tt)
                fr_a = frFA_a{ii,j};
                fr_nontarget{j,3} = [fr_nontarget{j,3}; fr_a(:,t_loc)];
                fr_nontarget_all{3} = [fr_nontarget_all{3}; fr_a(:,t_loc)];
            end
        end
    end
    
    % Do NOT display false alarm trials in the plot
    for j=1:length(list_st)
        for k=1:2 %3
            if (~isempty(fr_target{j,k}) * ~isempty(fr_nontarget{j,k}))
                [auc(j,k,cl),dprime(j,k,cl)] = compDist(fr_target{j,k},fr_nontarget{j,k});
                stdiff(j,k,cl) = list_st(j);
%                 stdiff(j,k,cl) = j;
                group(j,k,cl) = k;
            else
                auc(j,k,cl) = NaN;
                dprime(j,k,cl) = NaN;
                stdiff(j,k,cl) = list_st(j);
%                 stdiff(j,k,cl) = j;
                group(j,k,cl) = k;
            end
        end
    end
    for k=1:2 %3
        if (~isempty(fr_target_all{k}) * ~isempty(fr_nontarget_all{k}))
            [auc_all(k,cl),dprime_all(k,cl)] = compDist(fr_target_all{k},fr_nontarget_all{k});
        else
            auc_all(k,cl) = NaN;
            dprime_all(k,cl) = NaN;
        end
    end
    
    % compare hit and miss trials
    for j=1:length(list_st)
        [auc_hm(j,cl),dprime_hm(j,cl)] = compDist(fr_target{j,1},fr_target{j,2});
        stdiff_hm(j,cl) = list_st(j);
        group_hm(j,cl) = 1;
    end
    [auc_hm_all(1,cl),dprime_hm_all(1,cl)] = compDist(fr_target_all{1},fr_nontarget_all{2});
end
HvsM.auc = auc_hm; % semitone diss x unit
HvsM.auc_all = auc_hm_all; % 1 x unit
HvsM.dprime = dprime_hm; % semitone diss x unit
HvsM.dprime_all = dprime_hm_all; % 1 x unit
HvsM.stdiff = stdiff_hm; % semitone diss x unit
HvsM.group = group_hm; % semitone diss x unit

c = [100 100 100; 51 102 255; 255 0 0] / 255; % set line color
figure; % ROC analysis
subplot(6,2,1);
histogram(auc_all(1,:),0.35:0.02:0.95);
title('hit'); box off;
subplot(6,2,3);
histogram(auc_all(2,:),0.35:0.02:0.95);
title('miss'); box off;
% subplot(6,2,5);
% histogram(auc_all(3,:),0.35:0.02:0.95);
% title('false alarm'); box off;

subplot(2,2,2);
% boxplot(auc_all'); hold on;
% plot([0.5 3.5],[0.5 0.5],':k');
% ylabel('AUC'); title('all trials combined');
% set(gca,'xTickLabel',{'hit','miss','fa'});
for k=1:2 %3
    temp(:,:,k) = transpose(auc_all(k,:));
end
h_tnt_auc_all = iosr.statistics.boxPlot(temp,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1]},...
            'scatterMarker','o',...
            'groupLabels',{'hit','miss','fa'});
hold on;
plot([0.25 1.75],[0.5 0.5],':k');
ylabel('AUC'); title('all trials combined');

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stdiff(:),auc(:),group(:));
h_tnt_auc_std = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'scalewidth',true,'xseparator',false,...
            'groupLabels',g); hold on;
set(gca,'xTickLabel',list_st);
x_lim = get(gca,'xlim');
plot(x_lim,[0.5 0.5],':k');
title([DATE ' AUC (target vs non-target)']);
xlabel('semitone diff'); ylabel('AUC'); box off;
saveas(gcf,[DATE '_TvsNT_roc'],'png');

figure; % d'
subplot(6,2,1);
histogram(dprime_all(1,:),-1:0.2:3);
title('hit'); box off;
subplot(6,2,3);
histogram(dprime_all(2,:),-1:0.2:3);
title('miss'); box off;
% subplot(6,2,5);
% histogram(dprime_all(3,:),-1:0.2:3);
% title('false alarm'); box off;
subplot(2,2,2);
% boxplot(dprime_all'); hold on;
% plot([0.5 3.5],[0 0],':k');
% ylabel('d-prime'); title('all trials combined');
% set(gca,'xTickLabel',{'hit','miss','fa'});
for k=1:2 %3
    temp(:,:,k) = transpose(dprime_all(k,:));
end
h_tnt_dp_all = iosr.statistics.boxPlot(temp,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1]},...
            'scatterMarker','o',...
            'groupLabels',{'hit','miss','fa'});
hold on;
plot([0.25 1.75],[0 0],':k');
ylabel('d-prime'); title('all trials combined');

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stdiff(:),dprime(:),group(:));
h_tnt_dp_std = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'scalewidth',true,'xseparator',false,...
            'groupLabels',g); hold on;
set(gca,'xTickLabel',list_st);
x_lim = get(gca,'xlim');
plot(x_lim,[0 0],':k');
title([DATE ' d-prime (target vs non-target)']);
xlabel('semitone diff'); ylabel('d-prime'); box off;
saveas(gcf,[DATE '_TvsNT_dprime'],'png');

figure;
subplot(2,1,1);
for k=1:2
    plot(active_channel+1,auc_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
plot([0 17],[0.5 0.5],'--k');
title('target vs non-target');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('AUC');
subplot(2,1,2);
for k=1:2
    plot(active_channel+1,dprime_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
plot([0 17],[0 0],'--k');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('d prime');
saveas(gcf,[DATE '_TvsNT_acrossCh'],'png');


TvsNT.auc = auc;
TvsNT.auc_all = auc_all;
TvsNT.dprime = dprime;
TvsNT.dprime_all = dprime_all;
TvsNT.stdiff = stdiff;
TvsNT.group = group;
% figure; % correlation sparseness index vs AUC
% for cl=1:size(dprime_all,2)
%     SPINDEX(cl) = Isp(active_channel(cl)+1);
% end
% plot(SPINDEX,auc_all(1,:),'o'); hold on
% plot(SPINDEX,auc_all(2,:),'o');
% plot(SPINDEX,auc_all(3,:),'o');
% plot([0.1 0.9],[0.1 0.9],'--k');

for cl=1:length(active_cl)
    cluster_id = index(list_cl==active_cl(cl));
    fr_AvsB = fr(cluster_id).AvsB; % SemitoneDiff x Behavior
    % firing_rate_b = fr(cl).b; % TargetTime x SemitoneDiff x Behavior
    
    fr_AvsB_all = cell(1,3);
    for j=1:length(list_st)
        for k=1:3
            if (~isempty(fr_AvsB{j,k}))
                temp_a = fr_AvsB{j,k}(:,1);
                temp_b = fr_AvsB{j,k}(:,2);
                [auc(j,k,cl),dprime(j,k,cl)] = compDist(temp_a,temp_b);
                stdiff(j,k,cl) = list_st(j);
%                 stdiff(j,k,cl) = j;
                group(j,k,cl) = k;
            else
                auc(j,k,cl) = NaN;
                dprime(j,k,cl) = NaN;
                stdiff(j,k,cl) = list_st(j);
%                 stdiff(j,k,cl) = j;
                group(j,k,cl) = k;
            end
            fr_AvsB_all{k} = [fr_AvsB_all{k}; fr_AvsB{j,k}];
        end
    end
    for k=1:3
        if (~isempty(fr_AvsB_all{k}))
            [auc_all(k,cl),dprime_all(k,cl)] = compDist(fr_AvsB_all{k}(:,1),fr_AvsB_all{k}(:,2));
        else
            auc_all(k,cl) = NaN;
            dprime_all(k,cl) = NaN;
        end
    end
end
figure; % ROC analysis
subplot(6,2,1);
histogram(auc_all(1,:),0.35:0.02:0.95);
title('hit'); box off;
subplot(6,2,3);
histogram(auc_all(2,:),0.35:0.02:0.95);
title('miss'); box off;
subplot(6,2,5);
histogram(auc_all(3,:),0.35:0.02:0.95);
title('false alarm'); box off;
subplot(2,2,2);
% boxplot(auc_all'); hold on;
% plot([0.5 3.5],[0.5 0.5],':k');
% ylabel('AUC'); title('all trials combined');
% set(gca,'xTickLabel',{'hit','miss','fa'});
for k=1:3
    temp(:,:,k) = transpose(auc_all(k,:));
end
h_anb_auc_all = iosr.statistics.boxPlot(temp,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'groupLabels',{'hit','miss','fa'});
hold on;
plot([0.25 1.75],[0.5 0.5],':k');
ylabel('AUC'); title('all trials combined');

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stdiff(:),auc(:),group(:));
h_anb_auc_std = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'scalewidth',true,'xseparator',false,...
            'groupLabels',g); hold on;
set(gca,'xTickLabel',list_st);
x_lim = get(gca,'xlim');
plot(x_lim,[0.5 0.5],':k');
title([DATE ' AUC (A vs B)']);
xlabel('semitone diff'); ylabel('AUC'); box off;
saveas(gcf,[DATE '_AvsB_roc'],'png');

figure; % d'
subplot(6,2,1);
histogram(dprime_all(1,:),-1:0.2:3);
title('hit'); box off;
subplot(6,2,3);
histogram(dprime_all(2,:),-1:0.2:3);
title('miss'); box off;
subplot(6,2,5);
histogram(dprime_all(3,:),-1:0.2:3);
title('false alarm'); box off;
subplot(2,2,2);
% boxplot(dprime_all'); hold on;
% plot([0.5 3.5],[0 0],':k');
% ylabel('d-prime'); title('all trials combined');
% set(gca,'xTickLabel',{'hit','miss','fa'});
for k=1:3
    temp(:,:,k) = transpose(dprime_all(k,:));
end
h_anb_dp_all = iosr.statistics.boxPlot(temp,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'groupLabels',{'hit','miss','fa'});
hold on;
plot([0.25 1.75],[0 0],':k');
ylabel('d-prime'); title('all trials combined');

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stdiff(:),dprime(:),group(:));
h_anb_dp_std = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'scalewidth',true,'xseparator',false,...
            'groupLabels',g); hold on;
set(gca,'xTickLabel',list_st);
x_lim = get(gca,'xlim');
plot(x_lim,[0 0],':k');
title([DATE ' d-prime (A vs B)']);
xlabel('semitone diff'); ylabel('d-prime'); box off;
saveas(gcf,[DATE '_AvsB_dprime'],'png');

figure;
subplot(2,1,1);
for k=1:3
    plot(active_channel+1,auc_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
plot([0 17],[0.5 0.5],'--k');
title('tone A vs tone B');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('AUC');
subplot(2,1,2);
for k=1:3
    plot(active_channel+1,dprime_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
plot([0 17],[0 0],'--k');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('d prime');
saveas(gcf,[DATE '_AvsB_acrossCh'],'png');

AvsB.auc = auc;
AvsB.auc_all = auc_all;
AvsB.dprime = dprime;
AvsB.dprime_all = dprime_all;
AvsB.stdiff = stdiff;
AvsB.group = group;


for cl=1:length(active_cl)
    cluster_id = index(list_cl==active_cl(cl));
    fr_adapt = fr(cluster_id).adapt; % SemitoneDiff x Behavior
    % firing_rate_b = fr(cl).b; % TargetTime x SemitoneDiff x Behavior
    
    fr_adapt_all = cell(1,3);
    for j=1:length(list_st)
        for k=1:3
            if (~isempty(fr_adapt{j,k}))
                temp_a1 = fr_adapt{j,k}(:,1); % 1st a
                temp_atm1 = fr_adapt{j,k}(:,2); % T-1th a
                [auc(j,k,cl),dprime(j,k,cl)] = compDist(temp_a1,temp_atm1);
                stdiff(j,k,cl) = list_st(j);
%                 stdiff(j,k,cl) = j;
                group(j,k,cl) = k;
            else
                auc(j,k,cl) = NaN;
                dprime(j,k,cl) = NaN;
                stdiff(j,k,cl) = list_st(j);
%                 stdiff(j,k,cl) = j;
                group(j,k,cl) = k;
            end
            fr_adapt_all{k} = [fr_adapt_all{k}; fr_adapt{j,k}];
        end
    end
    for k=1:3
        if (~isempty(fr_adapt_all{k}))
            [auc_all(k,cl),dprime_all(k,cl)] = compDist(fr_adapt_all{k}(:,1),fr_adapt_all{k}(:,2));
        else
            auc_all(k,cl) = NaN;
            dprime_all(k,cl) = NaN;
        end
    end
end
figure; % ROC analysis
subplot(6,2,1);
histogram(auc_all(1,:),0.35:0.02:0.95);
title('hit'); box off;
subplot(6,2,3);
histogram(auc_all(2,:),0.35:0.02:0.95);
title('miss'); box off;
subplot(6,2,5);
histogram(auc_all(3,:),0.35:0.02:0.95);
title('false alarm'); box off;
subplot(2,2,2);
% boxplot(auc_all'); hold on;
% plot([0.5 3.5],[0.5 0.5],':k');
% ylabel('AUC'); title('all trials combined');
% set(gca,'xTickLabel',{'hit','miss','fa'});
for k=1:3
    temp(:,:,k) = transpose(auc_all(k,:));
end
h_anb_auc_all = iosr.statistics.boxPlot(temp,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'groupLabels',{'hit','miss','fa'});
hold on;
plot([0.25 1.75],[0.5 0.5],':k');
ylabel('AUC'); title('all trials combined');

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stdiff(:),auc(:),group(:));
h_anb_auc_std = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'scalewidth',true,'xseparator',false,...
            'groupLabels',g); hold on;
set(gca,'xTickLabel',list_st);
x_lim = get(gca,'xlim');
plot(x_lim,[0.5 0.5],':k');
title([DATE ' AUC (adaptation)']); % 1st A vs T-1th A
xlabel('semitone diff'); ylabel('AUC'); box off;
saveas(gcf,[DATE,'_adaptation_roc'],'png');

figure; % d'
subplot(6,2,1);
histogram(dprime_all(1,:),-1:0.2:3);
title('hit'); box off;
subplot(6,2,3);
histogram(dprime_all(2,:),-1:0.2:3);
title('miss'); box off;
subplot(6,2,5);
histogram(dprime_all(3,:),-1:0.2:3);
title('false alarm'); box off;
subplot(2,2,2);
% boxplot(dprime_all'); hold on;
% plot([0.5 3.5],[0 0],':k');
% ylabel('d-prime'); title('all trials combined');
% set(gca,'xTickLabel',{'hit','miss','fa'});
for k=1:3
    temp(:,:,k) = transpose(dprime_all(k,:));
end
h_anb_dp_all = iosr.statistics.boxPlot(temp,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'groupLabels',{'hit','miss','fa'});
hold on;
plot([0.25 1.75],[0 0],':k');
ylabel('d-prime'); title('all trials combined');

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stdiff(:),dprime(:),group(:));
h_anb_dp_std = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'scalewidth',true,'xseparator',false,...
            'groupLabels',g); hold on;
set(gca,'xTickLabel',list_st);
x_lim = get(gca,'xlim');
plot(x_lim,[0 0],':k');
title([DATE ' d-prime (adaptation)']); % 1st A vs T-1th A
xlabel('semitone diff'); ylabel('d-prime'); box off;
saveas(gcf,[DATE,'_adaptation_dprime'],'png');

figure;
subplot(2,1,1);
for k=1:3
    plot(active_channel+1,auc_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
plot([0 17],[0.5 0.5],'--k');
title('adaptation'); % 1st A vs (T-1)th A
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('AUC');
subplot(2,1,2);
for k=1:3
    plot(active_channel+1,dprime_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
plot([0 17],[0 0],'--k');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('d prime');
saveas(gcf,[DATE,'adaptation_acrossCh'],'png');

Adapt.auc = auc;
Adapt.auc_all = auc_all;
Adapt.dprime = dprime;
Adapt.dprime_all = dprime_all;
Adapt.stdiff = stdiff;
Adapt.group = group;

% save result
params.list_st = list_st;
params.list_tt = list_tt;
params.ProcessedData = file_name;
save_file_name = [DATE,'_dPrimeROC'];
save(save_file_name,'TvsNT','AvsB','Adapt','HvsM','clInfo','params');

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% function [auc,dprime] = compDist(data_s,data_n)
% % compute area under the ROC curve and d'
% % data_a and data_b should be the data from signal and noise respectively
% 
% % ROC analysis
% num_bin = 10;
% min_data = floor(min([min(data_s) min(data_n)]));
% max_data = ceil(max([max(data_s) max(data_n)]));
% if max_data<10
%     x = 0:9;
% else
%     if min_data==max_data
%         x = num_bin;
%     else
%         x = min_data:diff([min_data max_data])/num_bin:max_data;
%     end
% end
% hist_s = histcounts(data_s,x);
% hist_n = histcounts(data_n,x);
% for i=1:num_bin
%     prob_s(i) = sum(hist_s(i:end)) / sum(hist_s);
%     prob_n(i) = sum(hist_n(i:end)) / sum(hist_n);
% end
% auc = -trapz(prob_n,prob_s);
% 
% % calculate d'
% mu_s = mean(data_s);
% mu_n = mean(data_n);
% sigma_s = std(data_s);
% sigma_n = std(data_n);
% dprime = (mu_s - mu_n) / sqrt((sigma_s^2+sigma_n^2)/2);
% end


