function [data_3layers] = compDP_3layers(data)
% compare d-prime as a function of supra, granular and infra layers

% dprime = data.dprime;
% dprime_all = data.dprime_all;
dprime_layer = data.dprime_layer;
n_dim = size(dprime_layer{3},1);
% stdiff = data.stdiff;
% group = data.group;
% active_layer = data.active_layer;
active_layer = [];
data_3layers.s = []; data_3layers.g = []; data_3layers.i = [];
for j=1:6 % six layers
    if j<4 % supragranular layer
        data_3layers.s = [data_3layers.s dprime_layer{j}];
    elseif j>4 % infragranular layer
        data_3layers.i = [data_3layers.i dprime_layer{j}];
    else % granular layer
        data_3layers.g = [data_3layers.g dprime_layer{j}];
    end
end

if size(data_3layers.s) > 0
    meanDP.layer(:,1) = nanmean(data_3layers.s,2);
    stdDP.layer(:,1) = nanstd(data_3layers.s,0,2);
    steDP.layer(:,1) = nanstd(data_3layers.s,0,2) / sqrt(size(data_3layers.s,2));
    active_layer = [active_layer 1]; % add 1 in active_layer
else
    meanDP.layer(:,1) = nan(n_dim,1);
    stdDP.layer(:,1) = nan(n_dim,1);
    steDP.layer(:,1) = nan(n_dim,1);
end
if size(data_3layers.g) > 0
    meanDP.layer(:,2) = nanmean(data_3layers.g,2);
    stdDP.layer(:,2) = nanstd(data_3layers.g,0,2);
    steDP.layer(:,2) = nanstd(data_3layers.g,0,2) / sqrt(size(data_3layers.g,2));
    active_layer = [active_layer 2]; % add 2 in active_layer
else
    meanDP.layer(:,2) = nan(n_dim,1);
    stdDP.layer(:,2) = nan(n_dim,1);
    steDP.layer(:,2) = nan(n_dim,1);
end
if size(data_3layers.i) > 0
    meanDP.layer(:,3) = nanmean(data_3layers.i,2);
    stdDP.layer(:,3) = nanstd(data_3layers.i,0,2);
    steDP.layer(:,3) = nanstd(data_3layers.i,0,2) / sqrt(size(data_3layers.i,2));
    active_layer = [active_layer 3]; % add 3 in active_layer
else
    meanDP.layer(:,3) = nan(n_dim,1);
    stdDP.layer(:,3) = nan(n_dim,1);
    steDP.layer(:,3) = nan(n_dim,1);
end

alayer = unique(active_layer);
mDPlayer = meanDP.layer(:,alayer);
sDPlayer = stdDP.layer(:,alayer); % standard deviation
% sDPlayer = steDP.layer(:,alayer); % standard error

data_3layers.mean = meanDP.layer;
data_3layers.std = stdDP.layer;
data_3layers.ste = steDP.layer;
data_3layers.active_layer = alayer;
% h = plot(ach,mDPch,'LineWidth',2);
% set(h, {'color'}, {c(1,:); c(2,:)});
% ylim([-2 2]);

% % plot data...
% errorbar(alayer,mDPlayer(1,:),sDPlayer(1,:),'LineWidth',1.5); % plot hit trial
% hold on;
% plot([0.5 3.5],[0 0],'--k');
% set(gca,'xlim',[0.5 3.5],'xTick',1:3,'xTickLabel',{'supra','granlar','infra'});
% xlabel('layer'); ylabel('abs( d prime )');
end