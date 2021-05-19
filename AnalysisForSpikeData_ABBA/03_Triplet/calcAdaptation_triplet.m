function [ dPrime, channel ] = calcAdaptation_triplet(RecDate,ChannelRange,isSave)
% compare response to the 1st and (T-1)th triplet separetely for the
% neurons preferring to the A tone and B tone. For the A-tone-pref neurons,
% responses to the A tone were evaluated, whereas for the B-tone-pref neurons,
% responses to the B rone were evaluated. 

% clear all
% RecDate = '20180727';
% ChannelRange = [0 16]; %[0 24];
% isSave = 0;

% specify data directory
root_dir = '/Volumes/TOSHIBA_EXT/01_STREAMING/ANALYSIS/analysis_after_20190821';
data_dir = fullfile(root_dir,RecDate); % directory for xxx_Raster_triplet.mat
% set directory for saving figures
save_dir = fullfile(root_dir,'across_sessions_triplet','Adaptation');

data_file_name = strcat(RecDate,'_Raster_triplet');
load(fullfile(data_dir,data_file_name));

% calculate ROC and d' 
for k=1:2 % hit and miss trials...
    for j=1:length(list_st) % semitone difference
        a_1st = A{1,j,k}; b1_1st = B1{1,j,k}; b2_1st = B2{1,j,k};
        %         a_tm1 = A{4,j,k}; b_tm1 = B1{4,j,k};
        for i=2:5
            a = A{i,j,k}; b1 = B1{i,j,k}; b2 = B2{i,j,k};
            for n = 1:length(list_cl)
                [auc_A(i-1,j,k,n) dp_A(i-1,j,k,n)] = compDist(a(:,n),a_1st(:,n));
                [auc_B1(i-1,j,k,n) dp_B1(i-1,j,k,n)] = compDist(b1(:,n),b1_1st(:,n));
                [auc_B2(i-1,j,k,n) dp_B2(i-1,j,k,n)] = compDist(b2(:,n),b2_1st(:,n));
            end
        end
    end
end

% get the best semitone difference for tone B
spc_m = SPC_triplet.mean; % triplet x pos x stdiff x hmf x cluster (mean of spike count)
b1_m = permute(spc_m(2,:,:,1,:),[2 3 5 1 4]); % use hit trial...
b1_m = permute(sum(b1_m(1:3,:,:),1),[2 3 1]); % sum of the first 3 triplets
for n=1:length(list_cl)
    b_cl = b1_m(:,n);
    ii = find(b_cl==max(b_cl),1); % get best semitone difference for each neuron...
    d_A(:,:,n) = permute(dp_A(:,ii,:,n),[1 3 4 2]);
    d_B1(:,:,n) = permute(dp_B1(:,ii,:,n),[1 3 4 2]);
    d_B2(:,:,n) = permute(dp_B2(:,ii,:,n),[1 3 4 2]);
%     AUC_A(:,n) = auc_A(ii,:,n);
%     AUC_B(:,n) = auc_B(ii,:,n);
%     i_select(n) = ii;
end

% find responding units (examining adaptation for A and B tone in all active units)
ac_I = clInfo.active_cluster; % active cluster index
for i=1:length(ac_I)
    i_ac(i) = find(list_cl==ac_I(i));
end
ch = clInfo.channel(i_ac) + 1;

ac_A = clInfo.active_clusterA;
if ~isempty(ac_A)
    for i=1:length(ac_A)
        i_acA(i) = find(list_cl==ac_A(i));
    end
    ch_A = clInfo.channel(i_acA) + 1;
else
    i_acA = NaN;
    ch_A = NaN;
end
ac_B = clInfo.active_clusterB;
if ~isempty(ac_B)
    for i=1:length(ac_B)
        i_acB(i) = find(list_cl==ac_B(i));
    end
    ch_B = clInfo.channel(i_acB) + 1;
else
    i_acB = NaN;
    ch_B = NaN;
end

% choose the active units...
dPrime_A = dp_A(:,:,:,i_ac);
dPrime_B1 = dp_B1(:,:,:,i_ac);
dPrime_B2 = dp_B2(:,:,:,i_ac);
% take the mean of adapted triplets (but not the target triplet)
dPrime_A_stdiff = permute(nanmean(dp_A(1:3,:,:,i_ac),1),[2 3 4 1]);
dPrime_B1_stdiff = permute(nanmean(dp_B1(1:3,:,:,i_ac),1),[2 3 4 1]);
dPrime_B2_stdiff = permute(nanmean(dp_B2(1:3,:,:,i_ac),1),[2 3 4 1]);

