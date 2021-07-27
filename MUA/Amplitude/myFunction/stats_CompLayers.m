function [ p_anova, p ] = stats_CompLayers( d_superficial, d_deep )
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

mat_one  = ones(size(d_superficial));
mat_zero = zeros(size(d_deep));

% organize data for anova...
X = [d_superficial; d_deep];
g_layer  = [mat_one; mat_zero]; % 1st factor: superficual vs deep
g_tpos = ones(size(X,1),1) * (1:size(X,2)); % 2nd factor: triplet position
G{1} = g_layer(:); G{2} = g_tpos(:);
[p_anova,~,st] = anovan(X(:),G,'model','interaction','display','off');

% multiple comparison
n_tpos = size(d_superficial,2);
n_group = 2 * n_tpos;
% c_layer = NaN(1,6); % statistical comparison of superficial vs deep layers
% c_tpos = NaN(1,6); % statistical comparison of triplet position
p_layer = NaN;
p_tpos = NaN(n_tpos*(n_tpos-1)/2,1);
p_group = NaN(n_group*(n_group-1)/2,1);
% check significance of interaction first
if p_anova(3) < alpha % if interaction is signficant...
%     M = [hh(:) hm(:) eh(:) em(:)];
    n_sup  = size(d_superficial,1);
    n_deep = size(d_deep,1);
    N = max(n_sup,n_deep);
    m_sup = []; m_deep = [];
    for i=1:n_tpos
        m_sup  = [m_sup d_superficial(:,i)];
        m_deep = [m_deep d_deep(:,i)];
    end
    g_sup = ones(n_sup,1) * (1:i);
    g_deep = ones(n_deep,1) * (i+1:i+i);
%     [~,~,stats] = anova1(M,{'hard-hit','hard-miss','easy-hit','easy-miss'},'off');
    GG = [g_sup; g_deep];
    MM = [m_sup; m_deep];
    [~,~,stats] = anovan(MM(:),GG(:),'display','off');
    figure;
    [c,m,h,nms] = multcompare(stats);
    p_group = c(:,6);
    
    if p_anova(1) < alpha
%         p_layer = p_anova(1);
        [~,p_layer] = ttest2(d_superficial(:),d_deep(:));
    end
    if p_anova(2) < alpha
%         p_tpos = p_anova(2);
        c_tpos = multcompare(st,'dimension',2,'display','off');
        p_tpos = c_tpos(:,6);
    end
else % if interaction is not significant...
    % significant main effect in factor 1 (superficial vs deep)
    if p_anova(1) < alpha
%         c_hm = multcompare(st,'dimension',1,'display','off');
%         hit = [hh(:); eh(:)];
%         miss = [hm(:); em(:)];
        [~,p_layer] = ttest2(d_superficial(:),d_deep(:));
    end
    % significant main effect in factor 2 (tpos)
    if p_anova(2) < alpha
        c_tpos = multcompare(st,'dimension',2,'display','off');
        p_tpos = c_tpos(:,6);
%         hard = [hh(:); hm(:)];
%         easy = [eh(:); em(:)];
%         [~,p_eh] = ttest2(hard,easy);
    end
end

% p = [c_hm(6); c_eh(6)];
% p = [p_hm; p_eh];
p.fc1 = p_layer; % factor 1: layer
p.fc2 = p_tpos; % factor 2: triplet position
p.group = p_group;

end