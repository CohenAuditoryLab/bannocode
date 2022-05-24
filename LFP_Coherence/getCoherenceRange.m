function [Crange] = getCoherenceRange(f,Coherence,wFreq)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

coh_range = Coherence( :, f>=wFreq(1) & f<=wFreq(2) );
Crange = mean(coh_range,2);

end

