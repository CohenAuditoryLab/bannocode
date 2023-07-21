function [Data_stdiff] = split_trial_stdiff_v2(data,stDiff,index)
% split trials by stdiff
% don't care about hit or miss...

% remove FA trials
data_woFA = data(index<2);
stDiff_woFA = stDiff(index<2);
index_woFA = index(index<2);

list_stdiff = unique(stDiff_woFA);
n_stdiff = length(list_stdiff);
for i=1:n_stdiff
    dd_df = data_woFA(stDiff_woFA==list_stdiff(i));
    ii_df = index_woFA(stDiff_woFA==list_stdiff(i));
    data_df{i} = dd_df;
%     index_df{i} = ii_df;

    % further separate by hit and miss
    data_df_hit{i} = dd_df(ii_df==0);
    data_df_miss{i} = dd_df(ii_df==1);

    clear dd_df ii_df
end

Data_stdiff.all  = data_df;
Data_stdiff.hit  = data_df_hit;
Data_stdiff.miss = data_df_miss;
end
