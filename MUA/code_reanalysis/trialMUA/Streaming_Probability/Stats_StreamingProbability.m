% code for statistical analysis of streaming probability
% modified from Stats_ROC.m
clear all

% choose data directory
thFrom = 'allTriplet1'; % either '1stTriplet', 'Tm1Triplet', or 'allTriplet'
% choose behavioral outcome
behavOut = 'all'; % either 'all', 'hit', or 'miss'

% set path
DATA_DIR = fullfile(pwd,strcat('threshold_',thFrom));
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
BF_Session = 'low'; % either 'low', 'high', or 'all'
% tpos = [1 2 3 6 7]; % 1st to Target
tpos = [1 2 3 6]; % exclude Target
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 4:8; % around target
% tpos = 1:8; % all

% load Data
fName = strcat('StreamingProb_Both_',BF_Session,'BF');
if strcmp(behavOut,'hit')
    fName = strcat(fName,'_hit');
elseif strcmp(behavOut,'miss')
    fName = strcat(fName,'_miss');
end
load(fullfile(DATA_DIR,fName));
% load(fullfile(DATA_DIR,'ROC_Both_lowBF.mat'));

% reshape matrix (sample x tpos x stdiff)
p1srm_post = reshape(pStream.post.single_stream,[size(pStream.post.single_stream,1)*size(pStream.post.single_stream,2) size(pStream.post.single_stream,3) size(pStream.post.single_stream,4)]);
p1srm_ant  = reshape(pStream.ant.single_stream,[size(pStream.ant.single_stream,1)*size(pStream.ant.single_stream,2) size(pStream.ant.single_stream,3) size(pStream.ant.single_stream,4)]);
p2srm_post = reshape(pStream.post.dual_stream,[size(pStream.post.dual_stream,1)*size(pStream.post.dual_stream,2) size(pStream.post.dual_stream,3) size(pStream.post.dual_stream,4)]);
p2srm_ant  = reshape(pStream.ant.dual_stream,[size(pStream.ant.dual_stream,1)*size(pStream.ant.dual_stream,2) size(pStream.ant.dual_stream,3) size(pStream.ant.dual_stream,4)]);
% % hit/miss with intermediate dF trials
% AUC_post_hm = reshape(AUC.post.hitmiss,[size(AUC.post.hitmiss,1)*size(AUC.post.hitmiss,2) size(AUC.post.hitmiss,3) size(AUC.post.hitmiss,4)]);
% AUC_ant_hm  = reshape(AUC.ant.hitmiss,[size(AUC.ant.hitmiss,1)*size(AUC.ant.hitmiss,2) size(AUC.ant.hitmiss,3) size(AUC.ant.hitmiss,4)]);

prob_post = p2srm_post ./ (p1srm_post + p2srm_post);
prob_ant = p2srm_ant ./ (p1srm_ant + p2srm_ant);

% statistical analysis
% Kruskal-Wallis test (Is ROC changing dynamically?) 
for ii=1:4
    pKW_post_df(ii) = kruskalwallis(prob_post(:,tpos,ii),[],'off');
    pKW_ant_df(ii)  = kruskalwallis(prob_ant(:,tpos,ii),[],'off');
end
% for jj=1:2
%     pKW_post_hm(jj) = kruskalwallis(AUC_post_hm(:,tpos,jj),[],'off');
%     pKW_ant_hm(jj)  = kruskalwallis(AUC_ant_hm(:,tpos,jj), [],'off');
% end

% SRH test
[pSRH_post_df,tbl_post_df,~] = stats_CompConditions_SRHtest(prob_post,tpos);
[pSRH_ant_df, tbl_ant_df, ~] = stats_CompConditions_SRHtest(prob_ant,tpos);
% [pSRH_post_hm,tbl_post_hm,~] = stats_CompConditions_SRHtest(AUC_post_hm,tpos);
% [pSRH_ant_hm, tbl_ant_hm, ~] = stats_CompConditions_SRHtest(AUC_ant_hm,tpos);

