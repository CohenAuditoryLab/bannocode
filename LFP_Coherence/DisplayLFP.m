% plot bipolar LFP in each channel
DATA_DIR = 'G:\LFP\FieldTrip'; %'G:\LFP\Coherence';

SessionName   = 'MrCassius-190421'; %'MrCassius-190421'; %'MrMiyagi-190904';
Epoch         = 'moveOnset'; % either 'testToneOnset', 'preCueOnset' or 'moveOnset'
Condition     = 'Both'; %'Pretone';
eID_ac        = 'D2'; % electrode ID in 1st column (usually AC electrode)
eID_pfc       = 'D1'; % electrode ID in 2nd column (usually PFC electrode)

% load data
% fName = strcat('Coherence_',Epoch,'_',Condition);
fName = strcat(SessionName,'_bipolarLFP_',Epoch);
load(fullfile(DATA_DIR,fName));

% set parameters
params.choice = choice;
params.err = err;
params.pretone = pretone;
params.pretoneLength = pretoneLength;
params.prior = cell2char(prior);
params.SNR = SNR;

% select data
iSelect = setStimulusCondition(Condition);
% choose correct trials
iSelect.err = 'c'; 
data_c = selectData(data,params,iSelect);
% choose wrong trials
iSelect.err = 'w'; 
data_w = selectData(data,params,iSelect);

label = data.label;
t = data.time{1};
LFP_c = cat(3,data_c.trial{:});
LFP_w = cat(3,data_w.trial{:});

% choose data by electrode
lfp_ac_c  = LFP_c(contains(label,eID_ac),:,:);
lfp_pfc_c = LFP_c(contains(label,eID_pfc),:,:);
lfp_ac_w  = LFP_w(contains(label,eID_ac),:,:);
lfp_pfc_w = LFP_w(contains(label,eID_pfc),:,:);
% lfp_ac_d  = lfp_ac_c - lfp_ac_w;
% lfp_pfc_d = lfp_pfc_c - lfp_pfc_w;
label_ac  = label(contains(label,eID_ac));
label_pfc = label(contains(label,eID_pfc));

% AC
figure('Position',[50 50 1200 700]);
dispset = [];
dispset.errortype = 'std'; % standard deviation
dispset.color = 'b';
dispset.isTitle = 'n';
% wrong trial
plot_lfp(t,lfp_ac_w,label_ac,dispset);
% correct trial
dispset.color = 'r';
dispset.isTitle = 'y';
plot_lfp(t,lfp_ac_c,label_ac,dispset);


% PFC
figure('Position',[100 100 1200 700]);
dispset = [];
dispset.errortype = 'std'; % standard deviation
dispset.color = 'b';
dispset.isTitle = 'n';
% wrong trial
plot_lfp(t,lfp_pfc_w,label_pfc,dispset);
% correct trial
dispset.color = 'r';
dispset.isTitle = 'y';
plot_lfp(t,lfp_pfc_c,label_pfc,dispset);