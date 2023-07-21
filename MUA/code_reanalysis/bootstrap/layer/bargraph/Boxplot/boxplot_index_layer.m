function [h] = boxplot_index_layer(index_laminar,selected_triplet)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% display parameter
c =  [0.45, 0.80, 0.69;...
      0.98, 0.40, 0.35;...
      0.55, 0.60, 0.79;...
      0.50, 0.50, 0.50];
% c = [255   0 102; ...
%       255 192   0; ...
%       112  48 160; ...
%       150 150 150] / 255;
condition_names = selected_triplet;
group_names = {'super','middle','deep'};

% initialization
index_mat = []; 
g_layer = [];

% supragranular layer
index_mat = cat(1,index_mat,index_laminar.s);
g_layer = cat(1,g_layer,ones(size(index_laminar.s)) * 1);
% granular layer
index_mat = cat(1,index_mat,index_laminar.g);
g_layer = cat(1,g_layer,ones(size(index_laminar.g)) * 2);
% infragranular layer
index_mat = cat(1,index_mat,index_laminar.i);
g_layer = cat(1,g_layer,ones(size(index_laminar.i)) * 3);
% bootstrapped data
index_mat = cat(1,index_mat,index_laminar.boot);
g_layer = cat(1,g_layer,ones(size(index_laminar.boot)) * 4);

g_tpos = ones(size(g_layer,1),1) * (1:size(g_layer,2));

% boxplot
% boxplot(index_mat(:),{g_tpos(:),g_layer(:)});
% daboxplot(index_mat,'groups',g_layer(:,1));

h = daboxplot(index_mat,'groups',g_layer(:,1),'xtlabels', condition_names,...
    'colors',c,'fill',0,'whiskers',0,'scatter',2,'outsymbol','k*',...
    'outliers',0,'scattersize',16,'flipcolors',1,'boxspacing',1.2,...
    'legend',group_names,'outlierfactor',1.0); 

end