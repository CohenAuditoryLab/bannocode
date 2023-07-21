clear all

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
BF_Session = 'low'; % either 'low', 'high', or 'all'
% tpos = [1 2 3 6 7];
% tpos = [1 2 3 6]; % exclude Target triplet
% tpos = [1 2 3 6 7 8]; % extended
tpos = 4:8; % around target
% tpos = 1:8; % all
line_color = [153 0 255; 0 204 0] / 255;
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
% line_color = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];

% load Data
fName = strcat('ROC_Both_ABB_',BF_Session,'BF');
load(fullfile(DATA_DIR,fName));


% reshape matrix (sample x tpos x ABB)
ABB_post_stim = reshape(AUC.post.stim,[size(AUC.post.stim,1)*size(AUC.post.stim,2) size(AUC.post.stim,3) size(AUC.post.stim,4)]);
ABB_ant_stim  = reshape(AUC.ant.stim,[size(AUC.ant.stim,1)*size(AUC.ant.stim,2) size(AUC.ant.stim,3) size(AUC.ant.stim,4)]);
% reshape matrix (sample x tpos x stdiff x ABB)
ABB_post_behav = reshape(AUC.post.behav,[size(AUC.post.behav,1)*size(AUC.post.behav,2) size(AUC.post.behav,3) size(AUC.post.behav,4) size(AUC.post.behav,5)]);
ABB_ant_behav  = reshape(AUC.ant.behav,[size(AUC.ant.behav,1)*size(AUC.ant.behav,2) size(AUC.ant.behav,3) size(AUC.ant.behav,4) size(AUC.ant.behav,5)]);

% remove intermediate dF trials from behav
ABB_post_behav = ABB_post_behav(:,:,[1 end],:);
ABB_ant_behav  = ABB_ant_behav(:,:,[1 end],:);
ABB_post_behav = squeeze(nanmean(ABB_post_behav,3)); % average across dF
ABB_ant_behav = squeeze(nanmean(ABB_ant_behav,3)); % average across dF


% plot
list_title = {'L','H1','H2'};
figure("Position",[100 100 800 450]);
for ii=1:3
    h(ii) = subplot(2,3,ii); hold on;
    plot_ROC(tpos,ABB_post_stim(:,:,ii),-0.04,line_color(1,:));
    plot_ROC(tpos,ABB_ant_stim(:,:,ii),0.04,line_color(2,:));
    plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
    xlim([0.5 length(tpos)+0.5]);
    xlabel('Triplet Position'); ylabel('AUROC');
    box off;
    title(list_title{ii});
    yrange(ii,:) = get(gca,'YLim');
end
% set yaxis
for ii=1:3
    set(h(ii),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
end
clear h yrange

for jj=1:3
    h(jj) = subplot(2,3,jj+3); hold on;
    plot_ROC(tpos,ABB_post_behav(:,:,jj),-0.04,line_color(1,:));
    plot_ROC(tpos,ABB_ant_behav(:,:,jj),0.04,line_color(2,:));
    plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
    xlim([0.5 length(tpos)+0.5]);
    xlabel('Triplet Position'); ylabel('AUROC');
    box off;
    title(list_title{jj});
    yrange(jj,:) = get(gca,'YLim');
end
% set yaxis
for jj=1:3
    set(h(jj),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
end
clear h yrange

legend({'posterior','anterior'});

% Plot figures separately...
% stimulus modulation (sROC)
figure("Position",[120 120 800 220]);
for ii=1:3
    h(ii) = subplot(1,3,ii); hold on;
    plot_ROC(tpos,ABB_post_stim(:,:,ii),-0.04,line_color(1,:));
    plot_ROC(tpos,ABB_ant_stim(:,:,ii),0.04,line_color(2,:));
    plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
    xlim([0.5 length(tpos)+0.5]);
    xlabel('Triplet Position'); ylabel('AUROC');
    box off;
    title(list_title{ii});
    yrange(ii,:) = get(gca,'YLim');
end
% set yaxis
for ii=1:3
    set(h(ii),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
end
clear h yrange
legend({'posterior','anterior'});

% behavioral modulation (bROC)
figure("Position",[140 140 800 220]);
for jj=1:3
    h(jj) = subplot(1,3,jj); hold on;
    plot_ROC(tpos,ABB_post_behav(:,:,jj),-0.04,line_color(1,:));
    plot_ROC(tpos,ABB_ant_behav(:,:,jj),0.04,line_color(2,:));
    plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
    xlim([0.5 length(tpos)+0.5]);
    xlabel('Triplet Position'); ylabel('AUROC');
    box off;
    title(list_title{jj});
    yrange(jj,:) = get(gca,'YLim');
end
% set yaxis
for jj=1:3
    set(h(jj),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
end
clear h yrange
legend({'posterior','anterior'});

% subplot(2,2,2); hold on;
% for ii=1:4
%     plot_ROC(tpos,AUC_ant_df(:,:,ii),jitter(ii),line_color(ii,:));
% end
% % % small dF
% % plot_ROC(tpos,AUC_ant_df(:,:,1),-jitter,line_color(1,:)); hold on;
% % % large dF
% % plot_ROC(tpos,AUC_ant_df(:,:,4), jitter,line_color(2,:));
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% box off;
% title('Anterior');
% legend({'Smallest dF','Small dF','Large dF','Largest dF'});
% 
% subplot(2,2,3);
% % small dF
% plot_ROC(tpos,AUC_post_hit(:,:,1),jitter(1),line_color(1,:)); hold on;
% plot_ROC(tpos,AUC_post_miss(:,:,1),jitter(3),line_color(2,:));
% % large dF
% plot_ROC(tpos,AUC_post_hit(:,:,4),jitter(2),line_color(4,:));
% plot_ROC(tpos,AUC_post_miss(:,:,4),jitter(4),line_color(3,:));
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% box off;
% 
% subplot(2,2,4);
% % small dF
% plot_ROC(tpos,AUC_ant_hit(:,:,1),jitter(1),line_color(1,:)); hold on;
% plot_ROC(tpos,AUC_ant_miss(:,:,1),jitter(3),line_color(2,:));
% % large dF
% plot_ROC(tpos,AUC_ant_hit(:,:,4),jitter(2),line_color(4,:));
% plot_ROC(tpos,AUC_ant_miss(:,:,4),jitter(4),line_color(3,:));
% xlim([0.5 length(tpos)+0.5]);
% xlabel('Triplet Position'); ylabel('AUROC');
% box off;
% % legend({'Hit','Miss'});
% legend({'Hit small dF','Miss small dF','Hit large dF' 'Miss large dF'});