function [index] = display_logIndex_emergenceOnset2_1(rCORE,rBELT,BorS)
% BorS should be either 'Behav' or 'Stim'

jitter = 0.04;
line_color = [229 0 125; 78 186 25] / 255;

% rCORE_A = rCORE.A;
% rCORE_B1 = rCORE.B1;
% rCORE_B2 = rCORE.B2;
% rBELT_A = rBELT.A;
% rBELT_B1 = rBELT.B1;
% rBELT_B2 = rBELT.B2;

rCORE_ABB = combineTriplet2(rCORE); % use version2
rBELT_ABB = combineTriplet2(rBELT); % use version2

H = figure;
subplot(2,2,1);
[index.ABB.c, h(1)] = plot_logIndex_area_emergenceOnset_wBL(rCORE_ABB,-jitter,BorS,line_color(1,:)); hold on;
[index.ABB.b, h(2)] = plot_logIndex_area_emergenceOnset_wBL(rBELT_ABB, jitter,BorS,line_color(2,:));
% set(h(1),'Color',line_color(1,:)); 
% set(h(2),'Color',line_color(2,:));
title('LHH combined');

% subplot(2,2,3);
% [index.B1.c, h(1)] = plot_logIndex_area_emergence(rCORE_B1,-jitter,BorS); hold on;
% [index.B1.b, h(2)] = plot_logIndex_area_emergence(rBELT_B1, jitter,BorS);
% set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
% title('H1');
% 
% subplot(2,2,4);
% [index.B2.c, h(1)] = plot_logIndex_area_emergence(rCORE_B2,-jitter,BorS); hold on;
% [index.B2.b, h(2)] = plot_logIndex_area_emergence(rBELT_B2, jitter,BorS);
% set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
% title('H2');

legend(h,{'Core','Belt'},'Location',[0.5 0.82 0.2 0.1]);


end