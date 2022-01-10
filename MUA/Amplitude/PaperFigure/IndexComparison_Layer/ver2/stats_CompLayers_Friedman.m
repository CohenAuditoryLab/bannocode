function [ p_friedman ] = stats_CompLayers_Friedman( d_sup, d_deep )
%stats_SessionSummary Summary of this function goes here
%   perform two-way repeated measures ANOVA
%   If significant interaction,further perform comparison between areas at 
%   each triplet position.

alpha = 0.01; % significance level

% remove NaN from data matrix...
d_sup = removeNaN_fromMat(d_sup);
d_deep = removeNaN_fromMat(d_deep);


% concatenate data...
n_sup = size(d_sup,1); % number of samples in core
n_deep = size(d_deep,1); % number of samples in belt
n_tpos = size(d_sup,2);
% N = max(n_core,n_belt);

% reshape matrix for Friedman test...
X = [d_sup; d_deep];

% s_string = repmat('S',n_sup,n_tpos);
% d_string = repmat('D',n_deep,n_tpos);
s_string = zeros(n_sup,n_tpos);
d_string = ones(n_deep,n_tpos);
Layer = [s_string; d_string];
Tpos = repmat(1:n_tpos, n_sup+n_deep, 1);

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