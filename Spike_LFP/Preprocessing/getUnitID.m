function [uID] = getUnitID(unit_name)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

uID = NaN(size(unit_name));

for i=1:length(uID)
    s = unit_name{i}(end-2:end);
    uID(i) = str2num(s);    
end

