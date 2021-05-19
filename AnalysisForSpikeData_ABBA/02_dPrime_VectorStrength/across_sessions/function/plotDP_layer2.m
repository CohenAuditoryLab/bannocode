function [] = plotDP_layer2(data)
% dprime = data.dprime;
% dprime_all = data.dprime_all;
dprime_layer = data.dprime_layer;
n_dim = size(dprime_layer{3},1);
% stdiff = data.stdiff;
% group = data.group;
active_layer = data.active_layer;
for j=1:6 % six layers
    if ~isempty(dprime_layer{j})
        meanDP.layer(j,:) = nanmean(dprime_layer{j},2);
        stdDP.layer(j,:) = nanstd(dprime_layer{j},0,2);
        steDP.layer(j,:) = nanstd(dprime_layer{j},0,2) / sqrt(size(dprime_layer{j},2));
    else
        meanDP.layer(j,:) = nan(n_dim,1);
        stdDP.layer(j,:) = nan(n_dim,1);
        steDP.layer(j,:) = nan(n_dim,1);
    end
end
alayer = unique(active_layer);
mDPlayer = meanDP.layer(alayer,:);
sDPlayer = stdDP.layer(alayer,:); % standard deviation
% sDPlayer = steDP.layer(alayer,:); % standard error

% h = plot(ach,mDPch,'LineWidth',2);
% set(h, {'color'}, {c(1,:); c(2,:)});
% ylim([-2 2]);

% subplot(2,1,1);
% for j=1:2
%     errorbar(ach,mDPch(:,j),sDPch(:,j),'Color',c(j,:),'LineWidth',1.5); hold on;
% end
errorbar(alayer,mDPlayer(:,1),sDPlayer(:,1),'LineWidth',1.5); % plot hit trial
% plot([0.5 6.5],[0 0],'--k');
set(gca,'xlim',[0.5 6.5],'xTick',1:6);
xlabel('layer'); ylabel('abs( d prime )');
end