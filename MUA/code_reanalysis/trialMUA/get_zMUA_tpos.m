function [zMUA_tpos] = get_zMUA_tpos(zMUA_trial,tpos_trial)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
n_trial = size(zMUA_trial,3);
zMUA_tpos = [];
for i=1:n_trial
    tpos = tpos_trial(i,:);
    zMUA = zMUA_trial(:,:,i);
    zMUA_tpos = cat(3,zMUA_tpos,zMUA(:,tpos));
end

end