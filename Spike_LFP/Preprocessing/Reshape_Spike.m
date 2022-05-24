% set parameters
DATA_DIR = '/data/by-user/Share';
SAVE_DIR = '/home/taku/Documents/Data';
sessionID = 'MrCassius-190921';
electrodeID = 'D2_PFC'; %'D3_AC';
alignment = 'testToneOnset'; % stimOnset;
% nChannel = 24; %16;

% load file
file_name = strcat(sessionID,'_spikesLFP.mat');
if ~exist('all_spikes','var')
    load(fullfile(DATA_DIR,file_name));
end

% select data by alignment type
[unit_name,selData] = selectSpike_by_Alignment(all_spikes,electrodeID,alignment);

% split data
unit_id = selData.unit_id;
trial_id = selData.trial_id;
stim = selData.stim;
win = selData.win;
prior = selData.prior;
pretone = selData.pretone;
pretoneLength = selData.pretoneLength;
SNR = selData.SNR;
choice = selData.choice;
raster = selData.raster;
t = transpose(selData.t);
err = selData.er_name;
sf = selData.sf;
ch = selData.ch;

list_unit = unique(unit_id);
nUnit = numel(list_unit);
% rearrange raster in matrix (sample x trial x unit)
Spikes = [];
% SNR_mat = []; % for test
for i = 1:nUnit
    sp_ch = raster(unit_id==list_unit(i),:);
    Spikes(:,:,i) = sp_ch';
    clear sp_ch
%     SNR_ch = SNR(unit_id==i);
%     SNR_mat(:,i) = SNR_ch;
end
nTrial = size(Spikes,2);
unit_mat = reshape(unit_id,nTrial,nUnit);
ch_mat = reshape(ch,nTrial,nUnit);

% reduce redundancy
trial_id = trial_id(1:nTrial);
stim = stim(1:nTrial,:);
prior = prior(1:nTrial);
pretone = pretone(1:nTrial);
pretoneLength = pretoneLength(1:nTrial);
SNR = SNR(1:nTrial);
choice = choice(1:nTrial);
err = err(1:nTrial);
% unit information
unit_id = unit_mat(1,:);
ch_id = ch_mat(1,:);

% save Spike data
save_file_name = strcat('Spike_',electrodeID,'_',alignment);
info = struct('sessionID',sessionID,'electrodeID',electrodeID, ...
    'alignment',alignment,'nUnit',nUnit,'nTrial',nTrial,'window',win,'sf',sf);
save(fullfile(SAVE_DIR,sessionID,save_file_name), ...
    'Spikes','t','trial_id','unit_id','ch_id','stim','prior','pretone','pretoneLength', ...
    'SNR','choice','err','info','-v7.3');