% plot triplet combined BMI with errorbar
clear all;

load Index_triplet.mat

% choose triplet position to show
% sTriplet = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};
% tpos = [1 2 3 6 7];
tpos = 4:8;
% choose Anteior-Posterior or Core-Belt
area_type = 'AP'; % either AP (anterior vs posterior) or CB (core vs belt)
line_color = [153 0 255; 0 204 0] / 255;

if strcmp(area_type,'AP')
    % primary
    bmi_p = BMI_triplet.post;
    % non-primary
    bmi_n = BMI_triplet.ant;
    % legend
    lg = {'posterior','anterior','','null'};
elseif strcmp(area_type,'CB')
    % primary
    bmi_p = BMI_triplet.core;
    % non-primary
    bmi_n = BMI_triplet.belt;
    % legend
    lg = {'core','belt','','null'};
end

% load bootstrap data...
clear SMI_triplet BMI_triplet
load Index_Boot_emergence.mat

figure;
% bmi
% subplot(2,3,1);
plot_index_v3(tpos,bmi_p,-0.05,line_color(1,:)); hold on
plot_index_v3(tpos,bmi_n,+0.05,line_color(2,:));
plot_index_boot(tpos,BMI_triplet.boot);
xlim([0.75 length(tpos)+0.25]);
xlabel('triplet position'); ylabel('BMI');
box off

legend(lg,'Location','northwest');
