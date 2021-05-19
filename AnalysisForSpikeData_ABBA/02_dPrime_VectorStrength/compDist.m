function [auc,dprime] = compDist(data_s,data_n)
% compute area under the ROC curve and d'
% data_a and data_b should be the data from signal and noise respectively

% ROC analysis
num_bin = 10;
min_data = floor(min([min(data_s) min(data_n)]));
max_data = ceil(max([max(data_s) max(data_n)]));
if max_data<10
    x = 0:9;
else
    if min_data==max_data
        x = num_bin;
    else
        x = min_data:diff([min_data max_data])/num_bin:max_data;
    end
end
hist_s = histcounts(data_s,x);
hist_n = histcounts(data_n,x);
for i=1:num_bin
    prob_s(i) = sum(hist_s(i:end)) / sum(hist_s);
    prob_n(i) = sum(hist_n(i:end)) / sum(hist_n);
end
auc = -trapz(prob_n,prob_s);

% calculate d'
mu_s = mean(data_s);
mu_n = mean(data_n);
sigma_s = std(data_s);
sigma_n = std(data_n);
dprime = (mu_s - mu_n) / sqrt((sigma_s^2+sigma_n^2)/2);
end