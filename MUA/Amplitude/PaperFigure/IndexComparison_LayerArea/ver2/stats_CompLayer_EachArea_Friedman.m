function [ p_friedman ] = stats_CompLayer_EachArea_Friedman( index )
%stats_SessionSummary Summary of this function goes here
%   perform two-way repeated measures ANOVA comparing layers
%   If significant interaction,further perform comparison between areas at 
%   each triplet position.

% add path for dunn.m
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');

alpha = 0.05; % significance level


d_sup_core = index.sup.core;
d_sup_belt = index.sup.belt;
d_deep_core = index.deep.core;
d_deep_belt = index.deep.belt;


% concatenate data...
n_sup_core = size(d_sup_core,1); % number of samples in superficial layer of core
n_sup_belt = size(d_sup_belt,1); % number of samples in superficial layer of belt
n_deep_core = size(d_deep_core,1); % number of samples in deep layer of core
n_deep_belt = size(d_deep_belt,1); % number of samples in deep layer of belt
n_tpos = size(d_sup_core,2);
% N = max(n_core,n_belt);

% reshape matrix for Friedman test...
% X = [d_sup_core; d_sup_belt; d_deep_core; d_deep_belt];
X_core = [d_sup_core; d_deep_core];
X_belt = [d_sup_belt; d_deep_belt];


sc_string = zeros(n_sup_core,n_tpos); % matrix of 0
sb_string = zeros(n_sup_belt,n_tpos); % matrix of 1
dc_string = ones(n_deep_core,n_tpos); % matrix of 2
db_string = ones(n_deep_belt,n_tpos); % matrix of 3
% Layer = [sc_string; sb_string; dc_string; db_string];
Layer_core = [sc_string; dc_string];
Layer_belt = [sb_string; db_string];
% Tpos = repmat(1:n_tpos, size(X,1), 1);
Tpos_core = repmat(1:n_tpos, size(X_core,1), 1);
Tpos_belt = repmat(1:n_tpos, size(X_belt,1), 1);

% Friedman test
% [p_layer,tbl_layer,stats_layer] = mrFriedman2(X(:),{Layer(:) Tpos(:)});
% [p_tpos,tbl_tpos,stats_tpos] = mrFriedman2(X(:),{Tpos(:) Layer(:)});
[p_layer_core,tbl_layer_core,stats_layer_core] = mrFriedman2(X_core(:),{Layer_core(:) Tpos_core(:)});
[p_tpos_core,tbl_tpos_core,stats_tpos_core] = mrFriedman2(X_core(:),{Tpos_core(:) Layer_core(:)});
[p_layer_belt,tbl_layer_belt,stats_layer_belt] = mrFriedman2(X_belt(:),{Layer_belt(:) Tpos_belt(:)});
[p_tpos_belt,tbl_tpos_belt,stats_tpos_belt] = mrFriedman2(X_belt(:),{Tpos_belt(:) Layer_belt(:)});

% p_friedman(1,:) = p_layer;
% p_friedman(2,:) = p_tpos;
p_friedman.core(1,:) = p_layer_core;
p_friedman.core(2,:) = p_tpos_core;
p_friedman.belt(1,:) = p_layer_belt;
p_friedman.belt(2,:) = p_tpos_belt;


if p_layer_core < alpha
    % Dunn's test for post-hoc comparison
    XX = X_core';
    LL = Layer_core';
    x = transpose(XX(:));
    g = transpose(LL(:)) + 1;
    dunn(x,g);
else
    disp('Becasue p_layer > 0.05, Dunn test has not been performed...');
end

if p_layer_belt < alpha
    % Dunn's test for post-hoc comparison
    XX = X_belt';
    LL = Layer_belt';
    x = transpose(XX(:));
    g = transpose(LL(:)) + 1;
    dunn(x,g);
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