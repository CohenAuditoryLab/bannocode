clear all
% plot choice-related ROC separately for each delta F

ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis';
DATA_DIR = fullfile(ROOT_DIR,'trialMUA','Reorganize_zMUA');
addpath(ROOT_DIR);

% set parameters...
% Animal_Name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
BF_Session = 'low'; % either 'low', 'high', or 'all'
% tpos = [1 2 3 6 7];
% tpos = 4:8; % around target
tpos = [1 2 3 6]; % exclude Target triplet
% tpos = [1 2 3 6 7 8]; % extended
% tpos = 1:8; % all
line_color  = [153 0 255; 0 204 0] / 255;
line_color2 = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980; ...
               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.0000 0.4470 0.7410];
% line_color = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
%               0.3010 0.7450 0.9330; 0.0000 0.4470 0.7410];


% load Data
fName = strcat('zMUA_Both_ABB_',BF_Session,'BF');
load(fullfile(DATA_DIR,fName));

% reshape matrix (sample x tpos x stdiff x ABB)
ABB_post_stdiff = reshape(zMUA.post.stdiff,[size(zMUA.post.stdiff,1)*size(zMUA.post.stdiff,2) size(zMUA.post.stdiff,3) size(zMUA.post.stdiff,4) size(zMUA.post.stdiff,5)]);
ABB_ant_stdiff  = reshape(zMUA.ant.stdiff,[size(zMUA.ant.stdiff,1)*size(zMUA.ant.stdiff,2) size(zMUA.ant.stdiff,3) size(zMUA.ant.stdiff,4) size(zMUA.ant.stdiff,5)]);
% hit and miss trials separated...
ABB_post_hit = reshape(zMUA.post.hit,[size(zMUA.post.hit,1)*size(zMUA.post.hit,2) size(zMUA.post.hit,3) size(zMUA.post.hit,4) size(zMUA.post.hit,5)]);
ABB_ant_hit  = reshape(zMUA.ant.hit,[size(zMUA.ant.hit,1)*size(zMUA.ant.hit,2) size(zMUA.ant.hit,3) size(zMUA.ant.hit,4) size(zMUA.ant.hit,5)]);
ABB_post_miss = reshape(zMUA.post.miss,[size(zMUA.post.miss,1)*size(zMUA.post.miss,2) size(zMUA.post.miss,3) size(zMUA.post.miss,4) size(zMUA.post.miss,5)]);
ABB_ant_miss  = reshape(zMUA.ant.miss,[size(zMUA.ant.miss,1)*size(zMUA.ant.miss,2) size(zMUA.ant.miss,3) size(zMUA.ant.miss,4) size(zMUA.ant.miss,5)]);


% % plot
% list_title = {'L','H1','H2'};
% figure("Position",[100 100 800 900]);
% for jj = 1:4 % choose stdiff level
% abb_post_behav = squeeze(ABB_post_behav(:,:,jj,:));
% abb_ant_behav  = squeeze(ABB_ant_behav(:,:,jj,:)); 
% for ii=1:3
%     pos = 3 * (jj - 1) + ii;
%     h(pos) = subplot(4,3,pos); hold on;
%     plot_ROC(tpos,abb_post_behav(:,:,ii),-0.04,line_color(1,:));
%     plot_ROC(tpos,abb_ant_behav(:,:,ii),0.04,line_color(2,:));
%     plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
%     xlim([0.5 length(tpos)+0.5]);
%     xlabel('Triplet Position'); ylabel('AUROC');
%     box off;
%     title(list_title{ii});
%     yrange(pos,:) = get(gca,'YLim');
% end
% end
% % set yaxis
% for i=1:pos %3
%     set(h(i),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
% end
% clear h yrange

list_title = {'L','H1','H2'};
jitter = [-0.06 -0.02 0.02 0.06];
figure('Position',[150 150 800 450]);
for jj = 1:4 % choose stdiff level
    abb_post_stdiff = squeeze(ABB_post_stdiff(:,:,jj,:));
    abb_ant_stdiff  = squeeze(ABB_ant_stdiff(:,:,jj,:));
    for ii=1:3
        % plot posterior data
        h(ii) = subplot(2,3,ii); hold on;
        plot_ROC(tpos,abb_post_stdiff(:,:,ii),jitter(jj),line_color2(jj,:));
%         plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
        xlim([0.5 length(tpos)+0.5]);
        xlabel('Triplet Position'); ylabel('zMUA');
        box off;
        title({'Posterior'; list_title{ii}});
        yrange(ii,:) = get(gca,'YLim');
        yrange_post(ii,:) = get(gca,'YLim'); % posterior

        % plot anterior data
        h(ii+3) = subplot(2,3,ii+3); hold on;
        plot_ROC(tpos,abb_ant_stdiff(:,:,ii),jitter(jj),line_color2(jj,:));
%         plot([0.5 length(tpos)+0.5],[0.5 0.5],':k');
        xlim([0.5 length(tpos)+0.5]);
        xlabel('Triplet Position'); ylabel('zMUA');
        box off;
        title({'Anterior'; list_title{ii}});
        yrange(ii+3,:) = get(gca,'YLim');
        yrange_ant(ii,:) = get(gca,'YLim');
    end
end
% set yaxis
% for i=1:6
%     set(h(i),'YLim',[min(yrange(:,1)) max(yrange(:,2))]);
% end
for i=1:3
    set(h(i),'YLim',[min(yrange_post(:,1)) max(yrange_post(:,2))]);
end
for i=4:6
    set(h(i),'YLim',[min(yrange_ant(:,1)) max(yrange_ant(:,2))]);
end
clear h yrange yrange_post yrange_ant

%show legend
subplot(2,3,3);
% legend({'smallest','','small','','large','','largest',''});
legend({'smallest','small','large','largest'});


