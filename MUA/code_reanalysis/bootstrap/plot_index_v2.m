function [] = plot_index_v2(tpos,index,jitter,col)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
Triplet_list = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};

% select triplet positions to plot
sTriplet = Triplet_list(tpos);
index_sel = index(:,tpos);

nData = size(index_sel,1); % number of data
index_mean = mean(index_sel,1);
index_std  = std(index_sel,[],1);
index_sem  = index_std / sqrt(nData);
x = 1:length(index_mean);

% plot(1:length(index_sel),index_sel,'LineWidth',2,'Color',col);
errorbar(x+jitter,index_mean,index_sem,'LineWidth',2,'Color',col);
set(gca,'XTick',x,'XTickLabel',sTriplet);

end