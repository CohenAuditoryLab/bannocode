function [] = plot_bootSMI_emergence(tpos,index_boot,symbol)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
Triplet_list = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};

% select triplet positions to plot
sTriplet = Triplet_list(tpos);
index_sel = index_boot(:,tpos,:);

for j=1:3
    index_temp = index_sel(:,:,j);
    index_mean = mean(index_temp,1);
    % [index_lower,index_upper] = get_CI_index(index_temp,0.90); % 90% conf interval
    [index_lower,index_upper] = get_CI_index(index_temp,0.95); % 95% conf interval
    % x = 1:length(index_mean);
    x = j:3:length(index_mean)*3;

    fill([x fliplr(x)],[index_lower fliplr(index_upper)],'k', ...
        'FaceAlpha',0.4,'EdgeColor','none');
    hold on;
    plot(x,index_mean,'LineStyle',symbol{j},'Color','k','LineWidth',1.5);
    % set(gca,'XTick',1:length(index_mean),'XTickLabel',sTriplet);
end

end