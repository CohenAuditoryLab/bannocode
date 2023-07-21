% obtain bootstrapped index values from the data separated by areas (core vs belt or posterior vs anterior)
tic;
clear all

% path for function stats_CompLayers.m...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
% addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');

% ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude';
% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% sTriplet = {'1st','2nd','3rd','Tm1','T'};
nBoot = 1000; %1000;
isSave = 1;
isFigure = 0;

% load data
load MUAResponse_ABB_all; % extended to T+1 triplet

rA_all   = rALL.A;
rBB_all  = rALL.BB;
rABB_all = rALL.ABB;

% % separate data by area
% Core
rA_core   = rA_all(:,:,:,area_index==1,:);
rBB_core  = rBB_all(:,:,:,area_index==1,:);
rABB_core = rABB_all(:,:,:,area_index==1,:);
% Belt
rA_belt   = rA_all(:,:,:,area_index==0,:);
rBB_belt  = rBB_all(:,:,:,area_index==0,:);
rABB_belt = rABB_all(:,:,:,area_index==0,:);
% Posterior
rA_post   = rA_all(:,:,:,AP_index==1,:);
rBB_post  = rBB_all(:,:,:,AP_index==1,:);
rABB_post = rABB_all(:,:,:,AP_index==1,:);
% Anterior
rA_ant   = rA_all(:,:,:,AP_index==0,:);
rBB_ant  = rBB_all(:,:,:,AP_index==0,:);
rABB_ant = rABB_all(:,:,:,AP_index==0,:);

% obtain bootstrap data
disp('bootstrapping CORE data...');
[SMI_A_core,BMI_A_core] = get_BootIndex(rA_core,nBoot);
[SMI_BB_core,BMI_BB_core] = get_BootIndex(rBB_core,nBoot);
[SMI_ABB_core,BMI_ABB_core] = get_BootIndex(rABB_core,nBoot);
% save
if isSave==1
    save('Index_ABB_Boot_core','SMI_A_core','SMI_BB_core','SMI_ABB_core', ...
        'BMI_A_core','BMI_BB_core','BMI_ABB_core','nBoot');
end
clc

disp('bootstrapping BELT data...');
[SMI_A_belt,BMI_A_belt] = get_BootIndex(rA_belt,nBoot);
[SMI_BB_belt,BMI_BB_belt] = get_BootIndex(rBB_belt,nBoot);
[SMI_ABB_belt,BMI_ABB_belt] = get_BootIndex(rABB_belt,nBoot);
% save
if isSave==1
    save('Index_ABB_Boot_belt','SMI_A_belt','SMI_BB_belt','SMI_ABB_belt', ...
        'BMI_A_belt','BMI_BB_belt','BMI_ABB_belt','nBoot');
end
clc

disp('bootstrapping POSTERIOR data...');
[SMI_A_post,BMI_A_post] = get_BootIndex(rA_post,nBoot);
[SMI_BB_post,BMI_BB_post] = get_BootIndex(rBB_post,nBoot);
[SMI_ABB_post,BMI_ABB_post] = get_BootIndex(rABB_post,nBoot);
% save
if isSave==1
    save('Index_ABB_Boot_post','SMI_A_post','SMI_BB_post','SMI_ABB_post', ...
        'BMI_A_post','BMI_BB_post','BMI_ABB_post','nBoot');
end
clc

disp('bootstrapping ANTERIOR data...');
[SMI_A_ant,BMI_A_ant] = get_BootIndex(rA_ant,nBoot);
[SMI_BB_ant,BMI_BB_ant] = get_BootIndex(rBB_ant,nBoot);
[SMI_ABB_ant,BMI_ABB_ant] = get_BootIndex(rABB_ant,nBoot);
% save
if isSave==1
    save('Index_ABB_Boot_ant','SMI_A_ant','SMI_BB_ant','SMI_ABB_ant', ...
        'BMI_A_ant','BMI_BB_ant','BMI_ABB_ant','nBoot');
end
clc

