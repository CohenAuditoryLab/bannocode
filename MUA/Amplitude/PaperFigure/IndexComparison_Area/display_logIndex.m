function [index] = display_logIndex(rCORE,rBELT,BorS)
% BorS should be either 'Behav' or 'Stim'

s_1 = inputname(1);
s_2 = inputname(2);

jitter = 0.04;
line_color = [229 0 125; 78 186 25] / 255;

rCORE_A = rCORE.A;
rCORE_B1 = rCORE.B1;
rCORE_B2 = rCORE.B2;
rBELT_A = rBELT.A;
rBELT_B1 = rBELT.B1;
rBELT_B2 = rBELT.B2;

H = figure;
subplot(2,2,1);
[index.A.c, h(1)] = plot_logIndex_area(rCORE_A,-jitter,BorS); hold on;
[index.A.b, h(2)] = plot_logIndex_area(rBELT_A, jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('L');

subplot(2,2,3);
[index.B1.c, h(1)] = plot_logIndex_area(rCORE_B1,-jitter,BorS); hold on;
[index.B1.b, h(2)] = plot_logIndex_area(rBELT_B1, jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('H1');

subplot(2,2,4);
[index.B2.c, h(1)] = plot_logIndex_area(rCORE_B2,-jitter,BorS); hold on;
[index.B2.b, h(2)] = plot_logIndex_area(rBELT_B2, jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('H2');

% legend({'Core','Belt'},'Location',[0.5 0.82 0.2 0.1]);
legend({setLegend(s_1),setLegend(s_2)},'Location',[0.5 0.82 0.2 0.1]);


end

function s_out = setLegend(s)
    if strcmp(s,'rCORE')
        s_out = 'Core';
    elseif strcmp(s,'rBELT')
        s_out = 'Belt';
    elseif strcmp(s,'rPOS')
        s_out = 'Posterior';
    elseif strcmp(s,'rANT')
        s_out = 'Anterior';
    end
end