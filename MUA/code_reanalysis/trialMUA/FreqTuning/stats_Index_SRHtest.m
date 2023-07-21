function [ p, tbl, stats_multcomp ] = stats_Index_SRHtest( IDX_lowBF, IDX_highBF )
%stats_SessionSummary Summary of this function goes here
%   perform Scheirer-Ray-Hare test (non-parametric two-way ANOVA)
%   If significant interaction,further perform comparison between areas at 
%   each triplet position.
%   function modified from stats_CompLayers_SRHtest.m in
%   C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Area

% add path to SRH_test.m 
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary');
alpha = 0.05; % significance level

% create data matrix for SRH test
X = cat(1,IDX_lowBF,IDX_highBF);
Cond = cat(1,zeros(size(IDX_lowBF)),ones(size(IDX_highBF)));
Tpos = repmat(1:2, size(X,1), 1);

% X = []; Cond = [];
% for i=1:size(AUC_condition,3)
%     auc_cond = AUC_condition(:,:,i);
%     
%     % remove NaN from data matri...
%     auc_cond = removeNaN_fromMat(auc_cond);
%     
%     n_data = size(auc_cond,1);
%     n_tpos = size(auc_cond,2);
%     c_string = ones(n_data,n_tpos) * (i-1);
% 
%     X = cat(1,X,auc_cond);
%     Cond = cat(1,Cond,c_string);
% end
% Tpos = repmat(1:n_tpos, size(X,1), 1);

% remove NaN
Cond = Cond(~isnan(X));
Tpos = Tpos(~isnan(X));
X    = X(~isnan(X));

% Scheirer-Ray-Hare
Data = [X(:) Cond(:) Tpos(:)];
% [p,tbl] = SRH_test(Data,'Cond','Tpos');
[p,tbl] = SRH_test(Data,'BFsite','Tpos');

% remove residual
p(4) = [];
tbl(4,:) = [];

p_x = p(3); % p-value for interaction 
if p_x < alpha
    % perform pair-wise comparisons
    [pval(1,:),~,st(1,:)] = signrank(IDX_lowBF(:,1),IDX_lowBF(:,2));
    [pval(2,:),~,st(2,:)] = signrank(IDX_highBF(:,1),IDX_highBF(:,2));
    [pval(3,:),~,st2(3,:)] = ranksum(IDX_lowBF(:,1),IDX_highBF(:,1));
    [pval(4,:),~,st2(4,:)] = ranksum(IDX_lowBF(:,2),IDX_highBF(:,2));
    [pval(5,:),~,st2(5,:)] = ranksum(IDX_lowBF(:,1),IDX_highBF(:,2));
    [pval(6,:),~,st2(6,:)] = ranksum(IDX_lowBF(:,2),IDX_highBF(:,1));
    
    for ii=1:6
        if ii<3
            zval(ii,:) = st(ii).zval;
        else
            zval(ii,:) = st2(ii).zval;
        end
        if pval(ii) < ( alpha/6 ) % Bonferroni correction
            h(ii,:) = 1;
        else
            h(ii,:) = 0;
        end
     end


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
else
%     n_tpos = size(X,2);
    pval = NaN(6,1);
    zval = NaN(6,1);
    h    = NaN(6,1);
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

