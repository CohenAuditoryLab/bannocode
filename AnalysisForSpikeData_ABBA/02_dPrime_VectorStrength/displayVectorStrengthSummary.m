clear all;
addpath(genpath('C:\MatlabTools\iosr'));

% ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Domo\NeuralData\vProbe\06_ABBA_KILOSORT\';
ROOT_DIR  = '/Volumes/TOSHIBA_EXT/01_STREAMING/ANALYSIS/analysis_after_20190821';
DATE = '20200114';
addpath(fullfile(ROOT_DIR,DATE));
save_file_dir = fullfile(DATE,'absDP&VS'); % need to create empty folder named 'absDP&VS' before run

load(strcat(DATE,'_ABBA_VectorStrength'));

% list_st = params.list_st;
active_channel = clInfo.active_channel;

% vs = VS;
% vs_all = VS_all;
% stdiff = AvsB.stdiff;
% group = AvsB.group;


figure; % d'
subplot(6,2,1);
histogram(VS_all(1,:),0:0.05:1);
title('hit'); box off;
subplot(6,2,3);
histogram(VS_all(2,:),0:0.05:1);
title('miss'); box off;
subplot(6,2,5);
histogram(VS_all(3,:),0:0.05:1);
title('false alarm'); box off;
subplot(2,2,2);
% boxplot(dprime_all'); hold on;
% plot([0.5 3.5],[0 0],':k');
% ylabel('d-prime'); title('all trials combined');
% set(gca,'xTickLabel',{'hit','miss','fa'});
for k=1:3
    temp(:,:,k) = transpose(VS_all(k,:));
end
h_vs_all = iosr.statistics.boxPlot(temp,...
            'symbolColor','k','medianColor','k','symbolMarker','+',...
            'showScatter',true,...
            'scatterColor',{[.39 .39 .39],[.2 .4 1],[1 0 0]},...
            'scatterMarker','o',...
            'groupLabels',{'hit','miss','fa'});
hold on;
% plot([0.25 1.75],[0 0],':k');
ylabel('vector strength'); title('Phase lock to the target stream');

% redefine stdiff for box plot
n_level = length(list_st);
stlevel = stdiff;
for i=1:n_level
    stlevel(stlevel==list_st(i)) = i;
end

subplot(2,1,2);
% [y,x,g] = iosr.statistics.tab2box(stdiff(:),VS(:),group(:));
[y,x,g] = iosr.statistics.tab2box(stlevel(:),VS(:),group(:));
h_vs_std = iosr.statistics.boxPlot(x,y,...
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
% title([DATE ' d-prime (A vs B)']);
xlabel('semitone difference'); ylabel('vector strength'); box off;
fig_title = strcat(DATE,' Vector Strength');
title(fig_title);

save_file_name = strcat(DATE,'_VectorStrength');
saveas(gcf,fullfile( save_file_dir, save_file_name ),'png');

% median across neurons
meanVS.all = nanmean(VS_all,2); % behavior x 1

figure;
c = [100 100 100; 51 102 255; 255 0 0] / 255; % set line color
subplot(2,1,1);
for k=1:3
    plot(active_channel+1,VS_all(k,:),'o','color',c(k,:),'LineWidth',2); hold on;
end
% plot([0 17],[0 0],'--k');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('vector strength');

% median across neurons
meanVS.stdiff = nanmean(VS,3); % stdiff x behavior x #channels

vs_ch = cell(1,16);
for i=1:16 % channel id
    vs_ch{i} = VS_all(:,active_channel==i-1);
    if ~isempty(vs_ch{i})
        meanVS.ch(i,:) = nanmean(vs_ch{i},2);
    else
        meanVS.ch(i,:) = nan(3,1);
    end
end

ach = unique(active_channel) + 1;
mVSch = meanVS.ch(ach,:);
% h = plot(ach,mVSch,'LineWidth',1.5);
% set(h, {'color'}, {c(1,:); c(2,:); c(3,:)});
legend({'HIT','MISS','FA'});
title('Phase lock to the target stream');

save_file_name = strcat(DATE,'_VectorStrength_accrossCh');
saveas(gcf,fullfile( save_file_dir, save_file_name ),'png');