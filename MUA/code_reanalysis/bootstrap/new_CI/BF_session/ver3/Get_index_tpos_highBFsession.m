% obtain index values for each channel
% modified to obtain CI values without taking absolute values...
% code modified from Index_tpos.m
clear all

DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap';
% path for function stats_CompLayers.m...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');

% ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude';
% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% sTriplet = {'1st','2nd','3rd','Tm1','T'};
line_color = [229 0 125; 78 186 25] / 255;
% nBoot = 1000;
isSave = 1;

% load data
fName = 'MUAResponse_all'; 
load(fullfile(DATA_PATH,fName)); % extended to T+1 triplet

rA_all  = rALL.A;
rB1_all = rALL.B1;
rB2_all = rALL.B2;

% % % select sessions by BF % % %
% sessin ID copied from Combine_ROC.m
% in ..\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA
iHighBF_domo = [7 8 10 13];
iHighBF_cassius = [2 3 5 7 9 10 11 12 13 15 16 17 18 19 20 21];
% concatenate index
iHighBF = [iHighBF_domo iHighBF_cassius+16];
% remove sessions with low BF
rA_all  = rA_all(:,:,:,iHighBF,:);
rB1_all = rB1_all(:,:,:,iHighBF,:);
rB2_all = rB2_all(:,:,:,iHighBF,:);
AP_index = AP_index(iHighBF);
area_index = area_index(iHighBF);

% get index values for each channel
[SMI_A,BMI_A] = get_SMIBMI_channel_v3(rA_all,area_index,AP_index);
[SMI_B1,BMI_B1] = get_SMIBMI_channel_v3(rB1_all,area_index,AP_index);
[SMI_B2,BMI_B2] = get_SMIBMI_channel_v3(rB2_all,area_index,AP_index);

if isSave==1
    save('Index_Channel_v3_highBF','SMI_A','SMI_B1','SMI_B2','BMI_A','BMI_B1','BMI_B2');
end

% % % plot data for checking % % %
% tpos = [1 2 3 6 7];
% figure("Position",[100 100 800 450]);
% % smi
% subplot(2,3,1);
% plot_index(tpos,SMI_A.post,line_color(1,:)); hold on
% plot_index(tpos,SMI_A.ant,line_color(2,:));
% plot_index_boot(tpos,SMI_A.boot);
% subplot(2,3,2);
% plot_index(tpos,SMI_B1.post,line_color(1,:)); hold on
% plot_index(tpos,SMI_B1.ant,line_color(2,:));
% plot_index_boot(tpos,SMI_B1.boot);
% subplot(2,3,3);
% plot_index(tpos,SMI_B2.post,line_color(1,:)); hold on
% plot_index(tpos,SMI_B2.ant,line_color(2,:));
% plot_index_boot(tpos,SMI_B2.boot);
% % bmi
% subplot(2,3,4);
% plot_index(tpos,BMI_A.post,line_color(1,:)); hold on
% plot_index(tpos,BMI_A.ant,line_color(2,:));
% plot_index_boot(tpos,BMI_A.boot);
% subplot(2,3,5);
% plot_index(tpos,BMI_B1.post,line_color(1,:)); hold on
% plot_index(tpos,BMI_B1.ant,line_color(2,:));
% plot_index_boot(tpos,BMI_B1.boot);
% subplot(2,3,6);
% plot_index(tpos,BMI_B2.post,line_color(1,:)); hold on
% plot_index(tpos,BMI_B2.ant,line_color(2,:));
% plot_index_boot(tpos,BMI_B2.boot);
% 
% 
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