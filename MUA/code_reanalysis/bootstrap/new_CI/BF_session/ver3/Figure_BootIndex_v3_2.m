% plot index value with errorbar
% 12/23/22 modified to remove absolute value from CI
clear all;
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');


% load Index_Channel_v3_highBF

% choose triplet position to show
% sTriplet = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};
tpos = [1 2 3 6 7];
% tpos = 4:8;
% choose Anteior-Posterior or Core-Belt
area_type = 'AP'; % either AP (anterior vs posterior) or CB (core vs belt)
% line_color = [153 0 255; 0 204 0] / 255;
% line_color = [43 140 2; 123 41 208; 98 251 34; 177 127 229] / 255;
line_color = [123 41 208; 43 140 2; 177 127 229; 98 251 34] / 255;

% low BF sites (L tone is BF)
load Index_Channel_v3_lowBF
if strcmp(area_type,'AP')
    % primary
    lsmi_a_p  = SMI_A.post;
    lsmi_b1_p = SMI_B1.post;
    lsmi_b2_p = SMI_B2.post;
    lbmi_a_p  = BMI_A.post;
    lbmi_b1_p = BMI_B1.post;
    lbmi_b2_p = BMI_B2.post;
    % non-primary
    lsmi_a_n  = SMI_A.ant;
    lsmi_b1_n = SMI_B1.ant;
    lsmi_b2_n = SMI_B2.ant;
    lbmi_a_n  = BMI_A.ant;
    lbmi_b1_n = BMI_B1.ant;
    lbmi_b2_n = BMI_B2.ant;
    % legend
    lg = {'posterior lowBF','anterior lowBF','posterior highBF','anterior highBF','','null'};
elseif strcmp(area_type,'CB')
    % primary
    lsmi_a_p  = SMI_A.core;
    lsmi_b1_p = SMI_B1.core;
    lsmi_b2_p = SMI_B2.core;
    lbmi_a_p  = BMI_A.core;
    lbmi_b1_p = BMI_B1.core;
    lbmi_b2_p = BMI_B2.core;
    % non-primary
    lsmi_a_n  = SMI_A.belt;
    lsmi_b1_n = SMI_B1.belt;
    lsmi_b2_n = SMI_B2.belt;
    lbmi_a_n  = BMI_A.belt;
    lbmi_b1_n = BMI_B1.belt;
    lbmi_b2_n = BMI_B2.belt;
    % legend
    lg = {'core lowBF','belt lowBF','core highBF','belt highBF','','null'};
end
clear SMI_A SMI_B1 SMI_B2 BMI_A BMI_B1 BMI_B2

% high BF sites (H tone is BF when large dF)
load Index_Channel_v3_highBF
if strcmp(area_type,'AP')
    % primary
    hsmi_a_p  = SMI_A.post;
    hsmi_b1_p = SMI_B1.post;
    hsmi_b2_p = SMI_B2.post;
    hbmi_a_p  = BMI_A.post;
    hbmi_b1_p = BMI_B1.post;
    hbmi_b2_p = BMI_B2.post;
    % non-primary
    hsmi_a_n  = SMI_A.ant;
    hsmi_b1_n = SMI_B1.ant;
    hsmi_b2_n = SMI_B2.ant;
    hbmi_a_n  = BMI_A.ant;
    hbmi_b1_n = BMI_B1.ant;
    hbmi_b2_n = BMI_B2.ant;
elseif strcmp(area_type,'CB')
    % primary
    hsmi_a_p  = SMI_A.core;
    hsmi_b1_p = SMI_B1.core;
    hsmi_b2_p = SMI_B2.core;
    hbmi_a_p  = BMI_A.core;
    hbmi_b1_p = BMI_B1.core;
    hbmi_b2_p = BMI_B2.core;
    % non-primary
    hsmi_a_n  = SMI_A.belt;
    hsmi_b1_n = SMI_B1.belt;
    hsmi_b2_n = SMI_B2.belt;
    hbmi_a_n  = BMI_A.belt;
    hbmi_b1_n = BMI_B1.belt;
    hbmi_b2_n = BMI_B2.belt;
