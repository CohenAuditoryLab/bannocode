%This program computes the area under the MUA for each A and
%B tone presentation (B1 and B1 separetely).
clear all
close all
addpath('../'); % path for dependent function...

ANIMAL = 'Cassius'; %'Domo';
% set path to the Data directory
DATA_DIR = fullfile('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\DATA',ANIMAL,'MUA');
SAVE_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
th = 1.96; % 95% threshold of z-score
% th = 2.58; % 99% threshold of z-score

params.RecordingDate = '20210403';
params.SampleRate = 24414; % original SR
% params.Baseline = 500; % baseline correction window in ms
% Nyquist = SampleRate/2;
% pointspermsec = SampleRate / 1000;
% msecperpoint = 1 / pointspermsec;

fName = strcat(params.RecordingDate,'_ABBA_MUA'); % data file name
load(fullfile(DATA_DIR,fName));
params.AnalysisWindow = [0 1500]; % analysis time window in ms
nChannel = size(meanMUA{1,1,1},2);

% get MUA_stdiff and MUA_ttime
n_ttime = sum(nTrial,1);
n_stdiff = sum(nTrial,2);
for k=1:2 % hit vs miss
    w_ttime = nTrial(:,:,k) ./ ( ones(length(list_st),1) * n_ttime(:,:,k) );
    w_stdiff = nTrial(:,:,k) ./ ( n_stdiff(:,:,k) * ones(1,length(list_tt)) );
    for i=1:length(list_st)
        for j=1:length(list_tt)
            if nTrial(i,j,k) == 0
                meanMUA{i,j,k} = zeros(size(meanMUA{i,j,k}));
            end
            MUA_stdiff(:,:,i,j,k) = meanMUA{i,j,k} * w_stdiff(i,j);
            MUA_ttime(:,:,i,j,k) = meanMUA{i,j,k} * w_ttime(i,j);
        end
    end
end
MUA_stdiff = squeeze(sum(MUA_stdiff,4)); % average across target time
MUA_ttime = squeeze(sum(MUA_ttime,3)); % average across stdiff


% plot MUA in the first triplet period for each channel...
for k=1 % hit trial
    for i=1:length(list_st)
        f = figure;
        f.Position = [50 50 1480 710];
        for ch=1:nChannel
            if nChannel==16
                h(ch) = subplot(4,4,ch);
            elseif nChannel==24
                h(ch) = subplot(5,5,ch);
            end
        plot(t,MUA_stdiff(:,ch,i,k)); hold on;
        ylim = get(gca,'YLim');
        plot([0 0],ylim,':k');
        plot([75 75],ylim,':k');
        plot([150 150],ylim,':k');
%         plot([-75 225],[0 0],'k','LineWidth',0.1);
        set(gca,'YLim',ylim);
        title(['ch' num2str(ch)]);
        xlabel('Time [ms]'); ylabel('Amplitude');
        set(h(ch),'XLim',[-75 225]);
        box off
%         y_range(i,:) = get(gca,'YLim');
        end
%         set(h,'YLim',[min(y_range(:,1)) max(y_range(:,2))]);
        % save figure
        fig_name = strcat('checkMUA_channel_',num2str(list_st(i)),'stdiff');
        saveas(gcf,fullfile(SAVE_DIR,params.RecordingDate,'RESP',fig_name),'png');
    end
end

% for k=1:2 % hit vs miss
%     f = figure;
%     f.Position = [50 50 480 710];
%     for j=1:length(list_tt)
%         h(j) = subplot(4,1,j);
%         plot(t,MUA_ttime(:,:,j,k));
%         title(['Target Time = ' num2str(list_tt(j)) ' ms']);
%         xlabel('Time [ms]'); ylabel('Amplitude');
%         box off
%         y_range(j,:) = get(gca,'YLim');
%     end
%     set(h,'YLim',[min(y_range(:,1)) max(y_range(:,2))]);
%     % save figure
%     fig_name = strcat(params.RecordingDate,'_MUAmean_ttime_',ss{k});
% %     saveas(gcf,fullfile(SAVE_DIR,params.RecordingDate,'RESP',fig_name),'png');
% end


% zMUA.stdiff = MUA_stdiff;
% zMUA.ttime = MUA_ttime;


close all