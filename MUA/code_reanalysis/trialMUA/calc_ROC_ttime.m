function [auc_ttime] = calc_ROC_ttime(a,b,ttime,list_tt)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

n_ch = size(a,1); % number of channel
% initialize matrix with NaN
auc_ttime = NaN(n_ch,length(list_tt));
for i=1:length(list_tt)
    n_trial = sum(ttime==list_tt(i));
    if n_trial~=0
        for ch=1:n_ch
            % get target triplet in each channel
            a_ttime = squeeze(a(ch,7,ttime==list_tt(i)));
            b_ttime = squeeze(b(ch,7,ttime==list_tt(i)));

            % calculate ROC
            label = [zeros(length(a_ttime),1); ones(length(b_ttime),1)];
            score = [a_ttime; b_ttime];
            [~,~,~,auc_ttime(ch,i)] = perfcurve(label,score,0); % assume A is larger than B
        end
    end
end

end