end
clear SMI_A SMI_B1 SMI_B2 BMI_A BMI_B1 BMI_B2

% load bootstrap data...
load Index_Boot_v3_lowBF
% load Index_Boot_v3_highBF

figure("Position",[100 100 800 450]);
% smi
subplot(2,3,1);
plot_index_v3(tpos,lsmi_a_p,-0.15,line_color(1,:)); hold on
plot_index_v3(tpos,lsmi_a_n,+0.05,line_color(2,:));
plot_index_v3(tpos,hsmi_a_p,-0.05,line_color(3,:));
plot_index_v3(tpos,hsmi_a_n,+0.15,line_color(4,:));
plot_index_boot(tpos,SMI_A.boot);
xlim([0.5 length(tpos)+0.5]); ylim([-6.5 6.5]);
xlabel('triplet position'); ylabel('CI');
title('L');
box off

subplot(2,3,2);
plot_index_v3(tpos,lsmi_b1_p,-0.15,line_color(1,:)); hold on
plot_index_v3(tpos,lsmi_b1_n,+0.05,line_color(2,:));
plot_index_v3(tpos,hsmi_b1_p,-0.05,line_color(3,:));
plot_index_v3(tpos,hsmi_b1_n,+0.15,line_color(4,:));
plot_index_boot(tpos,SMI_B1.boot);
xlim([0.5 length(tpos)+0.5]); ylim([-6.5 6.5]);
xlabel('triplet position'); ylabel('FSI');
title('H1');
box off

subplot(2,3,3);
plot_index_v3(tpos,lsmi_b2_p,-0.15,line_color(1,:)); hold on
plot_index_v3(tpos,lsmi_b2_n,+0.05,line_color(2,:));
plot_index_v3(tpos,hsmi_b2_p,-0.05,line_color(3,:));
plot_index_v3(tpos,hsmi_b2_n,+0.15,line_color(4,:));
plot_index_boot(tpos,SMI_B2.boot);
xlim([0.5 length(tpos)+0.5]); ylim([-6.5 6.5]);
xlabel('triplet position'); ylabel('FSI');
title('H2');
box off

% bmi
subplot(2,3,4);
plot_index_v3(tpos,lbmi_a_p,-0.15,line_color(1,:)); hold on
plot_index_v3(tpos,lbmi_a_n,+0.05,line_color(2,:));
plot_index_v3(tpos,hbmi_a_p,-0.05,line_color(3,:));
plot_index_v3(tpos,hbmi_a_n,+0.15,line_color(4,:));
plot_index_boot(tpos,BMI_A.boot);
xlim([0.5 length(tpos)+0.5]); ylim([-1 2]);
xlabel('triplet position'); ylabel('BMI');
title('L');
box off

subplot(2,3,5);
plot_index_v3(tpos,lbmi_b1_p,-0.15,line_color(1,:)); hold on
plot_index_v3(tpos,lbmi_b1_n,+0.05,line_color(2,:));
plot_index_v3(tpos,hbmi_b1_p,-0.05,line_color(3,:));
plot_index_v3(tpos,hbmi_b1_n,+0.15,line_color(4,:));
plot_index_boot(tpos,BMI_B1.boot);
xlim([0.5 length(tpos)+0.5]); ylim([-1 2]);
xlabel('triplet position'); ylabel('BMI');
title('H1');
box off

subplot(2,3,6);
plot_index_v3(tpos,lbmi_b2_p,-0.15,line_color(1,:)); hold on
plot_index_v3(tpos,lbmi_b2_n,+0.05,line_color(2,:));
plot_index_v3(tpos,hbmi_b2_p,-0.05,line_color(3,:));
plot_index_v3(tpos,hbmi_b2_n,+0.15,line_color(4,:));
plot_index_boot(tpos,BMI_B2.boot);
xlim([0.5 length(tpos)+0.5]); ylim([-1 2]);
xlabel('triplet position'); ylabel('BMI');
title('H2');
box off

legend(lg);
