function [ p, tbl ] = stats_CompConditions_SRHtest3( AUC_condition, tpos )
%stats_SessionSummary Summary of this function goes here
%   perform Scheirer-Ray-Hare test 
%   Examine simple effects of three factors (stdiff x tpos x hit-miss), but
%   interaction of the factors was not examined...
%   function modified from stats_CompLayers_SRHtest.m in
%   C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Area

% set alpha value
% alpha = 0.05; % significance level

% choose tpos for analysis
AUC_condition = AUC_condition(:,tpos,:,:);

X = []; Cond = []; HM = [];
for j=1:2
    x = []; c = []; b = [];
for i=1:size(AUC_condition,3)
    auc_cond = AUC_condition(:,:,i,j);
    
    % remove NaN from data matri...
    auc_cond = removeNaN_fromMat(auc_cond);
    
    n_data = size(auc_cond,1);
    n_tpos = size(auc_cond,2);
    c_string = ones(n_data,n_tpos) * (i-1);
    b_string = ones(n_data,n_tpos) * (j-1);

    x = cat(1,x,auc_cond);
    c = cat(1,c,c_string);
    b = cat(1,b,b_string);
end
X    = cat(3,X,x);
Cond = cat(3,Cond,c);
HM   = cat(3,HM,b);
end
Tpos = repmat(1:n_tpos, size(X,1), 1);
Tpos = cat(3,Tpos,Tpos);

% Scheirer-Ray-Hare
Data = [X(:) Cond(:) Tpos(:) HM(:)];
[p,tbl] = SRH_test3(Data,'Cond','Tpos','Hit_Miss');

% remove residuals...
p(4) = [];
tbl(4,:) = [];

% post-hoc analysis when interaction is significant
% p_x = p(3); % p-value for interaction 
% if p_x < alpha
%     iCond = Cond(:,1);
%     X_p = X(iCond==min(iCond),:); % data from smallest condition lavel
%     X_n = X(iCond==max(iCond),:); % data from largest condition level
% 
%     n_tpos = size(X,2);
%     for i=1:n_tpos
%         data_p = X_p(:,i);
%         data_n = X_n(:,i);
%         % Wilcoxon rank sum
%         [pp,~,stats] = ranksum(data_p,data_n);
%         pval(i,:) = pp; 
%         zval(i,:) = stats.zval;
%         if pp < ( alpha/n_tpos ) % Bonferroni correction
%             h(i,:) = 1;
%         else
%             h(i,:) = 0;
%         end
%     end
% else
%     n_tpos = size(X,2);
%     pval = NaN(n_tpos,1);
%     zval = NaN(n_tpos,1);
%     h    = NaN(n_tpos,1);
% end
% stats_multcomp.pval = pval;
% stats_multcomp.zval = zval;
% stats_multcomp.h    = h;
% % stats_multcomp = 'post-hoc analysis are not available for this function';

end

function [new_index_matrix] = removeNaN_fromMat(index_matrix)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
n = size(index_matrix,1);
idx = 1:n;
idx = idx(~isnan(index_matrix(:,1)));

new_index_matrix = index_matrix(idx,:);

end