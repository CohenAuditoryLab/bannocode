function [chan_name,SelectedData] = selectLFP_by_Alignment(all_lfp,electrode_id,alignment)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

rows = strcmp(all_lfp.align,alignment); % index for data selection

chan_name     = all_lfp.chan_name; 
% align         = all_lfp.align;
trial_id      = all_lfp.trialID;
freq_h        = all_lfp.freqHi;
freq_l        = all_lfp.freqLo;
prior         = all_lfp.prior;
pretone       = all_lfp.pretone;
pretoneLength = all_lfp.pretoneLength;
SNR           = all_lfp.SNR_dB;
choice        = all_lfp.choiceName;
lfp           = all_lfp.lfp;
t             = all_lfp.timeBin;
er_name       = all_lfp.ErrorName;
sf            = all_lfp.sampFreq;

% select data by alignment
chan_name = chan_name(rows);
% align = align(rows);
trial_id = trial_id(rows);
freq_h = freq_h(rows);
freq_l = freq_l(rows);
prior = prior(rows);
pretone = pretone(rows);
pretoneLength = pretoneLength(rows);
SNR = SNR(rows);
choice = choice(rows);
lfp = lfp(rows);
t = t(rows);
er_name = er_name(rows);

% select data by electrode
i_elec = contains(chan_name,electrode_id);

chan_name = chan_name(i_elec);
trial_id = trial_id(i_elec);
freq_h = freq_h(i_elec);
freq_l = freq_l(i_elec);
prior = prior(i_elec);
pretone = pretone(i_elec);
pretoneLength = pretoneLength(i_elec);
SNR = SNR(i_elec);
choice = choice(i_elec);
lfp = lfp(i_elec);
t = t(i_elec);
er_name = er_name(i_elec);

% select data by error type (remove fixBreak, noMove, startError)
i_correct = strcmp(er_name,'correct');
i_wrong = strcmp(er_name,'wrong');
i_behav = logical(i_correct + i_wrong);

chan_name = chan_name(i_behav);
trial_id = trial_id(i_behav);
freq_h = freq_h(i_behav);
freq_l = freq_l(i_behav);
prior = prior(i_behav);
pretone = pretone(i_behav);
pretoneLength = pretoneLength(i_behav);
SNR = SNR(i_behav);
choice = choice(i_behav);
lfp = lfp(i_behav);
t = t(i_behav);
er_name = er_name(i_behav);

% concatenate stimulus parameters
stim = [freq_h freq_l];
% convert cell to char
prior_ch = cell2mat(prior);
pretone_ch = convertCell2Char(pretone);
choice_ch = convertCell2Char(choice);
error_ch = convertCell2Char(er_name);
% convert lfp from cell to double
lfp_db = cell2mat(lfp);
% get time vector
tt = t{1};
% extract channel index number
chID = getChannelID(chan_name);
% sampling frequency
sf = sf(1); % never changed in the session...

SelectedData = struct('chan_id',chID,'trial_id',trial_id,'stim',stim, ...
    'prior',prior_ch,'pretone',pretone_ch,'pretoneLength',pretoneLength,'SNR',SNR, ...
    'choice',choice_ch,'lfp',lfp_db,'t',tt,'er_name',error_ch,'sf',sf);

end

