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
load Index_ABB_Boot_post.mat
load Index_ABB_Boot_ant.mat
list_SMIBMI = {'FMI','SMI','BMI'}; % choose SMI or BMI

pos = [2 1 3]; % set the figure order
for j=1:numel(list_SMIBMI)
    SorB = list_SMIBMI{j};

    if strcmp(SorB,'FMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sPost = SMI_BB_layer.post.sup(:,i_fmi); % supragranular layer
        IDX_gPost = SMI_BB_layer.post.grn(:,i_fmi); % granular layer
        IDX_iPost = SMI_BB_layer.post.inf(:,i_fmi); % infragranular layer
        IDX_sAnt  = SMI_BB_layer.ant.sup(:,i_fmi); % supragranula layer
        IDX_gAnt  = SMI_BB_layer.ant.grn(:,i_fmi); % granular layer
        IDX_iAnt  = SMI_BB_layer.ant.inf(:,i_fmi); % infragranular layer
%         IDX_boot  = SMI_BB.boot(:,i_fmi);
        IDX_boot_post = SMI_BB_post.boot(:,i_fmi);
        IDX_boot_ant  = SMI_BB_ant.boot(:,i_fmi);
%         x_label = 'log(FMI)';
        x_label = 'log(FSI)';
        t_string = sTriplet{i_fmi};
    elseif strcmp(SorB,'SMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sPost = SMI_A_layer.post.sup(:,i_smi); % supragranular layer
        IDX_gPost = SMI_A_layer.post.grn(:,i_smi); % granular layer
        IDX_iPost = SMI_A_layer.post.inf(:,i_smi); % infragranular layer
        IDX_sAnt = SMI_A_layer.ant.sup(:,i_smi); % supragranula layer
        IDX_gAnt = SMI_A_layer.ant.grn(:,i_smi); % granular layer
        IDX_iAnt = SMI_A_layer.ant.inf(:,i_smi); % infragranular layer
%         IDX_boot  = SMI_A.boot(:,i_smi);
        IDX_boot_post = SMI_A_post.boot(:,i_smi);
        IDX_boot_ant  = SMI_A_ant.boot(:,i_smi);
%         x_label = 'log(SMI)';
        x_label = 'log(CI)';
        t_string = sTriplet{i_smi};
    elseif strcmp(SorB,'BMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sPost = BMI_ABB_layer.post.sup(:,i_bmi); % supragranular layer
        IDX_gPost = BMI_ABB_layer.post.grn(:,i_bmi); % granular layer
        IDX_iPost = BMI_ABB_layer.post.inf(:,i_bmi); % infragranular layer
        IDX_sAnt = BMI_ABB_layer.ant.sup(:,i_bmi); % supragranula layer
        IDX_gAnt = BMI_ABB_layer.ant.grn(:,i_bmi); % granular layer
        IDX_iAnt = BMI_ABB_layer.ant.inf(:,i_bmi); % infragranular layer
%         IDX_boot  = BMI_ABB.boot(:,i_bmi);
        IDX_boot_post = BMI_ABB_post.boot(:,i_bmi);
        IDX_boot_ant  = BMI_ABB_ant.boot(:,i_bmi);
        x_label = 'BMI';
        t_string = sTriplet{i_bmi};
    end
    


    index_sp = mean(IDX_sPost,2);
    index_gp = mean(IDX_gPost,2);
    index_ip = mean(IDX_iPost,2);
    index_sa = mean(IDX_sAnt,2);
    index_ga = mean(IDX_gAnt,2);
    index_ia = mean(IDX_iAnt,2);

    % boot 
    iBoot_post = mean(IDX_boot_post,2);
    mIndex_post = mean(iBoot_post);
    [mIndex_pl,mIndex_pu] = get_CI_index(iBoot_post,0.90); % 90% confidence ineterval
    iBoot_ant = mean(IDX_boot_ant,2);
    mIndex_ant = mean(iBoot_ant);
    [mIndex_al,mIndex_au] = get_CI_index(iBoot_ant,0.90); % 90% confidence ineterval

    mIDX_LayerArea = [mean(index_sp(:)) mean(index_gp(:)) mean(index_ip(:)) mIndex_post; ...
        mean(index_sa(:)) mean(index_ga(:)) mean(index_ia(:)) mIndex_ant];
    eIDX_LayerArea = [std(index_sp(:))/sqrt(length(index_sp(:))) std(index_gp(:))/sqrt(length(index_gp(:))) std(index_ip(:))/sqrt(length(index_ip(:))) std(iBoot_post(:)); ...
        std(index_sa(:))/sqrt(length(index_sa(:))) std(index_ga(:))/sqrt(length(index_ga(:))) std(index_ia(:))/sqrt(length(index_ia(:))) std(iBoot_ant(:))];
    
    Column(:,:,j) = mIDX_LayerArea';

    % added for statistics...
    index.sup.core  = index_sp;
    index.gran.core = index_gp;
    index.deep.core = index_ip;
    index.sup.belt  = index_sa;
    index.gran.belt = index_ga;
    index.deep.belt = index_ia;

%     [p(:,ABB)] = stats_CompLayerAreaBargraph_Friedman_ver2(index);
%     [p(:,ABB),~] = stats_CompLayerAreaBargraph_SRHtest(index);
    [p(:,j),pp_post(:,j),pp_ant(:,j),pp_all(:,j)] = stats_CompLayerBargraph_KWtest(index);

    
    if j==1
        zSMI.sp = index_sp;
        zSMI.gp = index_gp;
        zSMI.ip = index_ip;
        zSMI.sa = index_sa;
        zSMI.ga = index_ga;
        zSMI.ia = index_ia;
    elseif j==2
        zBMI.sp = index_sp;
        zBMI.gp = index_gp;
        zBMI.ip = index_ip;
        zBMI.sa = index_sa;
        zBMI.ga = index_ga;
        zBMI.ia = index_ia;
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
% string = {'POSTERIOR','ANTERIOR'};
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