% statistical comparison of SMI and BMI across layers (comparing index
% time course including granular layer corresponding to Plot_indexLayerArea_emegence_ver2.m)
clear all;

load SMIBMI_LayerArea_emergence.mat

SMI = reshapeSMIBMI(SMI_LayerArea);
BMI = reshapeSMIBMI(BMI_LayerArea);

smi_a  = SMI.A;
smi_b1 = SMI.B1;
smi_b2 = SMI.B2;

bmi_a  = BMI.A;
bmi_b1 = BMI.B1;
bmi_b2 = BMI.B2;

% Friedman test
p_stim(:,1) = stats_CompLayerArea_Friedman_ver2(smi_a);
p_stim(:,2) = stats_CompLayerArea_Friedman_ver2(smi_b1);
p_stim(:,3) = stats_CompLayerArea_Friedman_ver2(smi_b2);

p_behav(:,1) = stats_CompLayerArea_Friedman_ver2(bmi_a);
p_behav(:,2) = stats_CompLayerArea_Friedman_ver2(bmi_b1);
p_behav(:,3) = stats_CompLayerArea_Friedman_ver2(bmi_b2);