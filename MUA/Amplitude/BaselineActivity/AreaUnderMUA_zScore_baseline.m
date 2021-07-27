%This program computes the area under the MUA for each A and
%B tone presentation (B1 and B1 separetely).
clear all
close all
addpath('../myFunction'); % path for dependent function...

ANIMAL = 'Cassius'; % either 'Domo' or 'Cassius'
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

for k=1:3 % hit or miss (1 for hit, 2 for miss)
    for i=1:length(list_st)
        for j=1:length(list_tt)
            tpos = list_tt(j) / 225 + 1;
            i_tpos = [1:3 tpos-1 tpos];
            MUA_condition = meanMUA{i,j,k}; % mean MUA of each semitone diff...
%         [resp,spont,stim] = get_MUAResponse(t,MUA_stdiff,params.AnalysisWindow);  % original
%         [abb,trp] = get_MUAResponse_AB(t,MUA_stdiff);
            zBaseline = get_zMUAResponse_baseline(t,MUA_condition); % BL window x ch
            zBL(:,:,i,j,k)  = zBaseline; % BL window x ch x stdiff x ttime x behav
        end
    end
end

n_ttime = sum(nTrial,1); % sum across stdiff
% n_stdiff = sum(nTrial,2); % sum across ttime
for k=1:3 % hit vs miss
    w_ttime = nTrial(:,:,k) ./ ( ones(length(list_st),1) * n_ttime(:,:,k) );
%     w_stdiff = nTrial(:,:,k) ./ ( n_stdiff(:,:,k) * ones(1,length(list_tt)) );
    for i=1:length(list_st)
        for j=1:length(list_tt)
            if nTrial(i,j,k) == 0
                meanMUA{i,j,k} = zeros(size(meanMUA{i,j,k}));
                zBL(:,:,i,j,k) = zeros(2,nChannel); % #BL period x #channel
%                 w_ttime(i,j) = 0;
            end
%             MUA_stdiff(:,:,i,j,k) = meanMUA{i,j,k} * w_stdiff(i,j);
            MUA_ttime(:,:,i,j,k) = meanMUA{i,j,k} * w_ttime(i,j);
%             zBL_stdiff(:,:,i,j,k) = zBL(:,:,i,j,k) * w_stdiff(i,j);
            zBL_ttime(:,:,i,j,k) = zBL(:,:,i,j,k) * w_ttime(i,j);
        end
    end
end
% MUA_stdiff = squeeze(sum(MUA_stdiff,4)); % average across target time
MUA_ttime = squeeze(nansum(MUA_ttime,3)); % average across stdiff
% zBL_stdiff = squeeze(sum(zBL_stdiff,4));
zBL_ttime = squeeze(nansum(zBL_ttime,3));

n_ttime = permute(n_ttime,[2 3 1]);
n_behav = sum(n_ttime,1);
w_behav = n_ttime ./ ( ones(size(n_ttime,1),1) * n_behav ); % ttime x behav
for k=1:3 % hit vs miss
    for j=1:length(list_tt)
        MUA_behav(:,:,j,k) = MUA_ttime(:,:,j,k) * w_behav(j,k);
        zBL_behav(:,:,j,k) = zBL_ttime(:,:,j,k) * w_behav(j,k);
    end
end
MUA_behav = squeeze(nansum(MUA_behav,3));
zBL_behav = squeeze(nansum(zBL_behav,3));


% % plot
% [h,fName] = show_zTriplet_stdiff(zABB_stdiff,list_st,params.RecordingDate);
% for i=1:length(list_st)
%     saveas(h(i),fullfile(SAVE_DIR,params.RecordingDate,'RESP',fName{i}),'png');
% end
% clear h fName;
% close all
% 
% [h,fName] = show_zTriplet_ttime(zABB_ttime,list_tt,params.RecordingDate);
% for j=1:length(list_tt)
%     saveas(h(j),fullfile(SAVE_DIR,params.RecordingDate,'RESP',fName{j}),'png');
% end
% clear h fName;
% close all



ss = {'hit','miss','false alarm'};
f = figure;
f.Position = [50 50 480 710];
for k=1:3 % hit vs miss
    h(k) = subplot(3,1,k);
    plot(t,MUA_behav(:,:,k));
    title(ss{k});
    xlabel('Time [ms]'); ylabel('Amplitude');
    box off
    y_range(k,:) = get(gca,'YLim');
end
set(h,'YLim',[min(y_range(:,1)) max(y_range(:,2))]);
% save figure
fig_name = strcat(params.RecordingDate,'_MUAmean_HitMiss');
saveas(gcf,fullfile(SAVE_DIR,params.RecordingDate,'RESP',fig_name),'png');


% reorganize data for saving...
zBL_behav = permute(zBL_behav,[1 3 2]); % BL window x behav x channel
% zABB_stdiff = permute(zABB_stdiff,[2 4 5 3 1]);
% zABB_ttime = permute(zABB_ttime,[2 4 5 3 1]);
% zMUA_A.stdiff  = zABB_stdiff(:,:,:,:,1); % triplet pos x stdiff x behav x channel
% zMUA_B1.stdiff = zABB_stdiff(:,:,:,:,2);
% zMUA_B2.stdiff = zABB_stdiff(:,:,:,:,3);
% zMUA_A.ttime  = zABB_ttime(:,:,:,:,1); % triplet pos x ttime x behav x channel
% zMUA_B1.ttime = zABB_ttime(:,:,:,:,2);
% zMUA_B2.ttime = zABB_ttime(:,:,:,:,3);

zMUA_behav = MUA_behav;
% zMUA.stdiff = MUA_stdiff;
% zMUA.ttime = MUA_ttime;

% save data
save_file_name = strcat(params.RecordingDate,'_zMUAbaseline');
save(fullfile(SAVE_DIR,params.RecordingDate,'RESP',save_file_name), ...
    'zBL_behav','zMUA_behav','t');

close all