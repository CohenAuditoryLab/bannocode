SessionName = 'MrMiyagi-190904';
Epoch = 'testToneOnset';
TrialType = 'Both'; %'Pretone';

% load data
fName = strcat('coherence_',TrialType);
load(fName);

% % plot power spectrum
% S_w = abs(freq_w.fourierspctrm);
% f = freq_w.freq;
% mS_w = squeeze(mean(S_w,1)); % trial average
% 
% mS_elec_w = mS_w(contains(label,'D4'),:); % choose electrode
% figure;
% plot(f,mS_elec_w);

% plot coherence between areas...
nAveCh = 20; % number of averaging channel
C_c = coh_c.cohspctrm;
C_w = coh_w.cohspctrm;
f   = coh_c.freq;
N = size(C_c,1); % total combination of channels
for i=1:(N/nAveCh)
    i_start = nAveCh * (i-1) + 1;
    i_end   = nAveCh * i;
    aveC_c(i,:) = mean(C_c(i_start:i_end,:),1);
    aveC_w(i,:) = mean(C_w(i_start:i_end,:),1);
    chID{i} = coh_c.labelcmb(i_start,2);
end
ACD3_c = aveC_c(1:2:end,:);
ACD3_w = aveC_w(1:2:end,:);
ACD4_c = aveC_c(2:2:end,:);
ACD4_w = aveC_w(2:2:end,:);
chID_PFC = chID(1:2:end);

ACD3_PFCD1_c = ACD3_c(1:14,:);
ACD3_PFCD2_c = ACD3_c(15:28,:);
ACD4_PFCD1_c = ACD4_c(1:14,:);
ACD4_PFCD2_c = ACD4_c(15:28,:);

ACD3_PFCD1_w = ACD3_w(1:14,:);
ACD3_PFCD2_w = ACD3_w(15:28,:);
ACD4_PFCD1_w = ACD4_w(1:14,:);
ACD4_PFCD2_w = ACD4_w(15:28,:);

chLabel_PFC = {'ch02','ch03','ch04','ch05','ch06','ch07','ch08','ch09','ch10','ch11','ch12','ch13','ch14','ch15'};

figure;
plotCoherence(f,ACD3_PFCD1_c);
% plotCoherence(f,ACD3_PFCD1_w);
xlabel('Frequency [Hz]'); ylabel('Coherence');
legend(chLabel_PFC);
title('AC_D_3 -- PFC_D_1 correct');
% title('AC_D_3 -- PFC_D_1 wrong');

figure;
imagesc(f(f<100),2:15,ACD3_PFCD1_c(:,f<100));
% imagesc(f(f<100),2:15,ACD3_PFCD1_w(:,f<100));
xlabel('Frequency [Hz]'); ylabel('PFC Electrode Channel');
title('AC_D_3 -- PFC_D_1 correct');
% title('AC_D_3 -- PFC_D_1 wrong');
colormap jet

figure;
plotCoherence(f,ACD3_PFCD2_c);
% plotCoherence(f,ACD3_PFCD2_w);
xlabel('Frequency [Hz]'); ylabel('Coherence');
legend(chLabel_PFC);
title('AC_D_3 -- PFC_D_2 correct');
% title('AC_D_3 -- PFC_D_2 wrong');

figure;
imagesc(f(f<100),2:15,ACD3_PFCD2_c(:,f<100));
% imagesc(f(f<100),2:15,ACD3_PFCD2_w(:,f<100));
xlabel('Frequency [Hz]'); ylabel('PFC Electrode Channel');
title('AC_D_3 -- PFC_D_2 correct');
% title('AC_D_3 -- PFC_D_2 wrong');
colormap jet

figure;
plotCoherence(f,ACD4_PFCD1_c);
% plotCoherence(f,ACD4_PFCD1_w);
xlabel('Frequency [Hz]'); ylabel('Coherence');
legend(chLabel_PFC);
title('AC_D_4 -- PFC_D_1 correct');
% title('AC_D_4 -- PFC_D_1 wrong');

figure;
imagesc(f(f<100),2:15,ACD4_PFCD1_c(:,f<100));
% imagesc(f(f<100),2:15,ACD4_PFCD1_w(:,f<100));
xlabel('Frequency [Hz]'); ylabel('PFC Electrode Channel');
title('AC_D_4 -- PFC_D_1 correct');
% title('AC_D_4 -- PFC_D_1 wrong');
colormap jet

figure;
plotCoherence(f,ACD4_PFCD2_c);
% plotCoherence(f,ACD4_PFCD2_w);
xlabel('Frequency [Hz]'); ylabel('Coherence');
legend(chLabel_PFC);
title('AC_D_4 -- PFC_D_2 correct');
% title('AC_D_4 -- PFC_D_2 wrong');

figure;
imagesc(f(f<100),2:15,ACD4_PFCD2_c(:,f<100));
% imagesc(f(f<100),2:15,ACD4_PFCD2_w(:,f<100));
xlabel('Frequency [Hz]'); ylabel('PFC Electrode Channel');
title('AC_D_4 -- PFC_D_2 correct');
% title('AC_D_4 -- PFC_D_2 wrong');
colormap jet

