% 1/31/22 modified to compare zFMI, zSMI, and zBMI

clear all;
addpath ../
addpath ../../

SAVE_DIR = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\6_LaminarComparisons';

load zFMISMIBMI_LayerArea_ABB_ver3.mat
% load zSMIBMI_LayerArea_ABB_ver2_2.mat
% load zSMIBMI_LayerArea_ABB_ver2_3.mat
% load zSMIBMI_LayerArea_ABB_ver2_4.mat
% load zSMIBMI_LayerArea_ABB_ver2_5.mat
list_SMIBMI = {'FMI','SMI','BMI'}; % choose SMI or BMI


for j=1:numel(list_SMIBMI)
    SorB = list_SMIBMI{j};
    if strcmp(SorB,'FMI')
        % triplet positions are already specified in the data!!
        % get Index value
        FMI.sCore = zFMI_LayerArea{1,1}; % supragranular layer
        FMI.gCore = zFMI_LayerArea{1,2}; % granular layer
        FMI.iCore = zFMI_LayerArea{1,3}; % infragranular layer
        FMI.sBelt = zFMI_LayerArea{2,1}; % supragranula layer
        FMI.gBelt = zFMI_LayerArea{2,2}; % granular layer
        FMI.iBelt = zFMI_LayerArea{2,3}; % infragranular layer
    elseif strcmp(SorB,'SMI')
        % triplet positions are already specified in the data!!
        % get Index value
        SMI.sCore = zSMI_LayerArea{1,1}; % supragranular layer
        SMI.gCore = zSMI_LayerArea{1,2}; % granular layer
        SMI.iCore = zSMI_LayerArea{1,3}; % infragranular layer
        SMI.sBelt = zSMI_LayerArea{2,1}; % supragranula layer
        SMI.gBelt = zSMI_LayerArea{2,2}; % granular layer
        SMI.iBelt = zSMI_LayerArea{2,3}; % infragranular layer
%         x_label = 'zSMI';
    elseif strcmp(SorB,'BMI')
        % triplet positions are already specified in the data!!
        % get Index value
        BMI.sCore = zBMI_LayerArea{1,1}; % supragranular layer
        BMI.gCore = zBMI_LayerArea{1,2}; % granular layer
        BMI.iCore = zBMI_LayerArea{1,3}; % infragranular layer
        BMI.sBelt = zBMI_LayerArea{2,1}; % supragranula layer
        BMI.gBelt = zBMI_LayerArea{2,2}; % granular layer
        BMI.iBelt = zBMI_LayerArea{2,3}; % infragranular layer
%         x_label = 'zBMI';
    end
end

pos = [3 2 1];
for j=1:3
    % compare index
    if j==1
        % compare FMI vs BMI
        index_sc = mean(compSMIBMI(FMI.sCore,BMI.sCore),2);
        index_gc = mean(compSMIBMI(FMI.gCore,BMI.gCore),2);
        index_ic = mean(compSMIBMI(FMI.iCore,BMI.iCore),2);
        index_sb = mean(compSMIBMI(FMI.sBelt,BMI.sBelt),2);
        index_gb = mean(compSMIBMI(FMI.gBelt,BMI.gBelt),2);
        index_ib = mean(compSMIBMI(FMI.iBelt,BMI.iBelt),2);
%         x_label = 'zBMI - zFMI';
        x_label = 'zBMI - zFSI';
    elseif j==2
        % compare SMI vs BMI
        index_sc = mean(compSMIBMI(SMI.sCore,BMI.sCore),2);
        index_gc = mean(compSMIBMI(SMI.gCore,BMI.gCore),2);
        index_ic = mean(compSMIBMI(SMI.iCore,BMI.iCore),2);
        index_sb = mean(compSMIBMI(SMI.sBelt,BMI.sBelt),2);
        index_gb = mean(compSMIBMI(SMI.gBelt,BMI.gBelt),2);
        index_ib = mean(compSMIBMI(SMI.iBelt,BMI.iBelt),2);
%         x_label = 'zBMI - zSMI';
        x_label = 'zBMI - zCI';
    elseif j==3
        % compare SMI vs FMI
        index_sc = mean(compSMIBMI(FMI.sCore,SMI.sCore),2);
        index_gc = mean(compSMIBMI(FMI.gCore,SMI.gCore),2);
        index_ic = mean(compSMIBMI(FMI.iCore,SMI.iCore),2);
        index_sb = mean(compSMIBMI(FMI.sBelt,SMI.sBelt),2);
        index_gb = mean(compSMIBMI(FMI.gBelt,SMI.gBelt),2);
        index_ib = mean(compSMIBMI(FMI.iBelt,SMI.iBelt),2);
%         x_label = 'zSMI - zFMI';
        x_label = 'zCI - zFSI';
    end

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
%     [p(:,j),pp_core(:,j),pp_belt(:,j),pp_all(:,j)] = stats_CompLayerBargraph_KWtest(index);
[p(:,j),pp_core(:,j),pp_belt(:,j),pp_all(:,j)] = stats_CompLayerBargraph_KWtest(index);

% figure
figure(1);
subplot(1,3,pos(j));
barh_LayerArea(mIDX_LayerArea,eIDX_LayerArea);
xlabel(x_label);
set(gca,'xlim',[-1.15 1.15]);
end
% pairwise comparison of index (1st column -- core, 2nd column -- belt)
p_FMIBMI = pairwiseComp_zIndex(FMI,BMI);
p_SMIBMI = pairwiseComp_zIndex(SMI,BMI);
p_SMIFMI = pairwiseComp_zIndex(SMI,FMI);

% export figure
exportgraphics(gcf,fullfile(SAVE_DIR,'zIndex_Comp.eps'),'Resolution',600);

% % show scemetics
% string = {'CORE','BELT'};
% for j=1:3
% figure
% for i=1:2
% subplot(1,2,i);
% imagesc(Column(:,i,j));
% title(string{i});
% axis off;
% caxis([-1.0 1.0]);
% end
% colormap(redblue);
% end

% % show schematics
% string = {'CORE','BELT'};
% % SMI
% figure
% for i=1:2
% subplot(1,2,i);
% imagesc(Column(:,i,1));
% title(string{i});
% axis off;
% caxis([-0.8 0.5]);
% end
% colormap(1-gray);
% 
% % BMI
% figure
% for i=1:2
% subplot(1,2,i);
% imagesc(Column(:,i,2));
% title(string{i});
% axis off;
% caxis([-0.5 1.3]);
% end
% colormap(1-gray);