function [  ] = bargraph_Baseline( sigRESP_area )
%UNTITLED2 Summary of this function goes here
%   show bargraph with error bar
%   sigRESP_area shold be 4-dimensional matrix of channels x hard-easy x
%   hit-miss x sessions of the area

% hit = sigRESP_BL_area(:,1,:);
% miss = sigRESP_BL_area(:,2,:);
% fa = sigRESP_BL_area(:,3,:);

dh = sigRESP_area(:,1,1,:); % hit [-575 -500]
dm = sigRESP_area(:,1,2,:); % miss [-575 -500]
ih = sigRESP_area(:,2,1,:); % hit [-75 0]
im = sigRESP_area(:,2,2,:); % miss [-75 0]

y = [ nanmean(dh(:)) nanmean(dm(:)); nanmean(ih(:)) nanmean(im(:)) ];
n = [ sum(~isnan(dh(:))) sum(~isnan(dm(:))); sum(~isnan(ih(:))) sum(~isnan(im(:))) ];
err  = [ nanstd(dh(:)) nanstd(dm(:)); nanstd(ih(:)) nanstd(im(:)) ];
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
set(gca,'XTick',1:2,'XTickLabel',{'[-575 -500]','[-75 0]'});
box off;
hold off

end

