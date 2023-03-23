function index_rm = rmnan_from_matrix(index_mat)
%UNTITLED4 Summary of this function goes here
%   remove NaN from matrix data of index (CI, FSI or BMI) to use Matlab
%   built-in frunction friedman(). the index_mat should be Channel x TPos
rmInd = index_mat(:,end); % use last triplet position
index_rm = index_mat(~isnan(rmInd),:);

end