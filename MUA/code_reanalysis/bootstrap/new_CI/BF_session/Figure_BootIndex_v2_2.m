% plot index value with errorbar
% 12/23/22 modified to remove absolute value from CI
clear all;
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');

load Index_Channel_v2_lowBF
% load Index_Channel_v2_highBF

% choose triplet position to show
% sTriplet = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};
tpos = [1 2 3 6 7];
% tpos = 4:8;
% choose Anteior-Posterior or Core-Belt
area_type = 'AP'; % either AP (anterior vs posterior) or CB (core vs belt)
% line_color = [229 0 125; 78 186 25] / 255;
line_color = [153 0 255; 0 204 0] / 255;

if strcmp(area_type,'AP')
    % primary
    smi_a_p  = SMI_A.post;
    smi_b1_p = SMI_B1.post;
    smi_b2_p = SMI_B2.post;
    bmi_a_p  = BMI_A.post;
    bmi_b1_p = BMI_B1.post;
    bmi_b2_p = BMI_B2.post;
    % non-primary
    smi_a_n  = SMI_A.ant;
    smi_b1_n = SMI_B1.ant;
    smi_b2_n = SMI_B2.ant;
    bmi_a_n  = BMI_A.ant;
    bmi_b1_n = BMI_B1.ant;
    bmi_b2_n = BMI_B2.ant;
    % legend
    lg = {'posterior','anterior','','null'};
elseif strcmp(area_type,'CB')
    % primary
    smi_a_p  = SMI_A.core;
    smi_b1_p = SMI_B1.core;
    smi_b2_p = SMI_B2.core;
    bmi_a_p  = BMI_A.core;
    bmi_b1_p = BMI_B1.core;
    bmi_b2_p = BMI_B2.core;
    % non-primary
    smi_a_n  = SMI_A.belt;
    smi_b1_n = SMI_B1.belt;
    smi_b2_n = SMI_B2.belt;
    bmi_a_n  = BMI_A.belt;
    bmi_b1_n = BMI_B1.belt;
    bmi_b2_n = BMI_B2.belt;
    % legend
    lg = {'core','belt','','null'};
end

% load bootstrap data...
clear SMI_A SMI_B1 SMI_B2 BMI_A BMI_B1 BMI_B2
load Index_Boot_v2_lowBF
% load Index_Boot_v2_highBF

figure("Position",[100 100 800 450]);
% smi
subplot(2,3,1);
plot_index_v3(tpos,smi_a_p,-0.05,line_color(1,:)); hold on
plot_index_v3(tpos,smi_a_n,+0.05,line_color(2,:));
plot_index_boot(tpos,SMI_A.boot);
xlim([0.5 length(tpos)+0.5]);
xlabel('triplet position'); ylabel('CI');
title('L');
box off
subplot(2,3,2);
plot_index_v3(tpos,smi_b1_p,-0.05,line_color(1,:)); hold on
plot_index_v3(tpos,smi_b1_n,+0.05,line_color(2,:));
plot_index_boot(tpos,SMI_B1.boot);
xlim([0.5 length(tpos)+0.5]);
xlabel('triplet position'); ylabel('log(FSI)');
title('H1');
box off
subplot(2,3,3);
plot_index_v3(tpos,smi_b2_p,-0.05,line_color(1,:)); hold on
plot_index_v3(tpos,smi_b2_n,+0.05,line_color(2,:));
plot_index_boot(tpos,SMI_B2.boot);
xlim([0.5 length(tpos)+0.5]);
xlabel('triplet position'); ylabel('log(FSI)');
title('H2');
box off
% bmi
subplot(2,3,4);
plot_index_v3(tpos,bmi_a_p,-0.05,line_color(1,:)); hold on
plot_index_v3(tpos,bmi_a_n,+0.05,line_color(2,:));
plot_index_boot(tpos,BMI_A.boot);
xlim([0.5 length(tpos)+0.5]);
xlabel('triplet position'); ylabel('BMI');
title('L');
box off
subplot(2,3,5);
plot_index_v3(tpos,bmi_b1_p,-0.05,line_color(1,:)); hold on
plot_index_v3(tpos,bmi_b1_n,+0.05,line_color(2,:));
plot_index_boot(tpos,BMI_B1.boot);
xlim([0.5 length(tpos)+0.5]);
xlabel('triplet position'); ylabel('BMI');
title('H1');
box off
subplot(2,3,6);
plot_index_v3(tpos,bmi_b2_p,-0.05,line_color(1,:)); hold on
plot_index_v3(tpos,bmi_b2_n,+0.05,line_color(2,:));
plot_index_boot(tpos,BMI_B2.boot);
xlim([0.5 length(tpos)+0.5]);
xlabel('triplet position'); ylabel('BMI');
title('H2');
box off

legend(lg);
