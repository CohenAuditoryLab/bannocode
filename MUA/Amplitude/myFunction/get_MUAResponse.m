function [ MUA_resp, MUA_spont, MUA_stim ] = get_MUAResponse( t, MUA_stdiff, win )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% win = [0 1500]; % analysis tine window ( 0-1500 ms )
d_spont = 0 - min(t); % duration of spontaneous period (ms)
d_stim = win(2) - win(1); %duration of stimulus period (ms)

i_spont = ( t < win(1) );
i_stim  = ( t>= win(1) & t<win(2) );
t_spont = t(i_spont);
t_stim  = t(i_stim); % 1500 ms from stimulus onset
MUA_spont = MUA_stdiff(i_spont,:);
MUA_stim  = MUA_stdiff(i_stim,:);

r_spont = trapz(t_spont,MUA_spont) * 1000 / d_spont;
r_stim  = trapz(t_stim,MUA_stim) * 1000 / d_stim;

MUA_resp = r_stim - r_spont;
MUA_spont = r_spont;
MUA_stim = r_stim;
end

