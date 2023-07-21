function [h] = plot_ROC(tpos,ROC,jitter,col)
%UNTITLED10 Summary of this function goes here
%   modified from plot_index_v3.m to consider number of valid (non NaN)
%   channels to calculate sem
%   ROC must be a 2D matrix (sample x tpos)
Triplet_list = {'1st','2nd','3rd','T-3','T-2','T-1','T','T+1'};

% select triplet positions to plot
sTriplet = Triplet_list(tpos);
ROC_sel = ROC(:,tpos);

ROC_mean = nanmean(ROC_sel,1);
ROC_std  = nanstd(ROC_sel,[],1);
for i=1:length(tpos)
    % get valid number of channels
    temp = ROC_sel(:,i);
    nData(i) = sum(~isnan(temp)); % number of data
    clear temp
    
    % standare error of mean
    ROC_sem(i)  = ROC_std(i) / sqrt(nData(i));
end

x = 1:length(ROC_mean);

% plot(1:length(index_sel),index_sel,'LineWidth',2,'Color',col);
h = errorbar(x+jitter,ROC_mean,ROC_sem,'LineWidth',2,'Color',col);
set(gca,'XTick',x,'XTickLabel',sTriplet);

end