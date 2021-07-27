clear all

addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
animal_name = 'Domo';
auditory_area = 'Belt'; % either 'Core', 'Belt', or 'All'
load(strcat('RecordingDate_',animal_name));
isSave = 0; % 1 for saving figure...


sigRESP_A_pos = []; sigRESP_B1_pos = []; sigRESP_B2_pos = []; chDepth = [];
sigRESP_A_neg = []; sigRESP_B1_neg = []; sigRESP_B2_neg = [];
for ff=1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    % calculate index for each session...
    [sig,sigResp,depth] = get_MUASignificance(rec_date,L3_ch,isSave);
    % close figure
    close all
    
    % positively significant...
    sigA  = sig.pos.A;
    sigB1 = sig.pos.B1;
    sigB2 = sig.pos.B2;
    
    sigA_easyhard  = sigA(:,[1 end],:);
    sigB1_easyhard = sigB1(:,[1 end],:);
    sigB2_easyhard = sigB2(:,[1 end],:);
    
    if ~isnan(L3_ch)
        sigRESP_A_pos = cat(4,sigRESP_A_pos,sigA_easyhard);
        sigRESP_B1_pos = cat(4,sigRESP_B1_pos,sigB1_easyhard);
        sigRESP_B2_pos = cat(4,sigRESP_B2_pos,sigB2_easyhard);
        chDepth = cat(1,chDepth,depth);
    end
    clear sigA sigB1 sigB2
    clear sigA_easyhard sigB1_easyhard sigB2_easyhard
    
    % negatively significant...
    sigA  = sig.neg.A;
    sigB1 = sig.neg.B1;
    sigB2 = sig.neg.B2;
    
    sigA_easyhard  = sigA(:,[1 end],:);
    sigB1_easyhard = sigB1(:,[1 end],:);
    sigB2_easyhard = sigB2(:,[1 end],:);
    
    if ~isnan(L3_ch)
        sigRESP_A_neg = cat(4,sigRESP_A_neg,sigA_easyhard);
        sigRESP_B1_neg = cat(4,sigRESP_B1_neg,sigB1_easyhard);
        sigRESP_B2_neg = cat(4,sigRESP_B2_neg,sigB2_easyhard);
%         chDepth = cat(1,chDepth,depth);
    end
    clear sigA sigB1 sigB2
    clear sigA_easyhard sigB1_easyhard sigB2_easyhard
end
chDepth = chDepth';
aIndex = area_index(~isnan(L3_channel));

j = 1:length(aIndex);
if strcmp(auditory_area,'Core')
    j = j(aIndex==1);
elseif strcmp(auditory_area,'Belt');
    j = j(aIndex==0);
end

% concatenate positive and negative significant response count
sigA_hard = cat(2,sigRESP_A_pos(:,1,:,:),sigRESP_A_neg(:,1,:,:));
sigA_easy = cat(2,sigRESP_A_pos(:,2,:,:),sigRESP_A_neg(:,2,:,:));
sigB1_hard = cat(2,sigRESP_B1_pos(:,1,:,:),sigRESP_B1_neg(:,1,:,:));
sigB1_easy = cat(2,sigRESP_B1_pos(:,2,:,:),sigRESP_B1_neg(:,2,:,:));
sigB2_hard = cat(2,sigRESP_B2_pos(:,1,:,:),sigRESP_B2_neg(:,1,:,:));
sigB2_easy = cat(2,sigRESP_B2_pos(:,2,:,:),sigRESP_B2_neg(:,2,:,:));

% sigA_hard_hit  = squeeze(sigRESP_A_pos(:,1,1,j));
% sigA_hard_miss = squeeze(sigRESP_A_pos(:,1,2,j));
% sigA_easy_hit  = squeeze(sigRESP_A_pos(:,2,1,j));
% sigA_easy_miss = squeeze(sigRESP_A_pos(:,2,2,j));
% chDepth = chDepth(:,j);

figure('Position',[100 100 800 600]);
H(1) = subplot(3,2,1);
y_range(1,:) = showBarGraph_MUASessions(sigA_hard,chDepth,j);
title('Small dF Trials A');
H(2) = subplot(3,2,2);
y_range(2,:) = showBarGraph_MUASessions(sigA_easy,chDepth,j);
title('Large dF Trials A');

H(3) = subplot(3,2,3);
y_range(3,:) = showBarGraph_MUASessions(sigB1_hard,chDepth,j);
title('Small dF Trials B1');
H(4) = subplot(3,2,4);
y_range(4,:) = showBarGraph_MUASessions(sigB1_easy,chDepth,j);
title('Large dF Trials B1');

H(5) = subplot(3,2,5);
y_range(5,:) = showBarGraph_MUASessions(sigB2_hard,chDepth,j);
title('Small dF Trials B2');
H(6) = subplot(3,2,6);
y_range(6,:) = showBarGraph_MUASessions(sigB2_easy,chDepth,j);
title('Large dF Trials B2');

y_min = min(y_range(:,1));
y_max = max(y_range(:,2));
set(H,'YLIM',[y_min y_max]);

save_file_dir = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/zScore';
save_file_name = strcat(animal_name,'_nSignificantRespnose_',auditory_area);
saveas(gca,fullfile(save_file_dir,save_file_name),'png');
