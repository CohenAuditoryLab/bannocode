function [ p_anova, p_factor, p ] = display_IndexSummary(index_core, index_belt, tpos)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% fName_core = 'ModulationIndex_Core';
% fName_belt = 'ModulationIndex_Belt';
% if strcmp(version,'v2')
%     DATA_PATH = fullfile(DATA_PATH,'v2');
%     fName_core = strcat(fName_core,'_v2');
%     fName_belt = strcat(fName_belt,'_v2');
% end
    
ver_name = inputname(1);
if contains(ver_name,'SMI')
    y_label = 'SMI';
elseif contains(ver_name,'BMI')
    y_label = 'BMI';
end

% load CORE data
% load(fullfile(DATA_PATH,fName_core));
idx_A.core_sup = index_core.A.sup;
idx_A.core_deep = index_core.A.deep;
idx_B1.core_sup = index_core.B1.sup;
idx_B1.core_deep = index_core.B1.deep;
idx_B2.core_sup = index_core.B2.sup;
idx_B2.core_deep = index_core.B2.deep;

% Stim_A.core_sup = dStim.A.sup;
% Stim_A.core_deep = dStim.A.deep;
% Stim_B1.core_sup = dStim.B1.sup;
% Stim_B1.core_deep = dStim.B1.deep;
% Stim_B2.core_sup = dStim.B2.sup;
% Stim_B2.core_deep = dStim.B2.deep;
% clear dBehav dStim

% load BELT data
% load(fullfile(DATA_PATH,fName_belt));
idx_A.belt_sup = index_belt.A.sup;
idx_A.belt_deep = index_belt.A.deep;
idx_B1.belt_sup = index_belt.B1.sup;
idx_B1.belt_deep = index_belt.B1.deep;
idx_B2.belt_sup = index_belt.B2.sup;
idx_B2.belt_deep = index_belt.B2.deep;

% Stim_A.belt_sup = dStim.A.sup;
% Stim_A.belt_deep = dStim.A.deep;
% Stim_B1.belt_sup = dStim.B1.sup;
% Stim_B1.belt_deep = dStim.B1.deep;
% Stim_B2.belt_sup = dStim.B2.sup;
% Stim_B2.belt_deep = dStim.B2.deep;
% clear dBehav dStim

% plot
H(1) = figure;
subplot(2,2,1);
bargraph_DepthArea(idx_A,tpos);
ylabel(y_label);
title('A');

subplot(2,2,3);
bargraph_DepthArea(idx_B1,tpos);
ylabel(y_label);
title('B1');

subplot(2,2,4);
bargraph_DepthArea(idx_B2,tpos);
ylabel(y_label);
title('B2');

legend({'superficial','deep'},'Location',[0.52 0.82 0.1 0.1]);

% statistical analysis
[p_anova(:,1),p_factor(:,1),p(:,1)] = stats_DepthArea_v2(idx_A,tpos);
[p_anova(:,2),p_factor(:,2),p(:,2)] = stats_DepthArea_v2(idx_B1,tpos);
[p_anova(:,3),p_factor(:,3),p(:,3)] = stats_DepthArea_v2(idx_B2,tpos);

end

