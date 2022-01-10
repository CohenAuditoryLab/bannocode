function [ MUA_baseline ] = get_BaselineActivity_ABB( t, MUA_condition )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% define analysis windows (baseline period)
% win_baseline = [-1000:5:-575; -925:5:-500];
% d = 75; % duration of A tone period in the triplet (ms)
win_baseline = [-1000:5:-725; -775:5:-500];
d = 225; % duration of ABB triplet period (ms)

% get spontaneous activity
for k=1:size(win_baseline,2)
    i_baseline = ( t >= win_baseline(1,k) & t < win_baseline(2,k) );
    t_baseline = t(i_baseline);
    mua_baseline = MUA_condition(i_baseline,:);
    MUA_baseline(k,:)  = trapz(t_baseline,mua_baseline) * 1000 / d;
end
% mMUA_spont = ones(size(win_A,2),1) * mean(MUA_spont,1); % mean of the spontaneous MUA
% sMUA_spont = ones(size(win_A,2),1) * std(MUA_spont,0,1); % standard deviation of spontaneous MUA

end

