clear all;

load SMIBMI_LayerArea_ABB.mat
% load SMIBMI_LayerArea_ABB_redef.mat; % 12/17/21 redefine layer assignment
list_SMIBMI = {'SMI','BMI'}; % choose SMI or BMI


for j=1:numel(list_SMIBMI)
    SorB = list_SMIBMI{j};
    if strcmp(SorB,'SMI')
        % specify triplet position
%         wTpos = 5:6; % T-2 and T-1 period
        wTpos = 2; % 2nd triplet
        % get Index value
        IDX_sCore = SMI_LayerArea{1,1}; % supragranular layer
        IDX_gCore = SMI_LayerArea{1,2}; % granular layer
        IDX_iCore = SMI_LayerArea{1,3}; % infragranular layer
        IDX_sBelt = SMI_LayerArea{2,1}; % supragranula layer
        IDX_gBelt = SMI_LayerArea{2,2}; % granular layer
        IDX_iBelt = SMI_LayerArea{2,3}; % infragranular layer
        x_label = 'log(SMI)';
    elseif strcmp(SorB,'BMI')
        % specify triplet position
%         wTpos = 6:7; % T-1 and T period
        wTpos = 7; % Target triplet
        % get Index value
        IDX_sCore = BMI_LayerArea{1,1}; % supragranular layer
        IDX_gCore = BMI_LayerArea{1,2}; % granular layer
        IDX_iCore = BMI_LayerArea{1,3}; % infragranular layer
        IDX_sBelt = BMI_LayerArea{2,1}; % supragranula layer
        IDX_gBelt = BMI_LayerArea{2,2}; % granular layer
        IDX_iBelt = BMI_LayerArea{2,3}; % infragranular layer
        x_label = 'BMI';
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
caxis([0.75 2.7]);
end
colormap(1-gray);

% BMI
figure
for i=1:2
subplot(1,2,i);
imagesc(Column(:,i,2));
title(string{i});
axis off;
caxis([0.15 3.2]);
end
colormap(1-gray);