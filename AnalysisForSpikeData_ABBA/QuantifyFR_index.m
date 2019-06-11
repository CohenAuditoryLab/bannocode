clear all;
DATE = '20180727';
% DATE = '20190123';

addpath(genpath('C:\MatlabTools\iosr')); % toolbox for boxplot
addpath(DATE);
file_name = strcat(DATE,'_ABBA_FiringRate');
load(file_name)

active_cl = clInfo.active_cluster;
active_channel = clInfo.active_channel;
index = 1:length(list_cl);
% cl = 2; % test

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
%                 [auc(j,k,cl),dprime(j,k,cl)] = compDist(temp_a,temp_b);
                i_ab = temp_a ./ (temp_a + temp_b);
                Iab(j,k,cl) = nanmean(i_ab);
                stdiff(j,k,cl) = list_st(j);
                group(j,k,cl) = k;
            else
%                 auc(j,k,cl) = NaN;
%                 dprime(j,k,cl) = NaN;
                Iab(j,k,cl) = NaN;
                stdiff(j,k,cl) = list_st(j);
                group(j,k,cl) = k;
            end
            fr_AvsB_all{k} = [fr_AvsB_all{k}; fr_AvsB{j,k}];
        end
    end
    for k=1:3
        if (~isempty(fr_AvsB_all{k}))
%             [auc_all(k,cl),dprime_all(k,cl)] = compDist(fr_AvsB_all{k}(:,1),fr_AvsB_all{k}(:,2));
            i_ab_all = fr_AvsB_all{k}(:,1) ./ (fr_AvsB_all{k}(:,1) + fr_AvsB_all{k}(:,2));
            Iab_all(k,cl) = nanmean(i_ab_all);
        else
%             auc_all(k,cl) = NaN;
%             dprime_all(k,cl) = NaN;
            Iab_all(k,cl) = NaN;
        end
    end
end

figure; % ROC analysis
subplot(6,2,1);
histogram(Iab_all(1,:),0.35:0.02:0.95);
title('hit'); box off;
subplot(6,2,3);
histogram(Iab_all(2,:),0.35:0.02:0.95);
title('miss'); box off;
subplot(6,2,5);
histogram(Iab_all(3,:),0.35:0.02:0.95);
title('false alarm'); box off;
subplot(2,2,2);
% boxplot(auc_all'); hold on;
% plot([0.5 3.5],[0.5 0.5],':k');
% ylabel('AUC'); title('all trials combined');
% set(gca,'xTickLabel',{'hit','miss','fa'});
for k=1:3
    temp(:,:,k) = transpose(Iab_all(k,:));
end
iosr.statistics.boxPlot(temp,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'groupLabels',{'hit','miss','fa'});
hold on;
plot([0.25 1.75],[0.5 0.5],':k');
ylabel('index'); title('all trials combined');

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stdiff(:),Iab(:),group(:));
h = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'scalewidth',true,'xseparator',false,...
            'showMean',true,...
            'groupLabels',g); hold on;
x_lim = get(gca,'xlim');
plot(x_lim,[0.5 0.5],':k');
title([DATE ' AUC (A vs B)']);
xlabel('semitone diff'); ylabel('index'); box off;

% figure; % d'
% subplot(6,2,1);
% histogram(dprime_all(1,:),-1:0.2:3);
% title('hit'); box off;
% subplot(6,2,3);
% histogram(dprime_all(2,:),-1:0.2:3);
% title('miss'); box off;
% subplot(6,2,5);
% histogram(dprime_all(3,:),-1:0.2:3);
% title('false alarm'); box off;
% subplot(2,2,2);
% % boxplot(dprime_all'); hold on;
% % plot([0.5 3.5],[0 0],':k');
% % ylabel('d-prime'); title('all trials combined');
% % set(gca,'xTickLabel',{'hit','miss','fa'});
% for k=1:3
%     temp(:,:,k) = transpose(dprime_all(k,:));
% end
% iosr.statistics.boxPlot(temp,...
%             'symbolColor','k','medianColor','k','symbolMarker','+',...
%             'showScatter',true,...
%             'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
%             'scatterMarker','o',...
%             'groupLabels',{'hit','miss','fa'});
% hold on;
% plot([0.25 1.75],[0 0],':k');
% ylabel('d-prime'); title('all trials combined');
% 
% subplot(2,1,2);
% [y,x,g] = iosr.statistics.tab2box(stdiff(:),dprime(:),group(:));
% h = iosr.statistics.boxPlot(x,y,...
%             'symbolColor','k','medianColor','k','symbolMarker','+',...
%             'showScatter',true,...
%             'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
%             'scatterMarker','o',...
%             'scatterSize',24,...
%             'scatterLayer','bottom',...
%             'scalewidth',true,'xseparator',false,...
%             'groupLabels',g); hold on;
% x_lim = get(gca,'xlim');
% plot(x_lim,[0 0],':k');
% title([DATE ' d-prime (A vs B)']);
% xlabel('semitone diff'); ylabel('d-prime'); box off;
% 
% figure;
% subplot(2,1,1);
% for k=1:3
%     plot(active_channel+1,auc_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
% end
% plot([0 17],[0.5 0.5],'--k');
% title('tone A vs tone B');
% set(gca,'xlim',[0.5 16.5]);
% xlabel('channel'); ylabel('AUC');
% subplot(2,1,2);
% for k=1:3
%     plot(active_channel+1,dprime_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
% end
% plot([0 17],[0 0],'--k');
% set(gca,'xlim',[0.5 16.5]);
% xlabel('channel'); ylabel('d prime');
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% function [auc,dprime] = compDist(data_s,data_n)
% % compute area under the ROC curve and d'
% % data_a and data_b should be the data from signa and noise respectively
% 
% % ROC analysis
% num_bin = 10;
% min_data = floor(min([min(data_s) min(data_n)]));
% max_data = ceil(max([max(data_s) max(data_n)]));
% if max_data<10
%     x = 0:9;
% else
%     x = min_data:diff([min_data max_data])/num_bin:max_data;
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


