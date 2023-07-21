function [outputArg1,outputArg2] = plot_index(tpos,index,col)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
Triplet_list = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};

% select triplet positions to plot
sTriplet = Triplet_list(tpos);
index_sel = index(tpos);

plot(1:length(index_sel),index_sel,'LineWidth',2,'Color',col);
set(gca,'XTick',1:length(index_sel),'XTickLabel',sTriplet);

end