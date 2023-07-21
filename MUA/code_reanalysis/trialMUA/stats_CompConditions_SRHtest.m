function [ p, tbl, stats_multcomp ] = stats_CompConditions_SRHtest( AUC_condition, tpos )
%stats_SessionSummary Summary of this function goes here
%   perform Scheirer-Ray-Hare test (non-parametric two-way ANOVA)
%   If significant interaction,further perform comparison between areas at 
%   each triplet position.
%   function modified from stats_CompLayers_SRHtest.m in
%   C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Area

% add path to SRH_test.m 
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary');
alpha = 0.05; % significance level

% choose tpos for analysis
AUC_condition = AUC_condition(:,tpos,:);

X = []; Cond = [];
for i=1:size(AUC_condition,3)
    auc_cond = AUC_condition(:,:,i);
    
    % remove NaN from data matri...
    auc_cond = removeNaN_fromMat(auc_cond);
    
    n_data = size(auc_cond,1);
    n_tpos = size(auc_cond,2);
    c_string = ones(n_data,n_tpos) * (i-1);

    X = cat(1,X,auc_cond);
    Cond = cat(1,Cond,c_string);
end
Tpos = repmat(1:n_tpos, size(X,1), 1);




% % concatenate data...
% n_sup = size(d_sup,1); % number of samples in superficial layer
% n_mid = size(d_mid,1); % number of samples in middle layer
% n_dep = size(d_dep,1); % number of samples in deep layer
% n_tpos = size(d_sup,2);
% % N = max(n_core,n_belt);
% 
% % reshape matrix for Friedman test...
% X = [d_sup; d_mid; d_dep];
% 
% % s_string = repmat('S',n_sup,n_tpos);
% % d_string = repmat('D',n_deep,n_tpos);
% s_string = zeros(n_sup,n_tpos);
% m_string = ones(n_mid,n_tpos) * 1;
% d_string = ones(n_dep,n_tpos) * 2;
% Layer = [s_string; m_string; d_string];
% Tpos = repmat(1:n_tpos, n_sup+n_mid+n_dep, 1);

% Scheirer-Ray-Hare
Data = [X(:) Cond(:) Tpos(:)];
[p,tbl] = SRH_test(Data,'Cond','Tpos');

% remove residual
p(4) = [];
tbl(4,:) = [];

p_x = p(3); % p-value for interaction 
if p_x < alpha
    iCond = Cond(:,1);
    X_p = X(iCond==min(iCond),:); % data from smallest condition lavel
    X_n = X(iCond==max(iCond),:); % data from largest condition level

    n_tpos = size(X,2);
    for i=1:n_tpos
        data_p = X_p(:,i);
        data_n = X_n(:,i);
        % Wilcoxon rank sum
        [pp,~,stats] = ranksum(data_p,data_n);
        pval(i,:) = pp; 
        zval(i,:) = stats.zval;
        if pp < ( alpha/n_tpos ) % Bonferroni correction
            h(i,:) = 1;
        else
            h(i,:) = 0;
        end
    end
else
    n_tpos = size(X,2);
    pval = NaN(n_tpos,1);
    zval = NaN(n_tpos,1);
    h    = NaN(n_tpos,1);
end
stats_multcomp.pval = pval;
stats_multcomp.zval = zval;
stats_multcomp.h    = h;
% stats_multcomp = 'post-hoc analysis are not available for this function';

% % Friedman test
% [p_layer,tbl_layer,stats_layer] = mrFriedman2(X(:),{Layer(:) Tpos(:)});
% [p_tpos,tbl_tpos,stats_tpos] = mrFriedman2(X(:),{Tpos(:) Layer(:)});
% 
% p_friedman(1,:) = p_layer;
% p_friedman(2,:) = p_tpos;

% Layer = [s_string; d_string];
% Y = [d_sup; d_deep];

% Tpos = transpose(1:n_tpos);
% 
% % Create a table storing the respones 
% varNames = {'Layer','t1','t2','t3','t4','t5'};
% t = table(Layer,Y(:,1),Y(:,2),Y(:,3),Y(:,4),Y(:,5), ...
%     'VariableNames',varNames);
% 
% % fit the repeated measures model
% rm = fitrm(t,'t1-t5~Layer','WithinDesign',Tpos);
% 
% % perform repeated measures analysis of variance
% tbl_tpos = ranova(rm)
% p_tpos = tbl_tpos.pValueGG(1:2);
% 
% % compare areas
% tbl_layer = multcompare(rm,'Layer')
% p_layer = tbl_layer.pValue(1);
% 
% % concatenate p-values [area; tpos; interaction]
% p_anova = cat(1,double(p_layer),double(p_tpos));
% % pval.anova = p_anova;
% 
% if p_anova(3) < alpha % if significant interaction...
%     tbl_m = multcompare(rm,'Layer','By','Time');
%     p_posthoc = tbl_m.pValue(1:2:end);
% %     pval.posthoc = p_posthoc;
% else
%     p_posthoc = NaN(n_tpos,1);
% %     pval.posthoc = p_posthoc;
% end

end

function [new_index_matrix] = removeNaN_fromMat(index_matrix)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
n = size(index_matrix,1);
idx = 1:n;
idx = idx(~isnan(index_matrix(:,1)));

new_index_matrix = index_matrix(idx,:);

end