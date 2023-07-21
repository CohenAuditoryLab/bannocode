% plot BMI with errorbar
clear all;

addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');
load Index_Channel

% choose triplet position to show
% sTriplet = {'early','','','late'};
tpos = 4:8;
% choose Anteior-Posterior or Core-Belt
area_type = 'AP'; % either AP (anterior vs posterior) or CB (core vs belt)
line_color = [153 0 255; 0 204 0] / 255;
line_color_p = [102 0 204; 153 0 255; 153 102 255]/255;
line_color_n = [37 115 0; 78 186 25; 139 190 26]/255;

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
    line_label = {'posterior','anterior','','null'};
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
    line_label = {'core','belt','','null'};
end

% combine triplet
smi_abb_p = cat(3,smi_a_p,smi_b1_p,smi_b2_p);
smi_abb_n = cat(3,smi_a_n,smi_b1_n,smi_b2_n);
bmi_abb_p = cat(3,bmi_a_p,bmi_b1_p,bmi_b2_p);
bmi_abb_n = cat(3,bmi_a_n,bmi_b1_n,bmi_b2_n);

% load bootstrap data
clear SMI_A SMI_B1 SMI_B2 BMI_A BMI_B1 BMI_B2
load Index_Boot.mat
smi_abb_boot = cat(3,SMI_A.boot,SMI_B1.boot,SMI_B2.boot);
bmi_abb_boot = cat(3,BMI_A.boot,BMI_B1.boot,BMI_B2.boot);

figure;
symbol = {'o-','^--','s:'};
plot_smi_emergence(tpos,smi_abb_p,-0.05,line_color_p,symbol);
plot_smi_emergence(tpos,smi_abb_n,+0.05,line_color_n,symbol);
plot_bootSMI_emergence(tpos,smi_abb_boot,{'-','--',':'});
set(gca,'XLim',[0.5 15.5]);
xlabel('Triplet Positiion'); ylabel('log(CI) & log(FSI)');
box off

figure;
plot_bmi_emergence(tpos,bmi_abb_p,-0.05,line_color(1,:));
plot_bmi_emergence(tpos,bmi_abb_n,+0.05,line_color(2,:));
plot_bootBMI_emergence(tpos,bmi_abb_boot);
set(gca,'XLim',[0.5 15.5]);
xlabel('Triplet Position'); ylabel('BMI');
box off
legend(line_label,'Location','northwest');

% figure;
% % figure("Position",[100 100 800 450]);
% % subplot(2,2,1);
% plot_index_v3(tpos,bmi_p,-0.05,line_color(1,:)); hold on
% plot_index_v3(tpos,bmi_n,+0.05,line_color(2,:));
% plot_index_boot(tpos,BMI_T.boot);
% xlabel('Target Position'); ylabel('BMI');
% set(gca,'XLim',[0.5 4.5],'XTick',tpos,'XTickLabel',sTriplet);
% % title('Target');
% box off
% 
% legend(line_label,'Location','northwest');
