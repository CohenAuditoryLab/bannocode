function [ p, pp, chisq, z ] = stats_CompLayer_KWtest( index )
%stats_CompLayer_KWtest Summary of this function goes here
%   perform Kruskal-Wallis test for laminar difference
%   If significant interaction,further perform comparison between layers. 
%   code modified from stats_CompLayerBargraph_KWtest.m

% add path for dunn.m
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');

alpha = 0.05; % significance level
% choose how to perform multiple comparison
% 'tukey-kramer', 'dunn-sidak', 'bonferroni' use multcompare function
% 'FDR' performs Wilcoxon ranksum test and adjust p-value by FDR 
CType = 'FDR'; % 'bonferroni';


d_sup = index.s;
d_gran = index.g;
d_deep = index.i;


% concatenate data...
n_sup = size(d_sup,1); % number of samples in superficial layer of core
n_gran = size(d_gran,1);
n_deep = size(d_deep,1); % number of samples in deep layer of core
n_tpos = size(d_sup,2);


% reshape matrix...
X_core = [d_sup; d_gran; d_deep];


s_layer = zeros(n_sup,n_tpos); % matrix of 0 -- sCORE
g_layer = ones(n_gran,n_tpos); % matrix of 1 -- gCORE
d_layer = ones(n_deep,n_tpos)*2; % matrix of 2 -- dCORE
Layer_core = [s_layer; g_layer; d_layer];

% Kruskall-Wallis test
[p,tbl,stats] = kruskalwallis(X_core,Layer_core,'off');
% p(1,:) = p_core;
chisq = tbl{2,5}; % chi squere value from KW test

% Dunn's test for post-hoc comparison (laminar comparison)
% 1 -- supragranular layer
% 2 -- granular layer
% 3 -- infragranular layer

% core
if p < alpha 
    if strcmp(CType,'FDR')
        % Wilcoxon rank-sum test
        [p_wrs(1,:),~,s(1)] = ranksum(d_sup,d_gran);
        [p_wrs(2,:),~,s(2)] = ranksum(d_sup,d_deep);
        [p_wrs(3,:),~,s(3)] = ranksum(d_gran,d_deep);
        % FDR adjusted
        pp = mafdr(p_wrs,'BHFDR',true);
        for ii=1:3
            z(ii,:) = s(ii).zval; % z-value from rank-sum test
        end
    else
        % tk method is recommended for multiple comp after kruskal wallis test
        pp = multcompare(stats,'CType','tukey-kramer','Display','on');
%         pp = multcompare(stats_core,'CType','dunn-sidak','Display','off');
        pp = pp(:,end);
    end    
else
%     disp('Becasue p_layer > 0.05, Dunn test has not been performed in core...');
    disp('Becasue p_layer > 0.05, post-hoc test has not been performed...');
    pp = NaN(3,1);
    z  = NaN(3,1);
end


