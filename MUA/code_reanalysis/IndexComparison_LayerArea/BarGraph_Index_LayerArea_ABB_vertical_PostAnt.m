% 1/31/22 re-analyzed the data
% first obtain z-scored index by Get_zIndex_ver3 then plot and compare the
% z-scored data...

clear all;
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary\z_score');
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary');

tpos_type = '_Tp1'; %[];

fname = strcat('FMISMIBMI_LayerArea_ABB_PostAnt',tpos_type);

load(fullfile('IndexValues',fname));
% load FMISMIBMI_LayerArea_ABB_CoreBelt_2.mat
% load FMISMIBMI_LayerArea_ABB_PostAnt_2.mat
list_SMIBMI = {'FMI','SMI','BMI'}; % choose SMI or BMI

pos = [2 1 3]; % set the figure order
for j=1:numel(list_SMIBMI)
    SorB = list_SMIBMI{j};

    if strcmp(SorB,'FMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sPost = FMI_LayerArea{1,1}; % supragranular layer
        IDX_gPost = FMI_LayerArea{1,2}; % granular layer
        IDX_iPost = FMI_LayerArea{1,3}; % infragranular layer
        IDX_sAnt = FMI_LayerArea{2,1}; % supragranula layer
        IDX_gAnt = FMI_LayerArea{2,2}; % granular layer
        IDX_iAnt = FMI_LayerArea{2,3}; % infragranular layer
%         x_label = 'log(FMI)';
        x_label = 'log(FSI)';
        t_string = sTriplet_fmi;
    elseif strcmp(SorB,'SMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sPost = SMI_LayerArea{1,1}; % supragranular layer
        IDX_gPost = SMI_LayerArea{1,2}; % granular layer
        IDX_iPost = SMI_LayerArea{1,3}; % infragranular layer
        IDX_sAnt = SMI_LayerArea{2,1}; % supragranula layer
        IDX_gAnt = SMI_LayerArea{2,2}; % granular layer
        IDX_iAnt = SMI_LayerArea{2,3}; % infragranular layer
%         x_label = 'log(SMI)';
        x_label = 'log(CI)';
        t_string = sTriplet_smi;
    elseif strcmp(SorB,'BMI')
        % tpos already selected in the data!!
        % get Index value
        IDX_sPost = BMI_LayerArea{1,1}; % supragranular layer
        IDX_gPost = BMI_LayerArea{1,2}; % granular layer
        IDX_iPost = BMI_LayerArea{1,3}; % infragranular layer
        IDX_sAnt = BMI_LayerArea{2,1}; % supragranula layer
        IDX_gAnt = BMI_LayerArea{2,2}; % granular layer
        IDX_iAnt = BMI_LayerArea{2,3}; % infragranular layer
        x_label = 'BMI';
        t_string = sTriplet_bmi;
    end
    
%     index_sp = IDX_sPost(:,wTpos);
%     index_gp = IDX_gPost(:,wTpos);
%     index_ip = IDX_iPost(:,wTpos);
%     index_sa = IDX_sAnt(:,wTpos);
%     index_ga = IDX_gAnt(:,wTpos);
%     index_ia = IDX_iAnt(:,wTpos);

    index_sp = mean(IDX_sPost,2);
    index_gp = mean(IDX_gPost,2);
    index_ip = mean(IDX_iPost,2);
    index_sa = mean(IDX_sAnt,2);
    index_ga = mean(IDX_gAnt,2);
    index_ia = mean(IDX_iAnt,2);

    mIDX_LayerArea = [mean(index_sp(:)) mean(index_gp(:)) mean(index_ip(:)); ...
        mean(index_sa(:)) mean(index_ga(:)) mean(index_ia(:))];
    eIDX_LayerArea = [std(index_sp(:))/sqrt(length(index_sp(:))) std(index_gp(:))/sqrt(length(index_gp(:))) std(index_ip(:))/sqrt(length(index_ip(:))); ...
        std(index_sa(:))/sqrt(length(index_sa(:))) std(index_ga(:))/sqrt(length(index_ga(:))) std(index_ia(:))/sqrt(length(index_ia(:)))];
    
    Column(:,:,j) = mIDX_LayerArea';

    % added for statistics...
    index.sup.core  = index_sp;
    index.gran.core = index_gp;
    index.deep.core = index_ip;
    index.sup.belt   = index_sa;
    index.gran.belt  = index_ga;
    index.deep.belt  = index_ia;

%     [p(:,ABB)] = stats_CompLayerAreaBargraph_Friedman_ver2(index);
%     [p(:,ABB),~] = stats_CompLayerAreaBargraph_SRHtest(index);
    [p(:,j),pp_post(:,j),pp_ant(:,j),pp_all(:,j)] = stats_CompLayerBargraph_KWtest(index);

    
    if j==1
        zSMI.sc = index_sp;
        zSMI.gc = index_gp;
        zSMI.ic = index_ip;
        zSMI.sb = index_sa;
        zSMI.gb = index_ga;
        zSMI.ib = index_ia;
    elseif j==2
        zBMI.sc = index_sp;
        zBMI.gc = index_gp;
        zBMI.ic = index_ip;
        zBMI.sb = index_sa;
        zBMI.gb = index_ga;
        zBMI.ib = index_ia;
    end

    % figure
    if j==1
        figure;
    end
    subplot(1,3,pos(j));
    barh_LayerArea(mIDX_LayerArea,eIDX_LayerArea);
    xlabel(x_label);
    title(t_string);
end

% show schematics
string = {'POSTERIOR','ANTERIOR'};

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