function [  ] = plot_index( chDepth, stIndex_condition, line_prop )
%UNTITLED5 Summary of this function goes here
%   chDepth [#channels x #sessions]
%   stIndex_condition [#channels x #sessions]

% marker = line_prop.marker;
% color = line_prop.color;
% lin_width = line_prop.linewidth;
% scatter_plot = line_prop.scatter;

nSession = size(stIndex_condition,2); % number of sessions
d = unique(chDepth);
n_ch = size(chDepth,1);
stIndex_depth = NaN(length(d),nSession);
for j=1:nSession
    temp_d = chDepth(1,j);
    i_depth = find(d==temp_d);
    i_depth = i_depth:(i_depth+n_ch-1);
    stIndex_session = stIndex_condition(:,j); % hard/hit
    stIndex_depth(i_depth,j) = stIndex_session;
    clear temp_d i_depth stIndex_session
end
index_mean = nanmean(stIndex_depth,2);
index_std = nanstd(stIndex_depth,0,2);
% index_sem = index_std / sqrt(nSession);
if strcmp(line_prop.scatter,'on')
    plot(chDepth,stIndex_condition,'LineStyle','none', ...
        'marker',line_prop.marker,'color',line_prop.color); hold on;
end
errorbar(d,index_mean,index_std,'LineStyle',line_prop.lin_style, ...
    'LineWidth',line_prop.lin_width,'color',line_prop.color);

end

