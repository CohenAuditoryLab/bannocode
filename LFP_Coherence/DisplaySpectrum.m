% 6/16/22 rewrite the code to reduce the redundancy of the data
DATA_DIR = 'G:\LFP\Frequency'; %'G:\LFP\Coherence';

SessionName   = 'MrCassius-190421'; %'MrCassius-190421'; %'MrMiyagi-190904';
Epoch         = 'testToneOnset';
Condition     = 'Both'; %'Pretone';
eID_ac        = 'D2'; % electrode ID in 1st column (usually AC electrode)
eID_pfc       = 'D1'; % electrode ID in 2nd column (usually PFC electrode)

% load data
% fName = strcat('Coherence_',Epoch,'_',Condition);
fName = strcat('Frequency_',Epoch,'_',Condition);
load(fullfile(DATA_DIR,SessionName,fName));

S_c   = fd_c.powspctrm;
S_w   = fd_w.powspctrm;
label = fd_c.label;
f     = fd_c.freq; 

% choose data by electrode
S_ac_c  = S_c(contains(label,eID_ac),:);
S_pfc_c = S_c(contains(label,eID_pfc),:);
S_ac_w  = S_w(contains(label,eID_ac),:);
S_pfc_w = S_w(contains(label,eID_pfc),:);
S_ac_d  = S_ac_c - S_ac_w;
S_pfc_d = S_pfc_c - S_pfc_w;
label_ac  = label(contains(label,eID_ac));
label_pfc = label(contains(label,eID_pfc));

string_ac = strcat('AC_D_',(eID_ac(end)));
string_pfc = strcat('PFC_D_',(eID_pfc(end)));

% display AC spectrum power
figure('Position',[50 50 1200 700]);
subplot(2,3,1);
plot_spectrum(f,S_ac_c,string_ac,'n');
subplot(2,3,2);
plot_spectrum(f,S_ac_w,string_ac,'n');
subplot(2,3,3);
plot_spectrum(f,S_ac_d,string_ac,'y');
subplot(2,3,4);
image_coherence(f,S_ac_c,string_ac);
subplot(2,3,5);
image_coherence(f,S_ac_w,string_ac);
% difference (correct - wrong) 
subplot(2,3,6);
image_coherence(f,S_ac_d,string_ac);

% display PFC spectrum power
figure('Position',[100 100 1200 700]);
subplot(2,3,1);
plot_spectrum(f,S_pfc_c,string_pfc,'n');
subplot(2,3,2);
plot_spectrum(f,S_pfc_w,string_pfc,'n');
subplot(2,3,3);
plot_spectrum(f,S_pfc_d,string_pfc,'y');
subplot(2,3,4);
image_coherence(f,S_pfc_c,string_pfc);
subplot(2,3,5);
image_coherence(f,S_pfc_w,string_pfc);
% difference (correct - wrong) 
subplot(2,3,6);
image_coherence(f,S_pfc_d,string_pfc);

