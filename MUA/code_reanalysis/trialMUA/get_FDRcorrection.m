function [pVal_adj] = get_FDRcorrection(pVal,tpos)
%UNTITLED Summary of this function goes here
%   given a matrix of p-values, this function performs FDR correction
%   pVal -- original matrix of p-values (ABB x tpos)
%   tpos -- tpos to select data

% select tpos
pVal_sel = pVal(:,tpos); 

% FDR correction
p_adj = mafdr(pVal_sel(:),'BHFDR',true);
pVal_adj = reshape(p_adj,size(pVal_sel));

end