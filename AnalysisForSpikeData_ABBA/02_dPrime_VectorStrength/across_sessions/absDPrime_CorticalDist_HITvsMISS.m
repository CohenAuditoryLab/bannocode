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

a1.dprime = []; a1.dprime_all = []; a1.dprime_ch = cell(1,16); a1.dprime_layer = cell(1,5);
a1.stdiff = []; a1.group = []; a1.active_channel = []; a1.active_layer = [];
meanDP_a1 = [];
% a1.recsite = [];
for ff=1:length(LIST_DATE_A1)
    date = LIST_DATE_A1{ff};
    addpath(fullfile(ROOT_DIR,date));
    
    load(strcat(date,'_dPrimeROC'));
%     load(strcat(date,'_LayerBoundary'));
    
%     % assign layer for each channel
%     active_layer = nan(size(clInfo.active_channel));
%     for j=numel(lb):-1:1
%         active_layer(clInfo.active_channel<lb(j)) = j;
%     end
%     active_layer(isnan(active_layer)) = numel(lb)+1;
%     
%     list_st = params.list_st;
%     a1.active_channel = [a1.active_channel clInfo.active_channel];
%     a1.active_layer = [a1.active_layer active_layer];
    
    a1.dprime = [a1.dprime; abs(HvsM.dprime(:))]; % absolute value
    a1.dprime_all = cat(2, a1.dprime_all, abs(HvsM.dprime_all)); % absolute value
    a1.stdiff = [a1.stdiff; HvsM.stdiff(:)];
    a1.group = [a1.group; HvsM.group(:)];
%     a1.recsite = [a1.recsite; ones(size(TvsNT.dprime_all,2),1)*REC_SITE_A1(ff,:)];
%     meanDP_a1 = [meanDP_a1 nanmean(abs(HvsM.dprime_all),2)]; % absolute value
    
    % redefine meanDP
    dp_hit = HvsM.dprime(:,1,:);
    stdiff_hit = HvsM.stdiff(:,1,:);
    meanDP_a1 = [meanDP_a1 nanmean(abs(dp_hit(stdiff_hit==8 | stdiff_hit==10)))];
%     meanDP_a1 = [meanDP_a1 nanmean(abs(dp_hit(stdiff_hit==8)))];

%     % dprime_ch = cell(1,16);
%     for i=1:16 % channel id
% %         a1.dprime_ch{i} = [a1.dprime_ch{i} a1.dprime_all(:,a1.active_channel==i-1)];
%         a1.dprime_ch{i} = [a1.dprime_ch{i} abs(HvsM.dprime_all(:,clInfo.active_channel==i-1))]; % absolute value
%     end
%     for j=1:5
%         a1.dprime_layer{j} = [a1.dprime_layer{j} abs(HvsM.dprime_all(:,active_layer==j))]; % absolute value
%     end
%     clear active_layer
end

belt.dprime = []; belt.dprime_all = []; belt.dprime_ch = cell(1,16); belt.dprime_layer = cell(1,5);
belt.stdiff = []; belt.group = []; belt.active_channel = []; belt.active_layer = [];
meanDP_belt = [];
% belt.recsite = [];
for ff=1:length(LIST_DATE_BELT)
    date = LIST_DATE_BELT{ff};
    addpath(fullfile(ROOT_DIR,date));
    
    load(strcat(date,'_dPrimeROC'));
%     load(strcat(date,'_LayerBoundary'));
    
%     % assign layer for each channel
%     active_layer = nan(size(clInfo.active_channel));
%     for j=numel(lb):-1:1
%         active_layer(clInfo.active_channel<lb(j)) = j;
%     end
%     active_layer(isnan(active_layer)) = numel(lb)+1;
%     
%     list_st = params.list_st;
%     belt.active_channel = [belt.active_channel clInfo.active_channel];
%     belt.active_layer = [belt.active_layer active_layer];
    
    belt.dprime = [belt.dprime; abs(HvsM.dprime(:))]; % absolute value
    belt.dprime_all = cat(2, belt.dprime_all, abs(HvsM.dprime_all)); % absolute value
    belt.stdiff = [belt.stdiff; HvsM.stdiff(:)];
    belt.group = [belt.group; HvsM.group(:)];
%     belt.recsite = [belt.recsite; ones(size(TvsNT.dprime_all,2),1)*REC_SITE_BELT(ff,:)];
%     meanDP_belt = [meanDP_belt nanmean(abs(HvsM.dprime_all),2)]; % absolute value
    
    % redefine meanDP
    dp_hit = HvsM.dprime(:,1,:);
    stdiff_hit = HvsM.stdiff(:,1,:);
    meanDP_belt = [meanDP_belt nanmean(abs(dp_hit(stdiff_hit==8 | stdiff_hit==10)))];
%     meanDP_belt = [meanDP_belt nanmean(abs(dp_hit(stdiff_hit==8)))];
    
%     % dprime_ch = cell(1,16);
%     for i=1:16 % channel id
% %         belt.dprime_ch{i} = [belt.dprime_ch{i} belt.dprime_all(:,belt.active_channel==i-1)];
%         belt.dprime_ch{i} = [belt.dprime_ch{i} abs(HvsM.dprime_all(:,clInfo.active_channel==i-1))]; % absolute value
%     end
%     for j=1:5
%         belt.dprime_layer{j} = [belt.dprime_layer{j} abs(HvsM.dprime_all(:,active_layer==j))]; % absolute value
%     end
%     clear active_layer
end

