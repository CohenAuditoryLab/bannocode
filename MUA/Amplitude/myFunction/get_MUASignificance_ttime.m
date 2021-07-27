function [ sig, sigResp, resp, chDepth, list_tt ] = get_MUASignificance_ttime( RecordingDate, L3_ch, tpos, isSave )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% RecordingDate = '20180727';
% L3_ch = 8; % channel corresponding to the bottom of layer 3...
% isSave = 0; % 1 if saving figure...
% tpos = 5; % triplet position target = 5

DATA_DIR = fullfile('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results',RecordingDate,'RESP');
f_name = strcat(RecordingDate,'_zMUAtriplet');
th = 1.96; % 95% significance
% th = 2.58; % 99% significance

load(fullfile(DATA_DIR,f_name));
nChannel = size(zMUA_A.stdiff,4); % number of channels

resp_A  = squeeze(mean(zMUA_A.ttime(tpos,:,:,:),1)); % ttime x HvsM x channel
resp_B1 = squeeze(mean(zMUA_B1.ttime(tpos,:,:,:),1));
resp_B2 = squeeze(mean(zMUA_B2.ttime(tpos,:,:,:),1));

sig_A_pos  = (resp_A > th);
sig_B1_pos = (resp_B1 > th);
sig_B2_pos = (resp_B2 > th);
sig_A_neg  = (resp_A < -th);
sig_B1_neg = (resp_B1 < -th);
sig_B2_neg = (resp_B2 < -th);

sigResp_A_pos  = resp_A;  sigResp_A_pos(sig_A_pos==0)   = NaN;
sigResp_B1_pos = resp_B1; sigResp_B1_pos(sig_B1_pos==0) = NaN;
sigResp_B2_pos = resp_B2; sigResp_B2_pos(sig_B2_pos==0) = NaN;
sigResp_A_neg  = resp_A;  sigResp_A_neg(sig_A_neg==0)   = NaN;
sigResp_B1_neg = resp_B1; sigResp_B1_neg(sig_B1_neg==0) = NaN;
sigResp_B2_neg = resp_B2; sigResp_B2_neg(sig_B2_neg==0) = NaN;

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
sig_A_pos = permute(sig_A_pos,[3,1,2]); sig_A_neg = permute(sig_A_neg,[3,1,2]);
sig_B1_pos = permute(sig_B1_pos,[3,1,2]); sig_B1_neg = permute(sig_B1_neg,[3,1,2]);
sig_B2_pos = permute(sig_B2_pos,[3,1,2]); sig_B2_neg = permute(sig_B2_neg,[3,1,2]);

sigResp_A_pos = permute(sigResp_A_pos,[3,1,2]); sigResp_A_neg = permute(sigResp_A_neg,[3,1,2]);
sigResp_B1_pos = permute(sigResp_B1_pos,[3,1,2]); sigResp_B1_neg = permute(sigResp_B1_neg,[3,1,2]);
sigResp_B2_pos = permute(sigResp_B2_pos,[3,1,2]); sigResp_B2_neg = permute(sigResp_B2_neg,[3,1,2]);

resp_A  = permute(resp_A,[3,1,2]);
resp_B1 = permute(resp_B1,[3,1,2]);
resp_B2 = permute(resp_B2,[3,1,2]);

sig.pos = struct('A',sig_A_pos,'B1',sig_B1_pos,'B2',sig_B2_pos);
sig.neg = struct('A',sig_A_neg,'B1',sig_B1_neg,'B2',sig_B2_neg);
sigResp.pos = struct('A',sigResp_A_pos,'B1',sigResp_B1_pos,'B2',sigResp_B2_pos);
sigResp.neg = struct('A',sigResp_A_neg,'B1',sigResp_B1_neg,'B2',sigResp_B2_neg);

resp = struct('A',resp_A,'B1',resp_B1,'B2',resp_B2);

s_triplet = {'1st','2nd','3rd'};
if isSave==1
    % save figure
    save_file_dir = DATA_DIR;
    save_file_name = strcat(RecordingDate,'_MUASignificance_TT',s_triplet(tpos),'ms');
    saveas(gcf,fullfile(save_file_dir,save_file_name),'png');
    % save variables
    save(fullfile(save_file_dir,save_file_name),'sig','sigResp','resp','chDepth','list_tt');
end

end

