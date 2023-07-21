% code for statistical analysis of streaming probability
% perform 3-way ANOVA exaniming main effects of stdiff, tpos and behavioral
% outcomes
% modified from Stats_ROC.m
clear all

% choose data directory
thFrom = 'allTriplet1'; % either '1stTriplet', 'Tm1Triplet', or 'allTriplet'
% choose behavioral outcome
% behavOut = 'all'; % either 'all', 'hit', or 'miss'

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

% load Data (Hit)
fName = strcat('StreamingProb_Both_',BF_Session,'BF_hit');
load(fullfile(DATA_DIR,fName));

% reshape matrix (sample x tpos x stdiff)
p1srm_post = reshape(pStream.post.single_stream,[size(pStream.post.single_stream,1)*size(pStream.post.single_stream,2) size(pStream.post.single_stream,3) size(pStream.post.single_stream,4)]);
p1srm_ant  = reshape(pStream.ant.single_stream,[size(pStream.ant.single_stream,1)*size(pStream.ant.single_stream,2) size(pStream.ant.single_stream,3) size(pStream.ant.single_stream,4)]);
p2srm_post = reshape(pStream.post.dual_stream,[size(pStream.post.dual_stream,1)*size(pStream.post.dual_stream,2) size(pStream.post.dual_stream,3) size(pStream.post.dual_stream,4)]);
p2srm_ant  = reshape(pStream.ant.dual_stream,[size(pStream.ant.dual_stream,1)*size(pStream.ant.dual_stream,2) size(pStream.ant.dual_stream,3) size(pStream.ant.dual_stream,4)]);
% adjust probability
prob_post_hit = p2srm_post ./ (p1srm_post + p2srm_post);
prob_ant_hit = p2srm_ant ./ (p1srm_ant + p2srm_ant);
clear p1srm_post p2strm_post p1srm_ant p2srm_ant

% load Data (Miss)
fName = strcat('StreamingProb_Both_',BF_Session,'BF_miss');
load(fullfile(DATA_DIR,fName));

% reshape matrix (sample x tpos x stdiff)
p1srm_post = reshape(pStream.post.single_stream,[size(pStream.post.single_stream,1)*size(pStream.post.single_stream,2) size(pStream.post.single_stream,3) size(pStream.post.single_stream,4)]);
p1srm_ant  = reshape(pStream.ant.single_stream,[size(pStream.ant.single_stream,1)*size(pStream.ant.single_stream,2) size(pStream.ant.single_stream,3) size(pStream.ant.single_stream,4)]);
p2srm_post = reshape(pStream.post.dual_stream,[size(pStream.post.dual_stream,1)*size(pStream.post.dual_stream,2) size(pStream.post.dual_stream,3) size(pStream.post.dual_stream,4)]);
p2srm_ant  = reshape(pStream.ant.dual_stream,[size(pStream.ant.dual_stream,1)*size(pStream.ant.dual_stream,2) size(pStream.ant.dual_stream,3) size(pStream.ant.dual_stream,4)]);
% adjust probability
prob_post_miss = p2srm_post ./ (p1srm_post + p2srm_post);
prob_ant_miss = p2srm_ant ./ (p1srm_ant + p2srm_ant);
clear p1srm_post p2strm_post p1srm_ant p2srm_ant

% concatenate data (ch x tpos x stdiff x hit-miss)
prob_post = cat(4,prob_post_hit,prob_post_miss);
prob_ant  = cat(4,prob_ant_hit,prob_ant_miss);

% statistical analysis
% Kruskal-Wallis test (Is ROC changing dynamically?) 
% for ii=1:4
%     pKW_post_df(ii) = kruskalwallis(prob_post(:,tpos,ii),[],'off');
%     pKW_ant_df(ii)  = kruskalwallis(prob_ant(:,tpos,ii),[],'off');
% end


% SRH test (3-way ANOVA examining effects of stdiff, tpos and behavioral
% outcomes)
[pSRH_post_df,tbl_post_df] = stats_CompConditions_SRHtest3(prob_post,tpos);
[pSRH_ant_df, tbl_ant_df] = stats_CompConditions_SRHtest3(prob_ant,tpos);
