clear all

addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
animal_name = 'Domo';
auditory_area = 'Belt'; % either 'Core', 'Belt', or 'All'
load(strcat('RecordingDate_',animal_name));
isSave = 0; % 1 for saving figure...


sigRESP_A = []; sigRESP_B1 = []; sigRESP_B2 = []; chDepth = [];
for ff=1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    % calculate index for each session...
    [sig,sigResp,depth] = get_MUASignificance(rec_date,L3_ch,isSave);
    % close figure
    close all
    
    rA  = sigResp.pos.A;
    rB1 = sigResp.pos.B1;
    rB2 = sigResp.pos.B2;
    
    rA_easyhard  = rA(:,[1 end],:);
    rB1_easyhard = rB1(:,[1 end],:);
    rB2_easyhard = rB2(:,[1 end],:);
    
    if ~isnan(L3_ch)
        sigRESP_A = cat(4,sigRESP_A,rA_easyhard);
        sigRESP_B1 = cat(4,sigRESP_B1,rB1_easyhard);
        sigRESP_B2 = cat(4,sigRESP_B2,rB2_easyhard);
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

H(1) = showPlot_MUASessions(sigRESP_A,chDepth,j);
H(2) = showPlot_MUASessions(sigRESP_B1,chDepth,j);
H(3) = showPlot_MUASessions(sigRESP_B2,chDepth,j);

save_file_dir = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/zScore';
ABB = {'A','B1','B2'};
for i=1:3
    save_file_name = strcat(animal_name,'_SignificantRespnose_',ABB{i},'tone_',auditory_area);
%     saveas(H(i),fullfile(save_file_dir,save_file_name),'png');
end