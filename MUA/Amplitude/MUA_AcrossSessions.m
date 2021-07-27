clear all

addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
animal_name = 'Cassius';
auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
load(strcat('RecordingDate_',animal_name));
isSave = 0; % 1 for saving figure...


RESP_A = []; RESP_B1 = []; RESP_B2 = []; chDepth = [];
for ff=1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    % calculate index for each session...
    [resp,depth] = alignMUAResp(rec_date,L3_ch,isSave);
    % close figure
    close all
    
    rA  = resp.A;
    rB1 = resp.B1;
    rB2 = resp.B2;
    
    rA_easyhard  = rA(:,[1 end],:);
    rB1_easyhard = rB1(:,[1 end],:);
    rB2_easyhard = rB2(:,[1 end],:);
    
    if ~isnan(L3_ch)
        RESP_A = cat(4,RESP_A,rA_easyhard);
        RESP_B1 = cat(4,RESP_B1,rB1_easyhard);
        RESP_B2 = cat(4,RESP_B2,rB2_easyhard);
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

H(1) = showPlot_MUASessions(RESP_A,chDepth,j);
H(2) = showPlot_MUASessions(RESP_B1,chDepth,j);
H(3) = showPlot_MUASessions(RESP_B2,chDepth,j);

save_file_dir = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/zScore';
ABB = {'A','B1','B2'};
for i=1:3
    save_file_name = strcat(animal_name,'_respnose_',ABB{i},'tone_',auditory_area);
    saveas(H(i),fullfile(save_file_dir,save_file_name),'png');
end