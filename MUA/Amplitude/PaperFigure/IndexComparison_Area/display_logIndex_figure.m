function [index] = display_logIndex_figure(rCORE,rBELT,BorS)
% BorS should be either 'Behav' or 'Stim'

jitter = 0.04;
% line_color = [229 0 125; 78 186 25] / 255;
line_color = [153 0 255; 0 204 0] / 255;

rCORE_A = rCORE.A;
rCORE_B1 = rCORE.B1;
rCORE_B2 = rCORE.B2;
rBELT_A = rBELT.A;
rBELT_B1 = rBELT.B1;
rBELT_B2 = rBELT.B2;

% set figure position
if strcmp(BorS,'Stim')
    pos = 1:3;
elseif strcmp(BorS,'Behav')
    pos = 4:6;
end
% H = figure;
subplot(2,3,pos(1));
[index.A.c, h(1)] = plot_logIndex_area(rCORE_A,-jitter,BorS); hold on;
[index.A.b, h(2)] = plot_logIndex_area(rBELT_A, jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('L');

subplot(2,3,pos(2));
[index.B1.c, h(1)] = plot_logIndex_area(rCORE_B1,-jitter,BorS); hold on;
[index.B1.b, h(2)] = plot_logIndex_area(rBELT_B1, jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('H1');

subplot(2,3,pos(3));
[index.B2.c, h(1)] = plot_logIndex_area(rCORE_B2,-jitter,BorS); hold on;
[index.B2.b, h(2)] = plot_logIndex_area(rBELT_B2, jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('H2');

% legend({'Core','Belt'},'Location',[0.80 0.82 0.1 0.1]);


end