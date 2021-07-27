function [ output_args ] = plot_EffectSize_tpos( sigRESP_area )
%UNTITLED2 Summary of this function goes here
%   R_area must be a matrix of channel x cond x session x tpos

Reh = squeeze(mean(sigRESP_area,3)); % easy-hard 
Rhm = squeeze(mean(sigRESP_area,2)); % hit-miss
% ** need to use weighted average! SHOULD MODIFY LATER!!!

Reasy = squeeze(Reh(:,1,:,:));
Rhard = squeeze(Reh(:,2,:,:));
Rhit  = squeeze(Rhm(:,1,:,:));
Rmiss = squeeze(Rhm(:,2,:,:));

% % rectification...
% Reasy(Reasy<0) = 0;
% Rhard(Rhard<0) = 0;
% Rhit(Rhit<0) = 0;
% Rmiss(Rmiss<0) = 0;

% ignore channel/depth...
size_reshape = [size(Reasy,1)*size(Reasy,2) size(Reasy,3)];
Reasy = reshape(Reasy,size_reshape);
Rhard = reshape(Rhard,size_reshape);
Rhit  = reshape(Rhit,size_reshape);
Rmiss = reshape(Rmiss,size_reshape);

% caclulate effect size
for i=1:size(Reasy,2)
    stats = mes(Reasy(:,i),Rhard(:,i),'hedgesg','isDep',1,'confLevel',0.95);
    g_eh(i) = abs(stats.hedgesg);
%     gCi_eh(:,i) = stats.hedgesgCi;
    gCi_eh(i) = mean(abs(stats.hedgesgCi - stats.hedgesg));
    clear stats
    stats = mes(Rhit(:,i),Rmiss(:,i),'hedgesg','isDep',1,'confLevel',0.95);
    g_hm(i) = abs(stats.hedgesg);
%     gCi_hm(:,i) = stats.hedgesgCi;
    gCi_hm(i) = mean(abs(stats.hedgesgCi - stats.hedgesg));
    clear stats
end
% Ieh = (Reasy - Rhard) ./ (Reasy + Rhard);
% Ihm = (Rhit - Rmiss) ./ (Rhit + Rmiss);
% % take the absolute value of the index...
% aIeh = abs(Ieh);
% aIhm = (Ihm);

y = [ g_eh; g_hm ];
% n = [ sum(~isnan(aIeh),1); sum(~isnan(aIhm),1) ];
% err  = [ nanstd(aIeh,0,1); nanstd(aIhm,0,1) ];
err2 = [ gCi_eh; gCi_hm]; % confidence interval

x = ones(2,1) * (1:size(y,2));
jitter = [-0.01; 0.01] * ones(1,size(y,2));
x = x + jitter;

h = errorbar(x',y',err2');
set(h(1),'Marker','o','Color','b','LineWidth',1.5); % easy vs hard
set(h(2),'Marker','o','Color','r','LineWidth',1.5); % hit vs miss
% set(h(3),'Marker','o','Color','r','LineWidth',1.5);
% set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
xlabel('Triplet Position');
ylabel('abs(Hedges g)');
box off;

end

