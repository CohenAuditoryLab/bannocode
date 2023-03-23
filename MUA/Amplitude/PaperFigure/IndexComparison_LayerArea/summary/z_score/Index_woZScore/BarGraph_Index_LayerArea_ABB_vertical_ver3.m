% 1/31/22 re-analyzed the data
% first obtain z-scored index by Get_zIndex_ver3 then plot and compare the
% z-scored data...

clear all;
addpath ../../
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary');

load FMISMIBMI_LayerArea_ABB_ver3.mat
% load FMISMIBMI_LayerArea_ABB_ver3_2.mat
% load FMISMIBMI_LayerArea_ABB_ver3_3.mat
list_SMIBMI = {'FMI','SMI','BMI'}; % choose SMI or BMI

pos = [2 1 3]; % set the figure order
for j=1:numel(list_SMIBMI)
    SorB = list_SMIBMI{j};

    if strcmp(SorB,'FMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sCore = FMI_LayerArea{1,1}; % supragranular layer
        IDX_gCore = FMI_LayerArea{1,2}; % granular layer
        IDX_iCore = FMI_LayerArea{1,3}; % infragranular layer
        IDX_sBelt = FMI_LayerArea{2,1}; % supragranula layer
        IDX_gBelt = FMI_LayerArea{2,2}; % granular layer
        IDX_iBelt = FMI_LayerArea{2,3}; % infragranular layer
%         x_label = 'log(FMI)';
        x_label = 'log(FSI)';
    elseif strcmp(SorB,'SMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sCore = SMI_LayerArea{1,1}; % supragranular layer
        IDX_gCore = SMI_LayerArea{1,2}; % granular layer
        IDX_iCore = SMI_LayerArea{1,3}; % infragranular layer
        IDX_sBelt = SMI_LayerArea{2,1}; % supragranula layer
        IDX_gBelt = SMI_LayerArea{2,2}; % granular layer
        IDX_iBelt = SMI_LayerArea{2,3}; % infragranular layer
%         x_label = 'log(SMI)';
        x_label = 'log(CI)';
    elseif strcmp(SorB,'BMI')
        % tpos already selected in the data!!
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
    subplot(1,3,pos(j));
    barh_LayerArea(mIDX_LayerArea,eIDX_LayerArea);
    xlabel(x_label);

end

% show schematics
string = {'CORE','BELT'};
% FMI
figure
for i=1:2
subplot(1,2,i);
imagesc(Column(:,i,1));
title(string{i});
axis off;
% caxis([-0.7 0.7]);
end
colormap(1-gray);

% SMI
figure
for i=1:2
subplot(1,2,i);
imagesc(Column(:,i,2));
title(string{i});
axis off;
% caxis([-0.7 0.7]);
end
colormap(1-gray);

% BMI
figure
for i=1:2
subplot(1,2,i);
imagesc(Column(:,i,3));
title(string{i});
axis off;
% caxis([-0.7 0.7]);
end
colormap(1-gray);