a1_hit = a1.dprime(a1.group==1);
a1_stdiff = a1.stdiff(a1.group==1);
a1_group = ones(size(a1_hit)) * 1;
belt_hit = belt.dprime(belt.group==1);
belt_stdiff = belt.stdiff(belt.group==1);
% belt_hit(belt_stdiff==4) = [];
% belt_stdiff(belt_stdiff==4) = [];
belt_group = ones(size(belt_hit)) * 2;

dprime_comb = [a1_hit; belt_hit];
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
[y,x,g] = iosr.statistics.tab2box(stdiff_comb,dprime_comb,group_comb);
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
xlabel('semitone diff'); ylabel('abs( d-prime )'); box off;
title('Hit vs Miss');


% figure; 
% subplot(2,2,1);
% plot(REC_SITE_A1(:,1),meanDP_a1(1,:),'o','LineWidth',2); hold on
% plot(REC_SITE_BELT(:,1),meanDP_belt(1,:),'o','LineWidth',2);
% xlabel('Recording Site (AP)'); ylabel('mean d-prime');
% 
% subplot(2,2,2);
% plot(REC_SITE_A1(:,2),meanDP_a1(1,:),'o','LineWidth',2); hold on
% plot(REC_SITE_BELT(:,2),meanDP_belt(1,:),'o','LineWidth',2);
% xlabel('Recording Site (LM)'); ylabel('mean d-prime');

% subplot(2,1,2); hold on
% plotDP_ch(a1); 
% plotDP_ch(belt);

% figure for poster
figure; 
subplot(2,2,1);
plot(REC_SITE_A1(:,1),meanDP_a1(1,:),'o','LineWidth',2); hold on
plot(REC_SITE_BELT(:,1),meanDP_belt(1,:),'o','LineWidth',2);
xlabel('Recording Site (AP)'); ylabel('mean d-prime');

subplot(2,2,2);
plot(REC_SITE_A1(:,2),meanDP_a1(1,:),'o','LineWidth',2); hold on
plot(REC_SITE_BELT(:,2),meanDP_belt(1,:),'o','LineWidth',2);
xlabel('Recording Site (LM)'); ylabel('mean d-prime');

subplot(2,2,3);
plot(dist_a1,meanDP_a1(1,:),'o','LineWidth',2); hold on
plot(dist_belt,meanDP_belt(1,:),'o','LineWidth',2);
xlabel('Distance from A1'); ylabel('mean d-prime');
set(gca,'xlim',[-1 11]);
% set(gca,'ylim',[0.2 0.6]);
box off;

% figure;
% subplot(1,1,1); hold on
% plotDP_ch(a1); 
% plotDP_ch(belt);
% title('Hit vs Miss');
% 
% figure
% subplot(1,1,1); hold on
% plotDP_layer(a1); 
% plotDP_layer(belt);
% title('Hit vs Miss');


% function [] = plotDP_ch(data)
% % dprime = data.dprime;
% % dprime_all = data.dprime_all;
% dprime_ch = data.dprime_ch;
% % stdiff = data.stdiff;
% % group = data.group;
% active_channel = data.active_channel;
% for i=1:16
%     if ~isempty(dprime_ch{i})
%         meanDP.ch(i,:) = nanmean(dprime_ch{i},2);
%         stdDP.ch(i,:) = nanstd(dprime_ch{i},0,2);
%     else
%         meanDP.ch(i,:) = nan(2,1);
%         stdDP.ch(i,:) = nan(2,1);
%     end
% end
% ach = unique(active_channel) + 1;
% mDPch = meanDP.ch(ach,:);
% sDPch = stdDP.ch(ach,:);
% % h = plot(ach,mDPch,'LineWidth',2);
% % set(h, {'color'}, {c(1,:); c(2,:)});
% % ylim([-2 2]);
% 
% % subplot(2,1,1);
% % for j=1:2
% %     errorbar(ach,mDPch(:,j),sDPch(:,j),'Color',c(j,:),'LineWidth',1.5); hold on;
% % end
% errorbar(ach,mDPch(:,1),sDPch(:,1),'LineWidth',1.5); % plot hit trial
% plot([0.5 16.5],[0 0],'--k');
% set(gca,'xlim',[0.5 16.5]);
% xlabel('channel'); ylabel('abs( d prime )');
% end

% function [] = plotDP_layer(data)
% % dprime = data.dprime;
% % dprime_all = data.dprime_all;
% dprime_layer = data.dprime_layer;
% % stdiff = data.stdiff;
% % group = data.group;
% active_layer = data.active_layer;
% for j=1:5
%     if ~isempty(dprime_layer{j})
%         meanDP.layer(j,:) = nanmean(dprime_layer{j},2);
%         stdDP.layer(j,:) = nanstd(dprime_layer{j},0,2);
%     else
%         meanDP.layer(j,:) = nan(2,1);
%         stdDP.layer(j,:) = nan(2,1);
%     end
% end
% alayer = unique(active_layer);
% mDPlayer = meanDP.layer(alayer,:);
% sDPlayer = stdDP.layer(alayer,:);
% % h = plot(ach,mDPch,'LineWidth',2);
% % set(h, {'color'}, {c(1,:); c(2,:)});
% % ylim([-2 2]);
% 
% % subplot(2,1,1);
% % for j=1:2
% %     errorbar(ach,mDPch(:,j),sDPch(:,j),'Color',c(j,:),'LineWidth',1.5); hold on;
% % end
% errorbar(alayer,mDPlayer(:,1),sDPlayer(:,1),'LineWidth',1.5); % plot hit trial
% plot([0.5 5.5],[0 0],'--k');
% set(gca,'xlim',[0.5 5.5],'xTick',1:5);
% xlabel('layer'); ylabel('abs( d prime )');
% end