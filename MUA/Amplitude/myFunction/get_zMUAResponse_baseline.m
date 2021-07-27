function [ zMUA_BL ] = get_zMUAResponse_baseline( t, MUA_stdiff )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% define baseline windows
win_baseline  = [-575 -75; -500 0]; % 75 ms period immediately before stim onset...
win_spont = [-1000:5:-575; -925:5:-500];
d = 75; % duration of A tone period in the triplet (ms)

% get spontaneous activity
for k=1:size(win_spont,2)
    i_spont = ( t >= win_spont(1,k) & t < win_spont(2,k) );
    t_spont = t(i_spont);
    mua_spont = MUA_stdiff(i_spont,:);
    MUA_spont(k,:)  = trapz(t_spont,mua_spont) * 1000 / d;
end
mMUA_spont = ones(size(win_baseline,2),1) * mean(MUA_spont,1); % mean of the spontaneous MUA
sMUA_spont = ones(size(win_baseline,2),1) * std(MUA_spont,0,1); % standard deviation of spontaneous MUA

% get MUA response for each tone
for j=2 %1:size(win_baseline,2)
    i_BL   = ( t >= win_baseline(1,j) & t < win_baseline(2,j) );
    
    t_BL  = t(i_BL);
    
    mua_BL  = MUA_stdiff(i_BL,:);
    
    MUA_BL(j,:)  = trapz(t_BL,mua_BL) * 1000 / d;
end

% calculate z score
zMUA_BL = ( squeeze(MUA_BL) - mMUA_spont ) ./ sMUA_spont;
% for i=1:3
%     zMUA_ABB(i,:,:) = ( squeeze(MUA_ABB(i,:,:)) - mMUA_spont ) ./ sMUA_spont;
% end

end

