function [SMI,BMI] = get_SMIBMI_channel_v3(rALL_ABB,area_index,AP_index)
%UNTITLED12 Summary of this function goes here
%   modified from get_SMIBMI_channel.m to get CI without taking absolute
%   values
%   toneID must be a string either 'A', 'B1' or 'B2' 

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
end

end


% % calc_Index_channel
function [smi,bmi] = calc_Index_channel(Rmatrix)
Rhh = Rmatrix(:,1);
Reh = Rmatrix(:,2);
Rhm = Rmatrix(:,3);
Rem = Rmatrix(:,4);

% calculate index without taking absolute value
smi = ( Reh - Rhh ) + ( Rem - Rhm ); % easy - hard
bmi = ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme

% if strcmp(toneID,'A')
%     % calculate smi without taking absolute value
%     smi = ( Reh - Rhh ) + ( Rem - Rhm ); % easy - hard
%     bmi = ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme
% else
%     % stimulus and behavioral modulation index (withoug normalization)
%     smi = abs( Rhh - Reh ) + abs( Rhm - Rem ); % modulation by stimulus frequency
%     bmi =  ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme
% 
%     % log transformation to make the distribution normal
%     smi = smi(smi>0);
%     smi = log2(smi); % only for dStim...
% end


end