clear all;

load ROC_LvsH1_Layer
% sTriplet = {'1st','2nd','3rd','T-1','T'};

% set line color
line_color_p = [157 195 230; 46 117 182; 31 78 121] / 255;
line_color_n = [244 177 131; 197 90 17; 132 60 12] / 255;

x_lim = [0.5 length(sTriplet)+0.5];
y_lim = [0.2 0.8];
%% Figure 1
figure("Position",[100 100 650 750]); jitter = 0.08;
% superficial layer posterior
subplot(3,2,1); hold on;
X = 1:length(sTriplet);
Y = AUC_post.sup.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_p(1,:)); 
Y = AUC_post.sup.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_p(1,:));
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlim(x_lim);
ylim(y_lim);
ylabel('AUROC');
title('Posterior superficial');
legend({'Hit','Miss'});
% superficial layer anterior
subplot(3,2,2); hold on;
X = 1:length(sTriplet);
Y = AUC_ant.sup.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_n(1,:)); 
Y = AUC_ant.sup.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_n(1,:));
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlim(x_lim);
ylim(y_lim);
ylabel('AUROC');
title('Anterior superficial');
legend({'Hit','Miss'});

% middle layer posterior
subplot(3,2,3); hold on;
X = 1:length(sTriplet);
Y = AUC_post.mid.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_p(2,:)); 
Y = AUC_post.mid.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_p(2,:));
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlim(x_lim);
ylim(y_lim);
ylabel('AUROC');
title('Posterior middle');
% middle layer anterior
subplot(3,2,4); hold on;
X = 1:length(sTriplet);
Y = AUC_ant.mid.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_n(2,:)); 
Y = AUC_ant.mid.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_n(2,:));
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlim(x_lim);
ylim(y_lim);
ylabel('AUROC');
title('Anterior middle');

% deep layer posterior
subplot(3,2,5); hold on;
X = 1:length(sTriplet);
Y = AUC_post.dep.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_p(3,:)); 
Y = AUC_post.dep.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_p(3,:));
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlim(x_lim);
ylim(y_lim);
ylabel('AUROC');
title('Posterior deep');
% deep layer anterior
subplot(3,2,6); hold on;
X = 1:length(sTriplet);
Y = AUC_ant.dep.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_n(3,:)); 
Y = AUC_ant.dep.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_n(3,:));
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlim(x_lim);
ylim(y_lim);
ylabel('AUROC');
title('Anterior deep');

%% Figure 2
% plot AUC
figure("Position",[150 150 650 450]); jitter = 0.08;
% hit 
subplot(2,2,1); hold on
X = 1:length(sTriplet);
Y = AUC_post.sup.hit;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_p(1,:)); 
Y = AUC_post.mid.hit;
errorbar(X'+0,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_p(2,:));
Y = AUC_post.dep.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_p(3,:));
% edit axis
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlim(x_lim);
ylim(y_lim);
ylabel('AUROC');
title('Posterior Hit');
legend({'superficial','middle','deep'});

% hit
subplot(2,2,2); hold on
X = 1:length(sTriplet);
Y = AUC_ant.sup.hit;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_n(1,:)); 
Y = AUC_ant.mid.hit;
errorbar(X'+0,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_n(2,:));
Y = AUC_ant.dep.hit;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_n(3,:));
% edit axis
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlim(x_lim);
ylim(y_lim);
ylabel('AUROC');
title('Anterior Hit');
legend({'superficial','middle','deep'});

% miss
subplot(2,2,3); hold on
X = 1:length(sTriplet);
Y = AUC_post.sup.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_p(1,:)); 
Y = AUC_post.mid.miss;
errorbar(X'+0,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_p(2,:));
Y = AUC_post.dep.miss;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_p(3,:));
% edit axis
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlim(x_lim);
ylim(y_lim);
ylabel('AUROC');
title('Posterior Miss');

% miss
subplot(2,2,4); hold on
X = 1:length(sTriplet);
Y = AUC_ant.sup.miss;
errorbar(X'+jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_n(1,:)); 
Y = AUC_ant.mid.miss;
errorbar(X'+0,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_n(2,:));
Y = AUC_ant.dep.miss;
errorbar(X'-jitter,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',2.0,'Color',line_color_n(3,:));
% edit axis
set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
xlim(x_lim);
ylim(y_lim);
ylabel('AUROC');
title('Anterior Miss');

% subplot(2,2,3); hold on
% X = 1:length(sTriplet);
% % hit
% Y = AUC_post.sup.hit;
% errorbar(X'+jitter-J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_p(1,:)); 
% Y = AUC_post.mid.hit;
% errorbar(X'+0-J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_p(2,:));
% Y = AUC_post.dep.hit;
% errorbar(X'-jitter-J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_p(3,:));
% % miss
% Y = AUC_post.sup.miss;
% errorbar(X'+jitter+J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',1.5,'Color',line_color_p(1,:)); 
% Y = AUC_post.mid.miss;
% errorbar(X'+0+J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',1.5,'Color',line_color_p(2,:));
% Y = AUC_post.dep.miss;
% errorbar(X'-jitter+J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',1.5,'Color',line_color_p(3,:));
% % edit axis
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% ylabel('AUROC');
% title('Posterior');
% 
% subplot(2,2,4); hold on
% X = 1:length(sTriplet);
% % hit
% Y = AUC_ant.sup.hit;
% errorbar(X'+jitter-J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_n(1,:)); 
% Y = AUC_ant.mid.hit;
% errorbar(X'+0-J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_n(2,:));
% Y = AUC_ant.dep.hit;
% errorbar(X'-jitter-J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),'LineWidth',2.0,'Color',line_color_n(3,:));
% % miss
% Y = AUC_ant.sup.miss;
% errorbar(X'+jitter+J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',1.5,'Color',line_color_n(1,:)); 
% Y = AUC_ant.mid.miss;
% errorbar(X'+0+J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',1.5,'Color',line_color_n(2,:));
% Y = AUC_ant.dep.miss;
% errorbar(X'-jitter+J2,Y(:,1),Y(:,1)-Y(:,2),Y(:,3)-Y(:,1),':','LineWidth',1.5,'Color',line_color_n(3,:));
% % edit axis
% set(gca,'XTick',1:length(sTriplet),'XTickLabel',sTriplet);
% ylabel('AUROC');
% title('Anterior');


