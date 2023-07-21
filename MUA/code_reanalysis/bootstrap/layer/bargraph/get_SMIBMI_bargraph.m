function [SMI_layer,BMI_layer] = get_SMIBMI_bargraph(rALL_ABB,area_index,AP_index,depth_index)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

% nBoot = 20; % ~10 min for 500 reps
r_all  = rALL_ABB; %rALL.A;
r_core = r_all(:,:,:,area_index==1,:);
r_belt = r_all(:,:,:,area_index==0,:);
r_post = r_all(:,:,:,AP_index==1,:);
r_ant  = r_all(:,:,:,AP_index==0,:);

i_core = depth_index(:,area_index==1);
i_belt = depth_index(:,area_index==0);
i_post = depth_index(:,AP_index==1);
i_ant  = depth_index(:,AP_index==0);

% nBoot MUST be zero!!
[smi_core,bmi_core] = get_BootIndex_bargraph(r_core,i_core,0); % core
[smi_belt,bmi_belt] = get_BootIndex_bargraph(r_belt,i_belt,0); % belt
[smi_post,bmi_post] = get_BootIndex_bargraph(r_post,i_post,0); % posterior
[smi_ant,bmi_ant] = get_BootIndex_bargraph(r_ant,i_ant,0);  % anterior

% re-organize data
SMI_layer.core = smi_core.orig;
SMI_layer.belt = smi_belt.orig;
SMI_layer.post = smi_post.orig;
SMI_layer.ant  = smi_ant.orig;
BMI_layer.core = bmi_core.orig;
BMI_layer.belt = bmi_belt.orig;
BMI_layer.post = bmi_post.orig;
BMI_layer.ant  = bmi_ant.orig;

end