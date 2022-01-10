function [ d_reshape, h ] = plot_IndexAverage_area_emergenceOnset_wBL( Index_area, jitter, BorS, c )
%UNTITLED2 Summary of this function goes here
% Incex_area must be a matrix of (#unit) x (tpos)


% % stimulus and behavioral modulation index (without nomalization)
% dStim = abs( Rhh - Reh ) + abs( Rhm - Rem ); % modulation by behavioral outocme
% dBehav = ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme

% % log transformation to make the distribution normal
% dStim = log2(dStim); % only for dStim...

% % separate baseline...
% dStim_bl = dStim(:,:,1);
% dStim(:,:,1) = [];
% dBehav_bl = dBehav(:,:,1);
% dBehav(:,:,1) = [];
Index_bl = Index_area(:,1);
Index_area(:,1) = [];


% I = (dBehav - dStim) ./ (dBehav + dStim);

% size_reshape = [size(I,1)*size(I,2) size(I,3)];
if strcmp(BorS,'Behav')
%     d_reshape = reshape(dBehav,size_reshape);
%     d_reshape_bl = dBehav_bl(:);
    y_label = 'BMI';
elseif strcmp(BorS,'Stim')
%     d_reshape = reshape(dStim,size_reshape);
%     d_reshape_bl = dStim_bl(:);
    y_label = 'log(SMI)';
end



y = nanmean(Index_area,1);
n = sum(~isnan(Index_area),1);
err  = nanstd(Index_area,0,1);
err2 = err ./ sqrt(n); % standard error

% mean and standard error of baselien
y_bl = nanmean(Index_bl,1);
n_bl = sum(~isnan(Index_bl),1);
err_bl  = nanstd(Index_bl,0,1);
err2_bl = err_bl ./ sqrt(n_bl); % standard error

x = 1:size(y,2);
x = x + 1; % shift x position...
% jitter = [-0.01; 0.01] * ones(1,size(y,2));
% x = x + jitter;

% if length(x)==4
%     x_label = {'T-3','T-2','T-1','T'};
% elseif length(x)==5
%     x_label = {'Baseline','T-3','T-2','T-1','T'};
% else
%     x_label = {'L','H1','H2'};
% end
x_label = {'Baseline','T-3','T-2','T-1','T'};

h = errorbar(x'+jitter,y',err2','Color',c,'LineWidth',2.0); hold on;
plot([1 1],[y_bl-err2_bl y_bl+err2_bl],'Color',c,'LineWidth',2.0);
plot(1,y_bl,'.','Color',c,'MarkerSize',12);
% set(h(1),'Marker','o','Color','b','LineWidth',1.5); % easy vs hard
% set(h(2),'Marker','o','Color','r','LineWidth',1.5); % hit vs miss
% set(h(3),'Marker','o','Color','r','LineWidth',1.5);
% set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
set(gca,'xLim',[0.5 length(x)+1+0.5],'xTick',[1 x],'xTickLabel',x_label);
xlabel('Triplet Position');
ylabel(y_label);
box off;

end

