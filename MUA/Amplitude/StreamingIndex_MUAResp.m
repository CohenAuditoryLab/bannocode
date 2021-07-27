clear all

RecordingDate = '20180807';
DATA_DIR = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results',RecordingDate,'RESP','zScore');
f_name = strcat(RecordingDate,'_zMUAtriplet');

load(fullfile(DATA_DIR,f_name));
nChannel = size(zMUA_A,4);
resp_A  = squeeze(mean(zMUA_A,1)); % stdiff x HvsM x channel
resp_B1 = squeeze(mean(zMUA_B1,1));
resp_B2 = squeeze(mean(zMUA_B2,1));

resp_A_hit   = squeeze(resp_A(:,1,:));
resp_A_miss  = squeeze(resp_A(:,2,:));
resp_B1_hit  = squeeze(resp_B1(:,1,:));
resp_B1_miss = squeeze(resp_B1(:,2,:));
 
% index_hit  = atan(resp_A_hit ./ (resp_A_hit + resp_B1_hit) ) - pi/4;
% index_miss = atan(resp_A_miss ./ (resp_A_miss + resp_B1_miss) ) - pi/4;
index_hit  = (resp_A_hit - resp_B1_hit) ./ (resp_A_hit + resp_B1_hit);
index_miss = (resp_A_miss - resp_B1_miss) ./ (resp_A_miss + resp_B1_miss);
% 
% % FH(5) = figure(5);
% figure;
% for i=1:numel(list_st)
% % subplot(2,2,i);
% plot(1:nChannel,index_hit(:,:,i),'-o','LineWidth',2); hold on
% % plot(1:nChannel,index_miss(:,:,i),'--^');
% c = get(gca,'colororder');
% l{i} = strcat(num2str(list_st(i)),' semitone difference');
% end
% legend(l);
% for i=1:numel(list_st)
% % subplot(2,2,i);
% % plot(1:nChannel,index_hit(:,:,i),'-o'); hold on
% plot(1:nChannel,index_miss(:,:,i),'--^','color',c(i,:),'LineWidth',1.5);
% end
% 
% plot([0 nChannel+1],[0 0],':k');
% set(gca,'xLim',[0 nChannel+1],'yLim',[-0.8 0.8]);
% xlabel('Channel'); ylabel('index');
% box off;
% title('Two-Stream Index');
