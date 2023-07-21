function [data_df, index_df] = split_trial_stdiff(data,stDiff,index)
% split trials by stdiff
% don't care about hit or miss...

% remove FA trials
data_woFA = data(index<2);
stDiff_woFA = stDiff(index<2);
index_woFA = index(index<2);

list_stdiff = unique(stDiff_woFA);
n_stdiff = length(list_stdiff);
for i=1:n_stdiff
    data_df{i} = data_woFA(stDiff_woFA==list_stdiff(i));
    index_df{i} = index_woFA(stDiff_woFA==list_stdiff(i));
end

end
