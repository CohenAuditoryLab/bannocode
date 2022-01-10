function [ p, tbl ] = stats_CompLayerAreaBargraph_SRHtest( index )
%stats_CompLayerAreaBargraph_SRHtest Summary of this function goes here
%   perform Scheirer-Ray-Hare test (non-parametric two-way ANOVA)
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

% reshape matrix for Friedman test...
% X = [d_sup_core; d_sup_belt; d_deep_core; d_deep_belt];
X = [d_sup_core; d_sup_belt; d_gran_core; d_gran_belt; d_deep_core; d_deep_belt];
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
% Layer = [sc_string; sb_string; dc_string; db_string];
Layer = [sc_layer; sb_layer; gc_layer; gb_layer; dc_layer; db_layer];
Layer_core = [sc_layer; gc_layer; dc_layer];
Layer_belt = [sb_layer; gb_layer; db_layer];

% layer assignment version 2
sc_layer = zeros(n_sup_core,n_tpos); % matrix of 0 -- sCORE
sb_layer = ones(n_sup_belt,n_tpos); % matrix of 1 -- sBELT
gc_layer = ones(n_gran_core,n_tpos)*2; % matrix of 2 -- gCORE
gb_layer = ones(n_gran_belt,n_tpos)*3; % matrix of 3 -- gBELT
dc_layer = ones(n_deep_core,n_tpos)*4; % matrix of 4 -- dCORE
db_layer = ones(n_deep_belt,n_tpos)*5; % matrix of 5 -- dBELT
% Layer = [sc_string; sb_string; dc_string; db_string];
Layer2 = [sc_layer; sb_layer; gc_layer; gb_layer; dc_layer; db_layer];

sc_area = zeros(n_sup_core,n_tpos); % matrix of 0 -- sCORE
sb_area = ones(n_sup_belt,n_tpos); % matrix of 1 -- sBELT
gc_area = zeros(n_gran_core,n_tpos); % matrix of 0 -- gCORE
gb_area = ones(n_gran_belt,n_tpos); % matrix of 1 -- gBELT
dc_area = zeros(n_deep_core,n_tpos); % matrix of 0 -- dCORE
db_area = ones(n_deep_belt,n_tpos); % matrix of 1 -- dBELT
Area = [sc_area; sb_area; gc_area; gb_area; dc_area; db_area];



% % Friedman test
% [p_layer,tbl_layer,stats_layer] = mrFriedman3(X(:),{Layer(:) Area(:)});
% [p_area,tbl_area,stats_area] = mrFriedman3(X(:),{Area(:) Layer(:)});
% p_friedman(1,:) = p_layer;
% p_friedman(2,:) = p_area;

% Scheirer-Ray-Hare test
Data = [X(:) Layer(:) Area(:)];
[p,tbl] = SRH_test(Data,'Layer','Area');
p(end) = []; % remove NaN (p-value corresponding to residuals never calculated)

% Dunn's test for post-hoc comparison (laminar comparison)
% 1 -- supragranular layer
% 2 -- granular layer
% 3 -- infragranular layer
if p(1) < alpha % p(1) -- p-value for layer
    XX = X';
    LL = Layer';
    x = transpose(XX(:));
    g = transpose(LL(:)) + 1;
    dunn(x,g);

    % core
    XX_core = X_core';
    LL_core = Layer_core';
    x_core = transpose(XX_core(:));
    g_core = transpose(LL_core(:)) + 1;
    dunn(x_core,g_core);

    % belt
    XX_belt = X_belt';
    LL_belt = Layer_belt';
    x_belt = transpose(XX_belt(:));
    g_belt = transpose(LL_belt(:)) + 1;
    dunn(x_belt,g_belt);
else
    disp('Becasue p_layer > 0.05, Dunn test has not been performed...');
end

% Dunn's test for post-hoc comparison (comparison of layer/area)
% 1 -- supragranular layer core
% 2 -- supragranular layer belt
% 3 -- granular layer core
% 4 -- granular layer belt
% 5 -- infragranular layer core
% 6 -- infragranular layer belt
if p(3) < alpha % p(3) -- p-value for interaction
    XX2 = X';
    LL2 = Layer2';
    x = transpose(XX2(:));
    g = transpose(LL2(:)) + 1;
    dunn(x,g);
else
    disp('interaction is not significant');
end


end