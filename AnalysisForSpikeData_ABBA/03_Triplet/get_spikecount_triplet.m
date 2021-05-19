function [ spCount, A, B1, B2 ] = get_spikecount_triplet( raster, t, period )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% period = [0 50; 75 125; 150 200];
% raster = R_triplet{2,3,1};
% t = t_triplet;

for i = 1:size(period,1);
    r = raster(:, t>period(i,1) & t<=period(i,2), :);
%     spike_count = squeeze(sum(r,2));
    spike_count = permute(sum(r,2),[1 3 2]);
    spCount_mean(i,:) = mean(spike_count,1); % mean
    spCount_var(i,:) = var(spike_count,0,1); % variance
    spCount_std(i,:) = std(spike_count,0,1); % standard deviation
    if i==1
        A = spike_count; % r
    elseif i==2
        B1 = spike_count; % r
    else
        B2 = spike_count; % r
    end
end
spCount = struct('mean',spCount_mean,'var',spCount_var,'std',spCount_std);

end

