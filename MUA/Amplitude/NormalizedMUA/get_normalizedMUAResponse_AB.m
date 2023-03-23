function [ nMUA_ABB] = get_normalizedMUAResponse_AB( t, nMUA_stdiff )
%UNTITLED4 Summary of this function goes here
%   calculate area under MUA from normalized MUA data

% % define analysis windows...
% win_triplet = [0:225:1125; 225:225:1350];
% win_A  = [0:225:1125; 75:225:1200];
% win_B1 = [75:225:1200; 150:225:1275];
% win_B2 = [150:225:1275; 225:225:1350];
% d_triplet = 225; % duration of triplet (ms)
% d_AB = 75; % duration of A tone period in the triplet (ms)

% define analysis windodws
win_A  = [0:225:2250; 75:225:2325];
win_B1 = [75:225:2325; 150:225:2400];
win_B2 = [150:225:2400; 225:225:2475];
d = 75; % duration of A tone period in the triplet (ms)

for j=1:size(win_A,2)
%     i_triplet = ( t >= win_triplet(1,j) & t < win_triplet(2,j) );
    i_A   = ( t >= win_A(1,j) & t < win_A(2,j) );
    i_B1  = ( t >= win_B1(1,j) & t < win_B1(2,j) );
    i_B2  = ( t >= win_B2(1,j) & t < win_B2(2,j) );
    
%     t_triplet = t(i_triplet);
    t_A  = t(i_A);
    t_B1 = t(i_B1);
    t_B2 = t(i_B2);
    
%     mua_triplet = MUA_stdiff(i_triplet,:);
    mua_A  = nMUA_stdiff(i_A,:);
    mua_B1 = nMUA_stdiff(i_B1,:);
    mua_B2 = nMUA_stdiff(i_B2,:);
    
%     MUA_triplet(j,:) = trapz(t_triplet,mua_triplet) * 1000 / d_triplet;
%     MUA_A(j)  = trapz(t_A,mua_A) * 1000 / d_AB;
%     MUA_B1(j) = trapz(t_B1,mua_B1) * 1000 / d_AB;
%     MUA_B2(j) = trapz(t_B2,mua_B2) * 1000 / d_AB;
    nMUA_ABB(1,j,:)  = trapz(t_A,mua_A) * 1000 / d;
    nMUA_ABB(2,j,:) = trapz(t_B1,mua_B1) * 1000 / d;
    nMUA_ABB(3,j,:) = trapz(t_B2,mua_B2) * 1000 / d;
end

end

