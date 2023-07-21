function [SMI,BMI] = get_SMIBMI(rALL_ABB,area_index,AP_index,nBoot)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

% nBoot = 20; % ~10 min for 500 reps
r_all  = rALL_ABB; %rALL.A;
r_core = r_all(:,:,:,area_index==1,:);
r_belt = r_all(:,:,:,area_index==0,:);
r_post = r_all(:,:,:,AP_index==1,:);
r_ant  = r_all(:,:,:,AP_index==0,:);

[smi,bmi] = get_BootIndex(r_all,nBoot);
[smi_c,bmi_c] = get_BootIndex(r_core,1); % core
[smi_b,bmi_b] = get_BootIndex(r_belt,1); % belt
[smi_p,bmi_p] = get_BootIndex(r_post,1); % posterior
[smi_a,bmi_a] = get_BootIndex(r_ant,1);  % anterior

% re-organize data
SMI.boot = smi.boot;
SMI.core = smi_c.original;
SMI.belt = smi_b.original;
SMI.post = smi_p.original;
SMI.ant  = smi_a.original;
BMI.boot = bmi.boot;
BMI.core = bmi_c.original;
BMI.belt = bmi_b.original;
BMI.post = bmi_p.original;
BMI.ant  = bmi_a.original;

end