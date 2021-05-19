clear all;
addpath(genpath('C:\MatlabTools\iosr'));

% ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Domo\NeuralData\vProbe\06_ABBA_KILOSORT\';
ROOT_DIR = '/Volumes/TOSHIBA_EXT/01_STREAMING/ANALYSIS/analysis_after_20190821/';
% LIST_DATE = {'20180907'}; % test
LIST_DATE_A1 = {'20180709','20180727','20180807','20180907'}; % A1
LIST_DATE_BELT = {'20181210','20181212','20190123','20190409'}; % non-primary auditory cortex
LIST_STDIFF = [4 8 10 16 24];
REC_SITE_A1 = [-4 0; -4 0; -4 0; -4 0];
REC_SITE_BELT = [-1 3; -1 3; 5 5; 3 3];
REC_SITE_ORIGIN = [-4 0];

n_a1 = size(REC_SITE_A1,1); % number of recording sites in A1
xy_a1 = REC_SITE_A1 - ones(n_a1,1) * REC_SITE_ORIGIN;
for n=1:n_a1
    dist_a1(n) = norm(xy_a1(n,:));
end

n_belt = size(REC_SITE_BELT,1); % number of recording sites in belt
xy_belt = REC_SITE_BELT - ones(size(REC_SITE_BELT,1),1) * REC_SITE_ORIGIN;
for n=1:n_belt
    dist_belt(n) = norm(xy_belt(n,:));
end

a1.vs = []; a1.vs_all = []; a1.vs_ch = cell(1,16); a1.vs_layer = cell(1,6);
a1.stdiff = []; a1.group = []; a1.active_channel = []; a1.active_layer = [];
meanVS_a1 = [];
for ff=1:length(LIST_DATE_A1)
    date = LIST_DATE_A1{ff};
    addpath(fullfile(ROOT_DIR,date));
    
    load(strcat(date,'_ABBA_VectorStrength'));
    load(strcat(date,'_LayerBoundary'));
    
    % assign layer for each channel
    active_layer = nan(size(clInfo.active_channel));
    for j=numel(lb):-1:1
        active_layer(clInfo.active_channel<lb(j)) = j;
    end
    active_layer(isnan(active_layer)) = numel(lb)+1;
    
%     list_st = params.list_st;
    a1.active_channel = [a1.active_channel clInfo.active_channel];
    a1.active_layer = [a1.active_layer active_layer];
    
    a1.vs = [a1.vs; VS(:)];
    a1.vs_all = cat(2,a1.vs_all,VS_all);
    a1.stdiff = [a1.stdiff; stdiff(:)];
    a1.group = [a1.group; group(:)];
    meanVS_a1 = [meanVS_a1 nanmean(VS_all,2)];
    
    % dprime_ch = cell(1,16);
    for i=1:16 % channel id
        a1.vs_ch{i} = [a1.vs_ch{i} VS_all(:,clInfo.active_channel==i-1)];
    end
    for j=1:6 % six layers
        a1.vs_layer{j} = [a1.vs_layer{j} VS_all(:,active_layer==j)];
    end
    clear active_layer
end

belt.vs = []; belt.vs_all = []; belt.vs_ch = cell(1,16); belt.vs_layer = cell(1,6);
belt.stdiff = []; belt.group = []; belt.active_channel = []; belt.active_layer = [];
meanVS_belt = [];
for ff=1:length(LIST_DATE_BELT)
    date = LIST_DATE_BELT{ff};
    addpath(fullfile(ROOT_DIR,date));
    
    load(strcat(date,'_ABBA_VectorStrength'));
    load(strcat(date,'_LayerBoundary'));
    
    % assign layer for each channel
    active_layer = nan(size(clInfo.active_channel));
    for j=numel(lb):-1:1
        active_layer(clInfo.active_channel<lb(j)) = j;
    end
    active_layer(isnan(active_layer)) = numel(lb)+1;
    
%     list_st = params.list_st;
    belt.active_channel = [belt.active_channel clInfo.active_channel];
    belt.active_layer = [belt.active_layer active_layer];
    
    belt.vs = [belt.vs; VS(:)];
    belt.vs_all = cat(2,belt.vs_all,VS_all);
    belt.stdiff = [belt.stdiff; stdiff(:)];
    belt.group = [belt.group; group(:)];
    meanVS_belt = [meanVS_belt nanmean(VS_all,2)];
    
    % dprime_ch = cell(1,16);
    for i=1:16 % channel id
        belt.vs_ch{i} = [belt.vs_ch{i} VS_all(:,clInfo.active_channel==i-1)];
    end
    for j=1:6 % six layers
        belt.vs_layer{j} = [belt.vs_layer{j} VS_all(:,active_layer==j)];
    end
    clear active_layer
