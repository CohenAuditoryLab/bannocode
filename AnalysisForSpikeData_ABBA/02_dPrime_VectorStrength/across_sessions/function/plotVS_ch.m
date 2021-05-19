function [] = plotVS_ch(data)
% dprime = data.dprime;
% dprime_all = data.dprime_all;
vs_ch = data.vs_ch;
% stdiff = data.stdiff;
% group = data.group;
active_channel = data.active_channel;
for i=1:16
    if ~isempty(vs_ch{i})
        meanVS.ch(i,:) = nanmean(vs_ch{i},2);
        stdVS.ch(i,:) = nanstd(vs_ch{i},0,2);
    else
        meanVS.ch(i,:) = nan(3,1);
        stdVS.ch(i,:) = nan(3,1);
    end
end
ach = unique(active_channel) + 1;
mVSch = meanVS.ch(ach,:);
sVSch = stdVS.ch(ach,:);
% h = plot(ach,mDPch,'LineWidth',2);
% set(h, {'color'}, {c(1,:); c(2,:)});
% ylim([-2 2]);

% subplot(2,1,1);
% for j=1:2
%     errorbar(ach,mDPch(:,j),sDPch(:,j),'Color',c(j,:),'LineWidth',1.5); hold on;
% end
errorbar(ach,mVSch(:,1),sVSch(:,1),'LineWidth',1.5); % plot hit trial
% plot([0.5 16.5],[0 0],'--k');
set(gca,'xlim',[0.5 16.5]);
xlabel('channel'); ylabel('vector strength');
end