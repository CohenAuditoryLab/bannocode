function [ output_args ] = plot_EffectSize_depth( EffectSize_sup,EffectSize_deep )
%UNTITLED2 Summary of this function goes here
%   R_area must be a matrix of channel x easy-hard x hit-miss x session x
%   deep-sup

mean_sup  = EffectSize_sup.mean; % superficial layer
mean_deep = EffectSize_deep.mean; % deep layer
ci_sup  = EffectSize_sup.ci;
ci_deep = EffectSize_deep.ci;

% y = [ g_eh; g_hm ];
% err2 = [ gCi_eh; gCi_hm]; % confidence interval

y_eh = [ mean_sup(1,:); mean_deep(1,:) ];
err_eh = [ ci_sup(1,:); ci_deep(1,:) ]; % confidence interval
y_hm = [ mean_sup(2,:); mean_deep(2,:) ];
err_hm = [ ci_sup(2,:); ci_deep(2,:) ]; % confidence interval

Y = [y_eh; y_hm];
ERR = [err_eh; err_hm];

% x = ones(2,1) * (1:size(y_eh,2));
% jitter = [-0.01; 0.01] * ones(1,size(y_eh,2));
% x = x + jitter;
x = ones(4,1) * (1:size(Y,2));
jitter = [-0.03; -0.01; 0.01; 0.03] * ones(1,size(Y,2));
x = x + jitter;

% h = errorbar(x',y_eh',err_eh');
h = errorbar(x',Y',ERR');
set(h(1),'Marker','^','Color','c','LineWidth',1.5); % superficial layer
set(h(2),'Marker','^','Color','m','LineWidth',1.5); % deep layer
set(h(3),'Marker','o','Color','c','LineWidth',1.5);
set(h(4),'Marker','o','Color','m','LineWidth',1.5);
xlabel('Triplet Position');
ylabel('abs(Hedges g)');
box off;

end

