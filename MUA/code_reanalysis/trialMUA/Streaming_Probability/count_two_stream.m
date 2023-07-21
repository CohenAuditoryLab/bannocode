function [prob_1st,prob_2st] = count_two_stream(L_df,H_df,thresh)
% count number of two stream representation
% L and H should be a cell array obtained from split_trial_stdiff
% if both L and H are above threshold (thresh), we assume it as 1 stream
% if only L is above threshold, we assume it as 2 streams

n_stdiff = length(L_df);
for i=1:n_stdiff
    Labove = L_df{i}>thresh;
    Habove = H_df{i}>thresh;

    sumLH  = Labove + Habove;
    diffLH = Labove - Habove;

    n_1st = sum(sumLH==2);
    n_2st = sum(diffLH==1);
    n_all = length(Labove);

    prob_1st(i,:) = n_1st / n_all;
    prob_2st(i,:) = n_2st / n_all;

    clear Labove Habove sumLH diffLH n_1st n_2nd n_all
end

end