end

alpha = 0.05;
for j=1:6
%     [p,h] = ranksum(a1.vs_layer{j}(1,:),belt.vs_layer{j}(1,:));
    [h,p] = ttest2(a1.vs_layer{j}(1,:),belt.vs_layer{j}(1,:));
    pval_comp(j) = p;
    if p<(alpha/6) % Bonferroni correction
        stats_comp(j) = 1;
    else
        stats_comp(j) = 0;
    end
    clear h p
end

% a1_hit = a1.vs(a1.group==1);
% a1_stdiff = a1.stdiff(a1.group==1);
% a1_group = ones(size(a1_hit)) * 1;
% belt_hit = belt.vs(belt.group==1);
% belt_stdiff = belt.stdiff(belt.group==1);
% belt_hit(belt_stdiff==4) = []; % remove 4 semitone difference trials
% belt_stdiff(belt_stdiff==4) = []; % remove 4 semitone difference trials
% belt_group = ones(size(belt_hit)) * 2;
% 
% vs_comb = [a1_hit; belt_hit];
% stdiff_comb = [a1_stdiff; belt_stdiff];
% group_comb = [a1_group; belt_group];
% 
% LIST_STDIFF = [8 10 16 24];
% list_st = unique(stdiff_comb);
% for i=1:length(LIST_STDIFF)
%     stdiff_comb(stdiff_comb==LIST_STDIFF(i)) = i;
% end
% % subplot(2,1,2);
% [y,x,g] = iosr.statistics.tab2box(stdiff_comb,vs_comb,group_comb);
% h_anb_dp_std = iosr.statistics.boxPlot(x,y,...
%             'symbolColor','k','medianColor','k','symbolMarker','+',...
%             'showScatter',true,...
%             'scatterColor',{[.2 .4 1],[1 0 0]},...
%             'scatterMarker','o',...
%             'scatterSize',24,...
%             'scatterLayer','bottom',...
%             'scalewidth',true,'xseparator',false,...
%             'groupLabels',g); hold on;
% set(gca,'xTickLabel',list_st);
% x_lim = get(gca,'xlim');
% plot(x_lim,[0 0],':k');
% % title([DATE ' d-prime (A vs B)']);
% xlabel('semitone diff'); ylabel('vector strength'); box off;
% 
% figure; 
% subplot(2,2,1);
% plot(REC_SITE_A1(:,1),meanVS_a1(1,:),'o','LineWidth',2); hold on
% plot(REC_SITE_BELT(:,1),meanVS_belt(1,:),'o','LineWidth',2);
% xlabel('Recording Site (AP)'); ylabel('mean vector strength');
% 
% subplot(2,2,2);
% plot(REC_SITE_A1(:,2),meanVS_a1(1,:),'o','LineWidth',2); hold on
% plot(REC_SITE_BELT(:,2),meanVS_belt(1,:),'o','LineWidth',2);
% xlabel('Recording Site (LM)'); ylabel('mean vecor strength');
% 
% subplot(2,1,2); hold on
% plotVS_ch(a1); 
% plotVS_ch(belt);
% 
% % figure for poster
% figure; 
% subplot(2,2,1);
% plot(REC_SITE_A1(:,1),meanVS_a1(1,:),'o','LineWidth',2); hold on
% plot(REC_SITE_BELT(:,1),meanVS_belt(1,:),'o','LineWidth',2);
% xlabel('Recording Site (AP)'); ylabel('mean vector strength');
% 
% subplot(2,2,2);
% plot(REC_SITE_A1(:,2),meanVS_a1(1,:),'o','LineWidth',2); hold on
% plot(REC_SITE_BELT(:,2),meanVS_belt(1,:),'o','LineWidth',2);
% xlabel('Recording Site (LM)'); ylabel('mean vector strength');
% legend({'A1','BELT'});
% 
% subplot(2,2,3);
% plot(dist_a1,meanVS_a1(1,:),'o','LineWidth',2); hold on
% plot(dist_belt,meanVS_belt(1,:),'o','LineWidth',2);
% xlabel('Distance from A1'); ylabel('mean vector strength');
% set(gca,'xlim',[-1 11],'ylim',[0.0 0.5]);
% 
% figure
% subplot(1,1,1); hold on
% plotVS_ch(a1); 
% plotVS_ch(belt);
% title('Vector Strength');
% legend({'A1','BELT'});

