function [] = plot_ExampleMUA(ANIMAL,RecordingDate,ch)
% generate figure showing example MUA response

% addpath('../'); % path for dependent function...

% set path to the Data directory
DATA_DIR = fullfile('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\DATA',ANIMAL,'MUA');
% SAVE_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';

% set variables to generate figure...
% ANIMAL = 'Domo'; %'Cassius';
% % params.RecordingDate = '20180709';
% RecordingDate = '20200110';
% ch = 7; %9;

fName = strcat(RecordingDate,'_ABBA_MUA'); % data file name
load(fullfile(DATA_DIR,fName));
nChannel = size(meanMUA{1,1,1},2);

% set analysis time window
w_onset = [-50 700]; % 1st to 3rd triplet
w_target = [-250 250]; % T-1 and T triplet
t_onset = w_onset(1)/1000:1/24414:w_onset(2)/1000;
t_onset = t_onset * 1000; % in ms
t_target = w_target(1)/1000:1/24414:w_target(2)/1000;
t_target = t_target * 1000; % in ms

t_range = w_onset;
ind_t = find(t>=t_range(1),1,'first');
idx_onset = ind_t:ind_t+length(t_onset)-1;
clear t_range ind_t


% get MUA_onset and MUA_target
n_ttime = sum(nTrial,1);
n_stdiff = sum(nTrial,2);
for k=1:2 % hit vs miss
    w_ttime = nTrial(:,:,k) ./ ( ones(length(list_st),1) * n_ttime(:,:,k) ); % waight
    w_stdiff = nTrial(:,:,k) ./ ( n_stdiff(:,:,k) * ones(1,length(list_tt)) ); % waight
    for i=1:length(list_st)
        for j=1:length(list_tt)
            if nTrial(i,j,k) == 0
                meanMUA{i,j,k} = zeros(size(meanMUA{i,j,k}));
            end
            t_range = list_tt(j) + w_target;
            ind_t = find(t>=t_range(1),1,'first');
            idx_target = ind_t:ind_t+length(t_target)-1;
            
            mua = meanMUA{i,j,k}; % sample x channel
            MUA_onset(:,:,i,j,k) = mua(idx_onset,:) * w_stdiff(i,j);
            MUA_target(:,:,i,j,k) = mua(idx_target,:) * w_stdiff(i,j);
            clear t_range ind_t
            
%             MUA_stdiff(:,:,i,j,k) = meanMUA{i,j,k} * w_stdiff(i,j);
%             MUA_ttime(:,:,i,j,k) = meanMUA{i,j,k} * w_ttime(i,j);
        end
    end
end
MUA_onset = squeeze(sum(MUA_onset,4)); % average across target time
MUA_target = squeeze(sum(MUA_target,4)); % average across target time
% MUA_stdiff = squeeze(sum(MUA_stdiff,4)); % average across target time
% MUA_ttime = squeeze(sum(MUA_ttime,3)); % average across stdiff

% weighted average for hit and miss
n_stdiff = squeeze(n_stdiff);
n_hmf = sum(n_stdiff,1);
w_hmf = n_stdiff ./ ( ones(length(list_st),1) * n_hmf );
for k=1:2
    for i=1:length(list_st)
        MUAb_onset(:,:,i,k) = MUA_onset(:,:,i,k) * w_hmf(i,k);
        MUAb_target(:,:,i,k) = MUA_target(:,:,i,k) * w_hmf(i,k);
    end
end
MUAb_onset = squeeze(sum(MUAb_onset,3));
MUAb_target = squeeze(sum(MUAb_target,3));

% choose channel to plot..
chMUA_onset = squeeze(MUA_onset(:,ch,:,:));
chMUA_target = squeeze(MUA_target(:,ch,:,:));
chMUAb_onset = squeeze(MUAb_onset(:,ch,:));
chMUAb_target = squeeze(MUAb_target(:,ch,:));

for i=1:length(list_st)
    string{i} = strcat(num2str(list_st(i)),' st');
end

% plot MUA
figure('Position',[300 300 800 450]);
% MUA around stimulus onset
h(1) = subplot(2,5,1:3);
plot(t_onset,chMUA_onset(:,:,1),'LineWidth',1.5); % plot hit trial
set(gca,'XLim',w_onset); % first triplet (with 25 ms delay);
set(gca,'XTick',0:75:w_onset(2));
y_range(1,:) = get(gca,'YLim');
xlabel('time from stimulus onset [ms]'); ylabel('amplitude [\muV]');
title('MUA around the stimulus onset');
box off;
% MUA around the target
h(2) = subplot(2,5,4:5);
plot(t_target,chMUA_target(:,:,1),'LineWidth',1.5); % plot hit trial
set(gca,'XLim',w_target);
set(gca,'XTick',-225:75:w_target(2));
y_range(2,:) = get(gca,'YLim');
xlabel('time from target [ms]');
title('MUA around the target');
box off;
legend(string,'Location',[0.88 0.85 0.1 0.1]);

% MUA around stimulus onset
lColor = {'r','b'};
h(3) = subplot(2,5,6:8);
l = plot(t_onset,chMUAb_onset,'LineWidth',1.5);
set(gca,'XLim',w_onset); % first triplet (with 25 ms delay);
set(gca,'XTick',0:75:w_onset(2));
y_range(3,:) = get(gca,'YLim');
xlabel('time from stimulus onset [ms]'); ylabel('amplitude [\muV]');
title('MUA around the stimulus onset');
box off;
for k=1:2
    set(l(k),'Color',lColor{k});
end
% MUA around the target
h(4) = subplot(2,5,9:10);
l = plot(t_target,chMUAb_target,'LineWidth',1.5);
set(gca,'XLim',w_target);
set(gca,'XTick',-225:75:w_target(2));
y_range(4,:) = get(gca,'YLim');
xlabel('time from target [ms]');
title('MUA around the target');
box off;
for k=1:2
    set(l(k),'Color',lColor{k});
end
legend({'Hit','Miss'},'Location',[0.88 0.38 0.1 0.1]);

ylim = [min(y_range(:,1)) max(y_range(:,2))]; 
set(h,'YLim',ylim);

end