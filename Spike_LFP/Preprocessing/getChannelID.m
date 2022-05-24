function [chID] = getChannelID(chan_name)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

chID = NaN(size(chan_name));

for i = 1:24
    if i<10
        s = ['ch0' num2str(i)];
    else
        s = ['ch' num2str(i)];
    end
    
    rows = contains(chan_name,s);
    chID(rows) = i;
end
    
end

