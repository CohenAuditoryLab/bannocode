function [SMI,BMI] = get_index(zMUA_stdiff)
%get_Index Summary of this function goes here
%   calculate SMI and BMI

Rhh = squeeze(zMUA_stdiff(:,1,1,:)); % hard-hit
Reh = squeeze(zMUA_stdiff(:,end,1,:)); % easy-hit
Rhm  = squeeze(zMUA_stdiff(:,1,2,:)); % hard-miss
Rem = squeeze(zMUA_stdiff(:,end,2,:)); % easy_miss

% stimulus modulation index
SMI = abs( Rhh - Reh ) + abs( Rhm - Rem ); % modulation by stimulus frequency

% behavioral modulation index
BMI =  ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme

end