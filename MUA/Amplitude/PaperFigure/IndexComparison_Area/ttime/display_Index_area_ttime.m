function [ index ] = display_Index_area_ttime(rCORE,rBELT)

jitter = 0.04;
line_color = [229 0 125; 78 186 25] / 255;

rCORE_A = rCORE.A;
rCORE_B1 = rCORE.B1;
rCORE_B2 = rCORE.B2;
rBELT_A = rBELT.A;
rBELT_B1 = rBELT.B1;
rBELT_B2 = rBELT.B2;

% compare behavioral signal in deep vs superfirical layers...
H = figure;
subplot(2,2,1);
[index.A.c, h(1)] = plot_index_ttime(rCORE_A,-0.04); hold on;
[index.A.b, h(2)] = plot_index_ttime(rBELT_A, 0.04);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('L');

subplot(2,2,3);
[index.B1.c, h(1)] = plot_index_ttime(rCORE_B1,-0.04); hold on;
[index.B1.b, h(2)] = plot_index_ttime(rBELT_B1, 0.04);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('H1');

subplot(2,2,4);
[index.B2.c, h(1)] = plot_index_ttime(rCORE_B2,-0.04); hold on;
[index.B2.b, h(2)] = plot_index_ttime(rBELT_B2, 0.04);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('H2');

legend({'Core','Belt'},'Location',[0.5 0.82 0.2 0.1]);
end