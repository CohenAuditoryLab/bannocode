function [] = plotDP_layer(data)
% dprime = data.dprime;
% dprime_all = data.dprime_all;
dprime_layer = data.dprime_layer;
% stdiff = data.stdiff;
% group = data.group;
active_layer = data.active_layer;
for j=1:5
    if ~isempty(dprime_layer{j})
        meanDP.layer(j,:) = nanmean(dprime_layer{j},2);
        stdDP.layer(j,:) = nanstd(dprime_layer{j},0,2);
    else
        meanDP.layer(j,:) = nan(2,1);
        stdDP.layer(j,:) = nan(2,1);
    end
end
alayer = unique(active_layer);
mDPlayer = meanDP.layer(alayer,:);
sDPlayer = stdDP.layer(alayer,:);
% h = plot(ach,mDPch,'LineWidth',2);
% set(h, {'color'}, {c(1,:); c(2,:)});
% ylim([-2 2]);

% subplot(2,1,1);
% for j=1:2
%     errorbar(ach,mDPch(:,j),sDPch(:,j),'Color',c(j,:),'LineWidth',1.5); hold on;
% end
errorbar(alayer,mDPlayer(:,1),sDPlayer(:,1),'LineWidth',1.5); % plot hit trial
plot([0.5 5.5],[0 0],'--k');
set(gca,'xlim',[0.5 5.5],'xTick',1:5);
xlabel('layer'); ylabel('abs( d prime )');
end