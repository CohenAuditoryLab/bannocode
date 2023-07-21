% modified version of Figure_bootMUA_v3.m
% arrange the plot vertically
% small dF - large dF in comparison of stimulus

clear all;

% fName = '20180709_bootMUA_ch9';
% fName = '20190409_bootMUA_ch5';
fName = '20200110_bootMUA_ch7';
% fName = '20210111_bootMUA_ch23';
% fName = '20210220_bootMUA_ch5';
load(fName);
c = [0 0.4470 0.7410; 0.8500 0.3250 0.0980];
c_A = [0 0 0]; c_B = [0.6 0.6 0.6];
y_top = -2; y_btm = -2.048; % copied from yrange_top and yrange_btm

%% onset
epoch = 'onset';
X = [(0:75:675); (50:75:725)];
X_A = X(:,1:3:end);
X_B = X; X_B(:,1:3:end) = [];
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
% figure('Position',[680 558 1120 280]);
figure('Position',[100 100 600 600]);
h_top(1) = subplot(4,5,1:3);
plot_mua(t,mua_sdf,c(1,:)); hold on;
plot_mua(t,mua_ldf,c(2,:));
plot_stimbar(X_A,y_top,c_A);
plot_stimbar(X_B,y_top,c_B);
% plot_bootmua(t_onset,transpose(mua_boot.sdf.onset));
% plot_bootmua(t_onset,transpose(mua_boot.ldf.onset));
xlim(trange); box off;
ylabel('Amplitude [\muV]','FontSize',12);
% legend({'','Small \DeltaF','','Large \DeltaF'});

h_top(2) = subplot(4,5,11:13);
plot_mua(t,mua_miss,c(1,:)); hold on;
plot_mua(t,mua_hit,c(2,:));
plot_stimbar(X_A,y_top,c_A);
plot_stimbar(X_B,y_top,c_B);
% plot_bootmua(t_onset,transpose(mua_boot.hit.onset));
% plot_bootmua(t_onset,transpose(mua_boot.miss.onset));
xlim(trange); box off;
ylabel('Amplitude [\muV]','FontSize',12);
% legend({'','Miss','','Hit'});

h_btm(1) = subplot(4,5,6:8);
plot_bootmua(t,bmua_diffst); hold on;
plot(t,mua_diffst,'LineWidth',1.5);
plot_stimbar(X_A,y_btm,c_A);
plot_stimbar(X_B,y_btm,c_B);
xlim(trange); box off;
% xlabel('Time from Stimulus Onset [ms]');
ylabel('Difference','FontSize',12);
% legend({'','null','Small - Large'});

h_btm(2) = subplot(4,5,16:18);
plot_bootmua(t,bmua_diffhm); hold on;
plot(t,mua_diffhm,'LineWidth',1.5);
plot_stimbar(X_A,y_btm,c_A);
plot_stimbar(X_B,y_btm,c_B);
xlim(trange); box off;
xlabel('Time from Stimulus Onset [ms]','FontSize',12);
ylabel('Difference','FontSize',12);
% legend({'','null','Hit - Miss'});

%% target
epoch = 'target';
X = [(-225:75:225); (-175:75:275)];
X_A = X(:,1:3:end);
X_B = X; X_B(:,1:3:end) = [];
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
h_top(3) = subplot(4,5,4:5);
plot_mua(t,mua_sdf,c(1,:)); hold on;
plot_mua(t,mua_ldf,c(2,:));
plot_stimbar(X_A,y_top,c_A);
plot_stimbar(X_B,y_top,c_B);
% plot_bootmua(t_onset,transpose(mua_boot.sdf.onset));
% plot_bootmua(t_onset,transpose(mua_boot.ldf.onset));
xlim(trange); box off;
legend({'','Small \DeltaF','','Large \DeltaF'});

h_top(4) = subplot(4,5,14:15);
plot_mua(t,mua_miss,c(1,:)); hold on;
plot_mua(t,mua_hit,c(2,:));
plot_stimbar(X_A,y_top,c_A);
plot_stimbar(X_B,y_top,c_B);
% plot_bootmua(t_onset,transpose(mua_boot.hit.onset));
% plot_bootmua(t_onset,transpose(mua_boot.miss.onset));
xlim(trange); box off;
legend({'','Miss','','Hit'});

h_btm(3) = subplot(4,5,9:10);
plot_bootmua(t,bmua_diffst); hold on;
plot(t,mua_diffst,'LineWidth',1.5);
plot_stimbar(X_A,y_btm,c_A);
plot_stimbar(X_B,y_btm,c_B);
xlim(trange); box off;
% xlabel('Time from Target Onset [ms]');
legend({'','null','Small - Large'});

h_btm(4) = subplot(4,5,19:20);
plot_bootmua(t,bmua_diffhm); hold on;
plot(t,mua_diffhm,'LineWidth',1.5);
plot_stimbar(X_A,y_btm,c_A);
plot_stimbar(X_B,y_btm,c_B);
xlim(trange); box off;
xlabel('Time from Target Onset [ms]','FontSize',12);
legend({'','null','Hit - Miss'});

yrange_top = get_yrange(h_top);
yrange_btm = get_yrange(h_btm);
for i=1:4
    set(h_top(i),'YLim',yrange_top,'FontName','Arial','LineWidth',1);
    set(h_btm(i),'YLim',yrange_btm,'FontName','Arial','LineWidth',1);
end