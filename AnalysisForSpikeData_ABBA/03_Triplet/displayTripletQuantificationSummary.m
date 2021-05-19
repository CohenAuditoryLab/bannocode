function [] = displayTripletQuantificationSummary(DATE)
% quantification of triplet response

% clear all;
% addpath(genpath('/Volumes/TOSHIBA_EXT/99_MatlabToolbox/myFunction/'));
% DATE = '20191009';
% DATE = '20210208';

% load data
addpath(DATE);
load(strcat(DATE,'_TripletIndex'));
% c = [100 100 100; 51 102 255; 255 0 0] / 255; % set line color
% w = [2 1 1]; % set line width

active_cl = clInfo.active_cluster;
ch = clInfo.channel;

% find non-responsive unit
i_NonResponsive = ones(1,length(list_cl));
for i=1:numel(active_cl)
    cl = active_cl(i); % cluster id of active unit
    ii = find(list_cl==cl); % index number for the unit
    i_NonResponsive(ii) = 0; % make responsive unit to be zero...
end

% remove non-responsive unit
index(:,i_NonResponsive==1) = [];

% combine data across all active unit
for i=1:numel(active_cl) % cluster
    for k=1:3 % h/m/fa
        i_stream_all(:,:,k,i) = index(k,i).i_stream; % triplet pos x triplet x behav x cl 
        i_fselec1_all(:,:,k,i) = index(k,i).i_fselec1; % triplet pos x stDiff x behav x cl
        i_fselec2_all(:,:,k,i) = index(k,i).i_fselec2; % triplet pos x stDiff x behav x cl
        Fano_all(:,:,:,k,i) = index(k,i).Fano; % triplet pos x stDiff x triplet x behav x cl
    end
end
i_stream_mean = nanmean(i_stream_all,4);
i_fselec1_mean = nanmean(i_fselec1_all,4);
i_fselec2_mean = nanmean(i_fselec2_all,4);
Fano_mean = nanmean(Fano_all,5);
i_stream_std = nanstd(i_stream_all,0,4);
i_fselec1_std = nanstd(i_fselec1_all,0,4);
i_fselec2_std = nanstd(i_fselec2_all,0,4);
Fano_std = nanstd(Fano_all,0,5);
n_stream = sum(~isnan(i_stream_all),4);
n_fselec1 = sum(~isnan(i_fselec1_all),4);
n_fselec2 = sum(~isnan(i_fselec2_all),4);
n_Fano = sum(~isnan(Fano_all),5);
i_stream_sem = i_stream_std ./ sqrt(n_stream);
i_fselec1_sem = i_fselec1_std ./ sqrt(n_fselec1);
i_fselec2_sem = i_fselec2_std ./ sqrt(n_fselec2);
Fano_sem = Fano_std ./ sqrt(n_Fano);

string = {'A','B1','B2'};
l = {'1st','2nd','3rd','T-1','T'}; % xlabel
h(1) = figure('Position',[360 278 650 420]);
for k=1:3 % h/m/fa
    for j=1:3 % A, B1, B2
        subplot(3,3,j); hold on; box off;
%         plot(1:5,i_stream_mean(:,j,k));
        errorbar((1:5) + 0.1*(k-2),i_stream_mean(:,j,k),i_stream_sem(:,j,k));
        plot([0 6],[0 0],':k');
        set(gca,'XTick',1:5,'XTickLabel',l);
        if j==1
            ylabel('small vs large dF');
        end
        if k==1
            title(string{j});
        end
        
        subplot(3,3,j+3); hold on; box off;
%         plot(1:5,Fano_mean(:,1,j,k)); % Fano factor (small semitone diff)
        errorbar((1:5) + 0.1*(k-2),Fano_mean(:,1,j,k),Fano_sem(:,1,j,k));
        set(gca,'XTick',1:5,'XTickLabel',l);
        if j==1
            ylabel('Fano factor (small dF)');
        end
        
        subplot(3,3,j+6); hold on; box off;
%         plot(1:5,Fano_mean(:,end,j,k)); % Fano factor (large semitone diff)
        errorbar((1:5) + 0.1*(k-2),Fano_mean(:,end,j,k),Fano_sem(:,end,j,k));
        set(gca,'XTick',1:5,'XTickLabel',l);
        if j==1
            ylabel('Fano factor (large dF)');
        elseif j==3
            if k==3
%                 legend({'HIT','MISS','FA'});
            end
        end
    end
end

h(2) = figure('Position',[360 278 860 420]);
n = size(i_fselec1_all,2);
for j=1:n
    s = [num2str(list_st(j)) ' semitone'];
    string{j} = s;
end
for k=1:3 % h/m/fa
    for j=1:n % semitone diff
        subplot(3,n,j); hold on; box off;
%         plot(1:5,i_fselec1_mean(:,j,k));
        errorbar((1:5) + 0.1*(k-2),i_fselec1_mean(:,j,k),i_fselec1_sem(:,j,k));
        set(gca,'XTick',1:5,'XTickLabel',l,'XLim',[0 6]);
        if j==1
            ylabel('A vs B1');
        end
        if k==1
            title(string{j});
        end
        
        
        subplot(3,n,j+n); hold on; box off;
