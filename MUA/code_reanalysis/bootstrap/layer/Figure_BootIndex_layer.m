clear all;

addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');
% load data
load Index_Boot
load Index_Layer

% choose triplet position to show
% sTriplet = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};
tpos = [1 2 3 6 7];
% tpos = 4:8;
% choose Anteior-Posterior or Core-Belt
area_type = 'AP'; % either AP (anterior vs posterior) or CB (core vs belt)
% line_color = [229 0 125; 78 186 25] / 255;
line_color_p = [157 195 230; 46 117 182; 31 78 121] / 255;
line_color_n = [244 177 131; 197 90 17; 132 60 12] / 255;

if strcmp(area_type,'AP')
    % primary
    smi_a_p  = cat(1,SMI_A_layer.post.sup,SMI_A_layer.post.grn,SMI_A_layer.post.inf);
    smi_b1_p = cat(1,SMI_B1_layer.post.sup,SMI_B1_layer.post.grn,SMI_B1_layer.post.inf);
    smi_b2_p = cat(1,SMI_B2_layer.post.sup,SMI_B2_layer.post.grn,SMI_B2_layer.post.inf);  
    bmi_a_p  = cat(1,BMI_A_layer.post.sup,BMI_A_layer.post.grn,BMI_A_layer.post.inf);
    bmi_b1_p = cat(1,BMI_B1_layer.post.sup,BMI_B1_layer.post.grn,BMI_B1_layer.post.inf);
    bmi_b2_p = cat(1,BMI_B2_layer.post.sup,BMI_B2_layer.post.grn,BMI_B2_layer.post.inf);
    % non-primary
    smi_a_n  = cat(1,SMI_A_layer.ant.sup,SMI_A_layer.ant.grn,SMI_A_layer.ant.inf);
    smi_b1_n = cat(1,SMI_B1_layer.ant.sup,SMI_B1_layer.ant.grn,SMI_B1_layer.ant.inf);
    smi_b2_n = cat(1,SMI_B2_layer.ant.sup,SMI_B2_layer.ant.grn,SMI_B2_layer.ant.inf);
    bmi_a_n  = cat(1,BMI_A_layer.ant.sup,BMI_A_layer.ant.grn,BMI_A_layer.ant.inf);
    bmi_b1_n = cat(1,BMI_B1_layer.ant.sup,BMI_B1_layer.ant.grn,BMI_B1_layer.ant.inf);
    bmi_b2_n = cat(1,BMI_B2_layer.ant.sup,BMI_B2_layer.ant.grn,BMI_B2_layer.ant.inf);
    
elseif strcmp(area_type,'CB')
    % primary
    smi_a_p  = cat(1,SMI_A_layer.core.sup,SMI_A_layer.core.grn,SMI_A_layer.core.inf);
    smi_b1_p = cat(1,SMI_B1_layer.core.sup,SMI_B1_layer.core.grn,SMI_B1_layer.core.inf);
    smi_b2_p = cat(1,SMI_B2_layer.core.sup,SMI_B2_layer.core.grn,SMI_B2_layer.core.inf);
    bmi_a_p  = cat(1,BMI_A_layer.core.sup,BMI_A_layer.core.grn,BMI_A_layer.core.inf);
    bmi_b1_p = cat(1,BMI_B1_layer.core.sup,BMI_B1_layer.core.grn,BMI_B1_layer.core.inf);
    bmi_b2_p = cat(1,BMI_B2_layer.core.sup,BMI_B2_layer.core.grn,BMI_B2_layer.core.inf);
    % non-primary
    smi_a_n  = cat(1,SMI_A_layer.belt.sup,SMI_A_layer.belt.grn,SMI_A_layer.belt.inf);
    smi_b1_n = cat(1,SMI_B1_layer.belt.sup,SMI_B1_layer.belt.grn,SMI_B1_layer.belt.inf);
    smi_b2_n = cat(1,SMI_B2_layer.belt.sup,SMI_B2_layer.belt.grn,SMI_B2_layer.belt.inf);
    bmi_a_n  = cat(1,BMI_A_layer.belt.sup,BMI_A_layer.belt.grn,BMI_A_layer.belt.inf);
    bmi_b1_n = cat(1,BMI_B1_layer.belt.sup,BMI_B1_layer.belt.grn,BMI_B1_layer.belt.inf);
    bmi_b2_n = cat(1,BMI_B2_layer.belt.sup,BMI_B2_layer.belt.grn,BMI_B2_layer.belt.inf);
end


figure("Position",[100 100 800 450]);
% smi
subplot(2,3,1);
plot_index_layer(tpos,smi_a_p,line_color_p); hold on
plot_index_layer(tpos,smi_a_n,line_color_n);
plot_index_boot(tpos,SMI_A.boot);
xlabel('triplet position'); ylabel('log(CI)');
title('L');
box off
subplot(2,3,2);
plot_index_layer(tpos,smi_b1_p,line_color_p); hold on
plot_index_layer(tpos,smi_b1_n,line_color_n);
plot_index_boot(tpos,SMI_B1.boot);
xlabel('triplet position'); ylabel('log(FSI)');
title('H1');
box off
subplot(2,3,3);
plot_index_layer(tpos,smi_b2_p,line_color_p); hold on
plot_index_layer(tpos,smi_b2_n,line_color_n);
plot_index_boot(tpos,SMI_B2.boot);
xlabel('triplet position'); ylabel('log(FSI)');
title('H2');
box off
% bmi
subplot(2,3,4);
plot_index_layer(tpos,bmi_a_p,line_color_p); hold on
plot_index_layer(tpos,bmi_a_n,line_color_n);
plot_index_boot(tpos,BMI_A.boot);
xlabel('triplet position'); ylabel('BMI');
title('L');
box off
subplot(2,3,5);
plot_index_layer(tpos,bmi_b1_p,line_color_p); hold on
plot_index_layer(tpos,bmi_b1_n,line_color_n);
plot_index_boot(tpos,BMI_B1.boot);
xlabel('triplet position'); ylabel('BMI');
title('H1');
box off
subplot(2,3,6);
plot_index_layer(tpos,bmi_b2_p,line_color_p); hold on
plot_index_layer(tpos,bmi_b2_n,line_color_n);
plot_index_boot(tpos,BMI_B2.boot);
xlabel('triplet position'); ylabel('BMI');
title('H2');
box off
