clear all;
addpath ../

load zSMIBMI_LayerArea_ABB.mat
list_SMIBMI = {'SMI','BMI'}; % choose SMI or BMI


for j=1:numel(list_SMIBMI)
    SorB = list_SMIBMI{j};
    if strcmp(SorB,'SMI')
        % specify triplet position
        wTpos = 5:6; % T-2 and T-1 period
%         wTpos = 7; % Target triplet
        % get Index value
        SMI_sCore = zSMI_LayerArea{1,1}; % supragranular layer
        SMI_gCore = zSMI_LayerArea{1,2}; % granular layer
        SMI_iCore = zSMI_LayerArea{1,3}; % infragranular layer
        SMI_sBelt = zSMI_LayerArea{2,1}; % supragranula layer
        SMI_gBelt = zSMI_LayerArea{2,2}; % granular layer
        SMI_iBelt = zSMI_LayerArea{2,3}; % infragranular layer
%         x_label = 'zSMI';
    elseif strcmp(SorB,'BMI')
        % specify triplet position
        wTpos = 6:7; % T-1 and T period
%         wTpos = 7; % Target triplet
        % get Index value
        BMI_sCore = zBMI_LayerArea{1,1}; % supragranular layer
        BMI_gCore = zBMI_LayerArea{1,2}; % granular layer
        BMI_iCore = zBMI_LayerArea{1,3}; % infragranular layer
        BMI_sBelt = zBMI_LayerArea{2,1}; % supragranula layer
        BMI_gBelt = zBMI_LayerArea{2,2}; % granular layer
        BMI_iBelt = zBMI_LayerArea{2,3}; % infragranular layer
%         x_label = 'zBMI';
    end
end

%     index_sc = mean(IDX_sCore(:,wTpos),2);
%     index_gc = mean(IDX_gCore(:,wTpos),2);
%     index_ic = mean(IDX_iCore(:,wTpos),2);
%     index_sb = mean(IDX_sBelt(:,wTpos),2);
%     index_gb = mean(IDX_gBelt(:,wTpos),2);
%     index_ib = mean(IDX_iBelt(:,wTpos),2);

    index_sc = mean(compSMIBMI(SMI_sCore(:,wTpos),BMI_sCore(:,wTpos)),2);
    index_gc = mean(compSMIBMI(SMI_gCore(:,wTpos),BMI_gCore(:,wTpos)),2);
    index_ic = mean(compSMIBMI(SMI_iCore(:,wTpos),BMI_iCore(:,wTpos)),2);
    index_sb = mean(compSMIBMI(SMI_sBelt(:,wTpos),BMI_sBelt(:,wTpos)),2);
    index_gb = mean(compSMIBMI(SMI_gBelt(:,wTpos),BMI_gBelt(:,wTpos)),2);
    index_ib = mean(compSMIBMI(SMI_iBelt(:,wTpos),BMI_iBelt(:,wTpos)),2);

    mIDX_LayerArea = [mean(index_sc(:)) mean(index_gc(:)) mean(index_ic(:)); ...
        mean(index_sb(:)) mean(index_gb(:)) mean(index_ib(:))];
    eIDX_LayerArea = [std(index_sc(:))/sqrt(length(index_sc(:))) std(index_gc(:))/sqrt(length(index_gc(:))) std(index_ic(:))/sqrt(length(index_ic(:))); ...
        std(index_sb(:))/sqrt(length(index_sb(:))) std(index_gb(:))/sqrt(length(index_gb(:))) std(index_ib(:))/sqrt(length(index_ib(:)))];
    
    Column = mIDX_LayerArea';

    % added for statistics...
    index.sup.core  = index_sc;
    index.gran.core = index_gc;
    index.deep.core = index_ic;
    index.sup.belt  = index_sb;
    index.gran.belt = index_gb;
    index.deep.belt = index_ib;

%     [p(:,ABB)] = stats_CompLayerAreaBargraph_Friedman_ver2(index);
%     [p(:,ABB),~] = stats_CompLayerAreaBargraph_SRHtest(index);
%     [p(:,j),pp_core(:,j),pp_belt(:,j),pp_all(:,j)] = stats_CompLayerBargraph_KWtest(index);
    [p,pp_core,pp_belt,pp_all] = stats_CompLayerBargraph_KWtest(index);


    % figure
    figure;
    subplot(1,2,1);
    barh_LayerArea(mIDX_LayerArea,eIDX_LayerArea);
    xlabel('zBMI - zSMI');



% show schematics
string = {'CORE','BELT'};
% SMI
figure
for i=1:2
subplot(1,2,i);
imagesc(Column(:,i,1));
title(string{i});
axis off;
caxis([-0.8 0.5]);
end
colormap(1-gray);

% BMI
figure
for i=1:2
subplot(1,2,i);
imagesc(Column(:,i,2));
title(string{i});
axis off;
caxis([-0.5 1.3]);
end
colormap(1-gray);