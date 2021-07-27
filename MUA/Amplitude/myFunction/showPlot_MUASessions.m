function [ H ] = showPlot_MUASessions( RESP, chDepth, j )
%UNTITLED4 Summary of this function goes here
%   RESP shold be a 4-dimensional matrix of channel x easy-hard x hit-miss
%   x sessions

r_hard_hit  = squeeze(RESP(:,1,1,j));
r_hard_miss = squeeze(RESP(:,1,2,j));
r_easy_hit  = squeeze(RESP(:,2,1,j));
r_easy_miss = squeeze(RESP(:,2,2,j));

chDepth = chDepth(:,j);
dRange = unique(chDepth);
x_range = [min(dRange)-100 max(dRange)+100];

% plot...
H = figure('Position',[100 100 800 600]);
prop.lin_width = 2;
prop.scatter = 'on';

subplot(2,2,1);
prop.color = 'b'; prop.marker = 'o'; prop.lin_style = '-';
plot_index(chDepth-20,r_hard_hit,prop); hold on;
prop.color = 'r';
plot_index(chDepth+20,r_easy_hit,prop);
set(gca,'xlim',x_range);
xlabel('Distance from input layer'); ylabel('MUA amplitude [z-score]');
title('Hit Trials (Easy vs Hard)');

subplot(2,2,2);
prop.color = 'b'; prop.marker = 'x'; prop.lin_style = '-';
plot_index(chDepth-20,r_hard_miss,prop); hold on;
prop.color = 'r';
plot_index(chDepth+20,r_easy_miss,prop);
set(gca,'xlim',x_range);
xlabel('Distance from input layer'); ylabel('MUA amplitude [z-score]');
title('Miss Trials (Easy vs Hard)');

subplot(2,2,3);
prop.color = 'b'; prop.marker = 'none'; prop.lin_style = '-';
plot_index(chDepth-20,r_hard_hit,prop); hold on;
prop.color = 'b'; prop.lin_style = '--'; prop.lin_width = 1.5;
plot_index(chDepth+20,r_hard_miss,prop);
set(gca,'xlim',x_range);
xlabel('Distance from input layer'); ylabel('MUA amplitude [z-score]');
title('Hard trials (Hit vs Miss)');

subplot(2,2,4);
prop.color = 'r'; prop.lin_style = '-'; prop.lin_width = 2.0;
plot_index(chDepth-20,r_easy_hit,prop); hold on
prop.color = 'r'; prop.lin_style = '--'; prop.lin_width = 1.5;
plot_index(chDepth+20,r_easy_miss,prop);
set(gca,'xlim',x_range);
xlabel('Distance from input layer'); ylabel('MUA amplitude [z-score]');
title('Easy trials (Hit vs Miss)');
end

