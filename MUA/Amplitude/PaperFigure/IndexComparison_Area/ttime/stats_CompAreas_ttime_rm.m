function [ p_anova, p_posthoc ] = stats_CompAreas_ttime_rm( d_core, d_belt )
%stats_SessionSummary Summary of this function goes here
%   perform two-way repeated measures ANOVA
%   If significant interaction,further perform comparison between areas at 
%   each triplet position.

alpha = 0.01; % significance level

% remove NaN from data matrix...
d_core = removeNaN_fromMat(d_core);
d_belt = removeNaN_fromMat(d_belt);


% concatenate data...
n_core = size(d_core,1); % number of samples in core
n_belt = size(d_belt,1); % number of samples in belt
n_tpos = size(d_core,2);
% N = max(n_core,n_belt);

c_string = repmat('C',n_core,1);
b_string = repmat('B',n_belt,1);

Area = [c_string; b_string];
Y = [d_core; d_belt];

Tpos = transpose(1:n_tpos);

% Create a table storing the respones 
varNames = {'Area','t1','t2','t3','t4'};
t = table(Area,Y(:,1),Y(:,2),Y(:,3),Y(:,4), ...
    'VariableNames',varNames);

% fit the repeated measures model
rm = fitrm(t,'t1-t4~Area','WithinDesign',Tpos);

% perform repeated measures analysis of variance
tbl_tpos = ranova(rm)
p_tpos = tbl_tpos.pValueGG(1:2);

% compare areas
tbl_area = multcompare(rm,'Area')
p_area = tbl_area.pValue(1);

% % compare target time
% tbl_t = multcompare(rm,'Time')

% concatenate p-values [area; tpos; interaction]
p_anova = cat(1,double(p_area),double(p_tpos));
% pval.anova = p_anova;

if p_anova(3) < alpha % if significant interaction...
    tbl_m = multcompare(rm,'Area','By','Time');
    p_posthoc = tbl_m.pValue(1:2:end);
%     pval.posthoc = p_posthoc;
else
    p_posthoc = NaN(n_tpos,1);
%     pval.posthoc = p_posthoc;
end

end