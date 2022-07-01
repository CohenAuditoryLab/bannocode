function [lfp_ft] = reshapeLFP_ft(t,lfp)
%reshapeLFP_ft Summary of this function goes here
%   reshape LFP data so that it would fit with firld trip toolbox

nTrial = size(lfp,3);
for i=1:nTrial
    trial{i} = lfp(:,:,i);
    time{i} = t; 
end
lfp_ft.trial = trial;
lfp_ft.time  = time;

end

