clear all

addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes/Amplitude');
animal_name = 'Domo';
auditory_area = 'Core'; % either 'Core', 'Belt', or 'All'
load(strcat('RecordingDate_',animal_name));
isSave = 0; % 1 for saving figure...

if strcmp(animal_name,'Domo')
    nChannel = 16;
elseif strcmp(animal_name,'Cassius')
    nChannel = 24;
end

stIndex = []; chDepth = [];
for ff=1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    % calculate index for each session...
    [index,depth] = getStreamingIndex_ACF(rec_date,nChannel,L3_ch,isSave);
    % close figure
    close all
    
    index_easyhard = index(:,[1 end],:);
    if ~isnan(L3_ch)
        stIndex = cat(4,stIndex,index_easyhard);
        chDepth = cat(1,chDepth,depth);
    end
end
chDepth = chDepth';
aIndex = area_index(~isnan(L3_channel));

j = 1:length(aIndex);
if strcmp(auditory_area,'Core')
    j = j(aIndex==1);
elseif strcmp(auditory_area,'Belt');
    j = j(aIndex==0);
end
stIndex_hard_hit  = squeeze(stIndex(:,1,1,j));
stIndex_hard_miss = squeeze(stIndex(:,1,2,j));
stIndex_easy_hit  = squeeze(stIndex(:,2,1,j));
stIndex_easy_miss = squeeze(stIndex(:,2,2,j));
chDepth = chDepth(:,j);

% plot...
figure('Position',[100 100 800 600]);
prop.lin_width = 2;
prop.scatter = 'on';

subplot(2,2,1);
prop.color = 'b'; prop.marker = 'o'; prop.lin_style = '-';
plot_index(chDepth-20,stIndex_hard_hit,prop); hold on;
prop.color = 'r';
plot_index(chDepth+20,stIndex_easy_hit,prop);
xlabel('Distance from input layer'); ylabel('index');
title('Hit Trials (Easy vs Hard)');

subplot(2,2,2);
prop.color = 'b'; prop.marker = 'x'; prop.lin_style = '-';
plot_index(chDepth-20,stIndex_hard_miss,prop); hold on;
prop.color = 'r';
plot_index(chDepth+20,stIndex_easy_miss,prop);
xlabel('Distance from input layer'); ylabel('index');
title('Miss Trials (Easy vs Hard)');

subplot(2,2,3);
prop.color = 'b'; prop.marker = 'none'; prop.lin_style = '-';
plot_index(chDepth-20,stIndex_hard_hit,prop); hold on;
prop.color = 'b'; prop.lin_style = '--'; prop.lin_width = 1.5;
plot_index(chDepth+20,stIndex_hard_miss,prop);
xlabel('Distance from input layer'); ylabel('index');
title('Hard trials (Hit vs Miss)');

subplot(2,2,4);
prop.color = 'r'; prop.lin_style = '-'; prop.lin_width = 2.0;
plot_index(chDepth-20,stIndex_easy_hit,prop); hold on
prop.color = 'r'; prop.lin_style = '--'; prop.lin_width = 1.5;
plot_index(chDepth+20,stIndex_easy_miss,prop);
xlabel('Distance from input layer'); ylabel('index');
title('Easy trials (Hit vs Miss)');


% nSession = size(stIndex,4); % number of sessions
% d = unique(chDepth);
% stIndex_depth = NaN(length(d),nSession);
% for j=1:nSession
%     temp_d = chDepth(1,j);
%     i_depth = find(d==temp_d);
%     i_depth = i_depth:i_depth+15;
%     stIndex_session = stIndex(:,1,1,j); % hard/hit
%     stIndex_depth(i_depth,j) = stIndex_session;
%     clear temp_d i_depth stIndex_session
% end
% index_mean = nanmean(stIndex_depth,2);
% index_std = nanstd(stIndex_depth,0,2);
% errorbar(d,index_mean,index_std);

% nSession = size(stIndex,4); % number of sessions
% figure;
% for i=1:nSession
%     index_hit  = stIndex(:,:,1,i);
%     index_miss = stIndex(:,:,2,i);
%     plot(chDepth(i,:),index_hit,'o'); hold on
% end

% save_file_dir = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results','AcrossSessions');
% save_file_name = strcat('StreamingIndexACF_',animal_name);
% save(fullfile(save_file_dir,save_file_name),'list_RecDate','stIndex');