function [bd_lfp,label] = bipolarLFP(lfp,eInfo)
%bipolarLFP Summary of this function goes here
%   lfp   ... lfp data (sample x channel)
%   eInfo ... electrode info obtained by countChannels.m
nCh_all = size(lfp,2);
nElectrode = eInfo.nElectrode;

bd_lfp = [];
label = {};
for j=1:nElectrode
    nCh_elec = eInfo.nChannel(j);
    temp_list = eInfo.list{j};
    eLFP = lfp(:,1:nCh_elec);
    if nCh_elec==24 % 24ch v-probe
        for i=1:20
            bd_lfp_a(:,i) = eLFP(:,i) - eLFP(:,i+4);
        end
        list_a = temp_list(3:22);
    elseif nCh_elec==16 % 16ch v-probe
        for i=1:14
            bd_lfp_a(:,i) = eLFP(:,i) - eLFP(:,i+2);
        end
        list_a = temp_list(2:15);
    end
    bd_lfp = cat(2,bd_lfp,bd_lfp_a);
    label = [label; list_a];
    
    lfp(:,1:nCh_elec) = [];
end

if ~isempty(lfp)
    error('something must be wrong...');
end

end

