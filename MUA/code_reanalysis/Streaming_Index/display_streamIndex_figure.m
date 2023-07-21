function [index] = display_streamIndex_figure(rCORE,rBELT)
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

% % set figure position
% if strcmp(BorS,'Stim')
%     pos = 1:3;
% elseif strcmp(BorS,'Behav')
%     pos = 4:6;
% end
% H = figure;

% subplot(2,3,pos(1));
subplot(2,2,1);
[index.c.h, index.c.m, h(1)] = plot_stIndex_area(rCORE_A, rCORE_B1, jitter); 
% title('Posterior');

subplot(2,2,2);
[index.b.h, index_b.m, h(2)] = plot_stIndex_area(rBELT_A, rBELT_B1, jitter);
% [index.b.h, index_b.m, h(2)] = plot_stIndex_area(rBELT_B1, rBELT_B2, jitter);
% set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
% title('Anterior');

% subplot(2,3,pos(2));
% [index.B1.c, h(1)] = plot_stIndex_area(rCORE_B1,-jitter); hold on;
% [index.B1.b, h(2)] = plot_stIndex_area(rBELT_B1, jitter);
% set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
% title('H1');
% 
% subplot(2,3,pos(3));
% [index.B2.c, h(1)] = plot_stIndex_area(rCORE_B2,-jitter); hold on;
% [index.B2.b, h(2)] = plot_stIndex_area(rBELT_B2, jitter);
% set(h(1),'Color',line_color(1,:)); set(h(2),'Color',line_color(2,:));
% title('H2');

% legend({'Core','Belt'},'Location',[0.80 0.82 0.1 0.1]);


end

function [ dStream_hit, dStream_miss, h ] = plot_stIndex_area( rA, rB, jitter )
%UNTITLED2 Summary of this function goes here
%   sigRESP_area must be a matrix of channel x easy-hard x hit-miss x session x tpos

% Reh = squeeze(mean(sigRESP_area,3)); % easy-hard 
% Rhm = squeeze(mean(sigRESP_area,2)); % hit-miss

Ahh = squeeze(rA(:,1,1,:,:)); % hard-hit
Aeh = squeeze(rA(:,2,1,:,:)); % easy-hit
Ahm  = squeeze(rA(:,1,2,:,:)); % hard-miss
Aem = squeeze(rA(:,2,2,:,:)); % easy_miss

Bhh = squeeze(rB(:,1,1,:,:)); % hard-hit
Beh = squeeze(rB(:,2,1,:,:)); % easy-hit
Bhm  = squeeze(rB(:,1,2,:,:)); % hard-miss
Bem = squeeze(rB(:,2,2,:,:)); % easy_miss

Ahit = Ahh + Aeh; Amiss = Ahm + Aem;
Bhit = Bhh + Beh; Bmiss = Bhm + Bem;
% % stimulus and behavioral modulation index (withoug normalization)
% dStream_hit  = abs( Ahh - Bhh ); % modulation by stimulus frequency
% dStream_miss = abs( Ahm - Bhm ); % modulation by behavioral outocme
% % log transformation to make the distribution normal
% dStream_hit  = log2(dStream_hit); % only for dStim...
% dStream_miss = log2(dStream_miss);

Ahh(Ahh<0) = 0; Ahm(Ahm<0) = 0;
Bhh(Bhh<0) = 0; Bhm(Bhm<0) = 0;

Aeh(Aeh<0) = 0; Aem(Aem<0) = 0;
Beh(Beh<0) = 0; Bem(Bem<0) = 0;

Ahit(Ahit<0) = 0; Amiss(Amiss<0) = 0;
Bhit(Bhit<0) = 0; Bmiss(Bmiss<0) = 0;

% dStream_hit  = Aeh ./ (Aeh + Beh);
% dStream_miss = Aem ./ (Aem + Bem);
dStream_hit  = Ahit ./ (Ahit + Bhit);
dStream_miss = Amiss ./ (Amiss + Bmiss); 

I = dStream_hit ./ dStream_miss;

size_reshape = [size(I,1)*size(I,2) size(I,3)];
dStream_hit  = reshape(dStream_hit,size_reshape);
dStream_miss = reshape(dStream_miss,size_reshape);

% if strcmp(BorS,'Behav')
%     d_reshape = reshape(dBehav,size_reshape);
%     y_label = 'BMI';
% elseif strcmp(BorS,'Stim')
%     d_reshape = reshape(dStim,size_reshape);
% %     y_label = 'log(SMI)';
%     y_label = 'log(FSI)';
% end


% % y = nanmedian(d_reshape,1);
% y = nanmean(dStream_hit,1);
% n = sum(~isnan(dStream_hit),1);
% err  = nanstd(dStream_hit,0,1);
% err2 = err ./ sqrt(n); % standard error
% 
% x = 1:size(y,2);
% % jitter = [-0.01; 0.01] * ones(1,size(y,2));
% % x = x + jitter;
% h = errorbar(x'+jitter,y',err2','LineWidth',2.0);

h = plot_errorbar(dStream_miss,jitter); hold on % blue
h = plot_errorbar(dStream_hit,-jitter); % red



% set(h(1),'Marker','o','Color','b','LineWidth',1.5); % easy vs hard
% set(h(2),'Marker','o','Color','r','LineWidth',1.5); % hit vs miss
% set(h(3),'Marker','o','Color','r','LineWidth',1.5);
% set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
tpos = {'1st','2nd','3rd','T-1','T'};
set(gca,'xLim',[0.5 length(tpos)+0.5],'xTickLabel',tpos);
xlabel('Triplet Position');
% ylabel(y_label);
box off;

end

function h = plot_errorbar(dStream,jitter)
% y = nanmedian(d_reshape,1);
y = nanmean(dStream,1);
n = sum(~isnan(dStream),1);
err  = nanstd(dStream,0,1);
err2 = err ./ sqrt(n); % standard error

x = 1:size(y,2);
% jitter = [-0.01; 0.01] * ones(1,size(y,2));
% x = x + jitter;
h = errorbar(x'+jitter,y',err2','LineWidth',2.0);
end