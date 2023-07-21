function [ d_reshape, h ] = plot_logIndex_area_emergenceOnset3( sigRESP_area, jitter, BorS )
%UNTITLED2 Summary of this function goes here
%   sigRESP_area must be a matrix of channel x easy-hard x hit-miss x session x tpos

% Reh = squeeze(mean(sigRESP_area,3)); % easy-hard 
% Rhm = squeeze(mean(sigRESP_area,2)); % hit-miss

Rhh = squeeze(sigRESP_area(:,1,1,:,:)); % hard-hit
Reh = squeeze(sigRESP_area(:,2,1,:,:)); % easy-hit
Rhm  = squeeze(sigRESP_area(:,1,2,:,:)); % hard-miss
Rem = squeeze(sigRESP_area(:,2,2,:,:)); % easy_miss
% R_normalization = abs(Rhh) + abs(Reh) + abs(Rhm) + abs(Rem);
% % R_normalization = abs( Rhh + Reh + Rhm + Rem );

% stimulus and behavioral modulation index (without nomalization)
dStim = abs( Rhh - Reh ) + abs( Rhm - Rem ); % modulation by behavioral outocme
dBehav = ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme

% log transformation to make the distribution normal
dStim = log2(dStim); % only for dStim...

% with normalization
% dStim = abs( Rhh - Reh)./( abs(Rhh) + abs(Reh) ) + abs( Rhm - Rem )./( abs(Rhm) + abs(Rem) ); 
% dBehav = ( Rhh - Rhm )./( abs(Rhh) + abs(Rhm) ) + ( Reh - Rem )./( abs(Reh) + abs(Rem) );


I = (dBehav - dStim) ./ (dBehav + dStim);

size_reshape = [size(I,1)*size(I,2) size(I,3)];
if strcmp(BorS,'Behav')
    d_reshape = reshape(dBehav,size_reshape);
    y_label = 'BMI';
elseif strcmp(BorS,'Stim')
    d_reshape = reshape(dStim,size_reshape);
    y_label = 'log(CI) & log(FSI)';
end



y = nanmean(d_reshape,1);
n = sum(~isnan(d_reshape),1);
err  = nanstd(d_reshape,0,1);
err2 = err ./ sqrt(n); % standard error

if strcmp(BorS,'Behav')
    x = 1:size(y,2);
    % jitter = [-0.01; 0.01] * ones(1,size(y,2));
    % x = x + jitter;

    if length(x)==4
        x_label = {'T-3','T-2','T-1','T'};
    elseif length(x)==5
        x_label = {'Baseline','T-3','T-2','T-1','T'};
    else
        x_label = {'L','H1','H2'};
    end

    h = errorbar(x'+jitter,y',err2','LineWidth',2.0);
    % set(h(1),'Marker','o','Color','b','LineWidth',1.5); % easy vs hard
    % set(h(2),'Marker','o','Color','r','LineWidth',1.5); % hit vs miss
    % set(h(3),'Marker','o','Color','r','LineWidth',1.5);
    % set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
    set(gca,'xLim',[0.5 length(x)+0.5],'xTick',x,'xTickLabel',x_label);
    xlabel('Triplet Position');
    ylabel(y_label);
    box off;
elseif strcmp(BorS,'Stim')
    X = 1:size(y,2);
    xx = reshape(X,3,length(X)/3);
    yy = reshape(y,3,length(y)/3);
    ee = reshape(err2,3,length(err2)/3);

    if size(y,2)==4
        x_label = {'T-3','T-2','T-1','T'};
    elseif size(y,2)==5
        x_label = {'Baseline','T-3','T-2','T-1','T'};
    else
        x_label = {'L','H1','H2'};
    end
    
    mk = {'o','^','s'}; % marker
    ls = {'-','--',':'}; % line style
    for i=1:3
        x = xx(i,:);
        y = yy(i,:);
        err2 = ee(i,:);
        h(i) = errorbar(x'+jitter,y',err2','LineWidth',2.0,'LineStyle',ls{i},'Marker',mk{i}); hold on;
        % set(h(1),'Marker','o','Color','b','LineWidth',1.5); % easy vs hard
        % set(h(2),'Marker','o','Color','r','LineWidth',1.5); % hit vs miss
        % set(h(3),'Marker','o','Color','r','LineWidth',1.5);
        % set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
        set(gca,'xLim',[0.5 length(x)*3+0.5],'xTick',X,'xTickLabel',x_label);
        xlabel('Triplet Position');
        ylabel(y_label);
        box off;
    end

end

end

