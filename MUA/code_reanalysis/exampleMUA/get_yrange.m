function [yrange] = get_yrange(handle)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

n = numel(handle);
for i=1:n
    ylim_all(i,:) = handle(i).YLim;
end
ylim_min = min(ylim_all(:,1));
ylim_max = max(ylim_all(:,2));

yrange = [ylim_min ylim_max];

end