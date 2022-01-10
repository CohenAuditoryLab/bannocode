function [data_valid] = chooseDataRegression(data,iTriplet)
%UNTITLED Summary of this function goes here
%   choose data for regression analysis (comparing layers)

% choose data by triplet position
data_triplet = data(data(:,4)==iTriplet,:);

% remove data in which layer cannot be defined...
iValid = ~isnan(data_triplet(:,7));
data_valid = data_triplet(iValid==1,:); 

end