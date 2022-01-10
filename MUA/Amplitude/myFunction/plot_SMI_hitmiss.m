function [ rSMI_h, rSMI_m ] = plot_SMI_hitmiss( sigRESP_area )
%UNTITLED2 Summary of this function goes here
%   sigRESP_area must be a matrix of channel x easy-hard x hit-miss x session x tpos

% Reh = squeeze(mean(sigRESP_area,3)); % easy-hard 
% Rhm = squeeze(mean(sigRESP_area,2)); % hit-miss

Rhh = squeeze(sigRESP_area(:,1,1,:,:)); % hard-hit
Reh = squeeze(sigRESP_area(:,2,1,:,:)); % easy-hit
Rhm  = squeeze(sigRESP_area(:,1,2,:,:)); % hard-miss
Rem = squeeze(sigRESP_area(:,2,2,:,:)); % easy_miss


% stimulus modulation index
SMI_h = abs( Rhh - Reh ); % hit trial
SMI_m = abs( Rhm - Rem ); % miss trial
% SMI_h = abs( Rhh - Reh ) ./ ( abs(Rhh) + abs(Reh) ); % hit trial
% SMI_m = abs( Rhm - Rem ) ./ ( abs(Rhm) + abs(Rem) ); % miss trial



size_reshape = [size(SMI_h,1)*size(SMI_h,2) size(SMI_h,3)];
% reshape matrix
rSMI_h = reshape(SMI_h,size_reshape);
rSMI_m = reshape(SMI_m,size_reshape);
y_label = 'SMI'; %'dStimulus';



% y = nanmedian(d_reshape,1);
n = sum(~isnan(rSMI_h),1); % number of active channels
y_h = nanmean(rSMI_h,1);
err_h  = nanstd(rSMI_h,0,1);
err2_h = err_h ./ sqrt(n); % standard error

y_m = nanmean(rSMI_m,1);
err_m  = nanstd(rSMI_m,0,1);
err2_m = err_m ./ sqrt(n); % standard error

x = 1:size(y_h,2);
% jitter = [-0.01; 0.01] * ones(1,size(y,2));
% x = x + jitter;

h = errorbar(x'+0.05,y_h',err2_h','LineWidth',1.5,'Color',[1 0 0]); hold on
errorbar(x'-0.05,y_m',err2_m','LineWidth',1.5,'Color',[0 0 1]);
% set(h(1),'Marker','o','Color','b','LineWidth',1.5); % easy vs hard
% set(h(2),'Marker','o','Color','r','LineWidth',1.5); % hit vs miss
% set(h(3),'Marker','o','Color','r','LineWidth',1.5);
% set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
set(gca,'xLim',[0.5 length(x)+0.5],'xTickLabel',{'1st','2nd','3rd','Tm1','T'});
xlabel('Triplet Position');
ylabel(y_label);
box off;

end

