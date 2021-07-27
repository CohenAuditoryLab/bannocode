clear all

animal_name = 'Domo';
auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
isSave = 1; % 1 for saving figure...
tpos = 1; % triplet position (choose from 1-5)
% tpos = 2:4; % summary of standard tones (adapting period)

% addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
addpath('../');
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code');
load(strcat('RecordingDate_',animal_name));
root_dir = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';

RESP_A = []; RESP_B1 = []; RESP_B2 = []; %chDepth = [];
% SIG_A = []; SIG_B1 = []; SIG_B2 = [];
SIG = []; PREF = [];
for ff=1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    
    f_dir = fullfile(root_dir,rec_date,'RESP');
    f_name = strcat(rec_date,'_SignificantChannels');
    load(fullfile(f_dir,f_name));
    
    % calculate index for each session...
%     [sig,sigResp,resp,depth] = get_MUASignificance_tpos(rec_date,L3_ch,tpos,isSave);
    [~,~,resp,depth] = get_MUASignificance_tpos_stdiff(rec_date,L3_ch,tpos,0); % do not save figure
    
    rA  = resp.A;
    rB1 = resp.B1;
    rB2 = resp.B2;
    
    rA_easyhard  = rA(:,[1 end],:);
    rB1_easyhard = rB1(:,[1 end],:);
    rB2_easyhard = rB2(:,[1 end],:);

    RESP_A = cat(4,RESP_A,rA_easyhard);
    RESP_B1 = cat(4,RESP_B1,rB1_easyhard);
    RESP_B2 = cat(4,RESP_B2,rB2_easyhard);
    
    % use significant channels from xx_SignificantChannels.mat
    s = repmat(sig.Resp,[1 2]);
    ss = cat(3,s,s);
    SIG = cat(4,SIG,ss);
    clear s ss
    
    p = repmat(pref.A,[1 2]);
    pp = cat(3,p,p);
    PREF = cat(4,PREF,pp);
    clear p pp
end
% SIG = SIG_A + SIG_B1 + SIG_B2;
sigRESP_A  = RESP_A;  sigRESP_A(SIG==0)  = NaN;
sigRESP_B1 = RESP_B1; sigRESP_B1(SIG==0) = NaN;
sigRESP_B2 = RESP_B2; sigRESP_B2(SIG==0) = NaN;

% chDepth = chDepth';
% aIndex = area_index(~isnan(L3_channel)); % need to remove later
aIndex = area_index;

j = 1:length(aIndex);
if strcmp(auditory_area,'Core')
    j = j(aIndex==1);
elseif strcmp(auditory_area,'Belt')
    j = j(aIndex==0);
end

% number of significant channels...
% nSig_A = sum(SIG_A,4); nSig_A = permute(sum(nSig_A,1),[2 3 1]);
% nSig_B1 = sum(SIG_B1,4); nSig_B1 = permute(sum(nSig_B1,1),[2 3 1]);
% nSig_B2 = sum(SIG_B2,4); nSig_B2 = permute(sum(nSig_B2,1),[2 3 1]);
nSig = sum(SIG(:,:,:,j),4); nSig = permute(sum(nSig,1),[2 3 1]);

% choose sessions for analysis (core, belt or all)
sigRESP_A  = sigRESP_A(:,:,:,j);
sigRESP_B1 = sigRESP_B1(:,:,:,j);
sigRESP_B2 = sigRESP_B2(:,:,:,j);

% plot figure...
H = figure;
h(1) = subplot(2,2,1);
bargraph_SessionSummary(sigRESP_A);
y_range(1,:) = get(gca,'YLim');
ylabel('MUA response [z-score]');
title('A');
h(2) = subplot(2,2,3);
bargraph_SessionSummary(sigRESP_B1);
y_range(2,:) = get(gca,'YLim');
ylabel('MUA response [z-score]');
title('B1');
h(3) = subplot(2,2,4);
bargraph_SessionSummary(sigRESP_B2);
y_range(3,:) = get(gca,'YLim');
ylabel('MUA response [z-score]');
title('B2');
set(h,'YLim',[min(y_range(:,1)) max(y_range(:,2))]);

% statistical test...
[p_anova(:,1), p_level(:,1), p_group(:,1)] = stats_SessionSummary(sigRESP_A);
[p_anova(:,2), p_level(:,2), p_group(:,2)] = stats_SessionSummary(sigRESP_B1);
[p_anova(:,3), p_level(:,3), p_group(:,3)] = stats_SessionSummary(sigRESP_B2);

s_triplet = {'1stTriplet','2ndTriplet','3rdTriplet','Tm1Triplet','TTriplet'};
if isSave==1
%     root_save_file_dir = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response';
    root_save_file_dir = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
    save_file_dir = fullfile(root_save_file_dir,strcat('zScore_',s_triplet{tpos}));
    save_file_name = strcat(animal_name,'_CompMUAResp_',auditory_area);
    saveas(H,fullfile(save_file_dir,save_file_name),'png');
    
    if strcmp(auditory_area,'All')
        sigRESP = struct('A',sigRESP_A,'B1',sigRESP_B1,'B2',sigRESP_B2);
        p = struct('anova',p_anova,'level',p_level,'group',p_group);
        save_file_name = strcat(animal_name,strcat('_zMUAResp_',s_triplet{tpos}));
        save(fullfile(root_save_file_dir,save_file_name),'sigRESP','SIG','PREF','p','area_index');
    end
end