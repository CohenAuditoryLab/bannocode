clear all;

DATA_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\Data';
load RecordingDate_Domo; % get list of recording date...
rt_range = [0 650]; % reaction time range for plot

RecDate = list_RecDate;

RT_hit = []; RT_fa = [];
dPrime4 = []; dPrime3 = [];
n4 = 0; n3 = 0;
figure;
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
    subplot(2,2,1); hold on;
    plot(x,dp,'o','Color',[0.8 0.8 0.8]);
    
    dp_hard(ff) = dp(1);
    dp_easy(ff) = dp(end);
    
    RT_hit = [RT_hit; rt];
    RT_fa  = [RT_fa; rt_tsFA];
end
DP = NaN(5,numel(RecDate)); % summary of dPrime...
DP(1,:) = [dPrime4(1,:) dPrime3(1,:)];
DP(2,1:n4) = dPrime4(2,:);
DP(3,1:n3) = dPrime3(2,:);
DP(4,1:n4) = dPrime4(3,:);
DP(5,:) = [dPrime4(end,:) dPrime3(end,:)];
boxplot(DP','colors','k');
% medDP(1,:) = median([dPrime4(1,:) dPrime3(1,:)]);
% medDP(2,:) = median(dPrime4(2,:));
% medDP(3,:) = median(dPrime3(2,:));
% medDP(4,:) = median(dPrime4(3,:));
% medDP(5,:) = median([dPrime4(end,:) dPrime3(end,:)]);
medDP = nanmedian(DP,2);
% X = [1 2 2.5 3 4];
% plot(X,medDP,'-xk','LineWidth',2);
hold off;
set(gca,'XTick',[1 5],'XTickLabel',{'small','large'},'XLim',[0.5 5.5]);
xlabel('semitone difference'); ylabel('d prime');
box off;

subplot(2,2,2);
boxplot([dp_hard' dp_easy'],'notch','on','colors','k');
set(gca,'XTickLabel',{'small dF','large dF'});
ylabel('d prime');
box off;
[p,h] = signrank(dp_hard,dp_easy);

subplot(2,2,3);
bin = rt_range(1):25:rt_range(2);
histogram(RT_hit,bin); hold on
histogram(RT_fa,bin);
box off;
