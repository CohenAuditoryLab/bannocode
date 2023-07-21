function [bmi] = get_BootBMI(rALL,nBoot)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

n_tpos = size(rALL,4); % number of triplet positions
for i_tpos = 1:n_tpos
rALL_tpos = rALL(:,:,:,i_tpos);

Rh = squeeze(rALL_tpos(:,1,:)); % hit
Rm = squeeze(rALL_tpos(:,2,:)); % miss
% Rmat = [Rh(~isnan(Rh)) Rm(~isnan(Rm))]; % doesn't work...
Rmat = [Rh(:) Rm(:)];
% remove trial when data in either hit or miss trial are missing...
iValidTrial = ~isnan(Rh(:)+Rm(:));
Rmat = Rmat(iValidTrial==1,:);

% [smi_ori(1,i_tpos),bmi_ori(1,i_tpos)] = calc_Index(Rmat);
bmi_ori(1,i_tpos) = calc_bmi(Rmat);
for n=1:nBoot
%     Rmat_resample = resample_Rmat_v0(Rmat);
    Rmat_resample = resample_Rmat(Rmat);
%     [smi_boot(n,i_tpos),bmi_boot(n,i_tpos)] = calc_Index(Rmat_resample);
    bmi_boot(n,i_tpos) = calc_bmi(Rmat_resample);
end

end

% smi.original = smi_ori;
% smi.boot     = smi_boot;
bmi.original = bmi_ori;
bmi.boot     = bmi_boot;

end


function [bmi] = calc_bmi(Rmatrix)
Rh = Rmatrix(:,1);
Rm = Rmatrix(:,2);

% stimulus and behavioral modulation index (withoug normalization)
% bmi =  ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme
bmi =  Rh - Rm; % modulation by behavioral outocme

% mean
bmi = mean(bmi,1);
end
