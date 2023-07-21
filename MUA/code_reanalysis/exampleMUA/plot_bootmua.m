function [outputArg1,outputArg2] = plot_bootmua(t,mua_boot)
%UNTITLED10 Summary of this function goes here
%   t -- time vector (1 x sample)
%   mua_boot -- bootstrapped mua (trial x sample)


mua_median = median(mua_boot,1);
% [mua_lower,mua_upper] = get_CIMUA(mua_boot,0.90); % 90% conf interval
[mua_lower,mua_upper] = get_CIMUA(mua_boot,0.95); % 95% conf interval

X = [t fliplr(t)];
Y = [mua_lower fliplr(mua_upper)];

fill(X,Y,'k','FaceAlpha',0.5,'EdgeColor','none'); hold on
plot(t,mua_median,'k','LineWidth',1);
% plot(1:length(index_mean),index_lower,':k','LineWidth',1);
% plot(1:length(index_mean),index_upper,':k','LineWidth',1);
% set(gca,'XTick',1:length(index_mean),'XTickLabel',sTriplet);

end