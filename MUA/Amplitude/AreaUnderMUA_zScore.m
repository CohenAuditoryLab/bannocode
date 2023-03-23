%This program computes the area under the MUA for each A and
%B tone presentation (B1 and B1 separetely).
clear all
close all

ANIMAL = 'Domo';
% set path to the Data directory
DATA_DIR = fullfile('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\DATA',ANIMAL,'MUA','BL500ms');
SAVE_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
th = 1.96; % 95% threshold of z-score
% th = 2.58; % 99% threshold of z-score

params.RecordingDate = '20180727';
params.SampleRate = 24414; % original SR
% params.Baseline = 500; % baseline correction window in ms
% Nyquist = SampleRate/2;
% pointspermsec = SampleRate / 1000;
% msecperpoint = 1 / pointspermsec;

fName = strcat(params.RecordingDate,'_ABBA_MUA'); % data file name
load(fullfile(DATA_DIR,fName));
params.AnalysisWindow = [0 1500]; % analysis time window in ms
nChannel = size(meanMUA,2);

for HorM=1:2 % hit or miss (1 for hit, 2 for miss)
    for i=1:length(list_st)
        MUA_stdiff = meanMUA(:,:,i,HorM); % mean MUA of each semitone diff...
%         [resp,spont,stim] = get_MUAResponse(t,MUA_stdiff,params.AnalysisWindow);  % original
%         [abb,trp] = get_MUAResponse_AB(t,MUA_stdiff);
        abb = get_zMUAResponse_AB(t,MUA_stdiff); % get_zMUAResponse_AB has been modified 6/20/21
        abb = abb(:,1:6,:); % get the first 6 triplets...
        zABB(:,:,:,i,HorM)  = abb; % ABB x triplet pos x ch x stdiff x behav
%         triplet(:,:,i,HorM) = trp;
    end
end
% % z-score...
% size_ori = size(ABB);
% zABB = nanzscore(ABB(:));
% zABB = reshape(zABB,size_ori);

% plot
string = {'A','B1','B2'};
pos = [1 3 4];
for i=1:length(list_st)
    figure;
%     for HorM=1:2
%         H(HorM) = subplot(2,1,HorM);
%         h = bar(squeeze(mean(ABB(:,:,:,i,HorM),2)));
%         
%         set(gca,'XTick',1:3,'XTickLabel',{'A','B1','B2'});
%         ylabel('area under the MUA');
%         if HorM==1
%             title([num2str(list_st(i)) ' semitone difference (Hit)']);
%         elseif HorM==2
%             title([num2str(list_st(i)) ' semitone difference (Miss)']);
%         end
%         box off;
%     end

    for j=1:3 % ABB
        H(j) = subplot(2,2,pos(j));
        h = bar(squeeze(mean(zABB(j,:,:,i,:),2))); hold on;
        set(h(1),'FaceColor','r');
        set(h(2),'FaceColor','b');
        xlabel('channel'); ylabel('area under the MUA [z-score]');
        title(string{j});
        box off;
        
        plot([0 nChannel+1],[th th],':k');
        plot([0 nChannel+1],[-th -th],':k');
        
        y_lim = get(gca,'YLim');
        y_min(j) = y_lim(1);
        y_max(j) = y_lim(2);
        clear y_lim
    end
    set(H,'XLim',[0 nChannel+1],'YLim',[min(y_min) max(y_max)]);
    % save figure
    fig_name = strcat(params.RecordingDate,'_zTripletResp_',num2str(list_st(i)),'stdiff');
    saveas(gcf,fullfile(SAVE_DIR,params.RecordingDate,'RESP_BL500',fig_name),'png');
    clear y_min y_max
end
% reorganize data for saving...
zABB = permute(zABB,[2 4 5 3 1]);
zMUA_A  = zABB(:,:,:,:,1); % triplet pos x stdiff x behav x channel
zMUA_B1 = zABB(:,:,:,:,2);
zMUA_B2 = zABB(:,:,:,:,3);

% save data
save_file_name = strcat(params.RecordingDate,'_zMUAtriplet');
save(fullfile(SAVE_DIR,params.RecordingDate,'RESP_BL500',save_file_name), ...
    'zMUA_A','zMUA_B1','zMUA_B2','list_st');

close all