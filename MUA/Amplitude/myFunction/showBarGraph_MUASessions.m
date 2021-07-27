function [ y_range ] = showBarGraph_MUASessions( sigRESP, chDepth, j  )
%UNTITLED9 Summary of this function goes here
%   sigResp should be 4-dimensional matrix of channel x pos-neg x hit-miss
%   x sessions

isPlot = 0; % do not show bar graph for each condition...

% positively significant MUA response...
sig_pos_hit  = squeeze(sigRESP(:,1,1,j));
sig_pos_miss = squeeze(sigRESP(:,1,2,j));
chDepth = chDepth(:,j);

% count the number of significant channels...
[n_hit_p,d]  = bargraph_ACFSignificance(chDepth,sig_pos_hit,isPlot);
[n_miss_p,~] = bargraph_ACFSignificance(chDepth,sig_pos_miss,isPlot);

% negatively significant MUA response...
sig_neg_hit  = squeeze(sigRESP(:,2,1,j));
sig_neg_miss = squeeze(sigRESP(:,2,2,j));

% count the number of significant channels...
[n_hit_n,~]  = bargraph_ACFSignificance(chDepth,sig_neg_hit,isPlot);
[n_miss_n,~] = bargraph_ACFSignificance(chDepth,sig_neg_miss,isPlot);

h = bar(d,[n_hit_p n_miss_p]); hold on
set(h(1),'FaceColor','red','BarWidth',1);
set(h(2),'FaceColor','blue','BarWidth',1);
h = bar(d,-[n_hit_n n_miss_n]);
set(h(1),'FaceColor','red','BarWidth',1);
set(h(2),'FaceColor','blue','BarWidth',1);
set(gca,'XLim',[min(d)-100 max(d)+100]);

y_range = get(gca,'Ylim');
xlabel('Depth from input layer [um]'); ylabel('# of channels');
box off;

end

