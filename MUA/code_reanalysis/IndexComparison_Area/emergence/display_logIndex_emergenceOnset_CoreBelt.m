function [index] = display_logIndex_emergenceOnset_CoreBelt(rCORE,rBELT,BorS)
% BorS should be either 'Behav' or 'Stim'

jitter = 0.04;
% line_color = [229 0 125; 78 186 25] / 255;
line_color = [153 0 255; 0 204 0] / 255;

% line_color_core = [209 65 65; 229 0 125; 254 104 156]/255;
line_color_core = [102 0 204; 153 0 255; 153 102 255]/255;
line_color_belt = [37 115 0; 78 186 25; 139 190 26]/255;

% rCORE_A = rCORE.A;
% rCORE_B1 = rCORE.B1;
% rCORE_B2 = rCORE.B2;
% rBELT_A = rBELT.A;
% rBELT_B1 = rBELT.B1;
% rBELT_B2 = rBELT.B2;

rCORE_ABB = combineTriplet(rCORE);
rBELT_ABB = combineTriplet(rBELT);

% H = figure;
% subplot(2,1,1);
if strcmp(BorS,'Behav')
    [index.ABB.c, h(1)] = plot_logIndex_area_emergenceOnset3(rCORE_ABB,-jitter,BorS); hold on;
    [index.ABB.b, h(2)] = plot_logIndex_area_emergenceOnset3(rBELT_ABB, jitter,BorS);
    set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
%     title('in the order of the tone bursts');
    title('Behavior-related modulation index');
elseif strcmp(BorS,'Stim')
    [index.ABB.c, h_core(1:3)] = plot_logIndex_area_emergenceOnset3(rCORE_ABB,-jitter,BorS); hold on;
    [index.ABB.b, h_belt] = plot_logIndex_area_emergenceOnset3(rBELT_ABB, jitter,BorS);
%     set(h_core,'Color',line_color(1,:)); set(h_belt,'Color',line_color(2,:));
    for i=1:3
    set(h_core(i),'Color',line_color_core(i,:)); set(h_belt(i),'Color',line_color_belt(i,:));
    end
%     title('in the order of the tone bursts');
    title('Stimlus-related modulation index');
end

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

if strcmp(BorS,'Behav')
%     legend({'Core','Belt'},'Location',[0.5 0.82 0.2 0.1]);
    legend({'Core','Belt'},'Location','NorthWest');
elseif strcmp(BorS,'Stim')
%     legend({'SMI','FMI_H_1','FMI_H_2'},'Location',[0.5 0.82 0.2 0.1]);
    legend({'CI','FSI_H_1','FSI_H_2'},'Location',[0.8 0.84 0.12 0.1]);
end

end