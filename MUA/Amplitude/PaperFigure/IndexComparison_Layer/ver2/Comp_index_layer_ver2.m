clear all

% path for function (stats_CompLayers.m)...
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\myFunction');
addpath('../');

% load data
% load MUAResponse_Layer.mat; % original layer assignment
load MUAResponse_Layer_ver2;

% Core
BMI_core = display_Index(rCore,'Behav');
SMI_core = display_Index(rCore,'Stim');

% % statistical comparison
% p_core.behav(:,1) = stats_CompLayers(BMI_core.A.s,BMI_core.A.d);
% p_core.behav(:,2) = stats_CompLayers(BMI_core.B1.s,BMI_core.B1.d);
% p_core.behav(:,3) = stats_CompLayers(BMI_core.B2.s,BMI_core.B2.d);
% p_core.stim(:,1)  = stats_CompLayers(SMI_core.A.s,SMI_core.A.d);
% p_core.stim(:,2)  = stats_CompLayers(SMI_core.B1.s,SMI_core.B1.d);
% p_core.stim(:,3)  = stats_CompLayers(SMI_core.B2.s,SMI_core.B2.d);

% % perform repeated measures ANOVA
% [p_core.behav(:,1), pc.b(:,1)] = stats_CompLayers_rm(BMI_core.A.s,BMI_core.A.d);
% [p_core.behav(:,2), pc.b(:,2)] = stats_CompLayers_rm(BMI_core.B1.s,BMI_core.B1.d);
% [p_core.behav(:,3), pc.b(:,3)] = stats_CompLayers_rm(BMI_core.B2.s,BMI_core.B2.d);
% [p_core.stim(:,1), pc.s(:,1)]  = stats_CompLayers_rm(SMI_core.A.s,SMI_core.A.d);
% [p_core.stim(:,2), pc.s(:,2)]  = stats_CompLayers_rm(SMI_core.B1.s,SMI_core.B1.d);
% [p_core.stim(:,3), pc.s(:,3)]  = stats_CompLayers_rm(SMI_core.B2.s,SMI_core.B2.d);

% 11/03/21 modified
% perform Friedman test
[p_core.behav(:,1)] = stats_CompLayers_Friedman(BMI_core.A.s,BMI_core.A.d);
[p_core.behav(:,2)] = stats_CompLayers_Friedman(BMI_core.B1.s,BMI_core.B1.d);
[p_core.behav(:,3)] = stats_CompLayers_Friedman(BMI_core.B2.s,BMI_core.B2.d);
[p_core.stim(:,1)]  = stats_CompLayers_Friedman(SMI_core.A.s,SMI_core.A.d);
[p_core.stim(:,2)]  = stats_CompLayers_Friedman(SMI_core.B1.s,SMI_core.B1.d);
[p_core.stim(:,3)]  = stats_CompLayers_Friedman(SMI_core.B2.s,SMI_core.B2.d);

% Belt
BMI_belt = display_Index(rBelt,'Behav');
SMI_belt = display_Index(rBelt,'Stim');

% % statistical comparison
% p_belt.behav(:,1) = stats_CompLayers(BMI_belt.A.s,BMI_belt.A.d);
% p_belt.behav(:,2) = stats_CompLayers(BMI_belt.B1.s,BMI_belt.B1.d);
% p_belt.behav(:,3) = stats_CompLayers(BMI_belt.B2.s,BMI_belt.B2.d);
% p_belt.stim(:,1)  = stats_CompLayers(SMI_belt.A.s,SMI_belt.A.d);
% p_belt.stim(:,2)  = stats_CompLayers(SMI_belt.B1.s,SMI_belt.B1.d);
% p_belt.stim(:,3)  = stats_CompLayers(SMI_belt.B2.s,SMI_belt.B2.d);

% % perform repeated measures ANOVA
% [p_belt.behav(:,1), pb.b(:,1)] = stats_CompLayers_rm(BMI_belt.A.s,BMI_belt.A.d);
% [p_belt.behav(:,2), pb.b(:,2)] = stats_CompLayers_rm(BMI_belt.B1.s,BMI_belt.B1.d);
% [p_belt.behav(:,3), pb.b(:,3)] = stats_CompLayers_rm(BMI_belt.B2.s,BMI_belt.B2.d);
% [p_belt.stim(:,1), pb.s(:,1)]  = stats_CompLayers_rm(SMI_belt.A.s,SMI_belt.A.d);
% [p_belt.stim(:,2), pb.s(:,2)]  = stats_CompLayers_rm(SMI_belt.B1.s,SMI_belt.B1.d);
% [p_belt.stim(:,3), pb.s(:,3)]  = stats_CompLayers_rm(SMI_belt.B2.s,SMI_belt.B2.d);

% 11/03/21 modified
% perform Friedman test
[p_belt.behav(:,1)] = stats_CompLayers_Friedman(BMI_belt.A.s,BMI_belt.A.d);
[p_belt.behav(:,2)] = stats_CompLayers_Friedman(BMI_belt.B1.s,BMI_belt.B1.d);
[p_belt.behav(:,3)] = stats_CompLayers_Friedman(BMI_belt.B2.s,BMI_belt.B2.d);
[p_belt.stim(:,1)]  = stats_CompLayers_Friedman(SMI_belt.A.s,SMI_belt.A.d);
[p_belt.stim(:,2)]  = stats_CompLayers_Friedman(SMI_belt.B1.s,SMI_belt.B1.d);
[p_belt.stim(:,3)]  = stats_CompLayers_Friedman(SMI_belt.B2.s,SMI_belt.B2.d);