toc;
% [SMI_A,BMI_A] = get_SMIBMI(rA_all,area_index,AP_index,nBoot);
% [SMI_B1,BMI_B1] = get_SMIBMI(rB1_all,area_index,AP_index,nBoot);
% [SMI_B2,BMI_B2] = get_SMIBMI(rB2_all,area_index,AP_index,nBoot);



if isFigure==1
tpos = [1 2 3 6 7];
line_color = [229 0 125; 78 186 25] / 255;
figure("Position",[100 100 800 450]);
% ci
subplot(2,3,1);
plot_index(tpos,SMI_A_core.original,line_color(1,:)); hold on
plot_index(tpos,SMI_A_belt.original,line_color(2,:));
plot_index_boot(tpos,SMI_A_core.boot);
plot_index_boot(tpos,SMI_A_belt.boot);
% fsi
subplot(2,3,2);
plot_index(tpos,SMI_BB_core.original,line_color(1,:)); hold on
plot_index(tpos,SMI_BB_belt.original,line_color(2,:));
plot_index_boot(tpos,SMI_BB_core.boot);
plot_index_boot(tpos,SMI_BB_belt.boot);
% bmi
subplot(2,3,3);
plot_index(tpos,BMI_ABB_core.original,line_color(1,:)); hold on
plot_index(tpos,BMI_ABB_belt.original,line_color(2,:));
plot_index_boot(tpos,BMI_ABB_core.boot);
plot_index_boot(tpos,BMI_ABB_belt.boot);

% ci
subplot(2,3,4);
plot_index(tpos,SMI_A_post.original,line_color(1,:)); hold on
plot_index(tpos,SMI_A_ant.original,line_color(2,:));
plot_index_boot(tpos,SMI_A_post.boot);
plot_index_boot(tpos,SMI_A_ant.boot);
% fsi
subplot(2,3,5);
plot_index(tpos,SMI_BB_post.original,line_color(1,:)); hold on
plot_index(tpos,SMI_BB_ant.original,line_color(2,:));
plot_index_boot(tpos,SMI_BB_post.boot);
plot_index_boot(tpos,SMI_BB_ant.boot);
% bmi
subplot(2,3,6);
plot_index(tpos,BMI_ABB_post.original,line_color(1,:)); hold on
plot_index(tpos,BMI_ABB_ant.original,line_color(2,:));
plot_index_boot(tpos,BMI_ABB_post.boot);
plot_index_boot(tpos,BMI_ABB_ant.boot);

% figure("Position",[150 150 800 450]);
% % smi
% subplot(2,3,1);
% plot_index(tpos,SMI_A.core,line_color(1,:)); hold on
% plot_index(tpos,SMI_A.belt,line_color(2,:));
% plot_index_boot(tpos,SMI_A.boot);
% subplot(2,3,2);
% plot_index(tpos,SMI_B1.core,line_color(1,:)); hold on
% plot_index(tpos,SMI_B1.belt,line_color(2,:));
% plot_index_boot(tpos,SMI_B1.boot);
% subplot(2,3,3);
% plot_index(tpos,SMI_B2.core,line_color(1,:)); hold on
% plot_index(tpos,SMI_B2.belt,line_color(2,:));
% plot_index_boot(tpos,SMI_B2.boot);
% % bmi
% subplot(2,3,4);
% plot_index(tpos,BMI_A.core,line_color(1,:)); hold on
% plot_index(tpos,BMI_A.belt,line_color(2,:));
% plot_index_boot(tpos,BMI_A.boot);
% subplot(2,3,5);
% plot_index(tpos,BMI_B1.core,line_color(1,:)); hold on
% plot_index(tpos,BMI_B1.belt,line_color(2,:));
% plot_index_boot(tpos,BMI_B1.boot);
% subplot(2,3,6);
% plot_index(tpos,BMI_B2.core,line_color(1,:)); hold on
% plot_index(tpos,BMI_B2.belt,line_color(2,:));
% plot_index_boot(tpos,BMI_B2.boot);
end