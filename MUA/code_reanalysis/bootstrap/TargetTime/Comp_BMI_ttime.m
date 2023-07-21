% plot triplet combined BMI with errorbar
clear all;

% path for stats_CompLayers_SRHtest.m
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Area');
% path for stats_CompLayers_Friedman.m
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
% load data...
load Index_Channel_ttime

% choose triplet position to show
sTriplet = {'early','','','late'};
tpos = 1:4;
% choose Anteior-Posterior or Core-Belt
area_type = 'AP'; % either AP (anterior vs posterior) or CB (core vs belt)
% line_color = [229 0 125; 78 186 25] / 255;
line_color = [153 0 255; 0 204 0] / 255;

if strcmp(area_type,'AP')
    % primary
    bmi_p  = BMI_T.post;
    % non-primary
    bmi_n  = BMI_T.ant;
    line_label = {'posterior','anterior','','null'};
elseif strcmp(area_type,'CB')
    % primary
    bmi_p  = BMI_T.core;
    % non-primary
    bmi_n  = BMI_T.belt;
    line_label = {'core','belt','','null'};
end

% % load bootstrap data
% clear BMI_T
% load Index_Boot_ttime.mat

% kruskal-wallis test
pBMI_post = kruskalwallis(bmi_p);
pBMI_ant  = kruskalwallis(bmi_n);

% friedman test (one-way)
% repeated measuers of ANOVA comparable to kruskal-wallis test
rmBMI_p = rmnan_from_matrix(bmi_p); % remove NaN
rmBMI_n = rmnan_from_matrix(bmi_n); % remove NaN
pFr_BMI_post = friedman(rmBMI_p,1);
pFr_BMI_ant  = friedman(rmBMI_n,1);

% friedman test
% use friedman test as two-way ANOVA
% replaced by SRH test below...
pFr_BMI   = stats_CompLayers_Friedman(bmi_p,bmi_n);

% Scheirer-Ray-Hare test
pSRH_BMI = stats_CompLayers_SRHtest(bmi_p,bmi_n);
% to get more info, try
% [p,tbl,mc] = stats_CompLayers_SRHtest(bmi_p, bmi_n);

% figure;
% % bmi
% % subplot(2,3,1);
% plot_index_v3(tpos,bmi_p,-0.05,line_color(1,:)); hold on
% plot_index_v3(tpos,bmi_n,+0.05,line_color(2,:));
% plot_index_boot(tpos,BMI_triplet.boot);
% xlim([0.75 length(tpos)+0.25]);
% xlabel('triplet position'); ylabel('BMI');
% box off
% legend(lg,'Location','northwest');
