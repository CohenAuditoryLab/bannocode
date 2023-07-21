function [] = plot_index_boot_emergence(tpos,index_boot)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
Triplet_list = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};

% select triplet positions to plot
sTriplet = Triplet_list(tpos);
index_sel = index_boot(:,tpos,:);

index_reorder = reorder_index(index_sel);

index_mean = mean(index_reorder,1);
% [index_lower,index_upper] = get_CI_index(index_reorder,0.90); % 90% conf interval
[index_lower,index_upper] = get_CI_index(index_reorder,0.95); % 90% conf interval
x = 1:length(index_mean);

% plot(1:length(index_mean),index_mean,'k','LineWidth',2); hold on;
% plot(1:length(index_mean),index_lower,':k','LineWidth',1);
% plot(1:length(index_mean),index_upper,':k','LineWidth',1);
fill([x fliplr(x)],[index_lower fliplr(index_upper)],'k', ...
    'FaceAlpha',0.5,'EdgeColor','none'); 
hold on;
plot(x,index_mean,'k','LineWidth',1.5);
% set(gca,'XTick',1:length(index_mean),'XTickLabel',sTriplet);

end