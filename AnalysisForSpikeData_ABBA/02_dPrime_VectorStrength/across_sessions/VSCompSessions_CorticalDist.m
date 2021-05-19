clear all;
addpath(genpath('/Users/work/Documents/MATLAB/iosr')); % toollbox for boxplot % toolbox for boxplot

ROOT_DIR = '/Volumes/TOSHIBA_EXT/01_STREAMING/ANALYSIS/analysis_after_20190821/';
% LIST_DATE = {'20180907'}; % test
LIST_DATE_A1 = {'20180709','20180727','20180807','20180907', ...
                '20191009','20191210','20191220'}; % A1
LIST_DATE_BELT = {'20181210','20181212','20190123','20190409', ...
                  '20190821','20190828','20200103','20200110','20200114'}; % non-primary auditory cortex
LIST_STDIFF = [4 8 16 24];
REC_SITE_A1 = [-4 0; -4 0; -4 0; -4 0; ...
               -4 -1; -4 0; -4 0];
REC_SITE_BELT = [-1 3; -1 3; 5 5; 3 3; ...
                 -3 2; 2 2; -3 1; -2 1; 0 1];
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

a1.vs = []; a1.vs_all = []; a1.vs_ch = cell(1,16); a1.vs_layer = cell(1,5);
a1.stdiff = []; a1.group = []; a1.active_channel = []; a1.active_layer = [];
meanVS_a1 = [];
for ff=1:length(LIST_DATE_A1)
    date = LIST_DATE_A1{ff};
    addpath(fullfile(ROOT_DIR,date));
    
    load(strcat(date,'_ABBA_VectorStrength'));
%     load(strcat(date,'_LayerBoundary'));
    
%     % assign layer for each channel
%     active_layer = nan(size(clInfo.active_channel));
%     for j=numel(lb):-1:1
%         active_layer(clInfo.active_channel<lb(j)) = j;
%     end
%     active_layer(isnan(active_layer)) = numel(lb)+1;
%     
% %     list_st = params.list_st;
%     a1.active_channel = [a1.active_channel clInfo.active_channel];
%     a1.active_layer = [a1.active_layer active_layer];
    
    a1.vs = [a1.vs; VS(:)];
    a1.vs_all = cat(2,a1.vs_all,VS_all);
    a1.stdiff = [a1.stdiff; stdiff(:)];
    a1.group = [a1.group; group(:)];
%     meanVS_a1 = [meanVS_a1 nanmean(VS_all,2)];
    
    % redefine meanDP
    vs_hit = VS(:,1,:);
    stdiff_hit = stdiff(:,1,:);
    meanVS_a1 = [meanVS_a1 nanmean(vs_hit(stdiff_hit==8 | stdiff_hit==10))];
    
%     % dprime_ch = cell(1,16);
%     for i=1:16 % channel id
%         a1.vs_ch{i} = [a1.vs_ch{i} VS_all(:,clInfo.active_channel==i-1)];
%     end
%     for j=1:5
%         a1.vs_layer{j} = [a1.vs_layer{j} VS_all(:,active_layer==j)];
%     end
%     clear active_layer
end

belt.vs = []; belt.vs_all = []; belt.vs_ch = cell(1,16); belt.vs_layer = cell(1,16);
belt.stdiff = []; belt.group = []; belt.active_channel = []; belt.active_layer = [];
meanVS_belt = [];
for ff=1:length(LIST_DATE_BELT)
    date = LIST_DATE_BELT{ff};
    addpath(fullfile(ROOT_DIR,date));
    
    load(strcat(date,'_ABBA_VectorStrength'));
%     load(strcat(date,'_LayerBoundary'));
    
%     % assign layer for each channel
%     active_layer = nan(size(clInfo.active_channel));
%     for j=numel(lb):-1:1
%         active_layer(clInfo.active_channel<lb(j)) = j;
%     end
%     active_layer(isnan(active_layer)) = numel(lb)+1;
%     
% %     list_st = params.list_st;
%     belt.active_channel = [belt.active_channel clInfo.active_channel];
%     belt.active_layer = [belt.active_layer active_layer];
    
    belt.vs = [belt.vs; VS(:)];
    belt.vs_all = cat(2,belt.vs_all,VS_all);
    belt.stdiff = [belt.stdiff; stdiff(:)];
    belt.group = [belt.group; group(:)];
