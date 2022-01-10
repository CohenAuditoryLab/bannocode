function [ p_anova, p_factor, p_pairwise ] = stats_DepthArea_v2( index_combined, tpos )
%stats_SessionSummary Summary of this function goes here
%   perform two-way anova for Factor 1 (Hit vs Miss) and for Factor 2 (Easy
%   vs Hard). If significant main effect, further perform comparison of the
%   levels (ttest with Tukey-Kramer method). If significant interaction,
%   further perform comparison between groups. 
%   p_anova ... p value from anova (hit-miss, easy-hard, interaction)
%   p ... pvalue for multiple comparison of levels (if the main effect is
%   significant
%   pp ... pvalue for multiple comparison of groups (if interaction is
%   significant)

alpha = 0.05; % significance level

c_sup = index_combined.core_sup; % core-superficial
c_deep = index_combined.core_deep; % core-deep
b_sup = index_combined.belt_sup; % belt-superficial
b_deep = index_combined.belt_deep; % belt-deep

% choose triplet position
% take mean when length(tpos) > 1 ...
c_sup = nanmean(c_sup(:,tpos),2);
c_deep = nanmean(c_deep(:,tpos),2);
b_sup = nanmean(b_sup(:,tpos),2);
b_deep = nanmean(b_deep(:,tpos),2);

dim_matrix = max(length(c_sup),length(b_sup));
cs = nan(dim_matrix,1); cs(1:length(c_sup)) = c_sup;
cd = nan(dim_matrix,1); cd(1:length(c_deep)) = c_deep;
bs = nan(dim_matrix,1); bs(1:length(b_sup)) = b_sup;
bd = nan(dim_matrix,1); bd(1:length(b_deep)) = b_deep;

% mat_one  = ones(size(c_sup));
% mat_zero = zeros(size(c_sup));
mat_one  = ones(size(cs));
mat_zero = zeros(size(cs));

% organize data for anova...
% X = [c_sup c_deep; b_sup b_deep];
X = [cs cd; bs bd];
g_layer  = [mat_one mat_zero; mat_one mat_zero]; % 1st factor layer
g_area = [mat_zero mat_zero; mat_one mat_one]; % 2nd factor area
G{1} = g_layer(:); G{2} = g_area(:);
[p_anova,~,st] = anovan(X(:),G,'model','interaction','display','off');

% multiple comparison
p_layer = NaN; p_area = NaN;
p_pairwise = NaN(6,1);

% pair-wise comparison...
M = [cs(:) cd(:) bs(:) bd(:)];
[~,~,stats] = anova1(M,{'core-sup','core-deep','belt-sup','belt-deep'},'off');
% [~,~,stats] = kruskalwallis(M,[],'off');
% figure;
[c,m,h,nms] = multcompare(stats,'display','off');
p_pairwise = c(:,6);
    
% comparison between factors
% compair layers
superficial = [cs(:); bs(:)];
deep = [cd(:); bd(:)];
% [~,p_layer] = ttest2(superficial,deep);
[p_layer,~] = ranksum(superficial,deep);

% compair areas
core = [cs(:); cd(:)];
belt = [bs(:); bd(:)];
% [~,p_area] = ttest2(core,belt);
[p_area,~] = ranksum(core,belt);


p_factor = [p_layer; p_area];

end

