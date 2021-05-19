clear all

file_dir = 'TvsNT';
c = [0 0.4470 0.7410; 0.850 0.325 0.098]; % face color of bar graph
s = {'HIT','MISS'}; % label for the bar graph

% load file...
domo = load(fullfile(file_dir,'TvsNT_Domo'));
cassius = load(fullfile(file_dir,'TvsNT_Cassius'));

% concatenate data
dPrime_A = [domo.dPrime_A cassius.dPrime_A];
dPrime_B = [domo.dPrime_B cassius.dPrime_B];

dpa_mean = nanmean(dPrime_A,2);
dpb_mean = nanmean(dPrime_B,2);
% dpa_std = nanstd(dPrime_A,0,2);
% dpb_std = nanstd(dPrime_B,0,2);
dpa_sem = nanstd(dPrime_A,0,2) / sqrt(size(dPrime_A,2));
dpb_sem = nanstd(dPrime_B,0,2) / sqrt(size(dPrime_B,2));

% show figure
data_y = [dpa_mean dpb_mean];
error_y = [dpa_sem dpb_sem];
[ngroups,nbars] = size(data_y);
groupwidth = min(0.8, nbars/(nbars + 1.5));
h = bar([dpa_mean dpb_mean]); hold on
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, data_y(:,i), error_y(:,i), 'k', 'linestyle', 'none');
end
h(1).FaceColor = c(1,:);
h(2).FaceColor = c(2,:);
set(gca,'XTickLabel',s);
ylabel('d prime');
legend({'tone A','tone B'},'Location',[0.65 0.15 0.2 0.1]);
title('Target vs Non-Target');

% statistical analysis
[H(1,1) P(1,1)] = ttest2(dPrime_A(1,:),dPrime_A(2,:)); % comp hit vs miss
[H(1,2) P(1,2)] = ttest2(dPrime_B(1,:),dPrime_B(2,:)); % comp hit vs miss
[H(2,1) P(2,1)] = ttest2(dPrime_A(1,:),dPrime_B(1,:)); % comp A vs B in hit
[H(2,2) P(2,2)] = ttest2(dPrime_A(2,:),dPrime_B(2,:)); % comp A vs B in miss