%         plot(1:5,i_fselec2_mean(:,j,k));
        errorbar((1:5) + 0.1*(k-2),i_fselec2_mean(:,j,k),i_fselec2_sem(:,j,k));
        set(gca,'XTick',1:5,'XTickLabel',l,'XLim',[0 6]);
        if j==1
            ylabel('A vs B2');
        end
    end
    % plot 1st triplet as a function of st diff...
    subplot(3,3,7); hold on; box off;
%     plot(1:n,squeeze(i_fselec2_mean(4,:,:)),'o');
    errorbar((1:n) + 0.1*(k-2),squeeze(i_fselec1_mean(1,:,k)),squeeze(i_fselec1_sem(1,:,k)));
    set(gca,'XLim',[0 n+1]);
    title('1st triplet (A vs B1)');
    set(gca,'XTick',1:n,'XTickLabel',list_st);
    xlabel('semitone difference'); ylabel('index');
    
    % plot T-1 triplet as a function of st diff...
    subplot(3,3,8); hold on; box off;
%     plot(1:n,squeeze(i_fselec2_mean(4,:,:)),'o');
    errorbar((1:n) + 0.1*(k-2),squeeze(i_fselec1_mean(4,:,k)),squeeze(i_fselec1_sem(4,:,k)));
    set(gca,'XLim',[0 n+1]);
    title('Target-1 triplet (A vs B1)');
    set(gca,'XTick',1:n,'XTickLabel',list_st);
    xlabel('semitone difference'); ylabel('index');
    
    % plot T triplet as a function of st diff...
    subplot(3,3,9); hold on; box off;
    errorbar((1:n) + 0.1*(k-2),squeeze(i_fselec1_mean(5,:,k)),squeeze(i_fselec1_sem(5,:,k)));
    set(gca,'XLim',[0 n+1]);
    title('Target triplet (A vs B1)');
    set(gca,'XTick',1:n,'XTickLabel',list_st);
    xlabel('semitone difference'); ylabel('index');
    if k==3
        if j==n
%             legend({'HIT','MISS','FA'});
        end
    end
end
% save figure
save_dir = fullfile(DATE,'triplet');
save_file_name_1 = strcat(DATE,'_TripletIndex_summary1');
save_file_name_2 = strcat(DATE,'_TripletIndex_summary2');
saveas(h(1),fullfile(save_dir,save_file_name_1),'png');
saveas(h(2),fullfile(save_dir,save_file_name_2),'png');

% %% each individual unit...
% string = {'A','B1','B2'};
% l = {'1st','2nd','3rd','T-1','T'}; % xlabel
% i=14; %1:numel(active_cl)
% % index_cl = index(:,i); % choose unit to analize...
% figure;
% for k=1:3
% %     d_stream = index_cl(k).d_stream;
%     i_stream = i_stream_all(:,:,k,i);
%     Fano = Fano_all(:,:,:,k,i);
%     
%     for j=1:3 % A, B1, B2
%         subplot(3,3,j); hold on; box off;
%         plot(1:5,i_stream(:,j));
%         plot([0 6],[0 0],':k');
%         set(gca,'XTick',1:5,'XTickLabel',l);
%         title(string{j});
%         if j==1
%             ylabel('small vs large dF');
%         end
%         subplot(3,3,j+3); hold on; box off;
%         plot(1:5,Fano(:,1,j)); % Fano factor (small semitone diff)
%         set(gca,'XTick',1:5,'XTickLabel',l);
%         if j==1
%             ylabel('Fano factor (small dF)');
%         end
%         subplot(3,3,j+6); hold on; box off;
%         plot(1:5,Fano(:,end,j)); % Fano factor (large semitone diff)
%         set(gca,'XTick',1:5,'XTickLabel',l);
%         if j==1
%             ylabel('Fano factor (large dF)');
%         end
%     end
% end
% 
% figure;
% for k=1:3
% %     d_fselec1 = index_cl(k).d_fselec1;
% %     d_fselec2 = index_cl(k).d_fselec2;
%     i_fselec1 = i_fselec1_all(:,:,k,i);
%     i_fselec2 = i_fselec2_all(:,:,k,i);
%     n = size(i_fselec1,2);
%     
%     for j=1:n % semitone difference 
%         subplot(3,n,j); hold on; box off;
%         plot(1:5,i_fselec1(:,j));
%         set(gca,'XTick',1:5,'XTickLabel',l);
% %         title(string{j});
%         if j==1
%             ylabel('A vs B1');
%         end
%         subplot(3,n,j+n); hold on; box off;
%         plot(1:5,i_fselec2(:,j)); %
%         set(gca,'XTick',1:5,'XTickLabel',l);
%         if j==1
%             ylabel('A vs B2');
%         end
% %         subplot(3,n,j+2*n); hold on; box off;
% %         plot(1:5,Fano(:,end,j)); % Fano factor (large semitone diff)
% %         set(gca,'XTick',1:5,'XTickLabel',l);
% %         if j==1
% %             ylabel('Fano factor (large dF)');
% %         end
%     end
% end

end