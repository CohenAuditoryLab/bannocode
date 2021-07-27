clear all

animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
% auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
layer = 'Sup'; % either 'Sup' or 'Deep' or NaN
isSave = 1; % 1 for saving figure...
AorB = NaN; % choose channels by preference; 0 for A, 1 for B, NaN for no selection
% blpos = 2; % triplet position (choose from 1-5)
% blpos = 1:2; % summary of standard tones (adapting period)


% addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
addpath('../');
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code');
load(strcat('RecordingDate_',animal_name));
root_dir = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';

RESP_BL = []; %chDepth = [];
SIG = []; PREF = [];
for ff=1:numel(list_RecDate)
    rBL_init  = NaN(24,2,3);
    s_init = NaN(24,1);
    p_init = NaN(24,1);
    
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    
    f_dir = fullfile(root_dir,rec_date,'RESP');
    f_name = strcat(rec_date,'_SignificantChannels');
    load(fullfile(f_dir,f_name));
    
    % get MUA response in each session...
%     [sig,sigResp,resp,depth] = get_MUASignificance_tpos(rec_date,L3_ch,tpos,isSave);
    [~,~,resp,depth] = get_MUASignificance_baseline(rec_date,L3_ch); % do not save figure
    
    rBL = resp;
    nCh = size(rBL,1); % number of channels
    
    % select layer to analize...
    if isnan(layer) % if layer is not specified...
        i_depth = [];
    else
        i_depth = 1:length(depth);
        if strcmp(layer,'Sup')
            i_depth = i_depth(depth>0); % select superficial layer
        elseif strcmp(layer,'Deep')
            i_depth = i_depth(depth<=0); % select deep layer
        end
        if isnan(L3_ch)
            % remove session from analysis if layers cannot be determined...
            i_depth = 1:length(depth);
        end
    end
    
    % select depth to analize...
    rBL(i_depth,:,:) = NaN;
    % combine sessions having different number of channels...
    rBL_init(1:nCh,:,:) = rBL;
    RESP_BL = cat(4,RESP_BL,rBL_init);
    
    % use significant channels from xx_SignificantChannels.mat
    if isnan(L3_ch) % layers cannot be determined in some sessions...
        s_temp = NaN(size(sig.Resp));
        p_temp = NaN(size(sig.Resp));
    else
        s_temp = sig.Resp;
        p_temp = pref.A;
    end
    s_temp(i_depth,:) = NaN; % select depth
    s_init(1:nCh) = s_temp;
    s = repmat(s_init,[1 2]);
    ss = cat(3,s,s,s);
    SIG = cat(4,SIG,ss);
    clear s_temp s ss
    
    p_temp(i_depth,:) = NaN; % select depth
    p_init(1:nCh) = p_temp;
    p = repmat(p_init,[1 2]);
    pp = cat(3,p,p,p);
    PREF = cat(4,PREF,pp);
    clear p_temp p pp
    
    clear rBL_init s_init p_init
end
% SIG = SIG_A + SIG_B1 + SIG_B2;
sigRESP_BL = RESP_BL; sigRESP_BL(SIG~=1) = NaN;

% select neurons by preference (A or B)
if ~isnan(AorB)
    sigRESP_BL(PREF==AorB) = NaN;
end

% select sessions (Core, Belt, or All)
aIndex = area_index;
j = 1:length(aIndex);
j_core = j(aIndex==1); % select sessions from Core
j_belt = j(aIndex==0); % select sessions from Belt

% choose sessions for analysis (core, belt or all)
sigRESP_BL_core = sigRESP_BL(:,:,:,j_core);
sigRESP_BL_belt = sigRESP_BL(:,:,:,j_belt);

% number of significant channels...
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

% % statistical test...
[H(1,:), P(1,:)] = stats_Baseline(sigRESP_BL);
[H(2,:), P(2,:)] = stats_Baseline(sigRESP_BL_core);
[H(3,:), P(3,:)] = stats_Baseline(sigRESP_BL_belt);

% save figure...
if isSave==1
%     if AorB==0
%         folder = 'prefA';
%     elseif AorB==1
%         folder = 'prefB';
%     elseif isnan(AorB)
%         folder = 'AllCombined';
%     end
%     root_save_file_dir = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
    save_file_dir = fullfile(root_dir,'AcrossSessions','Response','BaselineActivity','Depth');
%     save_file_dir = fullfile(root_save_file_dir,layer);
    save_file_name = strcat(animal_name,'_CompBaselineActivity_',layer);
    saveas(gcf,fullfile(save_file_dir,save_file_name),'png');
    
%     if strcmp(auditory_area,'All')
%         sigRESP = struct('A',sigRESP_A,'B1',sigRESP_B1,'B2',sigRESP_B2);
%         p = struct('anova',p_anova,'level',p_level,'group',p_group);
%         save_file_name = strcat(animal_name,strcat('_zMUAResp_',s_triplet{tpos}));
%         save(fullfile(root_save_file_dir,layer,save_file_name),'sigRESP','SIG','PREF','p','area_index');
%     end
end