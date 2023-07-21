function [Rmat_resample] = resample_Rmat(Rmat)
%UNTITLED8 Summary of this function goes here
%   resample data within channels (prohibit comparison across channels)
nSample = size(Rmat,1); % number of sample in total
nCond   = size(Rmat,2); % nuber of condition = 4 (easy-hard x hit-miss)

for i=1:nSample
    r_mua = Rmat(i,:);
    r_resamp = r_mua(randsample(nCond,nCond,'true'));
    Rmat_resample(i,:) = r_resamp;
    clear r_mua r_Resamp
end

end