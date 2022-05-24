function [unit_name,SelectedData] = selectSpike_by_Alignment(all_spikes,electrode_id,alignment)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

rows = strcmp(all_spikes.align,alignment); % index for data selection

unit_name     = all_spikes.unit_name; 
% align         = all_spikes.align;
trial_id      = all_spikes.trialID;
freq_h        = all_spikes.freqHi;
freq_l        = all_spikes.freqLo;
prior         = all_spikes.prior;
pretone       = all_spikes.pretone;
pretoneLength = all_spikes.pretoneLength;
SNR           = all_spikes.SNR_dB;
choice        = all_spikes.choiceName;
spikes        = all_spikes.spikes;
t_win         = all_spikes.timeWindow;
er_name       = all_spikes.ErrorName;
ch            = all_spikes.channel; 
% sf            = all_spikes.sampFreq;

% select data by alignment
unit_name = unit_name(rows);
% align = align(rows);
trial_id = trial_id(rows);
freq_h = freq_h(rows);
freq_l = freq_l(rows);
prior = prior(rows);
pretone = pretone(rows);
pretoneLength = pretoneLength(rows);
SNR = SNR(rows);
choice = choice(rows);
spikes = spikes(rows);
t_win = t_win(rows,:);
er_name = er_name(rows);
ch = ch(rows);

% select data by electrode
i_elec = contains(unit_name,electrode_id);

unit_name = unit_name(i_elec);
trial_id = trial_id(i_elec);
freq_h = freq_h(i_elec);
freq_l = freq_l(i_elec);
prior = prior(i_elec);
pretone = pretone(i_elec);
pretoneLength = pretoneLength(i_elec);
SNR = SNR(i_elec);
choice = choice(i_elec);
spikes = spikes(i_elec);
t_win = t_win(i_elec,:);
er_name = er_name(i_elec);
ch = ch(i_elec);


% select data by error type (remove fixBreak, noMove, startError)
i_correct = strcmp(er_name,'correct');
i_wrong = strcmp(er_name,'wrong');
i_behav = logical(i_correct + i_wrong);

unit_name = unit_name(i_behav);
trial_id = trial_id(i_behav);
freq_h = freq_h(i_behav);
freq_l = freq_l(i_behav);
prior = prior(i_behav);
pretone = pretone(i_behav);
pretoneLength = pretoneLength(i_behav);
SNR = SNR(i_behav);
choice = choice(i_behav);
spikes = spikes(i_behav);
t_win = t_win(i_behav,:);
er_name = er_name(i_behav);
ch = ch(i_behav);


% convert time stamp to bin
window = t_win(1,:); % spike time window
edges = window(1):window(2);
for i=1:numel(spikes)
    ts = spikes{i}; % spike time stamp
    sp(i,:) = histcounts(ts,edges);
    clear ts
end

% concatenate stimulus parameters
stim = [freq_h freq_l];
% convert cell to char
prior_ch = cell2mat(prior);
pretone_ch = convertCell2Char(pretone);
choice_ch = convertCell2Char(choice);
error_ch = convertCell2Char(er_name);
% convert lfp from cell to double
% lfp_db = cell2mat(lfp);
raster = sp;
% get time vector
tt = edges(1:end-1); %t{1};
% extract channel index number
uID = getUnitID(unit_name);
% % sampling frequency
sf = 1000; % 1-ms bin -> 1000 Hz sampling

SelectedData = struct('unit_id',uID,'trial_id',trial_id,'stim',stim,'win',window, ...
    'prior',prior_ch,'pretone',pretone_ch,'pretoneLength',pretoneLength,'SNR',SNR, ...
    'choice',choice_ch,'raster',raster,'t',tt,'er_name',error_ch,'ch',ch,'sf',sf);

end

