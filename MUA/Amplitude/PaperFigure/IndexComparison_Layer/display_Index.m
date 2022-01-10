function [index] = display_Index(Resp,BorS)
% Resp should be a struct, BorS should be either 'Behav' or 'Stim'

jitter = 0.04;
line_color = [233 131 0; 125 0 99] / 255;
% line_color = [0.929 0.694 0.125; 0.494 0.184 0.556];

rSUP_A = Resp.rSUP.A;
rSUP_B1 = Resp.rSUP.B1;
rSUP_B2 = Resp.rSUP.B2;
rDEEP_A = Resp.rDEEP.A;
rDEEP_B1 = Resp.rDEEP.B1;
rDEEP_B2 = Resp.rDEEP.B2;

% compare behavioral signal in deep vs superfirical layers...
H = figure;
subplot(2,2,1);
[index.A.s, h(1)] = plot_index_layer(rSUP_A,-jitter,BorS); hold on;
[index.A.d, h(2)] = plot_index_layer(rDEEP_A,jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('L');

subplot(2,2,3);
[index.B1.s, h(1)] = plot_index_layer(rSUP_B1,-jitter,BorS); hold on;
[index.B1.d, h(2)] = plot_index_layer(rDEEP_B1,jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('H1');

subplot(2,2,4);
[index.B2.s, h(1)] = plot_index_layer(rSUP_B2,-jitter,BorS); hold on;
[index.B2.d, h(2)] = plot_index_layer(rDEEP_B2,jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('H2');

legend({'superficial','deep'},'Location',[0.5 0.82 0.2 0.1]);




    
end