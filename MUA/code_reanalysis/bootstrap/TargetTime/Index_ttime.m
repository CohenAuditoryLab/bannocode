% modified from Bootstrap_index_tpos.m

clear all

% path for function stats_CompLayers.m...
% addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_Area');

isSave = 1;
% isFigure = 0;

% load data
load MUAResponse_Target.mat;

% get BMI in each channel
% Data includes NaN!!!
BMI_T = get_BMI_channel(rTarget,area_index,AP_index);

if isSave==1
    save('Index_Channel_ttime','BMI_T');
end


% if isFigure==1
%     tpos = [1 2 3 6 7];
%     line_color = [229 0 125; 78 186 25] / 255;
%     figure("Position",[100 100 800 450]);
%     % smi
%     subplot(2,3,1);
%     plot_index(tpos,SMI_A.post,line_color(1,:)); hold on
%     plot_index(tpos,SMI_A.ant,line_color(2,:));
%     plot_index_boot(tpos,SMI_A.boot);
%     subplot(2,3,2);
%     plot_index(tpos,SMI_B1.post,line_color(1,:)); hold on
%     plot_index(tpos,SMI_B1.ant,line_color(2,:));
%     plot_index_boot(tpos,SMI_B1.boot);
%     subplot(2,3,3);
%     plot_index(tpos,SMI_B2.post,line_color(1,:)); hold on
%     plot_index(tpos,SMI_B2.ant,line_color(2,:));
%     plot_index_boot(tpos,SMI_B2.boot);
%     % bmi
%     subplot(2,3,4);
%     plot_index(tpos,BMI_A.post,line_color(1,:)); hold on
%     plot_index(tpos,BMI_A.ant,line_color(2,:));
%     plot_index_boot(tpos,BMI_A.boot);
%     subplot(2,3,5);
%     plot_index(tpos,BMI_B1.post,line_color(1,:)); hold on
%     plot_index(tpos,BMI_B1.ant,line_color(2,:));
%     plot_index_boot(tpos,BMI_B1.boot);
%     subplot(2,3,6);
%     plot_index(tpos,BMI_B2.post,line_color(1,:)); hold on
%     plot_index(tpos,BMI_B2.ant,line_color(2,:));
%     plot_index_boot(tpos,BMI_B2.boot);
% 
% 
%     figure("Position",[150 150 800 450]);
%     
%     % smi
%     subplot(2,3,1);
%     plot_index(tpos,SMI_A.core,line_color(1,:)); hold on
%     plot_index(tpos,SMI_A.belt,line_color(2,:));
%     plot_index_boot(tpos,SMI_A.boot);
%     subplot(2,3,2);
%     plot_index(tpos,SMI_B1.core,line_color(1,:)); hold on
%     plot_index(tpos,SMI_B1.belt,line_color(2,:));
%     plot_index_boot(tpos,SMI_B1.boot);
%     subplot(2,3,3);
%     plot_index(tpos,SMI_B2.core,line_color(1,:)); hold on
%     plot_index(tpos,SMI_B2.belt,line_color(2,:));
%     plot_index_boot(tpos,SMI_B2.boot);
%     % bmi
%     subplot(2,3,4);
%     plot_index(tpos,BMI_A.core,line_color(1,:)); hold on
%     plot_index(tpos,BMI_A.belt,line_color(2,:));
%     plot_index_boot(tpos,BMI_A.boot);
%     subplot(2,3,5);
%     plot_index(tpos,BMI_B1.core,line_color(1,:)); hold on
%     plot_index(tpos,BMI_B1.belt,line_color(2,:));
%     plot_index_boot(tpos,BMI_B1.boot);
%     subplot(2,3,6);
%     plot_index(tpos,BMI_B2.core,line_color(1,:)); hold on
%     plot_index(tpos,BMI_B2.belt,line_color(2,:));
%     plot_index_boot(tpos,BMI_B2.boot);
% end
