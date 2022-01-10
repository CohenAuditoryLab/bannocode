function [ d_reshape, h ] = plot_IndexAverage_area_emergenceOnset( Index_area, jitter, BorS, c )
%UNTITLED2 Summary of this function goes here
% Incex_area must be a matrix of (#unit) x (tpos)


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


x = 1:size(y,2);
x_label = {'T-3','T-2','T-1','T'};

h = errorbar(x'+jitter,y',err2','Color',c,'LineWidth',2.0); hold on;
set(gca,'xLim',[0.5 length(x)+0.5],'xTick',x,'xTickLabel',x_label);
xlabel('Triplet Position');
ylabel(y_label);
box off;

end

