function [ref_lfp] = referenceLFP(lfp,eInfo)
%referenceLFP Summary of this function goes here
%   function that re-reference LFP by average across electrode
%   lfp -- lfp data (samples x channel)
%   eInfo   -- electrode info, should contain number of channels in each
%   electrode

nChannel = eInfo.nChannel;
N = length(nChannel);

temp_lfp = lfp;
ref_lfp = [];
for i = 1:N
    e_lfp = temp_lfp(:,1:nChannel(i)); % lfp in electrode
    temp_lfp(:,1:nChannel(i)) = [];
    
    % mean across channels
    mean_lfp = mean(e_lfp,2);
    m_lfp = mean_lfp * ones(1,nChannel(i));
    
    % referencing lfp by mean
    r_lfp = e_lfp - m_lfp;
    
    ref_lfp = [ref_lfp r_lfp];
    clear r_lfp e_lfp m_lfp mean_lfp
end

end