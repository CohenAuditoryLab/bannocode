% 1/31/22 re-analyzed the data
% first obtain z-scored index by Get_zIndex_ver3 then plot and compare the
% z-scored data...

clear all;
addpath(genpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\bootstrap'));
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary\z_score');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary');

% tpos_type = '_Tp1'; %[];
sTriplet = {'1st','2nd','3rd','T-3','T-2','T-1','T','T+1'};
i_fmi = 1;
i_smi = 1;
i_bmi = 1;

% fname = strcat('FMISMIBMI_LayerArea_ABB_CoreBelt',tpos_type);

load Index_ABB_Bargraph.mat
% load Index_ABB_Boot.mat
load Index_ABB_Boot_core.mat
load Index_ABB_Boot_belt.mat
list_SMIBMI = {'FMI','SMI','BMI'}; % choose SMI or BMI

pos = [2 1 3]; % set the figure order
for j=1:numel(list_SMIBMI)
    SorB = list_SMIBMI{j};

    if strcmp(SorB,'FMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sCore = SMI_BB_layer.core.sup(:,i_fmi); % supragranular layer
        IDX_gCore = SMI_BB_layer.core.grn(:,i_fmi); % granular layer
        IDX_iCore = SMI_BB_layer.core.inf(:,i_fmi); % infragranular layer
        IDX_sBelt = SMI_BB_layer.belt.sup(:,i_fmi); % supragranula layer
        IDX_gBelt = SMI_BB_layer.belt.grn(:,i_fmi); % granular layer
        IDX_iBelt = SMI_BB_layer.belt.inf(:,i_fmi); % infragranular layer
%         IDX_boot  = SMI_BB.boot(:,i_smi);
        IDX_boot_core = SMI_BB_core.boot(:,i_fmi);
        IDX_boot_belt = SMI_BB_belt.boot(:,i_fmi);
%         x_label = 'log(FMI)';
        x_label = 'log(FSI)';
        t_string = sTriplet{i_fmi};
    elseif strcmp(SorB,'SMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sCore = SMI_A_layer.core.sup(:,i_smi); % supragranular layer
        IDX_gCore = SMI_A_layer.core.grn(:,i_smi); % granular layer
        IDX_iCore = SMI_A_layer.core.inf(:,i_smi); % infragranular layer
        IDX_sBelt = SMI_A_layer.belt.sup(:,i_smi); % supragranula layer
        IDX_gBelt = SMI_A_layer.belt.grn(:,i_smi); % granular layer
        IDX_iBelt = SMI_A_layer.belt.inf(:,i_smi); % infragranular layer
%         IDX_boot  = SMI_A.boot(:,i_smi);
        IDX_boot_core = SMI_A_core.boot(:,i_smi);
        IDX_boot_belt = SMI_A_belt.boot(:,i_smi);
%         x_label = 'log(SMI)';
        x_label = 'log(CI)';
        t_string = sTriplet{i_smi};
    elseif strcmp(SorB,'BMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sCore = BMI_ABB_layer.core.sup(:,i_bmi); % supragranular layer
        IDX_gCore = BMI_ABB_layer.core.grn(:,i_bmi); % granular layer
        IDX_iCore = BMI_ABB_layer.core.inf(:,i_bmi); % infragranular layer
        IDX_sBelt = BMI_ABB_layer.belt.sup(:,i_bmi); % supragranula layer
        IDX_gBelt = BMI_ABB_layer.belt.grn(:,i_bmi); % granular layer
        IDX_iBelt = BMI_ABB_layer.belt.inf(:,i_bmi); % infragranular layer
%         IDX_boot  = BMI_ABB.boot(:,i_bmi);
        IDX_boot_core  = BMI_ABB_core.boot(:,i_bmi);
        IDX_boot_belt  = BMI_ABB_belt.boot(:,i_bmi);
        x_label = 'BMI';
        t_string = sTriplet{i_bmi};
    end

    % if in case multiple periods were set in tpos
    index_sc = mean(IDX_sCore,2);
    index_gc = mean(IDX_gCore,2);
    index_ic = mean(IDX_iCore,2);
    index_sb = mean(IDX_sBelt,2);
    index_gb = mean(IDX_gBelt,2);
    index_ib = mean(IDX_iBelt,2);

    % boot 
    iBoot_core = mean(IDX_boot_core,2);
    mIndex_core = mean(iBoot_core);
    [mIndex_cl,mIndex_cu] = get_CI_index(iBoot_core,0.90); % 90% confidence ineterval
    iBoot_belt = mean(IDX_boot_belt,2);
    mIndex_belt = mean(iBoot_belt);
    [mIndex_bl,mIndex_bu] = get_CI_index(iBoot_belt,0.90); % 90% confidence ineterval

    mIDX_LayerArea = [mean(index_sc(:)) mean(index_gc(:)) mean(index_ic(:)) mIndex_core; ...
        mean(index_sb(:)) mean(index_gb(:)) mean(index_ib(:)) mIndex_belt];
    eIDX_LayerArea = [std(index_sc(:))/sqrt(length(index_sc(:))) std(index_gc(:))/sqrt(length(index_gc(:))) std(index_ic(:))/sqrt(length(index_ic(:))) std(iBoot_core(:)); ...
        std(index_sb(:))/sqrt(length(index_sb(:))) std(index_gb(:))/sqrt(length(index_gb(:))) std(index_ib(:))/sqrt(length(index_ib(:))) std(iBoot_belt(:))];
%     eIDX_low = [std(index_sc(:))/sqrt(length(index_sc(:))) std(index_gc(:))/sqrt(length(index_gc(:))) std(index_ic(:))/sqrt(length(index_ic(:))) abs(mIndex_l-mIndex_boot); ...
%         std(index_sb(:))/sqrt(length(index_sb(:))) std(index_gb(:))/sqrt(length(index_gb(:))) std(index_ib(:))/sqrt(length(index_ib(:))) abs(mIndex_l-mIndex_boot)];
%     eIDX_up = [std(index_sc(:))/sqrt(length(index_sc(:))) std(index_gc(:))/sqrt(length(index_gc(:))) std(index_ic(:))/sqrt(length(index_ic(:))) abs(mIndex_u-mIndex_boot); ...
%         std(index_sb(:))/sqrt(length(index_sb(:))) std(index_gb(:))/sqrt(length(index_gb(:))) std(index_ib(:))/sqrt(length(index_ib(:))) abs(mIndex_u-mIndex_boot)];
%     eIDX_LayerArea = cat(3,eIDX_low,eIDX_up);

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
    barh_LayerArea_Boot(mIDX_LayerArea,eIDX_LayerArea);
    xlabel(x_label);
    title(t_string);
end

% % show schematics
% string = {'CORE','BELT'};
% 
% % FMI
% figure
% for i=1:2
% subplot(1,2,i);
% imagesc(Column(:,i,1));
% title(string{i});
% axis off;
% % caxis([-0.7 0.7]);
% end
% colormap(1-gray);
% 
% % SMI
% figure
% for i=1:2
% subplot(1,2,i);
% imagesc(Column(:,i,2));
% title(string{i});
% axis off;
% % caxis([-0.7 0.7]);
% end
% colormap(1-gray);
% 
% % BMI
% figure
% for i=1:2
% subplot(1,2,i);
% imagesc(Column(:,i,3));
% title(string{i});
% axis off;
% % caxis([-0.7 0.7]);
% end
% colormap(1-gray);