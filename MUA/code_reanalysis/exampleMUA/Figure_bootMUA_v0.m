clear all;

% fName = '20180709_bootMUA_ch9';
fName = '20200110_bootMUA_ch7';
load(fName);
c = [0 0.4470 0.7410; 0.8500 0.3250 0.0980];

t_onset  = tt.onset;
mua_sdf  = transpose(mua.sdf.onset);
mua_ldf  = transpose(mua.ldf.onset);
mua_diffst = mean(mua_ldf,1) - mean(mua_sdf,1);
bmua_diffst = transpose(mua_boot.ldf.onset - mua_boot.sdf.onset);
mua_hit  = transpose(mua.hit.onset);
mua_miss = transpose(mua.miss.onset);
mua_diffhm = mean(mua_hit,1) - mean(mua_miss,1);
bmua_diffhm = transpose(mua_boot.hit.onset - mua_boot.miss.onset);

% plot
figure;
subplot(3,1,1);
plot_mua(t_onset,mua_sdf,c(1,:)); hold on;
plot_mua(t_onset,mua_ldf,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.sdf.onset));
% plot_bootmua(t_onset,transpose(mua_boot.ldf.onset));
xlim([-50 700]); box off;

subplot(3,1,2);
plot_mua(t_onset,mua_hit,c(1,:)); hold on;
plot_mua(t_onset,mua_miss,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.hit.onset));
% plot_bootmua(t_onset,transpose(mua_boot.miss.onset));
xlim([-50 700]); box off;

subplot(3,1,3);
plot_bootmua(t_onset,bmua_diffst); hold on;
plot_bootmua(t_onset,bmua_diffhm);
plot(t_onset,mua_diffst,'LineWidth',1.5);
plot(t_onset,mua_diffhm,'LineWidth',1.5);
xlim([-50 700]); box off;