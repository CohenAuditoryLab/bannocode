% plot MUA response as a function of 'Target Position'
% the Target Position 1 indicates the shortest target time in the session,
% and the Target Position 4 indicates the longest target time in the
% session.
clear all

animal_name = 'Domo'; % either 'Domo' or 'Cassius'
auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
isSave = 0; % 1 for saving figure...
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
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    
    f_dir = fullfile(root_dir,rec_date,'RESP');
    f_name = strcat(rec_date,'_SignificantChannels');
    load(fullfile(f_dir,f_name));
    
    % calculate index for each session...
%     [sig,sigResp,resp,depth] = get_MUASignificance_tpos(rec_date,L3_ch,tpos,isSave);
    [~,~,resp,depth,list_tt] = get_MUASignificance_ttime(rec_date,L3_ch,tpos,0); % do not save figure
    
    rA  = resp.A; % channel x ttime x hit-miss
    rB1 = resp.B1;
    rB2 = resp.B2;
    
    RESP_A = cat(4,RESP_A,rA);
    RESP_B1 = cat(4,RESP_B1,rB1);
    RESP_B2 = cat(4,RESP_B2,rB2);
    
    % use significant channels from xx_SignificantChannels.mat
%     s = repmat(sig.Resp,[1 4]);
    s = repmat(sig.Resp,[1 length(tt_range)]);
    ss = cat(3,s,s);
    SIG = cat(4,SIG,ss);
    clear s ss
    
%     p = repmat(pref.A,[1 4]);
    p = repmat(pref.A,[1 length(tt_range)]);
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


% s_triplet = 'TTriplet';
% if isSave==1
% %     root_save_file_dir = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response';
%     root_save_file_dir = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
%     save_file_dir = fullfile(root_save_file_dir,strcat('zScore_',s_triplet));
%     save_file_name = strcat(animal_name,'_CompMUAResp_ttime_',auditory_area);
%     saveas(H,fullfile(save_file_dir,save_file_name),'png');
%     
% %     if strcmp(auditory_area,'All')
% %         sigRESP = struct('A',sigRESP_A,'B1',sigRESP_B1,'B2',sigRESP_B2);
% %         p = struct('anova',p_anova,'level',p_level,'group',p_group);
% %         save_file_name = strcat(animal_name,strcat('_zMUAResp_',s_triplet));
% %         save(fullfile(root_save_file_dir,save_file_name),'sigRESP','p','area_index');
% %     end
% end