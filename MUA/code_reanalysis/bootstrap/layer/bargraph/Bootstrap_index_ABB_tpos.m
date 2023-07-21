clear all

% path for dependent function...
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');
% addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
% addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');

% set analysis parameter
line_color = [229 0 125; 78 186 25] / 255;
nBoot = 1000;
isSave = 1;
isFigure = 1;

% load data
load MUAResponse_ABB_all; % extended to T+1 triplet

% specify data set
rA_all   = rALL.A;
rBB_all  = rALL.BB;
rABB_all = rALL.ABB;

% bootstrap analysis
[SMI_A,BMI_A]     = get_SMIBMI(rA_all,area_index,AP_index,nBoot);
[SMI_BB,BMI_BB]   = get_SMIBMI(rBB_all,area_index,AP_index,nBoot);
[SMI_ABB,BMI_ABB] = get_SMIBMI(rABB_all,area_index,AP_index,nBoot);

% save values if isSave==1
if isSave==1
    save('Index_ABB_Boot','SMI_A','SMI_BB','SMI_ABB','BMI_A','BMI_BB','BMI_ABB','nBoot');
end

% show figure if isFigure==1
if isFigure==1
    tpos = [1 2 3 6 7];
    figure("Position",[100 100 800 450]);
    % smi
    subplot(2,3,1);
    plot_index(tpos,SMI_A.post,line_color(1,:)); hold on
    plot_index(tpos,SMI_A.ant,line_color(2,:));
    plot_index_boot(tpos,SMI_A.boot);
    xlabel('triplet position'); ylabel('log(CI)');
    title('L'); box off;
    subplot(2,3,2);
    plot_index(tpos,SMI_BB.post,line_color(1,:)); hold on
    plot_index(tpos,SMI_BB.ant,line_color(2,:));
    plot_index_boot(tpos,SMI_BB.boot);
    xlabel('triplet position'); ylabel('log(FSI)');
    title('HH'); box off;
    subplot(2,3,3);
    plot_index(tpos,SMI_ABB.post,line_color(1,:)); hold on
    plot_index(tpos,SMI_ABB.ant,line_color(2,:));
    plot_index_boot(tpos,SMI_ABB.boot);
    xlabel('triplet position'); ylabel('log(FSI)');
    title('LHH'); box off;
    % bmi
    subplot(2,3,4);
    plot_index(tpos,BMI_A.post,line_color(1,:)); hold on
    plot_index(tpos,BMI_A.ant,line_color(2,:));
    plot_index_boot(tpos,BMI_A.boot);
    xlabel('triplet position'); ylabel('BMI');
    title('L'); box off;
    subplot(2,3,5);
    plot_index(tpos,BMI_BB.post,line_color(1,:)); hold on
    plot_index(tpos,BMI_BB.ant,line_color(2,:));
    plot_index_boot(tpos,BMI_BB.boot);
    xlabel('triplet position'); ylabel('BMI');
    title('HH'); box off;
    subplot(2,3,6);
    plot_index(tpos,BMI_ABB.post,line_color(1,:)); hold on
    plot_index(tpos,BMI_ABB.ant,line_color(2,:));
    plot_index_boot(tpos,BMI_ABB.boot);
    xlabel('triplet position'); ylabel('BMI');
    title('LHH'); box off;

    figure("Position",[150 150 800 450]);
    % smi
    subplot(2,3,1);
    plot_index(tpos,SMI_A.core,line_color(1,:)); hold on
    plot_index(tpos,SMI_A.belt,line_color(2,:));
    plot_index_boot(tpos,SMI_A.boot);
    xlabel('triplet position'); ylabel('log(CI)');
    title('L'); box off;
    subplot(2,3,2);
    plot_index(tpos,SMI_BB.core,line_color(1,:)); hold on
    plot_index(tpos,SMI_BB.belt,line_color(2,:));
    plot_index_boot(tpos,SMI_BB.boot);
    xlabel('triplet position'); ylabel('log(FSI)');
    title('HH'); box off;
    subplot(2,3,3);
    plot_index(tpos,SMI_ABB.core,line_color(1,:)); hold on
    plot_index(tpos,SMI_ABB.belt,line_color(2,:));
    plot_index_boot(tpos,SMI_ABB.boot);
    xlabel('triplet position'); ylabel('log(FSI)');
    title('LHH'); box off;
    % bmi
    subplot(2,3,4);
    plot_index(tpos,BMI_A.core,line_color(1,:)); hold on
    plot_index(tpos,BMI_A.belt,line_color(2,:));
    plot_index_boot(tpos,BMI_A.boot);
    xlabel('triplet position'); ylabel('BMI');
    title('L'); box off;
    subplot(2,3,5);
    plot_index(tpos,BMI_BB.core,line_color(1,:)); hold on
    plot_index(tpos,BMI_BB.belt,line_color(2,:));
    plot_index_boot(tpos,BMI_BB.boot);
    xlabel('triplet position'); ylabel('BMI');
    title('HH'); box off;
    subplot(2,3,6);
    plot_index(tpos,BMI_ABB.core,line_color(1,:)); hold on
    plot_index(tpos,BMI_ABB.belt,line_color(2,:));
    plot_index_boot(tpos,BMI_ABB.boot);
    xlabel('triplet position'); ylabel('BMI');
    title('LHH'); box off;
end