clear all

addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
animal_name = 'Cassius';
auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
load(strcat('RecordingDate_',animal_name));
isSave = 0; % 1 for saving figure...

% if strcmp(animal_name,'Domo')
%     nChannel = 16;
% elseif strcmp(animal_name,'Cassius')
%     nChannel = 24;
% end

IND = []; SIG = []; % chDepth = [];
for ff=1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    % calculate index for each session...
    [sig,sigACF,index,depth] = getACFSignificance(rec_date,L3_ch,isSave);
    % close figure
    close all
    
    index_easyhard = index(:,[1 end],:);
    IND = cat(4,IND,index_easyhard);
    
    s = sig.either;
    s_easyhard  = s(:,[1 end],:);
    SIG = cat(4,SIG,s_easyhard);
end
% number of significant channels...
nSig = sum(SIG,4); nSig = permute(sum(nSig,1),[2 3 1]);

% chDepth = chDepth';
% aIndex = area_index(~isnan(L3_channel)); % need to remove later
aIndex = area_index;

j = 1:length(aIndex);
if strcmp(auditory_area,'Core')
    j = j(aIndex==1);
elseif strcmp(auditory_area,'Belt');
    j = j(aIndex==0);
end

% choose sessions for analysis (core, belt or all)
IND  = IND(:,:,:,j);

% plot figure...
figure;
bargraph_SessionSummary(IND);
% y_range(1,:) = get(gca,'YLim');
ylabel('index [z-score]');
title('Streaming Index ACF');

% statistical analysis
[p_anova, p_level, p_group] = stats_SessionSummary(IND);

if isSave==1
    save_file_dir = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Autocorrelation/zScore';
    save_file_name = strcat(animal_name,'_CompStreamingIndex_',auditory_area);
    saveas(gca,fullfile(save_file_dir,save_file_name),'png');
end
% 
% set(H,'YLim',[0 max(y_max)]);
% % save_file_dir = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results','AcrossSessions','zScore');
% % save_file_name = strcat('StreamingIndexACF_',animal_name);
% % save(fullfile(save_file_dir,save_file_name),'list_RecDate','stIndex');