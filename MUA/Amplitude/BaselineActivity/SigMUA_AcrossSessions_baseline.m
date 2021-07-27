clear all

animal_name = 'Cassius';
% auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
isSave = 0; % 1 for saving figure...
% blpos = 2; % baseline position; 1 = [-575 -500], 2 = [-75 0]
% blpos = 1:2; % average of baseline...

% addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
addpath('../');
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code');
load(strcat('RecordingDate_',animal_name));
root_dir = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';

RESP_BL = []; %chDepth = [];
SIG = []; PREF = [];
for ff=1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    
    f_dir = fullfile(root_dir,rec_date,'RESP');
    f_name = strcat(rec_date,'_SignificantChannels');
    load(fullfile(f_dir,f_name));
    
    % calculate index for each session...
%     [sig,sigResp,resp,depth] = get_MUASignificance_tpos(rec_date,L3_ch,tpos,isSave);
    [~,~,resp,depth] = get_MUASignificance_baseline(rec_date,L3_ch); % do not save figure
    
    rBL = resp;

    RESP_BL = cat(4,RESP_BL,rBL); % channel x blpos x behav x session
    
    % use significant channels from xx_SignificantChannels.mat
    s = repmat(sig.Resp,[1 2]);
    ss = cat(3,s,s,s);
    SIG = cat(4,SIG,ss); % channel x blpos x behav x session
    clear s ss
    
    p = repmat(pref.A,[1 2]);
    pp = cat(3,p,p,p);
    PREF = cat(4,PREF,pp);
    clear p pp
end
% SIG = SIG_A + SIG_B1 + SIG_B2;
sigRESP_BL = RESP_BL; sigRESP_BL(SIG~=1) = NaN;

% chDepth = chDepth';
% aIndex = area_index(~isnan(L3_channel)); % need to remove later
aIndex = area_index;

j = 1:length(aIndex);
j_core = j(aIndex==1); % select sessions from Core
j_belt = j(aIndex==0); % select sessions from Belt
% if strcmp(auditory_area,'Core')
%     j = j(aIndex==1);
% elseif strcmp(auditory_area,'Belt')
%     j = j(aIndex==0);
% end

% choose sessions for analysis (core, belt or all)
sigRESP_BL_core = sigRESP_BL(:,:,:,j_core);
sigRESP_BL_belt = sigRESP_BL(:,:,:,j_belt);

% count number of significant channels...
nn = ~isnan(sigRESP_BL);
nn_core = ~isnan(sigRESP_BL_core);
nn_belt = ~isnan(sigRESP_BL_belt);
nSig = nansum(nn,4); nSig = permute(sum(nSig,1),[2 3 1]);
nSig_core = nansum(nn_core,4); nSig_core = permute(sum(nSig_core,1),[2 3 1]);
nSig_belt = nansum(nn_belt,4); nSig_belt = permute(sum(nSig_belt,1),[2 3 1]);

% plot figure...
figure;
h(1) = subplot(2,2,1);
bargraph_Baseline(sigRESP_BL);
y_range(1,:) = get(gca,'YLim');
xlabel('baseline period [ms]');
ylabel('MUA response [z-score]');
title('Baseline Activity ALL');
h(2) = subplot(2,2,3);
bargraph_Baseline(sigRESP_BL_core);
y_range(2,:) = get(gca,'YLim');
xlabel('baseline period [ms]');
ylabel('MUA response [z-score]');
title('Baseline Activity CORE');
h(3) = subplot(2,2,4);
bargraph_Baseline(sigRESP_BL_belt);
y_range(3,:) = get(gca,'YLim');
xlabel('baseline period [ms]');
ylabel('MUA response [z-score]');
title('Baseline Activity BELT');
set(h,'YLim',[min(y_range(:,1)) max(y_range(:,2))]);

legend({'HIT','MISS'},'Location',[0.5 0.82,0.1,0.1]);

% statistical test...
[H(1,:), P(1,:)] = stats_Baseline(sigRESP_BL);
[H(2,:), P(2,:)] = stats_Baseline(sigRESP_BL_core);
[H(3,:), P(3,:)] = stats_Baseline(sigRESP_BL_belt);


% s_triplet = {'1stTriplet','2ndTriplet','3rdTriplet','Tm1Triplet','TTriplet'};
% if isSave==1
% %     root_save_file_dir = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response';
%     root_save_file_dir = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
%     save_file_dir = fullfile(root_save_file_dir,strcat('zScore_',s_triplet{tpos}));
%     save_file_name = strcat(animal_name,'_CompMUAResp_',auditory_area);
%     saveas(H,fullfile(save_file_dir,save_file_name),'png');
%     
%     if strcmp(auditory_area,'All')
%         sigRESP = struct('A',sigRESP_A,'B1',sigRESP_B1,'B2',sigRESP_B2);
%         p = struct('anova',p_anova,'level',p_level,'group',p_group);
%         save_file_name = strcat(animal_name,strcat('_zMUAResp_',s_triplet{tpos}));
%         save(fullfile(root_save_file_dir,save_file_name),'sigRESP','SIG','PREF','p','area_index');
%     end
% end