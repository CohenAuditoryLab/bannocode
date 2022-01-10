function [ p_anova, p, pp ] = stats_DepthArea( index_combined, tpos )
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
g_hitmiss  = [mat_one mat_zero; mat_one mat_zero]; % 1st factor hit vs miss
g_eazyhard = [mat_zero mat_zero; mat_one mat_one]; % 2nd factor easy vs hard
G{1} = g_hitmiss(:); G{2} = g_eazyhard(:);
[p_anova,~,st] = anovan(X(:),G,'model','interaction','display','off');

% multiple comparison
% c_c_deep = NaN(1,6); % statistical comparison of hit vs miss
% c_b_sup = NaN(1,6); % statistical comparison of easy vs hard
p_layer = NaN; p_area = NaN;
pp = NaN(6,1);
% check significance of interaction first
if p_anova(3) < alpha % if interaction is signficant...
%     M = [c_sup(:) c_deep(:) b_sup(:) b_deep(:)];
    M = [cs(:) cd(:) bs(:) bd(:)];
    [~,~,stats] = anova1(M,{'core-sup','core-deep','belt-sup','belt-deep'},'off');
    figure;
    [c,m,h,nms] = multcompare(stats);
    pp = c(:,6);
    
    if p_anova(1) < alpha
        p_layer = p_anova(1);
    end
    if p_anova(2) < alpha
        p_area = p_anova(2);
    end
else % if interaction is not significant...
    % significant main effect in factor 1 (layer)
    if p_anova(1) < alpha
%         c_c_deep = multcompare(st,'dimension',1,'display','off');
%         hit = [c_sup(:); b_sup(:)];
%         miss = [c_deep(:); b_deep(:)];
        superficial = [cs(:); bs(:)];
        deep = [cd(:); bd(:)];
        [~,p_layer] = ttest2(superficial,deep);
    end
    % significant main effect in factor 2 (area)
    if p_anova(2) < alpha
%         c_b_sup = multcompare(st,'dimension',2,'display','off');
%         hard = [c_sup(:); c_deep(:)];
%         easy = [b_sup(:); b_deep(:)];
        core = [cs(:); cd(:)];
        belt = [bs(:); bd(:)];
        [~,p_area] = ttest2(core,belt);
    end
end

% p = [c_c_deep(6); c_b_sup(6)];
p = [p_layer; p_area];

end

