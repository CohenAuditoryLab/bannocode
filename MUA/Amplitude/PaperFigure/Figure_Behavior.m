clear all;

DATA_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\Data';
addpath ../../
load RecordingDate_Both; % get list of recording date...
RecDate = list_RecDate;
% RecDate = RecDate(1:8); % for checking Domo's data...

% % % plot d-prime as a function of semitone difference % % % 
dPrime4 = []; dPrime3 = [];
n4 = 0; n3 = 0;
figure('Position',[300 300 800 450]);
for ff=1:numel(RecDate)
    fName = strcat(RecDate{ff},'_Behavior');
    load(fullfile(DATA_DIR,fName));
    
%     x = list_st / list_st(1);
    if length(list_st)==3
%         x = [1 2.5 4];
        x = [1 3 5];
        dPrime3 = [dPrime3 dp];
        n3 = n3 + 1;
    elseif length(list_st)==4
%         x = 1:4;
        x = [1 2 4 5];
        dPrime4 = [dPrime4 dp];
        n4 = n4 + 1;
    end
    subplot(2,2,3); hold on;
    jitter = (rand(1) - 0.5) / 4;
    plot(x+jitter,dp,'o','Color',[0.7 0.7 0.7]);
    
    subplot(2,2,4); hold on;
    plot([1 2]+jitter,dp([1 end]),'o','Color',[0.7 0.7 0.7]);
    
    dp_hard(ff) = dp(1);
    dp_easy(ff) = dp(end);
end
DP = NaN(5,numel(RecDate)); % summary of dPrime...
DP(1,:) = [dPrime4(1,:) dPrime3(1,:)];
DP(2,1:n4) = dPrime4(2,:);
DP(3,1:n3) = dPrime3(2,:);
DP(4,1:n4) = dPrime4(3,:);
DP(5,:) = [dPrime4(end,:) dPrime3(end,:)];
subplot(2,2,3);
boxplot(DP','colors','k');
hold off;
set(gca,'XTick',[1 5],'XTickLabel',{'small','large'},'XLim',[0.5 5.5]);
xlabel('frequency separation'); ylabel('d prime');
box off;

subplot(2,2,4);
boxplot([dp_hard' dp_easy'],'notch','on','colors','k');
set(gca,'XTickLabel',{'small dF','large dF'});
ylabel('d prime');
box off;
[p,h] = signrank(dp_hard,dp_easy); % Wilcoxon signed rank test

% % % % Reaction Time Distribution % % % % 
% Domo
load RecordingDate_Domo; % get list of recording date...
rt_range = [0 650]; % reaction time range for plot
RecDate = list_RecDate;

RT_hit = []; RT_fa = [];
for ff=1:numel(RecDate)
    fName = strcat(RecDate{ff},'_Behavior');
    load(fullfile(DATA_DIR,fName)); 
    RT_hit = [RT_hit; rt.all];
    RT_fa  = [RT_fa; rt_tsRT.all];
end
subplot(2,2,1);
bin = rt_range(1):25:rt_range(2);
histogram(RT_hit,bin); hold on
histogram(RT_fa,bin);
xlabel('time from target onset [ms]');
title('monkey D');
box off;
RT_summary(1,:) = [nanmean(RT_hit) nanmedian(RT_hit)]; % mean and median of RT
clear RT_hit RT_fa;

% Cassius
load RecordingDate_Cassius; % get list of recording date...
rt_range = [0 800]; % reaction time range for plot
RecDate = list_RecDate;

RT_hit = []; RT_fa = [];
for ff=1:numel(RecDate)
    fName = strcat(RecDate{ff},'_Behavior');
    load(fullfile(DATA_DIR,fName)); 
    RT_hit = [RT_hit; rt.all];
    RT_fa  = [RT_fa; rt_tsRT.all];
end
subplot(2,2,2);
bin = rt_range(1):25:rt_range(2);
histogram(RT_hit,bin); hold on
histogram(RT_fa,bin);
xlabel('time from target onset [ms]');
title('monkey C');
box off;
RT_summary(2,:) = [nanmean(RT_hit) nanmedian(RT_hit)]; % mean and median of RT
clear RT_hit RT_fa;