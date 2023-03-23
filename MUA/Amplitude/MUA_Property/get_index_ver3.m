function [Index] = get_index_ver3(zMUA_stdiff,index_type)
%get_Index Summary of this function goes here
%   calculate SMI and BMI

Rhh = squeeze(zMUA_stdiff(:,1,1,:)); % hard-hit
Reh = squeeze(zMUA_stdiff(:,end,1,:)); % easy-hit
Rhm  = squeeze(zMUA_stdiff(:,1,2,:)); % hard-miss
Rem = squeeze(zMUA_stdiff(:,end,2,:)); % easy_miss

if strcmp(index_type,'SMI')
    % separation modulation index (SMI)
    Index = abs( Rhh - Reh ) + abs( Rhm - Rem ); % modulation by stimulus frequency
elseif strcmp(index_type,'FMI')
    % frequency modulation index (FMI)
    Index = abs( Rhh - Reh ) + abs( Rhm - Rem ); % modulation by stimulus frequency
elseif strcmp(index_type,'BMI')
    % behavioral modulation index (BMI)
    Index =  ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme
end


end