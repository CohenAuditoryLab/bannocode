function [ zMUA_ABB ] = get_zMUAResponse_AB( t, MUA_stdiff )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% define analysis windows... modified on 6/20/21
% win_A  = [0:225:1125; 75:225:1200];
% win_B1 = [75:225:1200; 150:225:1275];
% win_B2 = [150:225:1275; 225:225:1350];
% win_spont = [-500:5:-75; -425:5:0];
win_A  = [0:225:2250; 75:225:2325];
win_B1 = [75:225:2325; 150:225:2400];
win_B2 = [150:225:2400; 225:225:2475];
win_spont = [-1000:5:-575; -925:5:-500];
d = 75; % duration of A tone period in the triplet (ms)

% get spontaneous activity
for k=1:size(win_spont,2)
    i_spont = ( t >= win_spont(1,k) & t < win_spont(2,k) );
    t_spont = t(i_spont);
    mua_spont = MUA_stdiff(i_spont,:);
    MUA_spont(k,:)  = trapz(t_spont,mua_spont) * 1000 / d;
end
mMUA_spont = ones(size(win_A,2),1) * mean(MUA_spont,1); % mean of the spontaneous MUA
sMUA_spont = ones(size(win_A,2),1) * std(MUA_spont,0,1); % standard deviation of spontaneous MUA

% get MUA response for each tone
for j=1:size(win_A,2)
    i_A   = ( t >= win_A(1,j) & t < win_A(2,j) );
    i_B1  = ( t >= win_B1(1,j) & t < win_B1(2,j) );
    i_B2  = ( t >= win_B2(1,j) & t < win_B2(2,j) );
    
    t_A  = t(i_A);
    t_B1 = t(i_B1);
    t_B2 = t(i_B2);
    
    mua_A  = MUA_stdiff(i_A,:);
    mua_B1 = MUA_stdiff(i_B1,:);
    mua_B2 = MUA_stdiff(i_B2,:);
    
    MUA_ABB(1,j,:)  = trapz(t_A,mua_A) * 1000 / d;
    MUA_ABB(2,j,:) = trapz(t_B1,mua_B1) * 1000 / d;
    MUA_ABB(3,j,:) = trapz(t_B2,mua_B2) * 1000 / d;
end

% calculate z score
for i=1:3
    zMUA_ABB(i,:,:) = ( squeeze(MUA_ABB(i,:,:)) - mMUA_spont ) ./ sMUA_spont;
end

end

