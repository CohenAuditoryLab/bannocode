clear all;

% fName = '20180709_bootMUA_ch9';
fName = '20190409_bootMUA_ch5';
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
mua_diffst = mean(mua_ldf,1) - mean(mua_sdf,1);
bmua_diffst = transpose(mua_boot.ldf.(epoch) - mua_boot.sdf.(epoch)) * 10^6; % uV
mua_hit  = transpose(mua.hit.(epoch)) * 10^6; % uV
mua_miss = transpose(mua.miss.(epoch)) * 10^6; % uV
mua_diffhm = mean(mua_hit,1) - mean(mua_miss,1);
bmua_diffhm = transpose(mua_boot.hit.(epoch) - mua_boot.miss.(epoch)) * 10^6; % uV

% plot
figure('Position',[680 558 1120 280]);
h_top(1) = subplot(2,10,1:3);
plot_mua(t,mua_sdf,c(1,:)); hold on;
plot_mua(t,mua_ldf,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.sdf.onset));
% plot_bootmua(t_onset,transpose(mua_boot.ldf.onset));
xlim(trange); box off;
ylabel('Amplitude [\muV]');
legend({'','Small \DeltaF','','Large \DeltaF'});

h_top(2) = subplot(2,10,6:8);
plot_mua(t,mua_miss,c(1,:)); hold on;
plot_mua(t,mua_hit,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.hit.onset));
% plot_bootmua(t_onset,transpose(mua_boot.miss.onset));
xlim(trange); box off;
% ylabel('Amplitude [\muV]');
legend({'','Miss','','Hit'});

h_btm(1) = subplot(2,10,11:13);
plot_bootmua(t,bmua_diffst); hold on;
% plot_bootmua(t,bmua_diffhm);
plot(t,mua_diffst,'LineWidth',1.5);
% plot(t,mua_diffhm,'LineWidth',1.5);
xlim(trange); box off;
xlabel('Time from Stimulus Onset [ms]');
ylabel('Difference');
legend({'','null','Large - Small'});

h_btm(2) = subplot(2,10,16:18);
plot_bootmua(t,bmua_diffhm); hold on;
plot(t,mua_diffhm,'LineWidth',1.5);
xlim(trange); box off;
xlabel('Time from Stimulus Onset [ms]');
% ylabel('Difference');
legend({'','null','Hit - Miss'});

%% target
epoch = 'target';
trange = [-250 250];
t  = tt.(epoch);
mua_sdf  = transpose(mua.sdf.(epoch)) * 10^6; % uV
mua_ldf  = transpose(mua.ldf.(epoch)) * 10^6; % uV
mua_diffst = mean(mua_ldf,1) - mean(mua_sdf,1);
bmua_diffst = transpose(mua_boot.ldf.(epoch) - mua_boot.sdf.(epoch)) * 10^6; % uV
mua_hit  = transpose(mua.hit.(epoch)) * 10^6; % uV
mua_miss = transpose(mua.miss.(epoch)) * 10^6; % uV
mua_diffhm = mean(mua_hit,1) - mean(mua_miss,1);
bmua_diffhm = transpose(mua_boot.hit.(epoch) - mua_boot.miss.(epoch)) * 10^6; % uV

% plot
h_top(3) = subplot(2,10,4:5);
plot_mua(t,mua_sdf,c(1,:)); hold on;
plot_mua(t,mua_ldf,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.sdf.onset));
% plot_bootmua(t_onset,transpose(mua_boot.ldf.onset));
xlim(trange); box off;
% legend({'','Small \DeltaF','','Large \DeltaF'});

h_top(4) = subplot(2,10,9:10);
plot_mua(t,mua_miss,c(1,:)); hold on;
plot_mua(t,mua_hit,c(2,:));
% plot_bootmua(t_onset,transpose(mua_boot.hit.onset));
% plot_bootmua(t_onset,transpose(mua_boot.miss.onset));
xlim(trange); box off;
% legend({'','Miss','','Hit'});

h_btm(3) = subplot(2,10,14:15);
plot_bootmua(t,bmua_diffst); hold on;
% plot_bootmua(t,bmua_diffhm);
plot(t,mua_diffst,'LineWidth',1.5);
% plot(t,mua_diffhm,'LineWidth',1.5);
xlim(trange); box off;
xlabel('Time from Target Onset [ms]');
% legend({'','null','Large - Small'});

h_btm(4) = subplot(2,10,19:20);
plot_bootmua(t,bmua_diffhm); hold on;
plot(t,mua_diffhm,'LineWidth',1.5);
xlim(trange); box off;
xlabel('Time from Target Onset [ms]');
% legend({'','null','Hit - Miss'});

yrange_top = get_yrange(h_top);
yrange_btm = get_yrange(h_btm);
for i=1:4
    set(h_top(i),'YLim',yrange_top);
    set(h_btm(i),'YLim',yrange_btm);
end