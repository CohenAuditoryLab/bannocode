function [low_CI,up_CI] = get_CIMUA(mua_boot,CI)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

n_boot = size(mua_boot,1);
n_tpos = size(mua_boot,2);
for i=1:n_tpos
    temp_mua = mua_boot(:,i);
    sort_mua(:,i) = sort(temp_mua);
end

alpha = (1-CI) / 2;
i_lci = round(n_boot * alpha, 1);
i_uci = round(n_boot * (1-alpha), 1);

if i_lci ~= floor(i_lci)
    i_lci = [floor(i_lci) floor(i_lci)+1];
end
if i_uci ~= floor(i_uci)
    i_uci = [floor(i_uci) floor(i_uci)+1];
end

low_CI = mean(sort_mua(i_lci,:),1);
up_CI = mean(sort_mua(i_uci,:),1);

end