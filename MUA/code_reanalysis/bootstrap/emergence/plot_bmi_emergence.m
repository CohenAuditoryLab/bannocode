function [h] = plot_bmi_emergence(tpos,index,jitter,col)
%UNTITLED10 Summary of this function goes here
%   modified from plot_index_v2.m to consider number of valid (non NaN)
%   channels to calculate sem
Triplet_list = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};

% select triplet positions to plot
sTriplet = Triplet_list(tpos);
index_sel = index(:,tpos,:);

index_reorder = reorder_index(index_sel);
    
index_mean = nanmean(index_reorder,1);
index_std  = nanstd(index_reorder,[],1);
for i=1:length(index_mean)
    % get valid number of channels
    temp = index_reorder(:,i);
    nData(i) = sum(~isnan(temp)); % number of data
    clear temp

    % standare error of mean
    index_sem(i)  = index_std(i) / sqrt(nData(i));
end

x = 1:length(index_mean);
%     x = j:3:length(index_mean)*3;

% plot(1:length(index_sel),index_sel,'LineWidth',2,'Color',col);
h = errorbar(x+jitter,index_mean,index_sem,'LineWidth',2,'Color',col); hold on;


set(gca,'XTick',2:3:length(index_mean),'XTickLabel',sTriplet);

end