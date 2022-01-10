function [ p_friedman ] = stats_CompLayerAreaBargraph_Friedman_ver2( index )
%stats_SessionSummary Summary of this function goes here
%   perform two-way repeated measures ANOVA
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

sc_area = zeros(n_sup_core,n_tpos); % matrix of 0 -- sCORE
sb_area = ones(n_sup_belt,n_tpos); % matrix of 1 -- sBELT
gc_area = zeros(n_gran_core,n_tpos); % matrix of 0 -- gCORE
gb_area = ones(n_gran_belt,n_tpos); % matrix of 1 -- gBELT
dc_area = zeros(n_deep_core,n_tpos); % matrix of 0 -- dCORE
db_area = ones(n_deep_belt,n_tpos); % matrix of 1 -- dBELT
Area = [sc_area; sb_area; gc_area; gb_area; dc_area; db_area];

% Friedman test
[p_layer,tbl_layer,stats_layer] = mrFriedman3(X(:),{Layer(:) Area(:)});
[p_area,tbl_area,stats_area] = mrFriedman3(X(:),{Area(:) Layer(:)});

p_friedman(1,:) = p_layer;
p_friedman(2,:) = p_area;

if p_layer < alpha
    % Dunn's test for post-hoc comparison
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

% 1 -- superficial layer core
% 2 -- superficial layer belt
% 3 -- deep layer core
% 4 -- deep layer belt




% Layer = [s_string; d_string];
% Y = [d_sup; d_deep];

% Tpos = transpose(1:n_tpos);
% 
% % Create a table storing the respones 
% varNames = {'Layer','t1','t2','t3','t4','t5'};
% t = table(Layer,Y(:,1),Y(:,2),Y(:,3),Y(:,4),Y(:,5), ...
%     'VariableNames',varNames);
% 
% % fit the repeated measures model
% rm = fitrm(t,'t1-t5~Layer','WithinDesign',Tpos);
% 
% % perform repeated measures analysis of variance
% tbl_tpos = ranova(rm)
% p_tpos = tbl_tpos.pValueGG(1:2);
% 
% % compare areas
% tbl_layer = multcompare(rm,'Layer')
% p_layer = tbl_layer.pValue(1);
% 
% % concatenate p-values [area; tpos; interaction]
% p_anova = cat(1,double(p_layer),double(p_tpos));
% % pval.anova = p_anova;
% 
% if p_anova(3) < alpha % if significant interaction...
%     tbl_m = multcompare(rm,'Layer','By','Time');
%     p_posthoc = tbl_m.pValue(1:2:end);
% %     pval.posthoc = p_posthoc;
% else
%     p_posthoc = NaN(n_tpos,1);
% %     pval.posthoc = p_posthoc;
% end

end