clear all;

% fName = '20180709_bootMUA_ch9';
fName = '20200110_bootMUA_ch7';
epoch = 'onset'; %'target';
load(fName);
c = [0 0.4470 0.7410; 0.8500 0.3250 0.0980];

t  = tt.(epoch);
mua_sdf  = transpose(mua.sdf.(epoch));
mua_ldf  = transpose(mua.ldf.(epoch));
mua_diffst = mean(mua_ldf,1) - mean(mua_sdf,1);
bmua_diffst = transpose(mua_boot.ldf.(epoch) - mua_boot.sdf.(epoch));
mua_hit  = transpose(mua.hit.(epoch));
mua_miss = transpose(mua.miss.(epoch));
mua_diffhm = mean(mua_hit,1) - mean(mua_miss,1);
bmua_diffhm = transpose(mua_boot.hit.(epoch) - mua_boot.miss.(epoch));

% plot
if strcmp(epoch,'onset')
    trange = [-50 700];
elseif strcmp(epoch,'target')
    trange = [-250 250];
end
figure;
subplot(3,1,1);
plot_mua(t,mua_sdf,c(1,:)); hold on;
plot_mua(t,mua_ldf,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.sdf.onset));
% plot_bootmua(t_onset,transpose(mua_boot.ldf.onset));
xlim(trange); box off;

subplot(3,1,2);
plot_mua(t,mua_miss,c(1,:)); hold on;
plot_mua(t,mua_hit,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.hit.onset));
% plot_bootmua(t_onset,transpose(mua_boot.miss.onset));
xlim(trange); box off;

subplot(3,1,3);
plot_bootmua(t,bmua_diffst); hold on;
plot_bootmua(t,bmua_diffhm);
plot(t,mua_diffst,'LineWidth',1.5);
plot(t,mua_diffhm,'LineWidth',1.5);
xlim(trange); box off;