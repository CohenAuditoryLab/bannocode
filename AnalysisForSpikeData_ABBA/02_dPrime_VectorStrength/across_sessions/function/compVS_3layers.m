function [data_3layers] = compVS_3layers(data)
% compare vector strength as a function of supra, granular and infra layers

% VSrime = data.VSrime;
% VSrime_all = data.VSrime_all;
vs_layer = data.vs_layer;
n_dim = size(vs_layer{3},1);
% stdiff = data.stdiff;
% group = data.group;
% active_layer = data.active_layer;
active_layer = [];
data_3layers.s = []; data_3layers.g = []; data_3layers.i = [];
for j=1:6 % six layers
    if j<4 % supragranular layer
        data_3layers.s = [data_3layers.s vs_layer{j}];
    elseif j>4 % infragranular layer
        data_3layers.i = [data_3layers.i vs_layer{j}];
    else % granular layer
        data_3layers.g = [data_3layers.g vs_layer{j}];
    end
end

if size(data_3layers.s) > 0
    meanVS.layer(:,1) = nanmean(data_3layers.s,2);
    stdVS.layer(:,1) = nanstd(data_3layers.s,0,2);
    steVS.layer(:,1) = nanstd(data_3layers.s,0,2) / sqrt(size(data_3layers.s,2));
    active_layer = [active_layer 1]; % add 1 in active_layer
else
    meanVS.layer(:,1) = nan(n_dim,1);
    stdVS.layer(:,1) = nan(n_dim,1);
    steVS.layer(:,1) = nan(n_dim,1);
end
if size(data_3layers.g) > 0
    meanVS.layer(:,2) = nanmean(data_3layers.g,2);
    stdVS.layer(:,2) = nanstd(data_3layers.g,0,2);
    steVS.layer(:,2) = nanstd(data_3layers.g,0,2) / sqrt(size(data_3layers.g,2));
    active_layer = [active_layer 2]; % add 2 in active_layer
else
    meanVS.layer(:,2) = nan(n_dim,1);
    stdVS.layer(:,2) = nan(n_dim,1);
    steVS.layer(:,2) = nan(n_dim,1);
end
if size(data_3layers.i) > 0
    meanVS.layer(:,3) = nanmean(data_3layers.i,2);
    stdVS.layer(:,3) = nanstd(data_3layers.i,0,2);
    steVS.layer(:,3) = nanstd(data_3layers.i,0,2) / sqrt(size(data_3layers.i,2));
    active_layer = [active_layer 3]; % add 3 in active_layer
else
    meanVS.layer(:,3) = nan(n_dim,1);
    stdVS.layer(:,3) = nan(n_dim,1);
    steVS.layer(:,3) = nan(n_dim,1);
end

alayer = unique(active_layer);
mVSlayer = meanVS.layer(:,alayer);
sVSlayer = stdVS.layer(:,alayer); % standard deviation
% sVSlayer = steVS.layer(:,alayer); % standard error

data_3layers.mean = meanVS.layer;
data_3layers.std = stdVS.layer;
data_3layers.ste = steVS.layer;
data_3layers.active_layer = alayer;
% h = plot(ach,mVSch,'LineWidth',2);
% set(h, {'color'}, {c(1,:); c(2,:)});
% ylim([-2 2]);

% % plot data...
% errorbar(alayer,mVSlayer(1,:),sVSlayer(1,:),'LineWidth',1.5); % plot hit trial
% hold on;
% plot([0.5 3.5],[0 0],'--k');
% set(gca,'xlim',[0.5 3.5],'xTick',1:3,'xTickLabel',{'supra','granlar','infra'});
% xlabel('layer'); ylabel('abs( d prime )');
end