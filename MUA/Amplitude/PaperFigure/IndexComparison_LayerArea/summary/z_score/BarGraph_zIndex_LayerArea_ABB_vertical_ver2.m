clear all;
addpath ../

% load zSMIBMI_LayerArea_ABB_ver2.mat
load zSMIBMI_LayerArea_ABB_ver2_3.mat
list_SMIBMI = {'SMI','BMI'}; % choose SMI or BMI


for j=1:numel(list_SMIBMI)
    SorB = list_SMIBMI{j};
    if strcmp(SorB,'SMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sCore = zSMI_LayerArea{1,1}; % supragranular layer
        IDX_gCore = zSMI_LayerArea{1,2}; % granular layer
        IDX_iCore = zSMI_LayerArea{1,3}; % infragranular layer
        IDX_sBelt = zSMI_LayerArea{2,1}; % supragranula layer
        IDX_gBelt = zSMI_LayerArea{2,2}; % granular layer
        IDX_iBelt = zSMI_LayerArea{2,3}; % infragranular layer
        x_label = 'zSMI';
    elseif strcmp(SorB,'BMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sCore = zBMI_LayerArea{1,1}; % supragranular layer
        IDX_gCore = zBMI_LayerArea{1,2}; % granular layer
        IDX_iCore = zBMI_LayerArea{1,3}; % infragranular layer
        IDX_sBelt = zBMI_LayerArea{2,1}; % supragranula layer
        IDX_gBelt = zBMI_LayerArea{2,2}; % granular layer
        IDX_iBelt = zBMI_LayerArea{2,3}; % infragranular layer
        x_label = 'zBMI';
    end
    
%     index_sc = IDX_sCore(:,wTpos);
%     index_gc = IDX_gCore(:,wTpos);
%     index_ic = IDX_iCore(:,wTpos);
%     index_sb = IDX_sBelt(:,wTpos);
%     index_gb = IDX_gBelt(:,wTpos);
%     index_ib = IDX_iBelt(:,wTpos);

    index_sc = mean(IDX_sCore,2);
    index_gc = mean(IDX_gCore,2);
    index_ic = mean(IDX_iCore,2);
    index_sb = mean(IDX_sBelt,2);
    index_gb = mean(IDX_gBelt,2);
    index_ib = mean(IDX_iBelt,2);

    mIDX_LayerArea = [mean(index_sc(:)) mean(index_gc(:)) mean(index_ic(:)); ...
        mean(index_sb(:)) mean(index_gb(:)) mean(index_ib(:))];
    eIDX_LayerArea = [std(index_sc(:))/sqrt(length(index_sc(:))) std(index_gc(:))/sqrt(length(index_gc(:))) std(index_ic(:))/sqrt(length(index_ic(:))); ...
        std(index_sb(:))/sqrt(length(index_sb(:))) std(index_gb(:))/sqrt(length(index_gb(:))) std(index_ib(:))/sqrt(length(index_ib(:)))];
    
    Column(:,:,j) = mIDX_LayerArea';

    % added for statistics...
    index.sup.core  = index_sc;
    index.gran.core = index_gc;
    index.deep.core = index_ic;
    index.sup.belt  = index_sb;
    index.gran.belt = index_gb;
    index.deep.belt = index_ib;

%     [p(:,ABB)] = stats_CompLayerAreaBargraph_Friedman_ver2(index);
%     [p(:,ABB),~] = stats_CompLayerAreaBargraph_SRHtest(index);
    [p(:,j),pp_core(:,j),pp_belt(:,j),pp_all(:,j)] = stats_CompLayerBargraph_KWtest(index);

    
    if j==1
        zSMI.sc = index_sc;
        zSMI.gc = index_gc;
        zSMI.ic = index_ic;
        zSMI.sb = index_sb;
        zSMI.gb = index_gb;
        zSMI.ib = index_ib;
    elseif j==2
        zBMI.sc = index_sc;
        zBMI.gc = index_gc;
        zBMI.ic = index_ic;
        zBMI.sb = index_sb;
        zBMI.gb = index_gb;
        zBMI.ib = index_ib;
    end

    % figure
    if j==1
        figure;
    end
    subplot(1,2,j);
    barh_LayerArea(mIDX_LayerArea,eIDX_LayerArea);
    xlabel(x_label);

end

% show schematics
string = {'CORE','BELT'};
% SMI
figure
for i=1:2
subplot(1,2,i);
imagesc(Column(:,i,1));
title(string{i});
axis off;
caxis([-0.7 0.7]);
end
colormap(1-gray);

% BMI
figure
for i=1:2
subplot(1,2,i);
imagesc(Column(:,i,2));
title(string{i});
axis off;
caxis([-0.7 0.7]);
end
colormap(1-gray);