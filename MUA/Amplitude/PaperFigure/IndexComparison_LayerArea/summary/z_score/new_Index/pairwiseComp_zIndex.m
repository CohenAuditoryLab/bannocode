function [p_pw] = pairwiseComp_zIndex(Index1,Index2)
%UNTITLED Summary of this function goes here
%   compare z-scored index between layers

idx1_sCore = Index1.sCore; idx2_sCore = Index2.sCore;
idx1_gCore = Index1.gCore; idx2_gCore = Index2.gCore;
idx1_iCore = Index1.iCore; idx2_iCore = Index2.iCore;

idx1_sBelt = Index1.sBelt; idx2_sBelt = Index2.sBelt;
idx1_gBelt = Index1.gBelt; idx2_gBelt = Index2.gBelt;
idx1_iBelt = Index1.iBelt; idx2_iBelt = Index2.iBelt;

% pairwise comparison of index
p_pw(1,1) = signrank(idx1_sCore,idx2_sCore);
p_pw(2,1) = signrank(idx1_gCore,idx2_gCore);
p_pw(3,1) = signrank(idx1_iCore,idx2_iCore);
p_pw(1,2) = signrank(idx1_sBelt,idx2_sBelt);
p_pw(2,2) = signrank(idx1_gBelt,idx2_gBelt);
p_pw(3,2) = signrank(idx1_iBelt,idx2_iBelt);

end