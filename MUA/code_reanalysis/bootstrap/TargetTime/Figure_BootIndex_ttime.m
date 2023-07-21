clear all;

addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap');
load Index_Boot_ttime

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
    line_label = {'posterior','anterior','null'};
elseif strcmp(area_type,'CB')
    % primary
    bmi_p  = BMI_T.core;
    % non-primary
    bmi_n  = BMI_T.belt;
    line_label = {'core','belt','null'};
end

figure;
% figure("Position",[100 100 800 450]);
% subplot(2,2,1);
plot_index(tpos,bmi_p,line_color(1,:)); hold on
plot_index(tpos,bmi_n,line_color(2,:));
plot_index_boot(tpos,BMI_T.boot);
xlabel('Target Position'); ylabel('BMI');
set(gca,'XLim',[0.5 4.5],'XTick',tpos,'XTickLabel',sTriplet);
% title('Target');
box off
legend(line_label);
