function [ stIndex, chDepth ] = getStreamingIndex_ACF( RecordingDate, nChannel, L3_ch, isSave )

% RecordingDate = '20180807';
% nChannel = 16; %24; % number of channel (16 for Domo, 24 for Cassius)
DATA_DIR = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results',RecordingDate,'ACF','zScore');
f_name = strcat(RecordingDate,'_zACF');
% isSave = 0; % 1 if saving figure...
% L3_ch = 8; % channel corresponding to the bottom of layer 3...

% load data
load(fullfile(DATA_DIR,f_name));

% ACF_A_all(ACF_A_all<0) = 0;
% ACF_B_all(ACF_B_all<0) = 0;

ACF_1SRM_hit  = ACF_B_all(:,:,1);
ACF_1SRM_miss = ACF_B_all(:,:,2);
ACF_2SRM_hit  = ACF_A_all(:,:,1);
ACF_2SRM_miss = ACF_A_all(:,:,2);

% index_hit  = atan(ACF_2SRM_hit ./ ACF_1SRM_hit) - pi/4;
% index_miss = atan(ACF_2SRM_miss ./ ACF_1SRM_miss) - pi/4;
% index_hit = (abs(ACF_2SRM_hit) - abs(ACF_1SRM_hit)) ./ (abs(ACF_2SRM_hit) + abs(ACF_1SRM_hit));
% index_miss = (abs(ACF_2SRM_miss) - abs(ACF_1SRM_miss)) ./ (abs(ACF_2SRM_miss) + abs(ACF_1SRM_miss));
index_hit = ACF_2SRM_hit - ACF_1SRM_hit;
index_miss = ACF_2SRM_miss - ACF_1SRM_miss;

% concatenate index...
stIndex = cat(3,index_hit,index_miss);

% get distance from input layer
if nChannel==16
    ch_spacing = 150;
elseif nChannel==24
    ch_spacing = 100;
end
chDepth = 1:nChannel;
chDepth = (chDepth - L3_ch) * ch_spacing;

figure;
for i=1:numel(list_st)
    if isnan(L3_ch)
        plot(1:nChannel,index_hit(:,i),'-o','LineWidth',2); hold on
    else
        plot(chDepth,index_hit(:,i),'-o','LineWidth',2); hold on
    end
    c = get(gca,'colororder');
    l{i} = strcat(num2str(list_st(i)),' semitone difference');
end
legend(l);
for i=1:numel(list_st)
    if isnan(L3_ch)
        plot(1:nChannel,index_miss(:,i),'--^','color',c(i,:),'LineWidth',1.5);
    else
        plot(chDepth,index_miss(:,i),'--^','color',c(i,:),'LineWidth',1.5);
    end
end

if isnan(L3_ch)
    x_range = [0 nChannel+1];
    x_label = 'Channel';
else
    x_range = [min(chDepth)-ch_spacing max(chDepth)+ch_spacing];
    x_label = 'Distance from input layer [um]';
end
plot(x_range,[0 0],':k');
set(gca,'xLim',x_range);
xlabel(x_label); ylabel('index');
box off;
title('Two-Stream Index');

if isSave==1
    % save figure
    save_file_dir = DATA_DIR;
    save_file_name = strcat(RecordingDate,'_StreamingIndex_zACF');
    saveas(gcf,fullfile(save_file_dir,save_file_name),'png');
    % save variables
    save(fullfile(save_file_dir,save_file_name),'stIndex','chDepth','list_st');
end

end