figure
subplot(2,2,1); hold on
plotVS_layer2(a1); 
plotVS_layer2(belt);
title('Vector Strength');
legend({'A1','BELT'});

% get data for each layer
a1_layer = compVS_3layers(a1); 
belt_layer = compVS_3layers(belt);
% hit and miss trials
a1_hm = a1_layer.mean(1:2,:);
belt_hm = belt_layer.mean(1:2,:);
% show plot
subplot(2,2,3);
bar(a1_hm');
subplot(2,2,4);
bar(belt_hm');

% statistical analysis
[a1_h(1),a1_p(1)] = ttest(a1_layer.s(1,:),a1_layer.s(2,:));
[a1_h(2),a1_p(2)] = ttest(a1_layer.g(1,:),a1_layer.g(2,:));
[a1_h(3),a1_p(3)] = ttest(a1_layer.i(1,:),a1_layer.i(2,:));
[belt_h(1),belt_p(1)] = ttest(belt_layer.s(1,:),belt_layer.s(2,:));
[belt_h(2),belt_p(2)] = ttest(belt_layer.g(1,:),belt_layer.g(2,:));
[belt_h(3),belt_p(3)] = ttest(belt_layer.i(1,:),belt_layer.i(2,:));

% % % % data rearrangement for box plot % % % %
a1_data = [a1_layer.s a1_layer.g a1_layer.i];
a1_group = transpose(1:3) * ones(1, size(a1_data,2)); % hit, miss, false alarm
a1_level = [ones(size(a1_layer.s))*1 ones(size(a1_layer.g))*2 ones(size(a1_layer.i))*3]; % supra, granular, infra layers
belt_data = [belt_layer.s belt_layer.g belt_layer.i];
belt_group = transpose(1:3) * ones(1, size(belt_data,2)); % level
belt_level = [ones(size(belt_layer.s))*1 ones(size(belt_layer.g))*2 ones(size(belt_layer.i))*3]; % supra, granular, infra layers

% remove false alarm trials...
a1_data  = a1_data(1:2,:);
a1_group = a1_group(1:2,:);
a1_level = a1_level(1:2,:);
belt_data = belt_data(1:2,:);
belt_group = belt_group(1:2,:);
belt_level = belt_level(1:2,:);

% % combine data
% dprime_comb = [a1_data belt_data];
% stdiff_comb = [a1_stdiff belt_stdiff];
% group_comb = [a1_group belt_group];
% % remove false alarm from the analysis
% dprime_comb = dprime_comb(1,:);
% stdiff_comb = stdiff_comb(1,:);
% group_comb = group_comb(1,:);
% list_st = unique(stdiff_comb);

% for i=1:length(LIST_STDIFF)
%     stdiff_comb(stdiff_comb==LIST_STDIFF(i)) = i;
% end

subplot(2,2,3);
% [y,x,g] = iosr.statistics.tab2box(stdiff_comb(:),dprime_comb(:),group_comb(:));
[y,x,g] = iosr.statistics.tab2box(a1_level(:),a1_data(:),a1_group(:));
h_anb_dp_std = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.5 .5 .5],[.2 .4 1]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'notch',true,...
            'scalewidth',true,'xseparator',false,...
            'groupLabels',g); hold on;
set(gca,'xTickLabel',{'supra','granular','infra'});
x_lim = get(gca,'xlim');
% xlabel('layer');
ylabel('vector strength'); box off;
title('Primary');

subplot(2,2,4);
% [y,x,g] = iosr.statistics.tab2box(stdiff_comb(:),dprime_comb(:),group_comb(:));
[y,x,g] = iosr.statistics.tab2box(belt_level(:),belt_data(:),belt_group(:));
h_anb_dp_std = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.5 .5 .5],[.2 .4 1]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'notch',true,...
            'scalewidth',true,'xseparator',false,...
            'groupLabels',g); hold on;
set(gca,'xTickLabel',{'supra','granular','infra'});
x_lim = get(gca,'xlim');
% xlabel('layer');
ylabel('vector strength'); box off;
title('Non-Primary');