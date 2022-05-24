% set parameters
DATA_DIR = '/data/by-user/Share';
SAVE_DIR = '/home/taku/Documents/Data';
sessionID = 'MrCassius-190921';
electrodeID = 'D2_PFC'; %'D4_AC';
alignment = 'testToneOnset'; %'stimOnset';
% nChannel = 16; %24;

% load file
file_name = strcat(sessionID,'_spikesLFP.mat');
if ~exist('all_lfp','var')
    load(fullfile(DATA_DIR,file_name));
end


% select data by alignment type
[chan_name,selData] = selectLFP_by_Alignment(all_lfp,electrodeID,alignment);

% split data
chan_id = selData.chan_id;
trial_id = selData.trial_id;
stim = selData.stim;
prior = selData.prior;
pretone = selData.pretone;
pretoneLength = selData.pretoneLength;
SNR = selData.SNR;
choice = selData.choice;
lfp = selData.lfp;
t = transpose(selData.t);
err = selData.er_name;
sf = selData.sf;

list_chan = unique(chan_id);
nChannel = numel(list_chan);
% rearrange LFP in matrix (sample x trial x channel)
LFP = [];
% SNR_mat = []; % for test
for i = 1:nChannel
    lfp_ch = lfp(chan_id==i,:);
    LFP(:,:,i) = lfp_ch';
    clear lfp_ch
%     SNR_ch = SNR(chan_id==i);
%     SNR_mat(:,i) = SNR_ch;
end

nTrial = size(LFP,2);
% reduce redundancy
trial_id = trial_id(1:nTrial);
stim = stim(1:nTrial,:);
prior = prior(1:nTrial);
pretone = pretone(1:nTrial);
pretoneLength = pretoneLength(1:nTrial);
SNR = SNR(1:nTrial);
choice = choice(1:nTrial);
err = err(1:nTrial);

% save LFP data
save_file_name = strcat('LFP_',electrodeID,'_',alignment);
info = struct('sessionID',sessionID,'electrodeID',electrodeID, ...
    'alignment',alignment,'nChannel',nChannel,'nTrial',nTrial,'sf',sf);
save(fullfile(SAVE_DIR,sessionID,save_file_name), ...
    'LFP','t','trial_id','stim','prior','pretone','pretoneLength', ...
    'SNR','choice','err','info','-v7.3');