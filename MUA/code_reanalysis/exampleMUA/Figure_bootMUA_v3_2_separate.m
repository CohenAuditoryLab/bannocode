% modified version of Figure_bootMUA_v3_2.m
% each panels are separetely plotted...
% arrange the plot vertically
% small dF - large dF in comparison of stimulus

clear all;

fName = '20180709_bootMUA_ch9';
% fName = '20190409_bootMUA_ch5';
% fName = '20200110_bootMUA_ch7';
% fName = '20210111_bootMUA_ch23';
% fName = '20210220_bootMUA_ch5';
load(fName);
c = [0 0.4470 0.7410; 0.8500 0.3250 0.0980];

%% onset
epoch = 'onset';
trange = [-50 700];
t  = tt.(epoch);
mua_sdf  = transpose(mua.sdf.(epoch)) * 10^6; % uV
mua_ldf  = transpose(mua.ldf.(epoch)) * 10^6; % uV 
mua_diffst = mean(mua_sdf,1) - mean(mua_ldf,1); % small df - large df
bmua_diffst = transpose(mua_boot.sdf.(epoch) - mua_boot.ldf.(epoch)) * 10^6; % uV
mua_hit  = transpose(mua.hit.(epoch)) * 10^6; % uV
mua_miss = transpose(mua.miss.(epoch)) * 10^6; % uV
mua_diffhm = mean(mua_hit,1) - mean(mua_miss,1);
bmua_diffhm = transpose(mua_boot.hit.(epoch) - mua_boot.miss.(epoch)) * 10^6; % uV

% plot
% figure('Position',[100 100 560 560]);
figure('Position',[100 100 336 140]);
% h_top(1) = subplot(4,5,1:3);
plot_mua(t,mua_sdf,c(1,:)); hold on;
plot_mua(t,mua_ldf,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.sdf.onset));
% plot_bootmua(t_onset,transpose(mua_boot.ldf.onset));
xlim(trange); box off;
ylabel('Amplitude [\muV]');
ax(1) = gca;
yrange(1,:) = get(gca,'YLim');
% legend({'','Small \DeltaF','','Large \DeltaF'});

figure('Position',[400 100 224 140]);
% h_top(2) = subplot(4,5,11:13);
plot_mua(t,mua_miss,c(1,:)); hold on;
plot_mua(t,mua_hit,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.hit.onset));
% plot_bootmua(t_onset,transpose(mua_boot.miss.onset));
xlim(trange); box off;
ylabel('Amplitude [\muV]');
ax(2) = gca;
yrange(2,:) = get(gca,'YLim');
% legend({'','Miss','','Hit'});

figure('Position',[200 200 336 140])
% h_btm(1) = subplot(4,5,6:8);
plot_bootmua(t,bmua_diffst); hold on;
% plot_bootmua(t,bmua_diffhm);
plot(t,mua_diffst,'LineWidth',1.5);
% plot(t,mua_diffhm,'LineWidth',1.5);
xlim(trange); box off;
ylabel('Difference');
% legend({'','null','Small - Large'});
ax_diff(1) = gca;
yrange_diff(1,:) = get(gca,'YLim');

figure('Position',[500 200 224 140]);
% h_btm(2) = subplot(4,5,16:18);
plot_bootmua(t,bmua_diffhm); hold on;
plot(t,mua_diffhm,'LineWidth',1.5);
xlim(trange); box off;
xlabel('Time from Stimulus Onset [ms]');
ylabel('Difference');
ax_diff(2) = gca;
yrange_diff(2,:) = get(gca,'YLim');
% legend({'','null','Hit - Miss'});

%% target
epoch = 'target';
trange = [-250 250];
t  = tt.(epoch);
mua_sdf  = transpose(mua.sdf.(epoch)) * 10^6; % uV
mua_ldf  = transpose(mua.ldf.(epoch)) * 10^6; % uV
mua_diffst = mean(mua_sdf,1) - mean(mua_ldf,1); % small df - large df
bmua_diffst = transpose(mua_boot.sdf.(epoch) - mua_boot.ldf.(epoch)) * 10^6; % uV
mua_hit  = transpose(mua.hit.(epoch)) * 10^6; % uV
mua_miss = transpose(mua.miss.(epoch)) * 10^6; % uV
mua_diffhm = mean(mua_hit,1) - mean(mua_miss,1);
bmua_diffhm = transpose(mua_boot.hit.(epoch) - mua_boot.miss.(epoch)) * 10^6; % uV

% plot
figure('Position',[300 300 336 140]);
% h_top(3) = subplot(4,5,4:5);
plot_mua(t,mua_sdf,c(1,:)); hold on;
plot_mua(t,mua_ldf,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.sdf.onset));
% plot_bootmua(t_onset,transpose(mua_boot.ldf.onset));
xlim(trange); box off;
legend({'','Small \DeltaF','','Large \DeltaF'});
ax(3) = gca;
yrange(3,:) = get(gca,'YLim');

figure('Position',[600 300 224 140]);
% h_top(4) = subplot(4,5,14:15);
plot_mua(t,mua_miss,c(1,:)); hold on;
plot_mua(t,mua_hit,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.hit.onset));
% plot_bootmua(t_onset,transpose(mua_boot.miss.onset));
xlim(trange); box off;
ax(4) = gca;
yrange(4,:) = get(gca,'YLim');
legend({'','Miss','','Hit'});

figure('Position',[400 400 336 140]);
% h_btm(3) = subplot(4,5,9:10);
plot_bootmua(t,bmua_diffst); hold on;
% plot_bootmua(t,bmua_diffhm);
plot(t,mua_diffst,'LineWidth',1.5);
% plot(t,mua_diffhm,'LineWidth',1.5);
xlim(trange); box off;
% xlabel('Time from Target Onset [ms]');
ax_diff(3) = gca;
yrange_diff(3,:) = get(gca,'YLim');
legend({'','null','Small - Large'});

figure('Position',[700 400 224 140]);
% h_btm(4) = subplot(4,5,19:20);
plot_bootmua(t,bmua_diffhm); hold on;
plot(t,mua_diffhm,'LineWidth',1.5);
xlim(trange); box off;
xlabel('Time from Target Onset [ms]');
ax_diff(4) = gca;
yrange_diff(4,:) = get(gca,'YLim');
legend({'','null','Hit - Miss'});

yrange_top = [min(yrange(:,1)) max(yrange(:,2))];
yrange_btm = [min(yrange_diff(:,1)) max(yrange_diff(:,2))];
for i=1:4
    set(ax(i),'YLim',yrange_top);
    set(ax_diff(i),'YLim',yrange_btm);
end