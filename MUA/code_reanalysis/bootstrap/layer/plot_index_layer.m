function [] = plot_index_layer(tpos,index_layer,col)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
Triplet_list = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};

% select triplet positions to plot
sTriplet = Triplet_list(tpos);
index_sel = index_layer(:,tpos);

p = plot(1:length(index_sel),index_sel,'LineWidth',1.5);
p(1).Color = col(1,:);
p(2).Color = col(2,:);
p(3).Color = col(3,:);
set(gca,'XTick',1:length(index_sel),'XTickLabel',sTriplet);

end