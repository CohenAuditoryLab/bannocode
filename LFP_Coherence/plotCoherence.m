function [] = plotCoherence(f,Coherence)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
n_ch = size(Coherence,1); % number of channel
c = parula(n_ch); % specify color map to use
% c = jet(n_ch); % specify color map to use

for i=1:n_ch
    plot(f,Coherence(i,:),'Color',c(i,:)); hold on;
end

end

