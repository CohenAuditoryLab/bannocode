function [ matrix_out ] = reshape_matrix( matrix, list_st )
%RESHAPE_MATRIX Summary of this function goes here
%   make a bigger matrix for the analysis across sessions having different
%   set of semitone difference. The input matrix should have dimensions:
%   triplet x stdiff x HorM x #units. 
list_st_all = [1 2 4 8 10 16 24];

nTriplet = size(matrix,1);
nUnit = size(matrix,4); % number of units
matrix_out = NaN(nTriplet,length(list_st_all),2,nUnit);
for i=1:length(list_st)
    j = find(list_st_all==list_st(i));
    matrix_out(:,j,:,:) = matrix(:,i,:,:);
end

end

