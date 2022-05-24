function [data_char] = cell2char(data_cell)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
n = numel(data_cell);
for i=1:n
    data_char(i,:) = data_cell{i};
end
end

