function [h] = plot_smi_emergence(tpos,index,jitter,col,symbol)
%UNTITLED10 Summary of this function goes here
%   modified from plot_index_v2.m to consider number of valid (non NaN)
%   channels to calculate sem
Triplet_list = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};

% select triplet positions to plot
sTriplet = Triplet_list(tpos);
index_sel = index(:,tpos,:);

for j=1:3
    index_temp = index_sel(:,:,j);
    index_mean = nanmean(index_temp,1);
    index_std  = nanstd(index_temp,[],1);
    for i=1:length(tpos)
        % get valid number of channels
        temp = index_sel(:,i);
        nData(i) = sum(~isnan(temp)); % number of data
        clear temp

        % standare error of mean
        index_sem(i)  = index_std(i) / sqrt(nData(i));
    end

    % x = 1:length(index_mean);
    x = j:3:length(index_mean)*3;

    % plot(1:length(index_sel),index_sel,'LineWidth',2,'Color',col);
    h = errorbar(x+jitter,index_mean,index_sem,symbol{j},'LineWidth',2,'Color',col(j,:)); hold on;
    clear index_temp
end
set(gca,'XTick',x-1,'XTickLabel',sTriplet);

end