% % difference...
figure;
diffC = ACD4_PFCD1_c - ACD4_PFCD1_w;
% diffC = ACD3_PFCD1_c - ACD3_PFCD1_w;
imagesc(f(f<100),2:15,diffC(:,f<100));
xlabel('Frequency [Hz]'); ylabel('PFC Electrode Channel');
title('AC_D_4 -- PFC_D_1 difference');
% title('AC_D_3 -- PFC_D_1 difference');
colormap jet

% plot coherence between areas...
nAveCh = 14; % number of averaging channel
C2_c = coh2_c.cohspctrm;
C2_w = coh2_w.cohspctrm;
f   = coh2_c.freq;
N = size(C2_c,1); % total combination of channels
for i=1:(N/nAveCh)
    i_start = nAveCh * (i-1) + 1;
    i_end   = nAveCh * i;
    aveC2_c(i,:) = mean(C2_c(i_start:i_end,:),1);
    aveC2_w(i,:) = mean(C2_w(i_start:i_end,:),1);
    chID{i} = coh2_c.labelcmb(i_start,2);
end
PFCD1_c = aveC2_c(1:2:end,:);
PFCD1_w = aveC2_w(1:2:end,:);
PFCD2_c = aveC2_c(2:2:end,:);
PFCD2_w = aveC2_w(2:2:end,:);
chID_AC = chID(1:2:end);

PFCD1_ACD3_c = PFCD1_c(1:20,:);
PFCD1_ACD4_c = PFCD1_c(21:40,:);
PFCD2_ACD3_c = PFCD2_c(1:20,:);
PFCD2_ACD4_c = PFCD2_c(21:40,:);

PFCD1_ACD3_w = PFCD1_w(1:20,:);
PFCD1_ACD4_w = PFCD1_w(21:40,:);
PFCD2_ACD3_w = PFCD2_w(1:20,:);
PFCD2_ACD4_w = PFCD2_w(21:40,:);

chLabel_AC = {'ch03','ch04','ch05','ch06','ch07','ch08','ch09','ch10','ch11','ch12','ch13','ch14','ch15','ch16','ch17','ch18','ch19','ch20','ch21','ch22'};

figure;
plotCoherence(f,PFCD1_ACD3_c);
% plotCoherence(f,PFCD1_ACD3_w);
xlabel('Frequency [Hz]'); ylabel('Coherence');
legend(chLabel_AC);
title('PFC_D_1 -- AC_D_3 correct');
% title('PFC_D_1 -- AC_D_3 wrong');

figure;
imagesc(f(f<100),3:22,PFCD1_ACD3_c(:,f<100));
% imagesc(f(f<100),3:22,PFCD1_ACD3_w(:,f<100));
xlabel('Frequency [Hz]'); ylabel('AC Electrode Channel');
title('PFC_D_1 -- AC_D_3 correct');
% title('PFC_D_1 -- AC_D_3 wrong');
colormap jet

figure;
plotCoherence(f,PFCD1_ACD4_c);
% plotCoherence(f,PFCD1_ACD4_w);
xlabel('Frequency [Hz]'); ylabel('Coherence');
legend(chLabel_AC);
title('PFC_D_1 -- AC_D_4 correct');
% title('PFC_D_1 -- AC_D_4 wrong');

figure;
imagesc(f(f<100),3:22,PFCD1_ACD4_c(:,f<100));
% imagesc(f(f<100),3:22,PFCD1_ACD4_w(:,f<100));
xlabel('Frequency [Hz]'); ylabel('AC Electrode Channel');
title('PFC_D_1 -- AC_D_4 correct');
% title('PFC_D_1 -- AC_D_4 wrong');
colormap jet

figure;
plotCoherence(f,PFCD2_ACD3_c);
% plotCoherence(f,PFCD2_ACD3_w);
xlabel('Frequency [Hz]'); ylabel('Coherence');
legend(chLabel_AC);
title('PFC_D_2 -- AC_D_3 correct');
% title('PFC_D_2 -- AC_D_3 wrong');

figure;
imagesc(f(f<100),3:22,PFCD2_ACD3_c(:,f<100));
% imagesc(f(f<100),3:22,PFCD2_ACD3_w(:,f<100));
xlabel('Frequency [Hz]'); ylabel('AC Electrode Channel');
title('PFC_D_2 -- AC_D_3 correct');
% title('PFC_D_2 -- AC_D_3 wrong');
colormap jet

figure;
plotCoherence(f,PFCD2_ACD4_c);
% plotCoherence(f,PFCD2_ACD4_w);
xlabel('Frequency [Hz]'); ylabel('Coherence');
legend(chLabel_AC);
title('PFC_D_2 -- AC_D_4 correct');
% title('PFC_D_2 -- AC_D_4 wrong');

figure;
imagesc(f(f<100),3:22,PFCD2_ACD4_c(:,f<100));
% imagesc(f(f<100),3:22,PFCD2_ACD4_w(:,f<100));
xlabel('Frequency [Hz]'); ylabel('AC Electrode Channel');
title('PFC_D_2 -- AC_D_4 correct');
% title('PFC_D_2 -- AC_D_4 wrong');
colormap jet

% % difference...
figure;
% diffC = PFCD1_ACD4_c - PFCD1_ACD4_w;
diffC = PFCD1_ACD3_c - PFCD1_ACD3_w;
imagesc(f(f<100),3:22,diffC(:,f<100));
xlabel('Frequency [Hz]'); ylabel('AC Electrode Channel');
% title('PFC_D_1 -- AC_D_4 difference');
title('PFC_D_1 -- AC_D_3 difference');
colormap jet