function h = plot_errorbar(iStream,jitter)
% y = nanmedian(d_reshape,1);
y = nanmean(iStream,1);
n = sum(~isnan(iStream),1);
err  = nanstd(iStream,0,1);
err2 = err ./ sqrt(n); % standard error

x = 1:size(y,2);
% jitter = [-0.01; 0.01] * ones(1,size(y,2));
% x = x + jitter;
h = errorbar(x'+jitter,y',err2','LineWidth',2.0);
end