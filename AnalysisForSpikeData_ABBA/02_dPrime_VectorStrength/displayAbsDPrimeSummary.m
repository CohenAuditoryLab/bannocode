clear all;
addpath(genpath('/Users/work/Documents/MATLAB/iosr')); % toollbox for boxplot % toolbox for boxplot

ROOT_DIR  = '/Volumes/TOSHIBA_EXT/01_STREAMING/ANALYSIS/analysis_after_20190821';
DATE = '20200114';
addpath(fullfile(ROOT_DIR,DATE));
save_file_dir = fullfile(DATE,'absDP&VS'); % need to create empty folder named 'absDP&VS' before run

file_name = strcat(DATE,'_dPrimeROC');
load(file_name);
% load(strcat(DATE,'_FrequencySelectivity'));

list_st = params.list_st;
active_channel = clInfo.active_channel;
c = [100 100 100; 51 102 255; 255 0 0] / 255; % set line color


% target vs non-target
dprime_all = abs(TvsNT.dprime_all); % take absolute value
dprime = abs(TvsNT.dprime); % take absolute value
stdiff = TvsNT.stdiff;
group = TvsNT.group;

figure; % d'
subplot(6,2,1);
histogram(dprime_all(1,:),-1:0.2:3);
title('hit'); box off;
subplot(6,2,3);
histogram(dprime_all(2,:),-1:0.2:3);
title('miss'); box off;

subplot(2,2,2);
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
% plot([0.25 1.75],[0 0],':k');
ylabel('abs( d-prime )'); title('Target vs Non-target');
clear temp

% redefine stdiff for box plot
stlevel = stdiff;
for i=1:length(list_st)
    stlevel(stlevel==list_st(i)) = i;
end

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stlevel(:),dprime(:),group(:));
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
% plot(x_lim,[0 0],':k');
title([DATE ' d-prime (target vs non-target)']);
xlabel('semitone diff'); ylabel('abs( d-prime )'); box off;
saveas(gcf,fullfile( save_file_dir, strcat(DATE,'_TvsNT_dprime') ),'png');

figure;
subplot(2,1,1);
for k=1:2
    plot(active_channel+1,dprime_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
% plot([0 17],[0 0],'--k');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('abs( d prime )');
title('Target vs Non-target');
saveas(gcf,fullfile( save_file_dir, strcat(DATE,'_TvsNT_acrossCh') ),'png');



% Frequency Selectivity (A vs B)
dprime_all = abs(AvsB.dprime_all); % take absolute value
dprime = abs(AvsB.dprime); % take absolute value
stdiff = AvsB.stdiff;
group = AvsB.group;

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
% plot([0.25 1.75],[0 0],':k');
ylabel('abs( d-prime )'); title('Frequency Selectivity');
clear temp

% redefine stdiff for box plot
stlevel = stdiff;
for i=1:length(list_st)
    stlevel(stlevel==list_st(i)) = i;
end

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stlevel(:),dprime(:),group(:));
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
% plot(x_lim,[0 0],':k');
title([DATE ' d-prime (A vs B)']);
xlabel('semitone diff'); ylabel('abs( d-prime )'); box off;
saveas(gcf,fullfile( save_file_dir, strcat(DATE,'_AvsB_dprime') ),'png');

figure;
subplot(2,1,1);
for k=1:3
    plot(active_channel+1,dprime_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
% plot([0 17],[0 0],'--k');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('abs( d prime )');
title('Frequency Selectivity');
saveas(gcf,fullfile( save_file_dir, strcat(DATE,'_AvsB_acrossCh') ),'png');


% adaptation
dprime_all = abs(Adapt.dprime_all); % take absolute value
dprime = abs(Adapt.dprime); % take absolute value
stdiff = Adapt.stdiff;
group = Adapt.group;

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

for k=1:3
    temp(:,:,k) = transpose(dprime_all(k,:));
end
h_adapt_dp_all = iosr.statistics.boxPlot(temp,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'groupLabels',{'hit','miss','fa'});
hold on;
% plot([0.25 1.75],[0 0],':k');
ylabel('abs( d-prime )'); title('Adaptation');
clear temp

% redefine stdiff for box plot
stlevel = stdiff;
for i=1:length(list_st)
    stlevel(stlevel==list_st(i)) = i;
end

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stlevel(:),dprime(:),group(:));
h_adapt_dp_std = iosr.statistics.boxPlot(x,y,...
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
% plot(x_lim,[0 0],':k');
title([DATE ' d-prime (adaptation)']); % 1st A vs T-1th A
xlabel('semitone diff'); ylabel('abs( d-prime )'); box off;
saveas(gcf,fullfile(save_file_dir, strcat(DATE,'_adaptation_dprime') ),'png');

figure;
subplot(2,1,1);
for k=1:3
    plot(active_channel+1,dprime_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
% plot([0 17],[0 0],'--k');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('abs( d prime )');
title('Adaptation');
saveas(gcf,fullfile( save_file_dir, strcat(DATE,'_adaptation_acrossCh') ),'png');



% hit vs miss
dprime_all = abs(HvsM.dprime_all); % take absolute value
dprime = abs(HvsM.dprime); % take absolute value
stdiff = HvsM.stdiff;
group = HvsM.group;

figure; % d'
subplot(6,2,1);
histogram(dprime_all(1,:),-1:0.2:3);
title('d-prime (hit vs miss)'); box off;

subplot(2,2,2);
for k=1 %3
    temp(:,:,k) = transpose(dprime_all(k,:));
end
hm_dp_all = iosr.statistics.boxPlot(temp,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.2 .4 1]},...
            'scatterMarker','o',...
            'groupLabels',{'hit','miss','fa'});
hold on;
% plot([0.25 1.75],[0 0],':k');
ylabel('abs( d-prime )'); title('Hit vs Miss');
clear temp

% redefine stdiff for box plot
stlevel = stdiff;
for i=1:length(list_st)
    stlevel(stlevel==list_st(i)) = i;
end

subplot(2,1,2);
[y,x,g] = iosr.statistics.tab2box(stlevel(:),dprime(:),group(:));
hm_dp_std = iosr.statistics.boxPlot(x,y,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.2 .4 1]},...
            'scatterMarker','o',...
            'scatterSize',24,...
            'scatterLayer','bottom',...
            'scalewidth',true,'xseparator',false,...
            'groupLabels',g); hold on;
set(gca,'xTickLabel',list_st);
x_lim = get(gca,'xlim');
% plot(x_lim,[0 0],':k');
title([DATE ' d-prime (target vs non-target)']);
xlabel('semitone diff'); ylabel('abs( d-prime )'); box off;
saveas(gcf,fullfile( save_file_dir, strcat(DATE,'_HITvsMISS_dprime') ),'png');

figure;
subplot(2,1,1);
for k=1
    plot(active_channel+1,dprime_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
% plot([0 17],[0 0],'--k');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('abs( d prime )');
title('Hit vs Miss');
saveas(gcf,fullfile( save_file_dir, strcat(DATE,'_HITvsMISS_acrossCh') ),'png');