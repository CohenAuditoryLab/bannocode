function [smi,bmi] = get_BootIndex_bargraph(rALL,i_depth,nBoot)
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

% choose layer
Rmat_s = [Rhh(i_depth==0) Reh(i_depth==0) Rhm(i_depth==0) Rem(i_depth==0)];
Rmat_g = [Rhh(i_depth==1) Reh(i_depth==1) Rhm(i_depth==1) Rem(i_depth==1)];
Rmat_i = [Rhh(i_depth==2) Reh(i_depth==2) Rhm(i_depth==2) Rem(i_depth==2)];

% Rmat = [Rhh(~isnan(Rhh)) Reh(~isnan(Reh)) Rhm(~isnan(Rhm)) Rem(~isnan(Rem))];
Rmat_s = rmnan(Rmat_s);
Rmat_g = rmnan(Rmat_g);
Rmat_i = rmnan(Rmat_i);

[smi_sup(:,i_tpos),bmi_sup(:,i_tpos)] = calc_Index2(Rmat_s);
[smi_grn(:,i_tpos),bmi_grn(:,i_tpos)] = calc_Index2(Rmat_g);
[smi_inf(:,i_tpos),bmi_inf(:,i_tpos)] = calc_Index2(Rmat_i); 

if nBoot>0
for n=1:nBoot
%     Rmat_resample = resample_Rmat_v0(Rmat);
    Rmat_resample_s = resample_Rmat(Rmat_s);
    Rmat_resample_g = resample_Rmat(Rmat_g);
    Rmat_resample_i = resample_Rmat(Rmat_i);

    [smi_boot_sup(:,i_tpos,n),bmi_boot_sup(:,i_tpos,n)] = calc_Index2(Rmat_resample_s);
    [smi_boot_grn(:,i_tpos,n),bmi_boot_grn(:,i_tpos,n)] = calc_Index2(Rmat_resample_g);
    [smi_boot_inf(:,i_tpos,n),bmi_boot_inf(:,i_tpos,n)] = calc_Index2(Rmat_resample_i);
end
end

end

% smi.original = smi_ori;
% bmi.original = bmi_ori;
% smi.boot     = smi_boot;
% bmi.boot     = bmi_boot;

smi.orig.sup = smi_sup;
smi.orig.grn = smi_grn;
smi.orig.inf = smi_inf;
bmi.orig.sup = bmi_sup;
bmi.orig.grn = bmi_grn;
bmi.orig.inf = bmi_inf;

if nBoot>0
smi.boot.sup = smi_boot_sup;
smi.boot.grn = smi_boot_grn;
smi.boot.inf = smi_boot_inf;
bmi.boot.sup = bmi_boot_sup;
bmi.boot.grn = bmi_boot_grn;
bmi.boot.inf = bmi_boot_inf;
end

end


function [Rmat_nonan] = rmnan(Rmat)
% remove NaN from matrix
index = ~isnan(Rmat(:,1));
Rmat_nonan = Rmat(index==1,:);
end