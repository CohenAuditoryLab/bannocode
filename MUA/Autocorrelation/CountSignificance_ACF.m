clear all

addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
animal_name = 'Domo';
auditory_area = 'Belt'; % either 'Core', 'Belt', or 'All'
load(strcat('RecordingDate_',animal_name));
isSave = 0; % 1 for saving figure...

% if strcmp(animal_name,'Domo')
%     nChannel = 16;
% elseif strcmp(animal_name,'Cassius')
%     nChannel = 24;
% end

sigACF_A = []; sigACF_B = []; chDepth = [];
for ff=1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    % calculate index for each session...
    [sig,sigACF,index,depth] = getACFSignificance(rec_date,L3_ch,isSave);
    % close figure
    close all
    
    sigA = sig.A;
    sigB = sig.B;
    sigA_easyhard = sigA(:,[1 end],:);
    sigB_easyhard = sigB(:,[1 end],:);
    if ~isnan(L3_ch)
        sigACF_A = cat(4,sigACF_A,sigA_easyhard);
        sigACF_B = cat(4,sigACF_B,sigB_easyhard);
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
sigA_hard_hit  = squeeze(sigACF_A(:,1,1,j));
sigA_hard_miss = squeeze(sigACF_A(:,1,2,j));
sigA_easy_hit  = squeeze(sigACF_A(:,2,1,j));
sigA_easy_miss = squeeze(sigACF_A(:,2,2,j));
sigB_hard_hit  = squeeze(sigACF_B(:,1,1,j));
sigB_hard_miss = squeeze(sigACF_B(:,1,2,j));
sigB_easy_hit  = squeeze(sigACF_B(:,2,1,j));
sigB_easy_miss = squeeze(sigACF_B(:,2,2,j));
chDepth = chDepth(:,j);

% plot...
isPlot = 0;
[n_ah_hit,d]  = bargraph_ACFSignificance(chDepth,sigA_hard_hit,isPlot);
[n_ah_miss,~] = bargraph_ACFSignificance(chDepth,sigA_hard_miss,isPlot);
[n_ae_hit,~]  = bargraph_ACFSignificance(chDepth,sigA_easy_hit,isPlot);
[n_ae_miss,~] = bargraph_ACFSignificance(chDepth,sigA_easy_miss,isPlot);
[n_bh_hit,~]  = bargraph_ACFSignificance(chDepth,sigB_hard_hit,isPlot);
[n_bh_miss,~] = bargraph_ACFSignificance(chDepth,sigB_hard_miss,isPlot);
[n_be_hit,~]  = bargraph_ACFSignificance(chDepth,sigB_easy_hit,isPlot);
[n_be_miss,~] = bargraph_ACFSignificance(chDepth,sigB_easy_miss,isPlot);

figure('Position',[100 100 800 600]);
H(1) = subplot(2,2,1);
h = bar(d,[n_ah_hit n_ah_miss]);
set(h(1),'FaceColor','red','BarWidth',1);
set(h(2),'FaceColor','blue','BarWidth',1);
y_max(1) = max(get(gca,'Ylim'));
xlabel('Depth from input layer [um]'); ylabel('# of channels');
title('Small dF Trials A Rate');
box off;

H(2) = subplot(2,2,2);
h = bar(d,[n_ae_hit n_ae_miss]);
set(h(1),'FaceColor','red','BarWidth',1);
set(h(2),'FaceColor','blue','BarWidth',1);
y_max(2) = max(get(gca,'Ylim'));
xlabel('Depth from input layer [um]'); ylabel('# of channels');
title('Large dF Trials A Rate');
box off;

H(3) = subplot(2,2,3);
h = bar(d,[n_bh_hit n_bh_miss]);
set(h(1),'FaceColor','red','BarWidth',1);
set(h(2),'FaceColor','blue','BarWidth',1);
y_max(3) = max(get(gca,'Ylim'));
xlabel('Depth from input layer [um]'); ylabel('# of channels');
title('Small dF Trials (A+B) Rate');
box off;

H(4) = subplot(2,2,4);
h = bar(d,[n_be_hit n_be_miss]);
set(h(1),'FaceColor','red','BarWidth',1);
set(h(2),'FaceColor','blue','BarWidth',1);
y_max(4) = max(get(gca,'Ylim'));
xlabel('Depth from input layer [um]'); ylabel('# of channels');
title('Large dF Trials (A+B) Rate');
box off;

set(H,'YLim',[0 max(y_max)]);
% save_file_dir = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results','AcrossSessions','zScore');
% save_file_name = strcat('StreamingIndexACF_',animal_name);
% save(fullfile(save_file_dir,save_file_name),'list_RecDate','stIndex');