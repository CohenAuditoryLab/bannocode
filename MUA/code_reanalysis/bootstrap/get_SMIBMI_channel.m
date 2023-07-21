function [SMI,BMI] = get_SMIBMI_channel(rALL_ABB,area_index,AP_index)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

r_all  = rALL_ABB; %rALL.A;
r_core = r_all(:,:,:,area_index==1,:);
r_belt = r_all(:,:,:,area_index==0,:);
r_post = r_all(:,:,:,AP_index==1,:);
r_ant  = r_all(:,:,:,AP_index==0,:);

% [smi,bmi] = get_BootIndex(r_all,nBoot);
[smi_c,bmi_c] = get_Index_channel(r_core); % core
[smi_b,bmi_b] = get_Index_channel(r_belt); % belt
[smi_p,bmi_p] = get_Index_channel(r_post); % posterior
[smi_a,bmi_a] = get_Index_channel(r_ant);  % anterior

% re-organize data
% SMI.boot = smi.boot;
SMI.core = smi_c;
SMI.belt = smi_b;
SMI.post = smi_p;
SMI.ant  = smi_a;
% BMI.boot = bmi.boot;
BMI.core = bmi_c;
BMI.belt = bmi_b;
BMI.post = bmi_p;
BMI.ant  = bmi_a;

end