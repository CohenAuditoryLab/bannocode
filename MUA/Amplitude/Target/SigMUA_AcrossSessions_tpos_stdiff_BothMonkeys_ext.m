% 8/25/22 modifed to get T+1 triplet period 
clear all
global ROOT_DIR

animal_name = 'Both';
auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
isSave = 0; % 1 for saving figure...
tpos = 6; % triplet position (choose from 1-6)
AorB = NaN; % choose channels by preference; 0 for A, 1 for B, NaN for no selection
% tpos = 2:4; % summary of standard tones (adapting period)

ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA';
% addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
addpath('../');
addpath(fullfile(ROOT_DIR,'code'));
load(strcat('RecordingDate_',animal_name));
root_dir = fullfile(ROOT_DIR,'Results');

RESP_A = []; RESP_B1 = []; RESP_B2 = []; %chDepth = [];
% SIG_A = []; SIG_B1 = []; SIG_B2 = [];
SIG = []; PREF = [];
for ff=1:numel(list_RecDate)
    rA_easyhard  = NaN(24,2,2);
    rB1_easyhard = NaN(24,2,2);
    rB2_easyhard = NaN(24,2,2);
    s_init = NaN(24,1);
    p_init = NaN(24,1);
    
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    
    f_dir = fullfile(root_dir,rec_date,'RESP');
    f_name = strcat(rec_date,'_SignificantChannels');
    load(fullfile(f_dir,f_name));
    
    % calculate index for each session...
%     [sig,sigResp,resp,depth] = get_MUASignificance_tpos(rec_date,L3_ch,tpos,isSave);
    [~,~,resp,depth] = get_MUASignificance_tpos_stdiff_ext(rec_date,L3_ch,tpos); % do not save figure
    
    rA  = resp.A;
    rB1 = resp.B1;
    rB2 = resp.B2;
    nCh = size(rA,1); % number of channels
    
    rA_easyhard(1:nCh,:,:)  = rA(:,[1 end],:);
    rB1_easyhard(1:nCh,:,:) = rB1(:,[1 end],:);
    rB2_easyhard(1:nCh,:,:) = rB2(:,[1 end],:);

    RESP_A = cat(4,RESP_A,rA_easyhard);
    RESP_B1 = cat(4,RESP_B1,rB1_easyhard);
    RESP_B2 = cat(4,RESP_B2,rB2_easyhard);
    
    % use significant channels from xx_SignificantChannels.mat
    s_init(1:nCh) = sig.Resp;
    s = repmat(s_init,[1 2]);
    ss = cat(3,s,s);
    SIG = cat(4,SIG,ss);
    clear s ss
    
    p_init(1:nCh) = pref.A;
    p = repmat(p_init,[1 2]);
    pp = cat(3,p,p);
    PREF = cat(4,PREF,pp);
    clear p pp
end
% SIG = SIG_A + SIG_B1 + SIG_B2;
sigRESP_A  = RESP_A;  sigRESP_A(SIG==0)  = NaN;
sigRESP_B1 = RESP_B1; sigRESP_B1(SIG==0) = NaN;
sigRESP_B2 = RESP_B2; sigRESP_B2(SIG==0) = NaN;

% select neurons by preference (A or B)
if ~isnan(AorB)
    sigRESP_A(PREF==AorB) = NaN;
    sigRESP_B1(PREF==AorB) = NaN;
    sigRESP_B2(PREF==AorB) = NaN;
end

% chDepth = chDepth';
% aIndex = area_index(~isnan(L3_channel)); % need to remove later
aIndex = area_index;

j = 1:length(aIndex);
if strcmp(auditory_area,'Core')
    j = j(aIndex==1);
elseif strcmp(auditory_area,'Belt')
    j = j(aIndex==0);
end

% choose sessions for analysis (core, belt or all)
sigRESP_A  = sigRESP_A(:,:,:,j);
sigRESP_B1 = sigRESP_B1(:,:,:,j);
sigRESP_B2 = sigRESP_B2(:,:,:,j);

% number of significant channels...
nn = ~isnan(sigRESP_A);
nSig = nansum(nn,4); nSig = permute(sum(nSig,1),[2 3 1]);

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

s_triplet = {'1stTriplet','2ndTriplet','3rdTriplet','Tm1Triplet','TTriplet','Tp1Triplet'};
if isSave==1
    if AorB==0
        folder = 'prefA';
    elseif AorB==1
        folder = 'prefB';
    elseif isnan(AorB)
        folder = 'AllCombined';
    end
%     root_save_file_dir = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
    root_save_file_dir = fullfile(ROOT_DIR,'Results\AcrossSessions\Response');
    save_file_dir = fullfile(root_save_file_dir,folder,strcat('zScore_',s_triplet{tpos}));
    save_file_name = strcat(animal_name,'_CompMUAResp_',auditory_area);
    saveas(H,fullfile(save_file_dir,save_file_name),'png');
    
    if strcmp(auditory_area,'All')
        sigRESP = struct('A',sigRESP_A,'B1',sigRESP_B1,'B2',sigRESP_B2);
        p = struct('anova',p_anova,'level',p_level,'group',p_group);
        save_file_name = strcat(animal_name,strcat('_zMUAResp_',s_triplet{tpos}));
        save(fullfile(root_save_file_dir,folder,save_file_name),'sigRESP','SIG','PREF','p','area_index');
    end
end