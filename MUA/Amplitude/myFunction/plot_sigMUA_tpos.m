function [ output_args ] = plot_sigMUA_tpos( sigRESP_area )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

hh = sigRESP_area(:,1,1,:,:); % hard-hit
hm = sigRESP_area(:,1,2,:,:); % hard-miss
eh = sigRESP_area(:,2,1,:,:); % easy-hit
em = sigRESP_area(:,2,2,:,:); % eash-miss

size_reshape = [size(hh,1)*size(hh,4) size(hh,5)];
hh = reshape(hh,size_reshape);
hm = reshape(hm,size_reshape);
eh = reshape(eh,size_reshape);
em = reshape(em,size_reshape);

y = [ nanmean(hh,1); nanmean(hm,1); nanmean(eh,1); nanmean(em,1) ];
n = [ sum(~isnan(hh),1); sum(~isnan(hm),1); sum(~isnan(eh),1); sum(~isnan(em),1) ];
err  = [ nanstd(hh,0,1); nanstd(hm,0,1); nanstd(eh,0,1); nanstd(em,0,1) ];
err2 = err ./ sqrt(n); % standard error

x = ones(4,1) * (1:size(y,2));
jitter = [-0.03; -0.01; 0.01; 0.03] * ones(1,size(y,2));
x = x + jitter;

h = errorbar(x',y',err2');
set(h(1),'Marker','^','Color','r','LineWidth',1.5);
set(h(2),'Marker','^','Color','b','LineStyle','--','LineWidth',1.5);
set(h(3),'Marker','o','Color','r','LineWidth',1.5);
set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
xlabel('Triplet Position');
ylabel('MUA Response [z-score]');
box off;

end

