function [] = plotDP_ch(data)
% dprime = data.dprime;
% dprime_all = data.dprime_all;
dprime_ch = data.dprime_ch;
% stdiff = data.stdiff;
% group = data.group;
active_channel = data.active_channel;
for i=1:16
    if ~isempty(dprime_ch{i})
        meanDP.ch(i,:) = nanmean(dprime_ch{i},2);
        stdDP.ch(i,:) = nanstd(dprime_ch{i},0,2);
    else
        meanDP.ch(i,:) = nan(2,1);
        stdDP.ch(i,:) = nan(2,1);
    end
end
ach = unique(active_channel) + 1;
mDPch = meanDP.ch(ach,:);
sDPch = stdDP.ch(ach,:);
% h = plot(ach,mDPch,'LineWidth',2);
% set(h, {'color'}, {c(1,:); c(2,:)});
% ylim([-2 2]);

% subplot(2,1,1);
% for j=1:2
%     errorbar(ach,mDPch(:,j),sDPch(:,j),'Color',c(j,:),'LineWidth',1.5); hold on;
% end
errorbar(ach,mDPch(:,1),sDPch(:,1),'LineWidth',1.5); % plot hit trial
plot([0.5 16.5],[0 0],'--k');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('abs( d prime )');
end