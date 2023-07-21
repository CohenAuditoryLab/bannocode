function [] = plot_mua(t,mua_trial,c)
%UNTITLED4 Summary of this function goes here
%   t -- time vector (1 x sample)
%   mua_trial -- mua (trial x sample)
n_trial = size(mua_trial,1);
mean_mua = mean(mua_trial,1); % mean
std_mua  = std(mua_trial,[],1); % standard deviation
ste_mua  = std_mua / sqrt(n_trial); % standard error of mean

X = [t fliplr(t)];
% Y = [mean_mua-ste_mua fliplr(mean_mua+ste_mua)];
Y = [mean_mua-std_mua fliplr(mean_mua+std_mua)];

fill(X,Y,c,'FaceAlpha',0.5,'EdgeColor','none'); hold on;
plot(t,mean_mua,'Color',c,'LineWidth',1.5);

end