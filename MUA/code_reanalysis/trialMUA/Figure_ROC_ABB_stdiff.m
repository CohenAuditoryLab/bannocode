clear all
% plot choice-related ROC separately for each delta F

DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\ROC_ABB';
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
BF_Session = 'low'; % either 'low', 'high', or 'all'
% tpos = [1 2 3 6 7];
% tpos = 4:8; % around target
% tpos = [1 2 3 6]; % exclude Target triplet
tpos = [1 2 3 6 7 8]; % extended
% tpos = 1:8; % all
line_color  = [153 0 255; 0 204 0] / 255;
line_color2 = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
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

% % remove intermediate dF trials from behav
% ABB_post_behav = ABB_post_behav(:,:,[1 end],:);
% ABB_ant_behav  = ABB_ant_behav(:,:,[1 end],:);
% ABB_post_behav = squeeze(nanmean(ABB_post_behav,3)); % average across dF
% ABB_ant_behav = squeeze(nanmean(ABB_ant_behav,3)); % average across dF


% plot
list_title = {'L','H1','H2'};
figure("Position",[100 100 800 900]);
for jj = 1:4 % choose stdiff level
abb_post_behav = squeeze(ABB_post_behav(:,:,jj,:));
abb_ant_behav  = squeeze(ABB_ant_behav(:,:,jj,:)); 
for ii=1:3
    pos = 3 * (jj - 1) + ii;
    h(pos) = subplot(4,3,pos); hold on;
    plot_ROC(tpos,abb_post_behav(:,:,ii),-0.04,line_color(1,:));
    plot_ROC(tpos,abb_ant_behav(:,:,ii),0.04,line_color(2,:));
    plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
    xlim([0.5 length(tpos)+0.5]);
    xlabel('Triplet Position'); ylabel('AUROC');
    box off;
    title(list_title{ii});
    yrange(pos,:) = get(gca,'YLim');
end
end
% set yaxis
for i=1:pos %3
    set(h(i),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
end
clear h yrange

figure('Position',[150 150 800 450]);
for jj = 1:4 % choose stdiff level
    abb_post_behav = squeeze(ABB_post_behav(:,:,jj,:));
    abb_ant_behav  = squeeze(ABB_ant_behav(:,:,jj,:));
    for ii=1:3
        % plot posterior data
        h(ii) = subplot(2,3,ii); hold on;
        plot_ROC(tpos,abb_post_behav(:,:,ii),-0.04,line_color2(jj,:));
        plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
        xlim([0.5 length(tpos)+0.5]);
        xlabel('Triplet Position'); ylabel('AUROC');
        box off;
        title({'Posterior'; list_title{ii}});
        yrange(ii,:) = get(gca,'YLim');

        % plot anterior data
        h(ii+3) = subplot(2,3,ii+3); hold on;
        plot_ROC(tpos,abb_ant_behav(:,:,ii),-0.04,line_color2(jj,:));
        plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
        xlim([0.5 length(tpos)+0.5]);
        xlabel('Triplet Position'); ylabel('AUROC');
        box off;
        title({'Anterior'; list_title{ii}});
        yrange(ii+3,:) = get(gca,'YLim');
    end
end
% set yaxis
for i=1:6
    set(h(i),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
end
clear h yrange

%show legend
legend({'smallest','','small','','large','','largest',''});


