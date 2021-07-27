function [ output_args ] = plot_sigMUA_ttime( list_tt, sigRESP_area )
%UNTITLED2 Summary of this function goes here
%   sigRESP_area should be a 4-dimensional matrix of channel x ttime x
%   hit-miss x session

hit = sigRESP_area(:,:,1,:); % hit trials
miss = sigRESP_area(:,:,2,:); % miss trials
% reorganize matrix (channel x hit-miss x session x ttime)
hit = permute(hit,[1 3 4 2]);
miss = permute(miss,[1 3 4 2]);

size_reshape = [size(hit,1)*size(hit,3) size(hit,4)];
hit = reshape(hit,size_reshape);
miss = reshape(miss,size_reshape);

y = [ nanmean(hit,1); nanmean(miss,1) ]; % mean
n = [ sum(~isnan(hit),1); sum(~isnan(miss),1) ];
err  = [ nanstd(hit,0,1); nanstd(miss,0,1) ]; % standard deviation
err2 = err ./ sqrt(n); % standard error

x = ones(2,1) * (1:size(y,2));
jitter = [-0.01; 0.01] * ones(1,size(y,2));
x = x + jitter;

h = errorbar(x',y',err2');
set(h(1),'Marker','o','Color','r','LineWidth',1.5);
set(h(2),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
% set(h(3),'Marker','o','Color','r','LineWidth',1.5);
% set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);
set(gca,'xLim',[0 length(list_tt)+1],'xTick',1:length(list_tt),'xTickLabel',list_tt);
if list_tt(1)==1
    xlabel('Target Position');
else
    xlabel('Target Time [ms]');
end
ylabel('MUA Response [z-score]');
box off;

end

