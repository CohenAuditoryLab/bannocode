function [] = plot_stimbar(X,y,c)
%UNTITLED Summary of this function goes here
%   add stimulus interval on the plot specified by time (X) and y-axis (y)
%   in color (c)
%   X must be a vector indicating onset and offset of tone bursts

n_ToneBurst = size(X,2);
Y = ones(2,n_ToneBurst) * y;

for i=1:n_ToneBurst
    plot(X(:,i),Y(:,i),'Color',c, 'LineWidth',3);
end

end