% 6/16/22 rewrite the code to reduce the redundancy of the data
DATA_DIR = 'G:\LFP\Frequency'; %'G:\LFP\Coherence';

SessionName = 'MrCassius-190421'; %'MrCassius-190421'; %'MrMiyagi-190904';
Epoch       = 'testToneOnset';
Condition   = 'Both'; %'Pretone';
eID_a       = 'D2'; % electrode ID in 1st column (usually AC electrode)
eID_b       = 'D1'; % electrode ID in 2nd column (usually PFC electrode)

% load data
% fName = strcat('Coherence_',Epoch,'_',Condition);
fName = strcat('Frequency_',Epoch,'_',Condition);
load(fullfile(DATA_DIR,SessionName,fName));

% % plot power spectrum
% S_w = abs(freq_w.fourierspctrm);
% f = freq_w.freq;
% mS_w = squeeze(mean(S_w,1)); % trial average
% 
% mS_elec_w = mS_w(contains(label,'D4'),:); % choose electrode
% figure;
% plot(f,mS_elec_w);

% choose electrode combination
C_c = reshape_coherence(coh_c,eID_a,eID_b); % correct trial
C_w = reshape_coherence(coh_w,eID_a,eID_b); % wrong trial
f   = coh_c.freq;

% % % average across 1st electrode (eID_a) % % %
aveC1_c = squeeze(mean(C_c.cohspctrm_mat,1)); 
aveC1_w = squeeze(mean(C_w.cohspctrm_mat,1)); 
% string_a = strcat('AC_D_', eID_a(end), ' -- PFC_D_', eID_b(end)); % original title...
string_a = strcat('PFC_D_', eID_b(end), ' -- AC_D_', eID_a(end));
% plot coherence
figure('Position',[100 100 1200 700]);
subplot(2,3,1);
plot_coherence(f,aveC1_c,string_a,'n');
subplot(2,3,2);
plot_coherence(f,aveC1_w,string_a,'y');
subplot(2,3,4);
image_coherence(f,aveC1_c,string_a);
subplot(2,3,5);
image_coherence(f,aveC1_w,string_a);
% difference (correct - wrong)
aveC1_d = aveC1_c - aveC1_w; 
subplot(2,3,6);
image_coherence(f,aveC1_d,string_a);

% % % average across 2nd electrode (eID_b) % % %
aveC2_c = squeeze(mean(C_c.cohspctrm_mat,2));
aveC2_w = squeeze(mean(C_w.cohspctrm_mat,2));
% string_b = strcat('PFC_D_', eID_b(end), ' -- AC_D_', eID_a(end)); %original title...
string_b = strcat('AC_D_', eID_a(end), ' -- PFC_D_', eID_b(end));
% plot coherence
figure('Position',[150 150 1200 700]);
subplot(2,3,1);
plot_coherence(f,aveC2_c,string_b,'n');
subplot(2,3,2);
plot_coherence(f,aveC2_w,string_b,'y');
subplot(2,3,4);
image_coherence(f,aveC2_c,string_b);
subplot(2,3,5);
image_coherence(f,aveC2_w,string_b);
% difference (correct - wrong)
aveC2_d = aveC2_c - aveC2_w; 
subplot(2,3,6);
image_coherence(f,aveC2_d,string_b);
