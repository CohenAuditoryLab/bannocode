function [ ] = barh_LayerArea_Boot(mIDX_LayerArea,eIDX_LayerArea)
%barh_LayerArea.m Summary of this function goes here
%   display index (SMI or BMI) in horizontal bar graph separated by layer
%   and area
%   mIDX_LayerArea 2D matrix of index mean  (area) x (layer)
%   eIDX_LayerArea 2D matrix of index error (area) x (layer)

% define bar color
c_map = [255 0 102; 255 192 0; 112 48 160; 150 150 150] / 255;

b = barh(mIDX_LayerArea); hold on;
b(1).FaceColor = c_map(1,:);
b(2).FaceColor = c_map(2,:);
b(3).FaceColor = c_map(3,:);
b(4).FaceColor = c_map(4,:); % color added for bootstrapped data...
set(gca,'YDir','reverse');

ngroups = size(mIDX_LayerArea, 1);
nbars = size(mIDX_LayerArea, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(mIDX_LayerArea(:,i), x, eIDX_LayerArea(:,i), '.k','horizontal');
%     errorbar(mIDX_LayerArea(:,i), x, squeeze(eIDX_LayerArea(:,i,:)), '.k','horizontal');
    tickpos(i,:) = x;
end
set(gca,'YTick',tickpos(:),'YTickLabel',{'supra','granular','infra','boot'});
ytickangle(45);

box off;
hold off;
end