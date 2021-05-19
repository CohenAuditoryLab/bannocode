clear all

file_dir = 'Selectivity';
c = [0 0.4470 0.7410; 0.850 0.325 0.098]; % face color of bar graph
s = {'HIT','MISS'}; % label for the bar graph
list_st_all = ([1 2 4 8 10 16 24])';
BrainArea = 'Belt'; % either 'Core', 'Belt', or 'All'

% load file...
domo = load(fullfile(file_dir,strcat('Selectivity_Domo_',BrainArea)));
cassius = load(fullfile(file_dir,strcat('Selectivity_Cassius_',BrainArea)));

% concatenate data
% dPrime_A  = cat(4, domo.dPrime_A, cassius.dPrime_A);
dPrime_B1 = cat(4, domo.dPrime_B1, cassius.dPrime_B1);
dPrime_B2 = cat(4, domo.dPrime_B2, cassius.dPrime_B2);

% take the mean of adapted triplets (but not the target triplet)
% dPrime_A_stdiff = permute(nanmean(dPrime_A(1:4,:,:,:),1),[2 3 4 1]);
dPrime_B1_stdiff = permute(nanmean(dPrime_B1(1:4,:,:,:),1),[2 3 4 1]);
dPrime_B2_stdiff = permute(nanmean(dPrime_B2(1:4,:,:,:),1),[2 3 4 1]);

% count number of units to be avaraged...
% nA = sum(~isnan(dPrime_A(1:4,:,:,:)),4);
nB1 = sum(~isnan(dPrime_B1(1:4,:,:,:)),4);
nB2 = sum(~isnan(dPrime_B2(1:4,:,:,:)),4);
% take average of adapting triplets
% dpa_mean = nanmean(dPrime_A(1:4,:,:,:),4);
dpb1_mean = nanmean(dPrime_B1(1:4,:,:,:),4);
dpb2_mean = nanmean(dPrime_B2(1:4,:,:,:),4);
% dpa_sem = nanstd(dPrime_A(1:4,:,:,:),0,4) ./ sqrt(nA);
dpb1_sem = nanstd(dPrime_B1(1:4,:,:,:),0,4) ./ sqrt(nB1);
dpb2_sem = nanstd(dPrime_B2(1:4,:,:,:),0,4) ./ sqrt(nB2);
clear nA nB1 nB2

% count number of units to be avaraged...
% nA = sum(~isnan(dPrime_A_stdiff),3);
nB1 = sum(~isnan(dPrime_B1_stdiff),3);
nB2 = sum(~isnan(dPrime_B2_stdiff),3);
% examine response to A and B1
% A_mean = nanmean(dPrime_A_stdiff,3);
B1_mean = nanmean(dPrime_B1_stdiff,3);
B2_mean = nanmean(dPrime_B2_stdiff,3);
% A_sem = nanstd(dPrime_A_stdiff,0,3) ./ sqrt(nA);
B1_sem = nanstd(dPrime_B1_stdiff,0,3) ./ sqrt(nB1);
B2_sem = nanstd(dPrime_B2_stdiff,0,3) ./ sqrt(nB2);
clear nA nB1 nB2


shift = ones(4,1) * [-0.15 -0.10 -0.05 0 0.05 0.10 0.15];
x = (1:4)' * ones(1,length(list_st_all));
X = x + shift;
% plot data
% figure('Position',[300, 500, 700, 500]);
figure;
subplot(2,2,1); % A hit trials
h = errorbar(X,dpb1_mean(:,:,1),dpb1_sem(:,:,1),'LineWidth',1.5); hold on
set(gca,'xTick',1:4,'xTickLabel',{'1st','2nd','3rd','T-1'});
xlabel('triplet'); ylabel('d-prime');
xlim([0.5 4.5]);
title('A vs B1 (Hit)');

subplot(2,2,2); % B1 hit trials
h = errorbar(X,dpb2_mean(:,:,1),dpb2_sem(:,:,1),'LineWidth',1.5); hold on
set(gca,'xTick',1:4,'xTickLabel',{'1st','2nd','3rd','T-1'});
xlabel('triplet'); ylabel('d-prime');
xlim([0.5 4.5]);
title('A vs B2 (Hit)');
legend(num2str(list_st_all),'Location',[0.90 0.85 0.07 0.05]);

% subplot(2,3,3); % B2 hit trials
% h = errorbar(X,dpb2_mean(:,:,1),dpb2_sem(:,:,1),'LineWidth',1.5); hold on
% set(gca,'xTick',1:3,'xTickLabel',{'2nd','3rd','T-1'});
% xlabel('triplet'); ylabel('d-prime');
% xlim([0.5 3.5]);
% title('adaptation B2 (Hit)');
% legend(num2str(list_st_all),'Location',[0.90 0.85 0.07 0.05]);

subplot(2,2,3);
[ngroups,nbars] = size(B1_mean);
groupwidth = min(0.8, nbars/(nbars + 1.5));
h = bar(B1_mean); hold on
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, B1_mean(:,i), B1_sem(:,i), 'k', 'linestyle', 'none');
end
h(1).FaceColor = c(1,:);
h(2).FaceColor = c(2,:);
set(gca,'XTickLabel',list_st_all);
xlabel('semitone difference'); ylabel('d-prime');
xlim([0.5 length(list_st_all)+0.5]);
title('A vs B1 (Hit vs Miss)');

subplot(2,2,4);
[ngroups,nbars] = size(B2_mean);
groupwidth = min(0.8, nbars/(nbars + 1.5));
h = bar(B2_mean); hold on
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, B2_mean(:,i), B2_sem(:,i), 'k', 'linestyle', 'none');
end
h(1).FaceColor = c(1,:);
h(2).FaceColor = c(2,:);
set(gca,'XTickLabel',list_st_all);
xlabel('semitone difference'); ylabel('d-prime');
xlim([0.5 length(list_st_all)+0.5]);
title('A vs B2 (Hit vs Miss)');
legend({'HIT','MISS'},'Location',[0.90 0.42 0.07 0.05]);

% subplot(2,3,6);
% [ngroups,nbars] = size(B2_mean);
% groupwidth = min(0.8, nbars/(nbars + 1.5));
% h = bar(B2_mean); hold on
% for i = 1:nbars
%     x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     errorbar(x, B2_mean(:,i), B2_sem(:,i), 'k', 'linestyle', 'none');
% end
% h(1).FaceColor = c(1,:);
% h(2).FaceColor = c(2,:);
% set(gca,'XTickLabel',list_st_all);
% xlabel('semitone difference'); ylabel('d-prime');
% xlim([0.5 length(list_st_all)+0.5]);
% title('B2 (Hit vs Miss)');
% legend({'HIT','MISS'},'Location',[0.90 0.42 0.07 0.05]);