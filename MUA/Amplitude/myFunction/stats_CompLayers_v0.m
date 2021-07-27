function [ p_anova ] = stats_CompLayers( d_superficial, d_deep )
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
g_layer  = [mat_one; mat_zero]; % 1st factor superficual vs deep
g_tpos = ones(size(X,1),1) * (1:size(X,2)); % 2nd factor easy vs hard
G{1} = g_layer(:); G{2} = g_tpos(:);
[p_anova,~,st] = anovan(X(:),G,'model','interaction','display','off');

% multiple comparison
% c_hm = NaN(1,6); % statistical comparison of hit vs miss
% c_eh = NaN(1,6); % statistical comparison of easy vs hard
% p_hm = NaN; p_eh = NaN;
% pp = NaN(6,1);
% % check significance of interaction first
% if p_anova(3) < alpha % if interaction is signficant...
%     M = [hh(:) hm(:) eh(:) em(:)];
%     [~,~,stats] = anova1(M,{'hard-hit','hard-miss','easy-hit','easy-miss'},'off');
%     figure;
%     [c,m,h,nms] = multcompare(stats);
%     pp = c(:,6);
%     
%     if p_anova(1) < alpha
%         p_hm = p_anova(1);
%     end
%     if p_anova(2) < alpha
%         p_eh = p_anova(2);
%     end
% else % if interaction is not significant...
%     % significant main effect in factor 1 (hit vs miss)
%     if p_anova(1) < alpha
% %         c_hm = multcompare(st,'dimension',1,'display','off');
%         hit = [hh(:); eh(:)];
%         miss = [hm(:); em(:)];
%         [~,p_hm] = ttest2(hit,miss);
%     end
%     % significant main effect in factor 2 (hard vs easy)
%     if p_anova(2) < alpha
% %         c_eh = multcompare(st,'dimension',2,'display','off');
%         hard = [hh(:); hm(:)];
%         easy = [eh(:); em(:)];
%         [~,p_eh] = ttest2(hard,easy);
%     end
% end
% 
% % p = [c_hm(6); c_eh(6)];
% p = [p_hm; p_eh];

end