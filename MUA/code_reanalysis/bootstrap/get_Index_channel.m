function [smi,bmi] = get_Index_channel(rALL)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% rALL_A  = rALL.A;
% rALL_B1 = rALL.B1;
% rALL_B2 = rALL.B2;

n_tpos = size(rALL,5); % number of triplet positions
for i_tpos = 1:n_tpos
rALL_tpos = rALL(:,:,:,:,i_tpos);

Rhh = squeeze(rALL_tpos(:,1,1,:)); % hard-hit
Reh = squeeze(rALL_tpos(:,2,1,:)); % easy-hit
Rhm = squeeze(rALL_tpos(:,1,2,:)); % hard-miss
Rem = squeeze(rALL_tpos(:,2,2,:)); % easy_miss
Rmat = [Rhh(~isnan(Rhh)) Reh(~isnan(Reh)) Rhm(~isnan(Rhm)) Rem(~isnan(Rem))];

[smi(:,i_tpos),bmi(:,i_tpos)] = calc_Index_channel(Rmat);
% [smi_ori(1,i_tpos),bmi_ori(1,i_tpos)] = calc_Index(Rmat);
% for n=1:nBoot
% %     Rmat_resample = resample_Rmat_v0(Rmat);
%     Rmat_resample = resample_Rmat(Rmat);
%     [smi_boot(n,i_tpos),bmi_boot(n,i_tpos)] = calc_Index(Rmat_resample);
% end

end

% smi.original = smi_ori;
% bmi.original = bmi_ori;
% smi.boot     = smi_boot;
% bmi.boot     = bmi_boot;

% Rvec = Rmat(:);
% n_sample = size(Rmat,1);
% n_condition = size(Rmat,2);
% n_all = length(Rvec);
% for n=1:nBoot
% % resample data
% for i=1:n_condition
%     r_temp = Rvec(randsample(n_all,n_sample,'true'));
%     Rmat_resample(:,i) = r_temp;
%     clear r_remp;
% end
% 
% [smi(n,1),bmi(n,1)] = calc_Index(Rmat_resample);
% clear Rmat_resample
% end

end