% take average of adapting triplets
dpa_mean = nanmean(dp_A(1:3,:,:,i_ac),4);
dpb1_mean = nanmean(dp_B1(1:3,:,:,i_ac),4);
dpb2_mean = nanmean(dp_B2(1:3,:,:,i_ac),4);
dpa_sem = nanstd(dp_A(1:3,:,:,i_ac),0,4) / sqrt(length(i_ac));
dpb1_sem = nanstd(dp_B1(1:3,:,:,i_ac),0,4) / sqrt(length(i_ac));
dpb2_sem = nanstd(dp_B2(1:3,:,:,i_ac),0,4) / sqrt(length(i_ac));

% examine response to A and B1
A_mean = nanmean(dPrime_A_stdiff,3);
B1_mean = nanmean(dPrime_B1_stdiff,3);
B2_mean = nanmean(dPrime_B2_stdiff,3);
A_sem = nanstd(dPrime_A_stdiff,0,3) / sqrt(size(dPrime_A_stdiff,3));
B1_sem = nanstd(dPrime_B1_stdiff,0,3) / sqrt(size(dPrime_B1_stdiff,3));
B2_sem = nanstd(dPrime_B2_stdiff,0,3) / sqrt(size(dPrime_B2_stdiff,3));

% take average of adapting triplet (neurons are separeted by preference)
% used for the plot as a function of channel...
if ~isnan(i_acA)
    dPrimeA_chA = permute(nanmean(d_A(1:3,:,i_acA),1),[2 3 1]);
    dPrimeB1_chA = permute(nanmean(d_B1(1:3,:,i_acA),1),[2 3 1]);
    dPrimeB2_chA = permute(nanmean(d_B2(1:3,:,i_acA),1),[2 3 1]);
else
    dPrimeA_chA = NaN(2,1); dPrimeB1_chA = NaN(2,1); dPrimeB2_chA = NaN(2,1);
end
if ~isnan(i_acB)
    dPrimeA_chB = permute(nanmean(d_A(1:3,:,i_acB),1),[2 3 1]);
    dPrimeB1_chB = permute(nanmean(d_B1(1:3,:,i_acB),1),[2 3 1]);
    dPrimeB2_chB = permute(nanmean(d_B2(1:3,:,i_acB),1),[2 3 1]);
else
    dPrimeA_chB = NaN(2,1); dPrimeB1_chB = NaN(2,1); dPrimeB2_chB = NaN(2,1);
end

%% plot data
figure('Position',[300, 500, 700, 500]);
if length(list_st)==3
    shift = ones(3,1) * [-0.15 0 0.15];
elseif length(list_st)==4
    shift = ones(3,1) * [-0.15 -0.05 0.05 0.15];
end
x = (1:3)' * ones(1,length(list_st));
X = x + shift;

subplot(3,3,1); % A hit trials
h = errorbar(X,dpa_mean(:,:,1),dpa_sem(:,:,1),'LineWidth',1.5); hold on
c = get(h,'Color');
% h = errorbar(X,dpa_mean(:,:,2),dpa_sem(:,:,2),'--');
% for n=1:numel(h)
%     set(h(n),'Color',c{n});
% end
set(gca,'xTick',1:3,'xTickLabel',{'2nd','3rd','T-1'});
xlabel('triplet'); ylabel('d-prime');
xlim([0.5 3.5]);
title('adaptation A (Hit)');

subplot(3,3,2); % B1 hit trials
h = errorbar(X,dpb1_mean(:,:,1),dpb1_sem(:,:,1),'LineWidth',1.5); hold on;
set(gca,'xTick',1:3,'xTickLabel',{'2nd','3rd','T-1'});
xlabel('triplet'); ylabel('d-prime');
xlim([0.5 3.5]);
title('adaptation B1 (Hit)');
% legend(num2str(list_st),'Location',[0.88 0.92 0.07 0.05]);

subplot(3,3,3); % B2 hit trials
h = errorbar(X,dpb2_mean(:,:,1),dpb2_sem(:,:,1),'LineWidth',1.5); hold on;
set(gca,'xTick',1:3,'xTickLabel',{'2nd','3rd','T-1'});
xlabel('triplet'); ylabel('d-prime');
xlim([0.5 3.5]);
title('adaptation B2 (Hit)');
legend(num2str(list_st),'Location',[0.88 0.92 0.07 0.05]);

