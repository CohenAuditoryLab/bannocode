function [ count_sig, d ] = bargraph_ACFSignificance( chDepth, significance_condition, isPlot )
%UNTITLED5 Summary of this function goes here
%   chDepth [#channels x #sessions]
%   stIndex_condition [#channels x #sessions]

% marker = line_prop.marker;
% color = line_prop.color;
% lin_width = line_prop.linewidth;
% scatter_plot = line_prop.scatter;

nSession = size(significance_condition,2); % number of sessions
d = unique(chDepth);
n_ch = size(chDepth,1);
sig_depth = NaN(length(d),nSession);
for j=1:nSession
    temp_d = chDepth(1,j);
    i_depth = find(d==temp_d);
    i_depth = i_depth:(i_depth+n_ch-1);
    sig_session = significance_condition(:,j); % hard/hit
    sig_depth(i_depth,j) = sig_session;
    clear temp_d i_depth stIndex_session
end
count_sig = nansum(sig_depth,2);
% index_std = nanstd(significance_depth,0,2);
% index_sem = index_std / sqrt(nSession);

if isPlot==1
    bar(d,count_sig);
end

end

