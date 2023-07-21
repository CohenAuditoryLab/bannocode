function [ p_friedman ] = stats_CompLayers_Friedman_v2( index_layer, tpos )
%stats_SessionSummary Summary of this function goes here
%   perform two-way repeated measures ANOVA
%   If significant interaction,further perform comparison between areas at 
%   each triplet position.

% alpha = 0.01; % significance level
d_sup = index_layer.s;
d_mid = index_layer.g;
d_dep = index_layer.i;

% choose tpos for analysis
d_sup = d_sup(:,tpos);
d_mid = d_mid(:,tpos);
d_dep = d_dep(:,tpos);

% remove NaN from data matrix...
d_sup = removeNaN_fromMat(d_sup);
d_mid = removeNaN_fromMat(d_mid);
d_dep = removeNaN_fromMat(d_dep);


% concatenate data...
n_sup = size(d_sup,1); % number of samples in superficial layer
n_mid = size(d_mid,1); % number of samples in middle layer
n_dep = size(d_dep,1); % number of samples in deep layer
n_tpos = size(d_sup,2);
% N = max(n_core,n_belt);

% reshape matrix for Friedman test...
X = [d_sup; d_mid; d_dep];

% s_string = repmat('S',n_sup,n_tpos);
% d_string = repmat('D',n_deep,n_tpos);
s_string = zeros(n_sup,n_tpos);
m_string = ones(n_mid,n_tpos) * 1;
d_string = ones(n_dep,n_tpos) * 2;
Layer = [s_string; m_string; d_string];
Tpos = repmat(1:n_tpos, n_sup+n_mid+n_dep, 1);

% Friedman test
[p_layer,tbl_layer,stats_layer] = mrFriedman2(X(:),{Layer(:) Tpos(:)});
[p_tpos,tbl_tpos,stats_tpos] = mrFriedman2(X(:),{Tpos(:) Layer(:)});

p_friedman(1,:) = p_layer;
p_friedman(2,:) = p_tpos;

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