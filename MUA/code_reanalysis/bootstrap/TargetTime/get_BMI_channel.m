function [BMI] = get_BMI_channel(rTarget,area_index,AP_index)
%UNTITLED12 Summary of this function goes here
%   obtain bootstrapped BMI of Target response as a function of target time
%   SMI cannot be defined because dF are collapsed

% nBoot = 20; % ~10 min for 500 reps
r_all  = rTarget; %rALL.A;
r_core = r_all(:,:,area_index==1,:);
r_belt = r_all(:,:,area_index==0,:);
r_post = r_all(:,:,AP_index==1,:);
r_ant  = r_all(:,:,AP_index==0,:);

% bmi = get_BootBMI(r_all,nBoot);
bmi_c = calc_BMI(r_core); % core
bmi_b = calc_BMI(r_belt); % belt
bmi_p = calc_BMI(r_post); % posterior
bmi_a = calc_BMI(r_ant);  % anterior

% re-organize data
% BMI.boot = bmi.boot;
BMI.core = bmi_c;
BMI.belt = bmi_b;
BMI.post = bmi_p;
BMI.ant  = bmi_a;

end



function [bmi] = calc_BMI(rALL)
n_tpos = size(rALL,4); % number of triplet positions
for i_tpos = 1:n_tpos
rALL_tpos = rALL(:,:,:,i_tpos);

Rh = squeeze(rALL_tpos(:,1,:)); % hit
Rm = squeeze(rALL_tpos(:,2,:)); % miss
% Rmat = [Rh(~isnan(Rh)) Rm(~isnan(Rm))]; % doesn't work...
Rmat = [Rh(:) Rm(:)];

% % remove trial when data in either hit or miss trial are missing...
% iValidTrial = ~isnan(Rh(:)+Rm(:));
% Rmat = Rmat(iValidTrial==1,:);

% bmi_ori(1,i_tpos) = calc_bmi_ch(Rmat);
bmi(:,i_tpos) = Rmat(:,1) - Rmat(:,2);

end

end

