function [ h ] = bargraph_DepthArea( index_combined, tpos )
%UNTITLED2 Summary of this function goes here
%   show bargraph with error bar
%   sigRESP_area shold be 4-dimensional matrix of channels x hard-easy x
%   hit-miss x sessions of the area


c_sup = index_combined.core_sup; % core-superficial
c_deep = index_combined.core_deep; % core-deep
b_sup = index_combined.belt_sup; % belt-superficial
b_deep = index_combined.belt_deep; % belt-deep

% choose triplet position
c_sup = nanmean(c_sup(:,tpos),2);
c_deep = nanmean(c_deep(:,tpos),2);
b_sup = nanmean(b_sup(:,tpos),2);
b_deep = nanmean(b_deep(:,tpos),2);

y = [ nanmean(c_sup(:)) nanmean(c_deep(:)); nanmean(b_sup(:)) nanmean(b_deep(:)) ];
n = [ sum(~isnan(c_sup(:))) sum(~isnan(c_deep(:))); sum(~isnan(b_sup(:))) sum(~isnan(b_deep(:))) ];
err  = [ nanstd(c_sup(:)) nanstd(c_deep(:)); nanstd(b_sup(:)) nanstd(b_deep(:)) ];
err2 = err ./ sqrt(n); % standard error

h = bar(y); hold on;
set(h(1),'FaceColor','red','BarWidth',0.8);
set(h(2),'FaceColor','blue','BarWidth',0.8);

ngroups = size(y, 1);
nbars = size(y, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     errorbar(x, y(:,i), err(:,i), '.k'); % standard deviation
    errorbar(x, y(:,i), err2(:,i), '.k'); % standard error
end
set(gca,'XTick',1:2,'XTickLabel',{'CORE','BELT'});
box off;
hold off

end

