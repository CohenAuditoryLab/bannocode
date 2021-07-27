% plot MUA response as a function of 'Target Position'
% the Target Position 1 indicates the shortest target time in the session,
% and the Target Position 4 indicates the longest target time in the
% session.
clear all

animal_name = 'Domo'; % either 'Domo', 'Cassius', or 'Both'
auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
layer = 'Deep'; % either 'Sup' or 'Deep'
isSave = 1; % 1 for saving figure...
tpos = 5; % 4 for T-1, 5 for Target...
% tpos = 2:4; % summary of standard tones (adapting period)

% addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
addpath('../');
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code');
load(strcat('RecordingDate_',animal_name));
root_dir = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';

% if strcmp(animal_name,'Domo')
%     tt_range = 675:225:1800;
%     n_ch = 16;
% elseif strcmp(animal_name,'Cassius')
%     tt_range = 1350:225:2025;
%     n_ch = 24;
% end
tt_range = 1:4; % target position 1-4...

RESP_A = []; RESP_B1 = []; RESP_B2 = []; %chDepth = [];
SIG = []; PREF = [];
for ff=1:numel(list_RecDate)
    rA_init  = NaN(24,4,2); % channel x ttime x hit-miss
    rB1_init = NaN(24,4,2);
    rB2_init = NaN(24,4,2);
    s_init = NaN(24,1);
    p_init = NaN(24,1);
    
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    
    f_dir = fullfile(root_dir,rec_date,'RESP');
    f_name = strcat(rec_date,'_SignificantChannels');
    load(fullfile(f_dir,f_name));
    
    % calculate index for each session...
%     [sig,sigResp,resp,depth] = get_MUASignificance_tpos(rec_date,L3_ch,tpos,isSave);
    [~,~,resp,depth,list_tt] = get_MUASignificance_ttime(rec_date,L3_ch,tpos,0); % do not save figure
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
    
    rA  = resp.A; % channel x ttime x hit-miss
    rB1 = resp.B1;
    rB2 = resp.B2;
    nCh = size(rA,1); % number of channels
    
    % select depth to analize...
    rA(i_depth,:,:) = NaN;
    rB1(i_depth,:,:) = NaN;
    rB2(i_depth,:,:) = NaN;
    
    rA_init(1:nCh,:,:)  = rA;
    rB1_init(1:nCh,:,:) = rB1;
    rB2_init(1:nCh,:,:) = rB2;
    
    RESP_A = cat(4,RESP_A,rA_init);
    RESP_B1 = cat(4,RESP_B1,rB1_init);
    RESP_B2 = cat(4,RESP_B2,rB2_init);
    
    % use significant channels from xx_SignificantChannels.mat
    if isnan(L3_ch) % layers cannot be determined in some sessions...
        s_temp = NaN(size(sig.Resp));
        p_temp = NaN(size(sig.Resp));
    else
        s_temp = sig.Resp;
        p_temp = pref.A;
    end
    s_temp(i_depth,:) = NaN; % select depth
    s_init(1:nCh) = sig.Resp;
    s = repmat(s_init,[1 length(tt_range)]);
    ss = cat(3,s,s);
    SIG = cat(4,SIG,ss);
    clear s_temp s ss
    
    p_temp(i_depth,:) = NaN; % select depth
    p_init(1:nCh) = pref.A;
    p = repmat(p_init,[1 length(tt_range)]);
    pp = cat(3,p,p);
    PREF = cat(4,PREF,pp);
    clear p_temp p pp
    
    clear rA_init rB1_init rB2_init s_init p_init
end
% SIG = SIG_A + SIG_B1 + SIG_B2;
sigRESP_A  = RESP_A;  sigRESP_A(SIG~=1)  = NaN;
sigRESP_B1 = RESP_B1; sigRESP_B1(SIG~=1) = NaN;
sigRESP_B2 = RESP_B2; sigRESP_B2(SIG~=1) = NaN;

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
sigRESP_A  = sigRESP_A(:,:,:,j); % channel x ttime x hit-miss x session
sigRESP_B1 = sigRESP_B1(:,:,:,j);
sigRESP_B2 = sigRESP_B2(:,:,:,j);

% number of significant channels...
nn = ~isnan(sigRESP_A);
nSig = sum(nn,4); nSig = permute(sum(nSig,1),[2 3 1]);

% plot figure...
H = figure;
subplot(2,2,1);
plot_sigMUA_ttime(tt_range,sigRESP_A);
title('A');

subplot(2,2,3);
plot_sigMUA_ttime(tt_range,sigRESP_B1);
title('B1');

subplot(2,2,4);
plot_sigMUA_ttime(tt_range,sigRESP_B2);
title('B2');

legend({'Hit','Miss'},'Location',[0.5 0.82 0.1 0.1]);

s_triplet = {'1stTriplet','2ndTriplet','3rdTriplet','Tm1Triplet','TTriplet'};
if isSave==1
%     root_save_file_dir = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response';
    root_save_file_dir = fullfile(root_dir,'AcrossSessions','Response','Depth');
    save_file_dir = fullfile(root_save_file_dir,layer,strcat('zScore_',s_triplet{tpos}),'TargetPosition');
    save_file_name = strcat(animal_name,'_CompMUAResp_tpos_',auditory_area);
    saveas(H,fullfile(save_file_dir,save_file_name),'png');
    
    if strcmp(auditory_area,'All')
        sigRESP = struct('A',sigRESP_A,'B1',sigRESP_B1,'B2',sigRESP_B2);
%         p = struct('anova',p_anova,'level',p_level,'group',p_group);
        save_file_name = strcat(animal_name,strcat('_zMUAResp_tpos_',s_triplet{tpos}));
        save(fullfile(save_file_dir,save_file_name),'sigRESP','SIG','PREF','area_index');
    end
end