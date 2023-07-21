function [r,p] = corr_ROC_vs_DP(matROC,matDP,c_type)
%UNTITLED Summary of this function goes here
%   calculate correlation between ROC value and d-prime in each channel
%   matROC -- matrix of channel x session x stdiff
%   matDP  -- matrix of session x stdiff
%   c_type -- how to calculate correlation either 'Pearson', 'Spearman', or
%   'Kendall'

ROC = permute(matROC,[3 1 2]);
DP  = permute(matDP,[2 1]);

n_session = size(ROC,3);
for i = 1:n_session % session id
    ROC_session = ROC(:,:,i);
    DP_session = DP(:,i);
    % correlation in each channel
    for j=1:size(ROC_session,2)
        [r_ch(j,i),p_ch(j,i)] = corr(DP_session,ROC_session(:,j),'type',c_type);
    end
    
    % correlation of the recording session
    DP_session2 = DP_session * ones(1,size(ROC_session,2));
    DP_session2 = DP_session2(~isnan(ROC_session));
    ROC_session2 = ROC_session(~isnan(ROC_session));
    if isempty(DP_session2)
        r_session(i) = NaN; p_session(i) = NaN;
    else
        % use Pearson correlation for session...
        [r_session(i),p_session(i)] = corr(DP_session2,ROC_session2,'type','Pearson');
    end
end
r.channel = r_ch;
r.session = r_session;
p.channel = p_ch;
p.session = p_session;

end