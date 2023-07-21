function [BMI] = get_BMI(rTarget,area_index,AP_index,nBoot)
%UNTITLED12 Summary of this function goes here
%   obtain bootstrapped BMI of Target response as a function of target time
%   SMI cannot be defined because dF are collapsed

% nBoot = 20; % ~10 min for 500 reps
r_all  = rTarget; %rALL.A;
r_core = r_all(:,:,area_index==1,:);
r_belt = r_all(:,:,area_index==0,:);
r_post = r_all(:,:,AP_index==1,:);
r_ant  = r_all(:,:,AP_index==0,:);

bmi = get_BootBMI(r_all,nBoot);
bmi_c = get_BootBMI(r_core,1); % core
bmi_b = get_BootBMI(r_belt,1); % belt
bmi_p = get_BootBMI(r_post,1); % posterior
bmi_a = get_BootBMI(r_ant,1);  % anterior

% re-organize data
% SMI.boot = smi.boot;
% SMI.core = smi_c.original;
% SMI.belt = smi_b.original;
% SMI.post = smi_p.original;
% SMI.ant  = smi_a.original;
BMI.boot = bmi.boot;
BMI.core = bmi_c.original;
BMI.belt = bmi_b.original;
BMI.post = bmi_p.original;
BMI.ant  = bmi_a.original;

end


