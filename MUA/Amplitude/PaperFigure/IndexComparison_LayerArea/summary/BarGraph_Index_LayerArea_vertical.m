clear all;

load SMIBMI_LayerArea_emergence.mat
SorB = 'BMI'; % choose SMI or BMI

for ABB=1:3 % A -- 1, B1 -- 2, B2 -- 3

    if strcmp(SorB,'SMI')
        % specify triplet position
%         wTpos = 1:2; % T-3, and T-2 period
        wTpos = 2:3; % T-2, and T-1 period
        % get Index value
        IDX_sCore = SMI_LayerArea{1,1,ABB}; % supragranular layer
        IDX_gCore = SMI_LayerArea{1,2,ABB}; % granular layer
        IDX_iCore = SMI_LayerArea{1,3,ABB}; % infragranular layer
        IDX_sBelt = SMI_LayerArea{2,1,ABB}; % supragranula layer
        IDX_gBelt = SMI_LayerArea{2,2,ABB}; % granular layer
        IDX_iBelt = SMI_LayerArea{2,3,ABB}; % infragranular layer
        y_label = 'log(SMI)';
    elseif strcmp(SorB,'BMI')
        % specify triplet position
        wTpos = 3:4; % T-1, and T period
        % get Index value
        IDX_sCore = BMI_LayerArea{1,1,ABB}; % supragranular layer
        IDX_gCore = BMI_LayerArea{1,2,ABB}; % granular layer
        IDX_iCore = BMI_LayerArea{1,3,ABB}; % infragranular layer
        IDX_sBelt = BMI_LayerArea{2,1,ABB}; % supragranula layer
        IDX_gBelt = BMI_LayerArea{2,2,ABB}; % granular layer
        IDX_iBelt = BMI_LayerArea{2,3,ABB}; % infragranular layer
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

    mIDX_LayerArea(:,:,ABB) = [mean(index_sc(:)) mean(index_gc(:)) mean(index_ic(:)); ...
        mean(index_sb(:)) mean(index_gb(:)) mean(index_ib(:))];
    eIDX_LayerArea(:,:,ABB) = [std(index_sc(:))/sqrt(length(index_sc(:))) std(index_gc(:))/sqrt(length(index_gc(:))) std(index_ic(:))/sqrt(length(index_ic(:))); ...
        std(index_sb(:))/sqrt(length(index_sb(:))) std(index_gb(:))/sqrt(length(index_gb(:))) std(index_ib(:))/sqrt(length(index_ib(:)))];
    
    % added for statistics...
    index.sup.core  = index_sc;
    index.gran.core = index_gc;
    index.deep.core = index_ic;
    index.sup.belt  = index_sb;
    index.gran.belt = index_gb;
    index.deep.belt = index_ib;

%     [p(:,ABB)] = stats_CompLayerAreaBargraph_Friedman_ver2(index);
%     [p(:,ABB),~] = stats_CompLayerAreaBargraph_SRHtest(index);
    [p(:,ABB),pp_core(:,ABB),pp_belt(:,ABB)] = stats_CompLayerBargraph_KWtest(index);
end

s_abb = {'L','H1','H2'};
c_map = [255 0 102; 255 192 0; 112 48 160] / 255;
% figure; % figure separated for core and belt
% for Area = 1:2
%     for ABB=1:3
%         subplot(2,3,3*(Area-1)+ABB);
%         b = barh(mIDX_LayerArea(Area,:,ABB)); hold on;
%         b.FaceColor = 'flat';
%         b.CData(1,:) = c_map(1,:);
%         b.CData(2,:) = c_map(2,:);
%         b.CData(3,:) = c_map(3,:);
%         set(gca,'YDir','reverse');
%         
%         
% 
%         errorbar(mIDX_LayerArea(Area,:,ABB),1:3,eIDX_LayerArea(Area,:,ABB),'.k','horizontal');
% 
%         set(gca,'YTickLabel',{'supra','granular','infra'});
% %         ylabel('Layer');
%         if strcmp(SorB,'SMI')
%             xlabel('log(SMI)');
%         elseif strcmp(SorB,'BMI')
%             xlabel('BMI');
%         end
%         ytickangle(45);
%         box off;
%         hold off;
%         title(s_abb{ABB});
%     end
% end

figure;
for ABB=1:3
    subplot(1,3,ABB);
    b = barh(mIDX_LayerArea(:,:,ABB)); hold on;
    b(1).FaceColor = c_map(1,:);
    b(2).FaceColor = c_map(2,:);
    b(3).FaceColor = c_map(3,:);
    set(gca,'YDir','reverse');

    ngroups = size(mIDX_LayerArea(:,:,ABB), 1);
    nbars = size(mIDX_LayerArea(:,:,ABB), 2);
    % Calculating the width for each bar group
    groupwidth = min(0.8, nbars/(nbars + 1.5));
    for i = 1:nbars
        %     x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
        %     errorbar(x, mIDX_LayerArea(:,i), eIDX_LayerArea(:,i), '.k');
        x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
        errorbar(mIDX_LayerArea(:,i,ABB), x, eIDX_LayerArea(:,i,ABB), '.k','horizontal');
        tickpos(i,:) = x;
    end
    set(gca,'YTick',tickpos(:),'YTickLabel',{'supra','granular','infra'});
    ytickangle(45);
    if strcmp(SorB,'SMI')
        xlabel('log(SMI)');
    elseif strcmp(SorB,'BMI')
        xlabel('BMI');
    end
    box off;
    hold off;
    title(s_abb{ABB});
end


% color_core = [157 195 230; 46 117 182; 31 78 121] / 255;
% color_belt = [244 177 131; 197 90 17; 132 60 12] / 255;
% color_map = [color_core; color_belt];
% for k = 1:size(color_map,1)
%     b(k).FaceColor = color_map(k,:);
% end
% box off;
% set(gca,'XTickLabel',{'L','H1','H2'});
% ylim([-0.5 2.5]);
% ylabel(y_label);
% legend({'Core supragranular','Core granular','Core infragranular','Belt supragranular','Belt granular','Belt infragranular'},'Location','NorthWest');