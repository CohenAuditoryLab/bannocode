function [ d_reshape ] = plot_index_tpos_v2( sigRESP_layer, BorS )
%UNTITLED2 Summary of this function goes here
%   sigRESP_area must be a matrix of channel x easy-hard x hit-miss x session x tpos

% Reh = squeeze(mean(sigRESP_area,3)); % easy-hard 
% Rhm = squeeze(mean(sigRESP_area,2)); % hit-miss

Rhh = squeeze(sigRESP_layer(:,1,1,:,:)); % hard-hit
Reh = squeeze(sigRESP_layer(:,2,1,:,:)); % easy-hit
Rhm  = squeeze(sigRESP_layer(:,1,2,:,:)); % hard-miss
Rem = squeeze(sigRESP_layer(:,2,2,:,:)); % easy_miss
R_normalization = abs(Rhh) + abs(Reh) + abs(Rhm) + abs(Rem);
% % R_normalization = abs( Rhh + Reh + Rhm + Rem );

% R_hit  = (Rhh + Reh) / 2;
% R_miss = (Rhm + Rem) / 2;
% R_hard = (Rhh + Rhm) / 2;
% R_easy = (Reh + Rem) / 2;

% original
% dBehav = abs( Rhh - Rhm ) + abs( Reh - Rem ); % modulation by behavioral outocme
dStim = abs( Rhh - Reh ) + abs( Rhm - Rem ); % modulation by stimulus frequency

% modified
dBehav =  Rhh - Rhm + Reh - Rem; % modulation by behavioral outocme
% dStim = Rhh - Reh + Rhm - Rem; % modulation by stimulus frequency

% dBehav = abs( Rhh - Rhm ) + abs( Reh - Rem ) ./ R_normalization; % modulation by behavioral outocme
% dStim = abs( Rhh - Reh) + abs( Rhm - Rem ) ./ R_normalization; % modulation by stimulus frequency
% dBehav = abs( Rhh -Rhm + Reh - Rem );
% dStim = abs( Rhh - Reh + Rhm - Rem );

% % modified on 7/28/21
% dBehav = abs( R_hit - R_miss );
% dStim = abs( R_hard - R_easy );

% dBehav = ( Rhh - Rhm ) + ( Reh - Rem ) ./ R_normalization;
% dStim  = ( Rhh - Reh ) + ( Rhm - Rem ) ./ R_normalization
% dBehav = (abs( Rhh - Rhm ) + abs( Reh - Rem )) ./ R_normalization; 
% dStim = (abs( Rhh - Reh ) + abs( Rhm - Rem )) ./ R_normalization;

I = (dBehav - dStim) ./ (dBehav + dStim);

size_reshape = [size(I,1)*size(I,2) size(I,3)];
if strcmp(BorS,'Behav')
    d_reshape = reshape(dBehav,size_reshape);
    y_label = 'dBehavior';
elseif strcmp(BorS,'Stim')
    d_reshape = reshape(dStim,size_reshape);
    y_label = 'dStimulus';
end


% y = nanmedian(d_reshape,1);
y = nanmean(d_reshape,1);
n = sum(~isnan(d_reshape),1);
err  = nanstd(d_reshape,0,1);
err2 = err ./ sqrt(n); % standard error

x = 1:size(y,2);
% jitter = [-0.01; 0.01] * ones(1,size(y,2));
% x = x + jitter;

h = errorbar(x',y',err2','LineWidth',1.5);
% set(h(1),'Marker','o','Color','b','LineWidth',1.5); % easy vs hard
% set(h(2),'Marker','o','Color','r','LineWidth',1.5); % hit vs miss
% set(h(3),'Marker','o','Color','r','LineWidth',1.5);
% set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
set(gca,'xLim',[0.5 length(x)+0.5],'xTickLabel',{'1st','2nd','3rd','Tm1','T'});
xlabel('Triplet Position');
ylabel(y_label);
box off;

end

