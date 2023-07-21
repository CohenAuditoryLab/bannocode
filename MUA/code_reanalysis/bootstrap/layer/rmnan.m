function [Rmat_nonan] = rmnan(Rmat)
% remove NaN from matrix
index = ~isnan(Rmat(:,1));
Rmat_nonan = Rmat(index==1,:);
end