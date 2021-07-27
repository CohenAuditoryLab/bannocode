function [ MUA_ABB, MUA_triplet ] = get_MUAResponse_AB( t, MUA_stdiff )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% define analysis windows...
win_triplet = [0:225:1125; 225:225:1350];
win_A  = [0:225:1125; 75:225:1200];
win_B1 = [75:225:1200; 150:225:1275];
win_B2 = [150:225:1275; 225:225:1350];
d_triplet = 225; % duration of triplet (ms)
d_AB = 75; % duration of A tone period in the triplet (ms)

for j=1:size(win_triplet,2)
    i_triplet = ( t >= win_triplet(1,j) & t < win_triplet(2,j) );
    i_A   = ( t >= win_A(1,j) & t < win_A(2,j) );
    i_B1  = ( t >= win_B1(1,j) & t < win_B1(2,j) );
    i_B2  = ( t >= win_B2(1,j) & t < win_B2(2,j) );
    
    t_triplet = t(i_triplet);
    t_A  = t(i_A);
    t_B1 = t(i_B1);
    t_B2 = t(i_B2);
    
    mua_triplet = MUA_stdiff(i_triplet,:);
    mua_A  = MUA_stdiff(i_A,:);
    mua_B1 = MUA_stdiff(i_B1,:);
    mua_B2 = MUA_stdiff(i_B2,:);
    
    MUA_triplet(j,:) = trapz(t_triplet,mua_triplet) * 1000 / d_triplet;
%     MUA_A(j)  = trapz(t_A,mua_A) * 1000 / d_AB;
%     MUA_B1(j) = trapz(t_B1,mua_B1) * 1000 / d_AB;
%     MUA_B2(j) = trapz(t_B2,mua_B2) * 1000 / d_AB;
    MUA_ABB(1,j,:)  = trapz(t_A,mua_A) * 1000 / d_AB;
    MUA_ABB(2,j,:) = trapz(t_B1,mua_B1) * 1000 / d_AB;
    MUA_ABB(3,j,:) = trapz(t_B2,mua_B2) * 1000 / d_AB;
end

end