% bar graph comparing hit vs miss
subplot(3,3,4);
[ngroups,nbars] = size(A_mean);
groupwidth = min(0.8, nbars/(nbars + 1.5));
h = bar(A_mean); hold on
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, A_mean(:,i), A_sem(:,i), 'k', 'linestyle', 'none');
end
h(1).FaceColor = c{1}; % c(1,:);
h(2).FaceColor = c{2}; % c(2,:);
set(gca,'XTickLabel',list_st);
xlabel('semitone difference'); ylabel('d-prime');
xlim([0.5 length(list_st)+0.5]);
title('A (Hit vs Miss)');

subplot(3,3,5);
[ngroups,nbars] = size(B1_mean);
groupwidth = min(0.8, nbars/(nbars + 1.5));
h = bar(B1_mean); hold on
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, B1_mean(:,i), B1_sem(:,i), 'k', 'linestyle', 'none');
end
h(1).FaceColor = c{1}; % c(1,:);
h(2).FaceColor = c{2}; % c(2,:);
set(gca,'XTickLabel',list_st);
xlabel('semitone difference'); ylabel('d-prime');
xlim([0.5 length(list_st)+0.5]);
title('B1 (Hit vs Miss)');
% legend({'HIT','MISS'},'Location',[0.88 0.62 0.07 0.05]);

subplot(3,3,6);
[ngroups,nbars] = size(B2_mean);
groupwidth = min(0.8, nbars/(nbars + 1.5));
h = bar(B2_mean); hold on
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, B2_mean(:,i), B2_sem(:,i), 'k', 'linestyle', 'none');
end
h(1).FaceColor = c{1}; % c(1,:);
h(2).FaceColor = c{2}; % c(2,:);
set(gca,'XTickLabel',list_st);
xlabel('semitone difference'); ylabel('d-prime');
xlim([0.5 length(list_st)+0.5]);
title('B1 (Hit vs Miss)');
legend({'HIT','MISS'},'Location',[0.88 0.62 0.07 0.05]);

% plot d-prime as a function of channel
subplot(3,3,7);
plot(ch_A,dPrimeA_chA(1,:),'om'); hold on;
plot(ch_B,dPrimeA_chB(1,:),'^c');
plot(ChannelRange + 0.5,[0 0],':k');
xlim(ChannelRange + 0.5);
xlabel('channel'); ylabel('d-prime');
box off;
title('A (Preference)');

subplot(3,3,8);
plot(ch_A,dPrimeB1_chA(1,:),'om'); hold on;
plot(ch_B,dPrimeB1_chB(1,:),'^c');
plot(ChannelRange + 0.5,[0 0],':k');
xlim(ChannelRange + 0.5);
xlabel('channel'); ylabel('d-prime');
box off;
title('B1 (Preference)');

subplot(3,3,9);
plot(ch_A,dPrimeB2_chA(1,:),'om'); hold on;
plot(ch_B,dPrimeB2_chB(1,:),'^c');
legend({'tone A','tone B'},'Location',[0.88 0.32 0.07 0.05]);
plot(ChannelRange + 0.5,[0 0],':k');
xlim(ChannelRange + 0.5);
xlabel('channel'); ylabel('d-prime');
box off;
title('B2 (Preference)');

if isSave==1
% save figure;
save_file_name = strcat(RecDate,'_Adaptation');
saveas(gcf,fullfile(save_dir,save_file_name),'png');
end

%% struct for output
% reshape matrix
dPrime_A  = reshape_matrix(dPrime_A , list_st);
dPrime_B1 = reshape_matrix(dPrime_B1, list_st);
dPrime_B2 = reshape_matrix(dPrime_B2, list_st);

dPrime.A  = dPrime_A;
dPrime.B1 = dPrime_B1;
dPrime.B2 = dPrime_B2;
% d' for the neurons preferring tone A
dPrime.prefA.A  = dPrimeA_chA;
dPrime.prefA.B1 = dPrimeB1_chA;
dPrime.prefA.B2 = dPrimeB2_chA;
% d' for the neurons preferring tone B
dPrime.prefB.A  = dPrimeA_chB;
dPrime.prefB.B1 = dPrimeB1_chB;
dPrime.prefB.B2 = dPrimeB2_chB;
channel.A = ch_A;
channel.B = ch_B;




end