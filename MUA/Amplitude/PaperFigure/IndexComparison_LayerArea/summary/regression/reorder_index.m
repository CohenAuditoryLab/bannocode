function [reID] = reorder_index(id)
%UNTITLED3 Summary of this function goes here
%   reorder electrode_id or unit_id from 1 to N

var_id = unique(id);
N = length(var_id);

reID = id;
for i=1:N
    reID(id==var_id(i)) = i;
end

end