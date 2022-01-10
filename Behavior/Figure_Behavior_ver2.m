clear all;

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\Data';
load RecordingDate_Both; % get list of recording date... (Both monkeys)
RecDate = list_RecDate;
% RecDate = RecDate(1:8); % for checking Domo's data...

% % % plot d-prime as a function of semitone difference % % % 
dPrime4 = []; dPrime3 = [];
rHit4 = []; rHit3 = [];
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
        rHit3 = [rHit3 r_hit];
        n3 = n3 + 1;
    elseif length(list_st)==4
%         x = 1:4;
        x = [1 2 4 5];
        dPrime4 = [dPrime4 dp];
        rHit4 = [rHit4 r_hit];
        n4 = n4 + 1;
    end
    subplot(3,2,1); hold on;
    jitter = (rand(1) - 0.5) / 4;
    plot(x+jitter,r_hit,'o','Color',[0.7 0.7 0.7]);

    subplot(3,2,2); hold on;
    plot([1 2]+jitter,r_hit([1 end]),'o','Color',[0.7 0.7 0.7]);

    subplot(3,2,3); hold on;
    jitter = (rand(1) - 0.5) / 4;
    plot(x+jitter,dp,'o','Color',[0.7 0.7 0.7]);
    
    subplot(3,2,4); hold on;
    plot([1 2]+jitter,dp([1 end]),'o','Color',[0.7 0.7 0.7]);
    
    dp_hard(ff) = dp(1);
    dp_easy(ff) = dp(end);
    hr_hard(ff) = r_hit(1);
    hr_easy(ff) = r_hit(end);
end
% HIT RATE (12/20/21 added)
HR = NaN(5,numel(RecDate)); % summary of hit rate...
HR(1,:) = [rHit4(1,:) rHit3(1,:)];
HR(2,1:n4) = rHit4(2,:);
HR(3,1:n3) = rHit3(2,:);
HR(4,1:n4) = rHit4(3,:);
HR(5,:) = [rHit4(end,:) rHit3(end,:)];
subplot(3,2,1);
boxplot(HR','colors','k');
hold off;
set(gca,'XTick',[1 5],'XTickLabel',{'Small','Large'},'XLim',[0.5 5.5]);
xlabel('Frequency Separation (dF)'); ylabel('Hit Rate');
box off;
G = transpose((1:5)' * ones(1,numel(RecDate)));
X_HR = HR';
G = G(~isnan(X_HR));
X_HR = X_HR(~isnan(X_HR));

subplot(3,2,2);
boxplot([hr_hard' hr_easy'],'notch','on','colors','k');
set(gca,'XTickLabel',{'Small dF','Large dF'});
ylabel('Hit Rate');
box off;
[p_hr,h_hr] = signrank(hr_hard,hr_easy); % Wilcoxon signed rank test

% D-PRIME
DP = NaN(5,numel(RecDate)); % summary of dPrime...
DP(1,:) = [dPrime4(1,:) dPrime3(1,:)];
DP(2,1:n4) = dPrime4(2,:);
DP(3,1:n3) = dPrime3(2,:);
DP(4,1:n4) = dPrime4(3,:);
DP(5,:) = [dPrime4(end,:) dPrime3(end,:)];
subplot(3,2,3);
boxplot(DP','colors','k');
hold off;
set(gca,'XTick',[1 5],'XTickLabel',{'Small','Large'},'XLim',[0.5 5.5]);
xlabel('Frequency Separation (dF)'); ylabel('d Prime');
box off;

X_DP = DP';
X_DP = X_DP(~isnan(X_DP));

subplot(3,2,4);
boxplot([dp_hard' dp_easy'],'notch','on','colors','k');
set(gca,'XTickLabel',{'Small dF','Large dF'});
ylabel('d Prime');
box off;
[p_dp,h_dp] = signrank(dp_hard,dp_easy); % Wilcoxon signed rank test


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
subplot(3,2,5);
bin = rt_range(1):25:rt_range(2);
histogram(RT_hit,bin); hold on
histogram(RT_fa,bin);
xlabel('Time from Target Onset [ms]');
title('Monkey D');
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
subplot(3,2,6);
bin = rt_range(1):25:rt_range(2);
histogram(RT_hit,bin); hold on
histogram(RT_fa,bin);
xlabel('Time from Target Onset [ms]');
title('Monkey C');
box off;
RT_summary(2,:) = [nanmean(RT_hit) nanmedian(RT_hit)]; % mean and median of RT
clear RT_hit RT_fa;