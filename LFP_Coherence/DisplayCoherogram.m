SessionName = 'MrMiyagi-190904';
Epoch = 'testToneOnset';
TrialType = 'Both';

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
C_c = tcoh_c.cohspctrm;
C_w = tcoh_w.cohspctrm;
t   = tcoh_c.time;
f   = tcoh_c.freq;
N = size(C_c,1); % total combination of channels
for i=1:(N/nAveCh)
    i_start = nAveCh * (i-1) + 1;
    i_end   = nAveCh * i;
    aveC_c(:,:,i) = squeeze(mean(C_c(i_start:i_end,:,:),1));
    aveC_w(:,:,i) = squeeze(mean(C_w(i_start:i_end,:,:),1));
    chID{i} = tcoh_c.labelcmb(i_start,2);
end
ACD3_c = aveC_c(:,:,1:2:end);
ACD3_w = aveC_w(:,:,1:2:end);
ACD4_c = aveC_c(:,:,2:2:end);
ACD4_w = aveC_w(:,:,2:2:end);
chID_PFC = chID(1:2:end);

ACD3_PFCD1_c = ACD3_c(:,:,1:14);
ACD3_PFCD2_c = ACD3_c(:,:,15:28);
ACD4_PFCD1_c = ACD4_c(:,:,1:14);
ACD4_PFCD2_c = ACD4_c(:,:,15:28);

ACD3_PFCD1_w = ACD3_w(:,:,1:14);
ACD3_PFCD2_w = ACD3_w(:,:,15:28);
ACD4_PFCD1_w = ACD4_w(:,:,1:14);
ACD4_PFCD2_w = ACD4_w(:,:,15:28);

chLabel_PFC = {'ch02','ch03','ch04','ch05','ch06','ch07','ch08','ch09','ch10','ch11','ch12','ch13','ch14','ch15'};

ch = 12:13; % choose PFC channels ch13 & ch14
% ch = 1:14;
figure('Position',[100 100 1250 750]);
subplot(2,3,1);
imagesc(t,f,mean(ACD3_PFCD1_c(:,:,ch),3)); set(gca,'YDir','normal');
% imagesc(t,f,mean(ACD4_PFCD1_c(:,:,ch),3)); set(gca,'YDir','normal');
xlabel('Time [sec]'); ylabel('Frequency [Hz]');
title('Correct');
subplot(2,3,2);
imagesc(t,f,mean(ACD3_PFCD1_w(:,:,ch),3)); set(gca,'YDir','normal');
% imagesc(t,f,mean(ACD4_PFCD1_w(:,:,ch),3)); set(gca,'YDir','normal');
xlabel('Time [sec]'); ylabel('Frequency [Hz]');
title('Wrong');
subplot(2,3,3);
imagesc(t,f,mean(ACD3_PFCD1_c(:,:,ch) - ACD3_PFCD1_w(:,:,ch),3)); set(gca,'YDir','normal');
% imagesc(t,f,mean(ACD4_PFCD1_c(:,:,ch) - ACD4_PFCD1_w(:,:,ch),3)); set(gca,'YDir','normal');
xlabel('Time [sec]'); ylabel('Frequency [Hz]');
title('Difference');
colormap jet;


% plot coherence between areas...
nAveCh = 14; % number of averaging channel
C2_c = tcoh2_c.cohspctrm;
C2_w = tcoh2_w.cohspctrm;
t   = tcoh2_c.time;
f   = tcoh2_c.freq;
N = size(C2_c,1); % total combination of channels
for i=1:(N/nAveCh)
    i_start = nAveCh * (i-1) + 1;
    i_end   = nAveCh * i;
    aveC2_c(:,:,i) = squeeze(mean(C2_c(i_start:i_end,:,:),1));
    aveC2_w(:,:,i) = squeeze(mean(C2_w(i_start:i_end,:,:),1));
    chID{i} = coh2_c.labelcmb(i_start,2);
end
PFCD1_c = aveC2_c(:,:,1:2:end);
PFCD1_w = aveC2_w(:,:,1:2:end);
PFCD2_c = aveC2_c(:,:,2:2:end);
PFCD2_w = aveC2_w(:,:,2:2:end);
chID_AC = chID(1:2:end);

PFCD1_ACD3_c = PFCD1_c(:,:,1:20);
PFCD1_ACD4_c = PFCD1_c(:,:,21:40);
PFCD2_ACD3_c = PFCD2_c(:,:,1:20);
PFCD2_ACD4_c = PFCD2_c(:,:,21:40);

PFCD1_ACD3_w = PFCD1_w(:,:,1:20);
PFCD1_ACD4_w = PFCD1_w(:,:,21:40);
PFCD2_ACD3_w = PFCD2_w(:,:,1:20);
PFCD2_ACD4_w = PFCD2_w(:,:,21:40);

chLabel_AC = {'ch03','ch04','ch05','ch06','ch07','ch08','ch09','ch10','ch11','ch12','ch13','ch14','ch15','ch16','ch17','ch18','ch19','ch20','ch21','ch22'};

ch = 6:9; % choose AC channel ch8 - ch11
% ch = 3:4; % choose AC channel ch5 - ch6
% ch = 1:20;
% figure;
subplot(2,3,4);
imagesc(t,f,mean(PFCD1_ACD3_c(:,:,ch),3)); set(gca,'YDir','normal');
% imagesc(t,f,mean(PFCD1_ACD4_c(:,:,ch),3)); set(gca,'YDir','normal');
xlabel('Time [sec]'); ylabel('Frequency [Hz]');
title('Correct');
subplot(2,3,5);
imagesc(t,f,mean(PFCD1_ACD3_w(:,:,ch),3)); set(gca,'YDir','normal');
% imagesc(t,f,mean(PFCD1_ACD4_w(:,:,ch),3)); set(gca,'YDir','normal');
xlabel('Time [sec]'); ylabel('Frequency [Hz]');
title('Wrong');
subplot(2,3,6);
imagesc(t,f,mean(PFCD1_ACD3_c(:,:,ch) - PFCD1_ACD3_w(:,:,ch),3)); set(gca,'YDir','normal');
% imagesc(t,f,mean(PFCD1_ACD4_c(:,:,ch) - PFCD1_ACD4_w(:,:,ch),3)); set(gca,'YDir','normal');
xlabel('Time [sec]'); ylabel('Frequency [Hz]');
title('Difference');
colormap jet;