function [ p, pp_core, pp_belt ] = stats_CompLayer_KWtest( index )
%stats_CompLayerBargraph_KWtest Summary of this function goes here
%   perform Kruskal-Wallis test
%   If significant interaction,further perform comparison between areas at 
%   each triplet position.

% add path for dunn.m
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');

alpha = 0.05; % significance level


d_sup_core = index.sup.core;
d_sup_belt = index.sup.belt;
d_gran_core = index.gran.core;
d_gran_belt = index.gran.belt;
d_deep_core = index.deep.core;
d_deep_belt = index.deep.belt;


% concatenate data...
n_sup_core = size(d_sup_core,1); % number of samples in superficial layer of core
n_sup_belt = size(d_sup_belt,1); % number of samples in superficial layer of belt
n_gran_core = size(d_gran_core,1);
n_gran_belt = size(d_gran_belt,1);
n_deep_core = size(d_deep_core,1); % number of samples in deep layer of core
n_deep_belt = size(d_deep_belt,1); % number of samples in deep layer of belt
n_tpos = size(d_sup_core,2);
% N = max(n_core,n_belt);

% reshape matrix...
X_core = [d_sup_core; d_gran_core; d_deep_core];
X_belt = [d_sup_belt; d_gran_belt; d_deep_belt];


% s_string = repmat('S',n_sup,n_tpos);
% d_string = repmat('D',n_deep,n_tpos);
sc_layer = zeros(n_sup_core,n_tpos); % matrix of 0 -- sCORE
sb_layer = zeros(n_sup_belt,n_tpos); % matrix of 0 -- sBELT
gc_layer = ones(n_gran_core,n_tpos); % matrix of 1 -- gCORE
gb_layer = ones(n_gran_belt,n_tpos); % matrix of 1 -- gBELT
dc_layer = ones(n_deep_core,n_tpos)*2; % matrix of 2 -- dCORE
db_layer = ones(n_deep_belt,n_tpos)*2; % matrix of 2 -- dBELT
% Layer = [sc_layer; sb_layer; gc_layer; gb_layer; dc_layer; db_layer];
Layer_core = [sc_layer; gc_layer; dc_layer];
Layer_belt = [sb_layer; gb_layer; db_layer];

% Kruskall-Wallis test
[p_core,tbl_core,stats_core] = kruskalwallis(X_core,Layer_core,'off');
[p_belt,tbl_belt,stats_belt] = kruskalwallis(X_belt,Layer_belt,'off');

p(1,:) = p_core;
p(2,:) = p_belt;

% Dunn's test for post-hoc comparison (laminar comparison)
% 1 -- supragranular layer
% 2 -- granular layer
% 3 -- infragranular layer

% core
if p_core < alpha 
    pp_core = multcompare(stats_core,'CType','dunn-sidak','Display','off')
    pp_core = pp_core(:,end);
else
    disp('Becasue p_layer > 0.05, Dunn test has not been performed in core...');
    pp_core = NaN(3,1);
end

% belt
if p_belt < alpha 
    pp_belt = multcompare(stats_belt,'CType','dunn-sidak','Display','off')
    pp_belt = pp_belt(:,end);
else
    disp('Becasue p_layer > 0.05, Dunn test has not been performed in belt...');
    pp_belt = NaN(3,1);
end

