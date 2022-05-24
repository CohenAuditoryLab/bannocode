addpath(cd);
date = '20201109';

file_dir = fullfile('D:\Cassius\04_ABBA',date);
cd(file_dir);
data_file_name = strcat(date,'_ABBA_spike.mat');
% data_file_name = strcat(date,'_ABBA_spk2_spike.mat');
load(data_file_name);

nTrial = param.nValidTrials;
nChannel = param.nChannel;
for trial=1:nTrial
    % show each trial
    % trial = 12;
    figure;
    plot(t_hand,Rew(trial,:),'Color',[.8 .6 .6]); hold on;
    plot(t_hand,Lever1(trial,:),'Color',[.5 .5 .5]);
    plot(t_hand,Lever2(trial,:) * 2,'Color',[.5 .5 .5]);
    plot(t_stim,Stim(trial,:) * 16,'k');
    ch = Channel{trial};
    time_stamps = TimeStamps{trial};
    pos = 22;
    for i=1:nChannel
        ts_ch = time_stamps(ch==i); % time stamp for each channel
        if ~isnan(ts_ch)
        showRaster(ts_ch,pos*ones(1,numel(ts_ch)),1);
        end
        pos = pos - 1;
    end
    tt = targetTime(trial);
    plot([tt tt+50],[0 0],'r','LineWidth',2);
    title(['Trial #' num2str(trial)]);
    xlabel('time [ms]'); ylabel('channel');
    box off;
    set(gca,'xlim',param.DataTimeRange*1000,'ylim',[-3 23]);
    set(gca,'yTick',pos+1:2:pos+16,'yTickLabel',16:-2:2);
    
    if trial<10
        ext = ['00' num2str(trial)];
    elseif trial>=100
        ext = num2str(trial);
    else
        ext = ['0' num2str(trial)];
    end
    save_file_name = strcat('trial#',ext,'.png');
    
    if index(trial)==0
        cd HIT
        saveas(gcf,save_file_name);
        close all;
        cd ../
    elseif index(trial)==1
        cd MISS;
        saveas(gcf,save_file_name);
        close all;
        cd ../
    elseif index(trial)==2
        cd 'FA'
        saveas(gcf,save_file_name);
        close all;
        cd ../
    else
        % don't save start error trial
        close all;
    end
end
cd ../

% average across trials
% nTrial = param.nValidTrials;
trial_id = 1:nTrial;
tt_list = unique(targetTime);
% target time
for i=0:2 % 0->HIT, 1->MISS, 2->FA
    tt_temp = targetTime(index==i);
    tid_temp = trial_id(index==i);
    figure;
    for j=1:length(tt_list)
        subplot(2,2,j);
        temp_psth = PSTH(:,:,tid_temp(tt_temp==tt_list(j)));
        n = size(temp_psth,3);
        imagesc(mean(temp_psth,3));
        caxis([0 .2]);
        set(gca,'xTick',100:100:600,'xTickLabel',0:.5:2.5);
        text(400,3,['n = ' num2str(n)],'color',[1 1 1],'FontWeight','bold');
        xlabel('time'); ylabel('channel');
        title(['target time = ' num2str(tt_list(j))]);
    end
end
clear i j

std_list = unique(stDiff);
% semitone difference
for i=0:2
    std_temp = stDiff(index==i);
    tid_temp = trial_id(index==i);
    figure;
    for j=1:length(std_list)
        subplot(2,2,j);
        temp_psth = PSTH(:,:,tid_temp(std_temp==std_list(j)));
        n = size(temp_psth,3);
        imagesc(mean(temp_psth,3));
        caxis([0 .2]);
        set(gca,'xTick',100:100:600,'xTickLabel',0:.5:2.5);
        text(400,3,['n = ' num2str(n)],'color',[1 1 1],'FontWeight','bold');
        xlabel('time'); ylabel('channel');
        title(['semitone diff = ' num2str(std_list(j))]);
    end
end
clear i j