function [ sig, sigResp, resp, chDepth ] = get_MUASignificance_baseline( RecordingDate, L3_ch )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% RecordingDate = '20180807';
% L3_ch = 8; % channel corresponding to the bottom of layer 3...
% % isSave = 0; % 1 if saving figure...
% blpos = 2; % baseline position 1 = [-575 -500], 2 = [-75 0]

DATA_DIR = fullfile('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results',RecordingDate,'RESP');
f_name = strcat(RecordingDate,'_zMUAbaseline');
th = 1.96; % 95% significance
% th = 2.58; % 99% significance

load(fullfile(DATA_DIR,f_name));
nChannel = size(zBL_behav,3); % number of channels

% resp_BL = squeeze(mean(zBL_behav(blpos,:,:),1)); % behavior x channel
resp_BL = zBL_behav; % blpos x behavior x channel 

sig_BL_pos = (resp_BL > th);
sig_BL_neg = (resp_BL < -th);

sigResp_BL_pos = resp_BL; sigResp_BL_pos(sig_BL_pos==0)   = NaN;
sigResp_BL_neg = resp_BL; sigResp_BL_neg(sig_BL_neg==0)   = NaN;

% get distance from input layer
if nChannel==16
    ch_spacing = 150;
elseif nChannel==24
    ch_spacing = 100;
end
chDepth = 1:nChannel;
chDepth = (chDepth - L3_ch) * ch_spacing;

if isnan(L3_ch)
    x_range = [0 nChannel+1];
    x_label = 'Channel';
else
    x_range = [min(chDepth)-ch_spacing max(chDepth)+ch_spacing];
    x_label = 'Distance from input layer [um]';
end

% reorganize matrix
sig_BL_pos = permute(sig_BL_pos,[3,1,2]); sig_BL_neg = permute(sig_BL_neg,[3,1,2]);
sigResp_BL_pos = permute(sigResp_BL_pos,[3,1,2]); sigResp_BL_neg = permute(sigResp_BL_neg,[3,1,2]);
resp_BL = permute(resp_BL,[3,1,2]);
% sig_A_pos = permute(sig_A_pos,[3,1,2]); sig_A_neg = permute(sig_A_neg,[3,1,2]);
% sig_B1_pos = permute(sig_B1_pos,[3,1,2]); sig_B1_neg = permute(sig_B1_neg,[3,1,2]);
% sig_B2_pos = permute(sig_B2_pos,[3,1,2]); sig_B2_neg = permute(sig_B2_neg,[3,1,2]);
% 
% sigResp_A_pos = permute(sigResp_A_pos,[3,1,2]); sigResp_A_neg = permute(sigResp_A_neg,[3,1,2]);
% sigResp_B1_pos = permute(sigResp_B1_pos,[3,1,2]); sigResp_B1_neg = permute(sigResp_B1_neg,[3,1,2]);
% sigResp_B2_pos = permute(sigResp_B2_pos,[3,1,2]); sigResp_B2_neg = permute(sigResp_B2_neg,[3,1,2]);
% 
% resp_A  = permute(resp_A,[3,1,2]);
% resp_B1 = permute(resp_B1,[3,1,2]);
% resp_B2 = permute(resp_B2,[3,1,2]);

sig.pos = sig_BL_pos;
sig.neg = sig_BL_neg;
sigResp.pos = sigResp_BL_pos;
sigResp.neg = sigResp_BL_neg;

resp = resp_BL;

% s_triplet = {'1st','2nd','3rd'};
% if isSave==1
%     % save figure
%     save_file_dir = DATA_DIR;
%     save_file_name = strcat(RecordingDate,'_MUASignificance_',s_triplet(blpos),'Triplet');
%     saveas(gcf,fullfile(save_file_dir,save_file_name),'png');
%     % save variables
%     save(fullfile(save_file_dir,save_file_name),'sig','sigResp','resp','chDepth','list_st');
% end

end

