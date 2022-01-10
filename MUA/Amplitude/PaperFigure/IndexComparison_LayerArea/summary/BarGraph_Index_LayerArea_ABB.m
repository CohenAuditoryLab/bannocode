clear all;

% load SMIBMI_LayerArea_ABB.mat
load SMIBMI_LayerArea_ABB_redef.mat
list_SMIBMI = {'SMI','BMI'}; % choose SMI or BMI

for j=1:numel(list_SMIBMI) % A -- 1, B1 -- 2, B2 -- 3
    SorB = list_SMIBMI{j};
    if strcmp(SorB,'SMI')
        % specify triplet position
%         wTpos = 1:2; % T-3, and T-2 period
%         wTpos = 2:3; % T-2, and T-1 period
        wTpos = 5:6; % T-2, and T-1 period
        % get Index value
        IDX_sCore = SMI_LayerArea{1,1}; % supragranular layer
        IDX_gCore = SMI_LayerArea{1,2}; % granular layer
        IDX_iCore = SMI_LayerArea{1,3}; % infragranular layer
        IDX_sBelt = SMI_LayerArea{2,1}; % supragranula layer
        IDX_gBelt = SMI_LayerArea{2,2}; % granular layer
        IDX_iBelt = SMI_LayerArea{2,3}; % infragranular layer
        y_label = 'log(SMI)';
    elseif strcmp(SorB,'BMI')
        % specify triplet position
%         wTpos = 3:4; % T-1, and T period
        wTpos = 6:7; % T-1, and T period
        % get Index value
        IDX_sCore = BMI_LayerArea{1,1}; % supragranular layer
        IDX_gCore = BMI_LayerArea{1,2}; % granular layer
        IDX_iCore = BMI_LayerArea{1,3}; % infragranular layer
        IDX_sBelt = BMI_LayerArea{2,1}; % supragranula layer
        IDX_gBelt = BMI_LayerArea{2,2}; % granular layer
        IDX_iBelt = BMI_LayerArea{2,3}; % infragranular layer
        y_label = 'BMI';
    end
    
%     index_sc = IDX_sCore(:,wTpos);
%     index_gc = IDX_gCore(:,wTpos);
%     index_ic = IDX_iCore(:,wTpos);
%     index_sb = IDX_sBelt(:,wTpos);
%     index_gb = IDX_gBelt(:,wTpos);
%     index_ib = IDX_iBelt(:,wTpos);

    index_sc = mean(IDX_sCore(:,wTpos),2);
    index_gc = mean(IDX_gCore(:,wTpos),2);
    index_ic = mean(IDX_iCore(:,wTpos),2);
    index_sb = mean(IDX_sBelt(:,wTpos),2);
    index_gb = mean(IDX_gBelt(:,wTpos),2);
    index_ib = mean(IDX_iBelt(:,wTpos),2);

    mIDX_LayerArea = [mean(index_sc(:)) mean(index_gc(:)) mean(index_ic(:)); ...
        mean(index_sb(:)) mean(index_gb(:)) mean(index_ib(:))];
    eIDX_LayerArea = [std(index_sc(:))/sqrt(length(index_sc(:))) std(index_gc(:))/sqrt(length(index_gc(:))) std(index_ic(:))/sqrt(length(index_ic(:))); ...
        std(index_sb(:))/sqrt(length(index_sb(:))) std(index_gb(:))/sqrt(length(index_gb(:))) std(index_ib(:))/sqrt(length(index_ib(:)))];
    
    % added for statistics...
    index.sup.core  = index_sc;
    index.gran.core = index_gc;
    index.deep.core = index_ic;
    index.sup.belt  = index_sb;
    index.gran.belt = index_gb;
    index.deep.belt = index_ib;

%     [p(:,ABB)] = stats_CompLayerAreaBargraph_Friedman_ver2(index);
    [p(:,j),~] = stats_CompLayerAreaBargraph_SRHtest(index);


if j==1
    figure;
end
subplot(2,1,j);
b = bar(mIDX_LayerArea); hold on;

ngroups = size(mIDX_LayerArea, 1);
nbars = size(mIDX_LayerArea, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, mIDX_LayerArea(:,i), eIDX_LayerArea(:,i), '.k');
    tickpos(i,:) = x;
end
hold off

% color_core = [157 195 230; 46 117 182; 31 78 121] / 255;
% color_belt = [244 177 131; 197 90 17; 132 60 12] / 255;
% color_map = [color_core; color_belt];
color_map = [255 0 102; 255 192 0; 112 48 160] / 255;
for k = 1:size(color_map,1)
    b(k).FaceColor = color_map(k,:);
end
box off;
% set(gca,'XTickLabel',{'L','H1','H2'});
% ylim([-0.5 2.5]);
set(gca,'XTick',tickpos(:),'XTickLabel',{'supra','granular','infra'});
xtickangle(45);
ylabel(y_label);

end