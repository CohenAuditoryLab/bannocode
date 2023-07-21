function [Rmat_resample] = resample_Rmat_v0(Rmat)
%UNTITLED8 Summary of this function goes here
%   randomly resample data across all channels (allows comparison across
%   channels)

Rvec = Rmat(:);
n_sample = size(Rmat,1); % number of channel
n_condition = size(Rmat,2); % number of trial condition
n_all = length(Rvec);
% resample data
for i=1:n_condition
    r_temp = Rvec(randsample(n_all,n_sample,'true'));
    Rmat_resample(:,i) = r_temp;
    clear r_remp;
end

end