% function [ sig, sigResp, resp, chDepth ] = EvaluateResponseSignificance( RecordingDate, L3_ch, tpos, isSave )
% Evaluate MUA response to find channels for further analysis.
% Get the response in hit trials for each semitone difference. The best response 
% in A period and B period are separatley obtained and is compared to get 
% the frequency preference. The statistical significance of response 
% (both A and B periods) is also evaluated.
clear all;

RecordingDate = '20210403';
% tpos = 1; % evaluate the response to the first triplet...
tpos = 1:5; % evaluate the mean response to 1st, 2nd, 3rd, T-1 and T triplets...
% L3_ch = 8; % channel corresponding to the bottom of layer 3...
% isSave = 0; % 1 if saving figure...

DATA_DIR = fullfile('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results',RecordingDate,'RESP');
f_name = strcat(RecordingDate,'_zMUAtriplet');
th = 1.96; % 95% significance
% th = 2.58; % 99% significance

load(fullfile(DATA_DIR,f_name));
nChannel = size(zMUA_A.stdiff,4); % number of channels

resp_A  = squeeze(mean(zMUA_A.stdiff(tpos,:,:,:),1)); % stdiff x HvsM x channel
resp_B1 = squeeze(mean(zMUA_B1.stdiff(tpos,:,:,:),1));
resp_B2 = squeeze(mean(zMUA_B2.stdiff(tpos,:,:,:),1));

% evaluate response in hit trials...
hResp_A = permute(resp_A(:,1,:),[3 1 2]);
hResp_B1 = permute(resp_B1(:,1,:),[3 1 2]);
hResp_B2 = permute(resp_B2(:,1,:),[3 1 2]);

% accept better response to B1 or B2 as B tone response
hResp_B = max(cat(3,hResp_B1,hResp_B2),[],3);

% best response
[best_B,i_B] = max(hResp_B,[],2);
% for ch=1:length(i_B)
%     best_A(ch,1) = hResp_A(ch,i_B(ch));
% end
[best_A,i_A] = max(hResp_A,[],2);

% get preference for A tone (1) or B tone (2)
[~,pref] = max([best_A best_B],[],2);

% evaluate significance
sig_A = zeros(size(pref)); sig_A(best_A>th) = 1;
sig_B = zeros(size(pref)); sig_B(best_B>th) = 1;
sig_Resp = zeros(size(pref)); sig_Resp((sig_A+sig_B)>0)=1;

% evaluate preference
pref_A = zeros(size(pref)); pref_A(pref==1) = 1;
pref_B = zeros(size(pref)); pref_B(pref==2) = 1;
pref_A(sig_Resp==0) = NaN; % do not evaluate pref if no response...
pref_B(sig_Resp==0) = NaN;
clear pref

% reorganize variables for saving...
sig = struct('A',sig_A,'B',sig_B,'Resp',sig_Resp);
pref = struct('A',pref_A,'B',pref_B);

% save data...
save_file_name = strcat(RecordingDate,'_SignificantChannels');
save(fullfile(DATA_DIR,save_file_name),'sig','pref');

% end

