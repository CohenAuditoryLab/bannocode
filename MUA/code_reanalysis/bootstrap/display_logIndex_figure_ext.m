function [index] = display_logIndex_figure_ext(rCORE,rBELT,BorS)
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
[index.A.c, h(1)] = plot_logIndex_area_ext(rCORE_A,-jitter,BorS); hold on;
[index.A.b, h(2)] = plot_logIndex_area_ext(rBELT_A, jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('L');

subplot(2,3,pos(2));
[index.B1.c, h(1)] = plot_logIndex_area_ext(rCORE_B1,-jitter,BorS); hold on;
[index.B1.b, h(2)] = plot_logIndex_area_ext(rBELT_B1, jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('H1');

subplot(2,3,pos(3));
[index.B2.c, h(1)] = plot_logIndex_area_ext(rCORE_B2,-jitter,BorS); hold on;
[index.B2.b, h(2)] = plot_logIndex_area_ext(rBELT_B2, jitter,BorS);
set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
title('H2');

% legend({'Core','Belt'},'Location',[0.80 0.82 0.1 0.1]);
end




function [ d_reshape, h ] = plot_logIndex_area_ext( sigRESP_area, jitter, BorS )
%UNTITLED2 Summary of this function goes here
%   sigRESP_area must be a matrix of channel x easy-hard x hit-miss x session x tpos

% Reh = squeeze(mean(sigRESP_area,3)); % easy-hard 
% Rhm = squeeze(mean(sigRESP_area,2)); % hit-miss

Rhh = squeeze(sigRESP_area(:,1,1,:,:)); % hard-hit
Reh = squeeze(sigRESP_area(:,2,1,:,:)); % easy-hit
Rhm  = squeeze(sigRESP_area(:,1,2,:,:)); % hard-miss
Rem = squeeze(sigRESP_area(:,2,2,:,:)); % easy_miss


% stimulus and behavioral modulation index (withoug normalization)
dStim = abs( Rhh - Reh ) + abs( Rhm - Rem ); % modulation by stimulus frequency
dBehav =  ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme

% log transformation to make the distribution normal
dStim = log2(dStim); % only for dStim...

% with normalization
% dStim = abs( Rhh - Reh)./( abs(Rhh) + abs(Reh) ) + abs( Rhm - Rem )./( abs(Rhm) + abs(Rem) ); 
% dBehav = ( Rhh - Rhm )./( abs(Rhh) + abs(Rhm) ) + ( Reh - Rem )./( abs(Reh) + abs(Rem) );

% another normalization (didn't work...)
% Rhh = max(Rhh,0); Reh = max(Reh,0); Rhm = max(Rhm,0); Rem = max(Rhm,0);
% dStim = abs( Rhh - Reh)./ ( Rhh + Reh ) + abs( Rhm - Rem )./ ( Rhm + Rem ); 
% dBehav = ( Rhh - Rhm )./ ( Rhh + Rhm ) + ( Reh - Rem )./ ( Reh + Rem );

I = (dBehav - dStim) ./ (dBehav + dStim);

size_reshape = [size(I,1)*size(I,2) size(I,3)];
if strcmp(BorS,'Behav')
    d_reshape = reshape(dBehav,size_reshape);
    y_label = 'BMI';
elseif strcmp(BorS,'Stim')
    d_reshape = reshape(dStim,size_reshape);
%     y_label = 'log(SMI)';
    y_label = 'log(FSI)';
end


% y = nanmedian(d_reshape,1);
y = nanmean(d_reshape,1);
n = sum(~isnan(d_reshape),1);
err  = nanstd(d_reshape,0,1);
err2 = err ./ sqrt(n); % standard error

x = 1:size(y,2);
% jitter = [-0.01; 0.01] * ones(1,size(y,2));
% x = x + jitter;

h = errorbar(x'+jitter,y',err2','LineWidth',2.0);
% set(h(1),'Marker','o','Color','b','LineWidth',1.5); % easy vs hard
% set(h(2),'Marker','o','Color','r','LineWidth',1.5); % hit vs miss
% set(h(3),'Marker','o','Color','r','LineWidth',1.5);
% set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
set(gca,'xLim',[0.5 length(x)+0.5],'xTick',1:length(x),'xTickLabel',{'1st','2nd','3rd','T-1','T','T+1'});
xlabel('Triplet Position');
ylabel(y_label);
box off;
end
