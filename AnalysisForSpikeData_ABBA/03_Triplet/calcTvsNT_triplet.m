function [ dPrime, channel ] = calcTvsNT_triplet(RecDate,isSave)
% compare response to the (T-1)th A tone vs target A tone to caclurate d
% prime separately for the neurons preferring to the A tone and B tone

% clear all
% RecDate = '20180727';
% addpath(RecDate);
% isSave = 0;

% specify data directory
root_dir = '/Volumes/TOSHIBA_EXT/01_STREAMING/ANALYSIS/analysis_after_20190821';
data_dir = fullfile(root_dir,RecDate); % directory for xxx_Raster_triplet.mat
% set directory for saving figures
save_dir = fullfile(root_dir,'across_sessions_triplet','TvsNT');

data_file_name = strcat(RecDate,'_Raster_triplet');
load(fullfile(data_dir,data_file_name));

% calculate ROC and d' 
for k=1:2 % hit and miss trials...
    for j=1:length(list_st) % semitone difference
%         a_1st = A{1,j,k}; b_1st = B1{1,j,k}; % 1st
        a_tm1 = A{4,j,k}; b_tm1 = B1{4,j,k}; % (target - 1)th
        a_tar = A{5,j,k}; b_tar = B1{5,j,k}; % target
        for n = 1:length(list_cl)
            [auc_A(j,k,n) dp_A(j,k,n)] = compDist(a_tar(:,n),a_tm1(:,n));
            [auc_B(j,k,n) dp_B(j,k,n)] = compDist(b_tar(:,n),b_tm1(:,n));
        end
    end
end

% get the best semitone difference for tone B
spc_m = SPC_triplet.mean; % triplet(ABB) x pos x stdiff x hmf x cluster
b1_m = permute(spc_m(2,:,:,1,:),[2 3 5 1 4]); % use hit trial...
b1_m = permute(sum(b1_m(1:3,:,:),1),[2 3 1]); % sum of 1st to 3rd triplet response...
for n=1:length(list_cl)
    b_cl = b1_m(:,n);
    ii = find(b_cl==max(b_cl),1); % get best semitone difference for each neuron...
    d_A(:,n) = dp_A(ii,:,n);
    d_B(:,n) = dp_B(ii,:,n);
%     AUC_A(:,n) = auc_A(ii,:,n);
%     AUC_B(:,n) = auc_B(ii,:,n);
%     i_select(n) = ii;
end

% find responding units
ac_A = clInfo.active_clusterA;
if ~isempty(ac_A)
    for i=1:length(ac_A)
        i_acA(i) = find(list_cl==ac_A(i));
    end
    ch_A = clInfo.channel(i_acA) + 1;
    dPrime_A = d_A(:,i_acA);
else
    ch_A = NaN;
    dPrime_A = NaN(2,1);
end

ac_B = clInfo.active_clusterB;
if ~isempty(ac_B)
    for i=1:length(ac_B)
        i_acB(i) = find(list_cl==ac_B(i));
    end
    ch_B = clInfo.channel(i_acB) + 1;
%     dPrime_B = d_B(:,i_acB);
    dPrime_B = d_A(:,i_acB); % evaluate response to the target even in B pref neurons...
else
    ch_B = NaN;
    dPrime_B = NaN(2,1);
end


% plot data
figure;
s = {'HIT','MISS'};
for k=1:2
    subplot(3,1,k);
    h(1) = plot(ch_A,dPrime_A(k,:),'o'); hold on;
    h(2) = plot(ch_B,dPrime_B(k,:),'^');
    box off;
    xlabel('channel');
    ylabel('d-prime');
    title(s{k});
end
c(1,:) = get(h(1),'Color');
c(2,:) = get(h(2),'Color');
clear h

dpa_mean = nanmean(dPrime_A,2);
dpb_mean = nanmean(dPrime_B,2);
dpa_sem = nanstd(dPrime_A,0,2) / sqrt(size(dPrime_A,2));
dpb_sem = nanstd(dPrime_B,0,2) / sqrt(size(dPrime_B,2));

subplot(3,2,5);
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
legend({'tone A','tone B'},'Location',[0.5 0.22 0.2 0.1]);

if isSave==1
    % save figure;
    save_file_name = strcat(RecDate,'_TvsNT');
    saveas(gcf,fullfile(save_dir,save_file_name),'png');
end

% struct for output
dPrime.A = dPrime_A;
dPrime.B = dPrime_B;
channel.A = ch_A;
channel.B = ch_B;




end