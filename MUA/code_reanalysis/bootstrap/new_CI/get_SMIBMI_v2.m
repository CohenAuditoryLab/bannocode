function [SMI,BMI] = get_SMIBMI_v2(rALL_ABB,area_index,AP_index,nBoot,toneID)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

% nBoot = 20; % ~10 min for 500 reps
r_all  = rALL_ABB; %rALL.A;
r_core = r_all(:,:,:,area_index==1,:);
r_belt = r_all(:,:,:,area_index==0,:);
r_post = r_all(:,:,:,AP_index==1,:);
r_ant  = r_all(:,:,:,AP_index==0,:);

[smi,bmi] = get_BootIndex(r_all,nBoot,toneID);
[smi_c,bmi_c] = get_BootIndex(r_core,1,toneID); % core
[smi_b,bmi_b] = get_BootIndex(r_belt,1,toneID); % belt
[smi_p,bmi_p] = get_BootIndex(r_post,1,toneID); % posterior
[smi_a,bmi_a] = get_BootIndex(r_ant,1,toneID);  % anterior

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



% % get_BootIndex
function [smi,bmi] = get_BootIndex(rALL,nBoot,toneID)
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

    [smi_ori(1,i_tpos),bmi_ori(1,i_tpos)] = calc_Index(Rmat,toneID);
    for n=1:nBoot
        %     Rmat_resample = resample_Rmat_v0(Rmat);
        Rmat_resample = resample_Rmat(Rmat);
        [smi_boot(n,i_tpos),bmi_boot(n,i_tpos)] = calc_Index(Rmat_resample,toneID);
    end

end

smi.original = smi_ori;
bmi.original = bmi_ori;
smi.boot     = smi_boot;
bmi.boot     = bmi_boot;

end

% % calc_Index
function [smi,bmi] = calc_Index(Rmatrix,toneID)
Rhh = Rmatrix(:,1);
Reh = Rmatrix(:,2);
Rhm = Rmatrix(:,3);
Rem = Rmatrix(:,4);

if strcmp(toneID,'A')
    % calculate smi without taking absolute value
    smi = ( Reh - Rhh ) + ( Rem - Rhm ); % easy - hard
    bmi = ( Rhh - Rhm ) + ( Reh - Rem );
    
    % mean
    smi = mean(smi,1);
    bmi = mean(bmi,1);
else
    % stimulus and behavioral modulation index (withoug normalization)
    smi = abs( Rhh - Reh ) + abs( Rhm - Rem ); % modulation by stimulus frequency
    bmi =  ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme

    % log transformation to make the distribution normal
    smi = smi(smi>0);
    smi = log2(smi); % only for dStim...

    % mean
    smi = mean(smi,1);
    bmi = mean(bmi,1);
end

end

% % resample_Rmat
function [Rmat_resample] = resample_Rmat(Rmat)
%UNTITLED8 Summary of this function goes here
%   resample data within channels (prohibit comparison across channels)
nSample = size(Rmat,1); % number of sample in total
nCond   = size(Rmat,2); % nuber of condition = 4 (easy-hard x hit-miss)

for i=1:nSample
    r_mua = Rmat(i,:);
    r_resamp = r_mua(randsample(nCond,nCond,'true'));
    Rmat_resample(i,:) = r_resamp;
    clear r_mua r_Resamp
end

end