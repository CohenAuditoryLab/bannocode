function [new_index_matrix] = removeNaN_fromMat(index_matrix)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
n = size(index_matrix,1);
idx = 1:n;
idx = idx(~isnan(index_matrix(:,1)));

new_index_matrix = index_matrix(idx,:);

end

