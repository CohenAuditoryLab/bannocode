function [] = plotVS_layer(data)
% dprime = data.dprime;
% dprime_all = data.dprime_all;
vs_layer = data.vs_layer;
% stdiff = data.stdiff;
% group = data.group;
active_layer = data.active_layer;
for j=1:5
    if ~isempty(vs_layer{j})
        meanVS.layer(j,:) = nanmean(vs_layer{j},2);
        stdVS.layer(j,:) = nanstd(vs_layer{j},0,2);
    else
        meanVS.layer(j,:) = nan(3,1);
        stdVS.layer(j,:) = nan(3,1);
    end
end
alayer = unique(active_layer);
mVSlayer = meanVS.layer(alayer,:);
sVSlayer = stdVS.layer(alayer,:);
% h = plot(ach,mDPch,'LineWidth',2);
% set(h, {'color'}, {c(1,:); c(2,:)});
% ylim([-2 2]);

% subplot(2,1,1);
% for j=1:2
%     errorbar(ach,mDPch(:,j),sDPch(:,j),'Color',c(j,:),'LineWidth',1.5); hold on;
% end
errorbar(alayer,mVSlayer(:,1),sVSlayer(:,1),'LineWidth',1.5); % plot hit trial
% plot([0.5 5.5],[0 0],'--k');
set(gca,'xlim',[0.5 5.5],'xTick',1:5);
xlabel('layer'); ylabel('vector strength');
end