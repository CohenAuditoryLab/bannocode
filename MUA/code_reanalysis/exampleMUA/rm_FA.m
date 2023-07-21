function [MUA_new,stDiff_new,targetTime_new,index_new] = rm_FA(MUA_trial,stDiff,targetTime,index)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% list_stDiff = unique(stDiff);
iValidTrial = ones(length(index),1);
iValidTrial(index==2) = 0; % make FA trials be zero...

MUA_trial(:,iValidTrial==0)  = [];
stDiff(iValidTrial==0)       = [];
targetTime(iValidTrial==0)   = [];
index(iValidTrial==0)        = [];

MUA_new = MUA_trial;
stDiff_new = stDiff;
targetTime_new = targetTime;
index_new = index;

end