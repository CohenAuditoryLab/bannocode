function [index_reordered] = reorder_index(index_abb)
%UNTITLED Summary of this function goes here
%   reorder index matrix 
n_channel = size(index_abb,1);
n_tpos    = size(index_abb,2);
n_tp      = size(index_abb,3); % number of triplet (must be 3)

% separate index
index_a  = index_abb(:,:,1);
index_b1 = index_abb(:,:,2);
index_b2 = index_abb(:,:,3);

index_reordered = nan(n_channel,n_tpos*n_tp);
for i=1:n_tpos
    index_reordered(:,3*i-2) = index_a(:,i);
    index_reordered(:,3*i-1) = index_b1(:,i);
    index_reordered(:,3*i)   = index_b2(:,i);
end

end