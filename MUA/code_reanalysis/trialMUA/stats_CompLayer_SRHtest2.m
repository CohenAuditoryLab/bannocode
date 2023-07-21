function [ p, tbl, stats_multcomp ] = stats_CompLayer_SRHtest2( AUC_abb, iDepth, tpos )
%stats_SessionSummary Summary of this function goes here
%   perform Scheirer-Ray-Hare test (non-parametric two-way ANOVA)
%   If significant interaction,further perform comparison between areas at 
%   each triplet position.
%   function modified from stats_CompLayers_SRHtest.m in
%   C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Area
%   AUC_abb must be 2D matrix of sample x tpos
%   iDepth must be a vector consists of 0 (superficial), 1 (middle), and 2 (deep)

% add path to SRH_test.m 
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary');
alpha = 0.05; % significance level

% choose tpos for analysis
AUC_abb = AUC_abb(:,tpos);
% list_index = unique(iDepth);
list_index = [0 1 2]; % depth ID (should be 0, 1, or 2)

X = []; Layer = [];
for i=1:length(list_index)
    % select depth
    auc_layer = AUC_abb( iDepth==list_index(i), : );

    % remove NaN from data matrix...
    auc_layer = removeNaN_fromMat(auc_layer);
    
    n_data = size(auc_layer,1);
    n_tpos = size(auc_layer,2);
    c_string = ones(n_data,n_tpos) * (i-1);

    X = cat(1,X,auc_layer);
    Layer = cat(1,Layer,c_string);
end
Tpos = repmat(1:n_tpos, size(X,1), 1);



% % % Scheirer-Ray-Hare test % % %
Data = [X(:) Layer(:) Tpos(:)];
[p,tbl] = SRH_test(Data,'Layer','Tpos');

% remove residual
p(4) = [];
tbl(4,:) = [];


% % % perform post-hoc analysis when interraction is significant % % %
p_x = p(3); % p-value for interaction 
if p_x < alpha
    iArea = Layer(:,1);
    X_sup = X(iArea==0,:); % data from superficial layer
    X_mid = X(iArea==1,:); % data from middle layer
    X_dep = X(iArea==2,:); % data from deep layer

    n_tpos = size(X,2);
    for i=1:n_tpos
        data_sup = X_sup(:,i);
        data_mid = X_mid(:,i);
        data_dep = X_dep(:,i);

        % % % Wilcoxon rank sum test % % % 
        % comp superficial vs middle layer
        [pp,~,stats] = ranksum(data_sup,data_mid);
        pval(1,i) = pp; 
        zval(1,i) = stats.zval;
        if pp < ( alpha/n_tpos ) % Bonferroni correction
            h(1,i) = 1;
        else
            h(1,i) = 0;
        end

        % comp superficial and deep layer
        [pp,~,stats] = ranksum(data_sup,data_dep);
        pval(2,i) = pp; 
        zval(2,i) = stats.zval;
        if pp < ( alpha/n_tpos ) % Bonferroni correction
            h(2,i) = 1;
        else
            h(2,i) = 0;
        end
        
        % comp middle vs deep layer
        [pp,~,stats] = ranksum(data_mid,data_dep);
        pval(3,i) = pp; 
        zval(3,i) = stats.zval;
        if pp < ( alpha/n_tpos ) % Bonferroni correction
            h(3,i) = 1;
        else
            h(3,i) = 0;
        end
%         % FDR adjusted
%         pval_adj(:,i) = mafdr(pval(:,i),'BHFDR',true);
    end
    % FDR adjusted
    pval_adj = mafdr(pval(:),'BHFDR',true);
    pval_adj = reshape(pval_adj,size(pval));
    h_adj = pval_adj<0.05;
else
    n_tpos = size(X,2);
    pval     = NaN(3,n_tpos);
    zval     = NaN(3,n_tpos);
    h        = NaN(3,n_tpos);
    pval_adj = NaN(3,n_tpos);
    h_adj    = NaN(3,n_tpos);
end
stats_multcomp.pval     = pval;
stats_multcomp.zval     = zval;
stats_multcomp.h        = h;
stats_multcomp.pval_adj = pval_adj;
stats_multcomp.h_adj    = h_adj;

% % % % Friedman test % % % 
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