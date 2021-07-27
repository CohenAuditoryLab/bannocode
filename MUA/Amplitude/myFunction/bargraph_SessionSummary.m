function [  ] = bargraph_SessionSummary( sigRESP_area )
%UNTITLED2 Summary of this function goes here
%   show bargraph with error bar
%   sigRESP_area shold be 4-dimensional matrix of channels x hard-easy x
%   hit-miss x sessions of the area


hh = sigRESP_area(:,1,1,:); % hard-hit
hm = sigRESP_area(:,1,2,:); % hard-miss
eh = sigRESP_area(:,2,1,:); % easy hit
em = sigRESP_area(:,2,2,:); % eash miss

y = [ nanmean(hh(:)) nanmean(hm(:)); nanmean(eh(:)) nanmean(em(:)) ];
n = [ sum(~isnan(hh(:))) sum(~isnan(hm(:))); sum(~isnan(eh(:))) sum(~isnan(em(:))) ];
err  = [ nanstd(hh(:)) nanstd(hm(:)); nanstd(eh(:)) nanstd(em(:)) ];
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
set(gca,'XTick',1:2,'XTickLabel',{'small dF','large dF'});
box off;
hold off

end