%     meanVS_belt = [meanVS_belt nanmean(VS_all,2)];
    
    % redefine meanDP
    vs_hit = VS(:,1,:);
    stdiff_hit = stdiff(:,1,:);
    meanVS_belt = [meanVS_belt nanmean(abs(vs_hit(stdiff_hit==8 | stdiff_hit==10)))];
    
%     % dprime_ch = cell(1,16);
%     for i=1:16 % channel id
%         belt.vs_ch{i} = [belt.vs_ch{i} VS_all(:,clInfo.active_channel==i-1)];
%     end
%     for j=1:5
%         belt.vs_layer{j} = [belt.vs_layer{j} VS_all(:,active_layer==j)];
%     end
%     clear active_layer
end

% % statistical analysis
% alpha = 0.05;
% for j=2:5 % cannot include 1 because no data points in A1...
% %     [p,h] = ranksum(a1.vs_layer{j}(1,:),belt.vs_layer{j}(1,:));
%     [h,p] = ttest2(a1.vs_layer{j}(1,:),belt.vs_layer{j}(1,:));
%     pval_comp(j) = p;
%     if p<(alpha/4) % Bonferroni correction
%         stats_comp(j) = 1;
%     else
%         stats_comp(j) = 0;
%     end
%     clear h p
% end

a1_hit = a1.vs(a1.group==1);
a1_stdiff = a1.stdiff(a1.group==1);
a1_group = ones(size(a1_hit)) * 1;
belt_hit = belt.vs(belt.group==1);
belt_stdiff = belt.stdiff(belt.group==1);
% belt_hit(belt_stdiff==4) = []; % remove 4 semitone difference trials
% belt_stdiff(belt_stdiff==4) = []; % remove 4 semitone difference trials
belt_group = ones(size(belt_hit)) * 2;

vs_comb = [a1_hit; belt_hit];
stdiff_comb = [a1_stdiff; belt_stdiff];
group_comb = [a1_group; belt_group];


list_st = unique(stdiff_comb);
% for i=1:length(LIST_STDIFF)
%     stdiff_comb(stdiff_comb==LIST_STDIFF(i)) = i;
% end
for i=1:length(list_st)
    stdiff_comb(stdiff_comb==list_st(i)) = i;
end
% subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stdiff_comb,vs_comb,group_comb);
h_anb_dp_std = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'scalewidth',true,'xseparator',false,...
            'groupLabels',g); hold on;
set(gca,'xTickLabel',list_st);
x_lim = get(gca,'xlim');
plot(x_lim,[0 0],':k');
% title([DATE ' d-prime (A vs B)']);
xlabel('semitone diff'); ylabel('vector strength'); box off;
title('Phase Locking');

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

% subplot(2,1,2); hold on
% plotVS_ch(a1); 
% plotVS_ch(belt);

% figure for poster
figure; 
subplot(2,2,1);
plot(REC_SITE_A1(:,1),meanVS_a1(1,:),'o','LineWidth',2); hold on
plot(REC_SITE_BELT(:,1),meanVS_belt(1,:),'o','LineWidth',2);
xlabel('Recording Site (AP)'); ylabel('mean vector strength');
box off;

subplot(2,2,2);
plot(REC_SITE_A1(:,2),meanVS_a1(1,:),'o','LineWidth',2); hold on
plot(REC_SITE_BELT(:,2),meanVS_belt(1,:),'o','LineWidth',2);
xlabel('Recording Site (LM)'); ylabel('mean vector strength');
legend({'A1','BELT'});
box off;

subplot(2,2,3);
plot(dist_a1,meanVS_a1(1,:),'o','LineWidth',2); hold on
plot(dist_belt,meanVS_belt(1,:),'o','LineWidth',2);
xlabel('Distance from A1'); ylabel('mean vector strength');
set(gca,'xlim',[-1 11],'ylim',[0.0 0.5]);
box off;

% figure
% subplot(1,1,1); hold on
% plotVS_ch(a1); 
% plotVS_ch(belt);
% title('Vector Strength');
% legend({'A1','BELT'});

% figure
% subplot(1,1,1); hold on
% plotVS_layer(a1); 
% plotVS_layer(belt);
% title('Vector Strength');
% legend({'A1','BELT'});