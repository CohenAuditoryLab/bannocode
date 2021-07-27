% plot MUA response as a function of 'Target Time'
% The range of the Target Time varied across sessions in Domo, but fixed in
% Cassius.
clear all

animal_name = 'Cassius';
auditory_area = 'Belt'; % either 'Core', 'Belt', or 'All'
isSave = 0; % 1 for saving figure...
tpos = 4; % 4 for T-1, 5 for Target...
% tpos = 2:4; % summary of standard tones (adapting period)

% addpath('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/codes');
root_dir = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
addpath('../');
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code');
load(strcat('RecordingDate_',animal_name));

% set the whole range of target time across sessions
if strcmp(animal_name,'Domo')
    tt_range = 675:225:1800;
    n_ch = 16;
elseif strcmp(animal_name,'Cassius')
    tt_range = 1350:225:2025;
    n_ch = 24;
end

RESP_A = []; RESP_B1 = []; RESP_B2 = []; %chDepth = [];
SIG = []; PREF = [];
for ff=1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
    L3_ch = L3_channel(ff);
    
    f_dir = fullfile(root_dir,rec_date,'RESP');
    f_name = strcat(rec_date,'_SignificantChannels');
    load(fullfile(f_dir,f_name));
    
    % calculate index for each session...
    [~,~,resp,depth,list_tt] = get_MUASignificance_ttime(rec_date,L3_ch,tpos,0); % do not save figure
    
    rA  = resp.A; % channel x ttime x hit-miss
    rB1 = resp.B1;
    rB2 = resp.B2;
    
    i_tpos = find(tt_range==min(list_tt));
    rrA = NaN(n_ch,length(tt_range),2);
    rrB1 = NaN(n_ch,length(tt_range),2);
    rrB2 = NaN(n_ch,length(tt_range),2);
    
    rrA(:,i_tpos:i_tpos+3,:) = rA;
    rrB1(:,i_tpos:i_tpos+3,:) = rB1;
    rrB2(:,i_tpos:i_tpos+3,:) = rB2;
    
    RESP_A = cat(4,RESP_A,rrA);
    RESP_B1 = cat(4,RESP_B1,rrB1);
    RESP_B2 = cat(4,RESP_B2,rrB2);
    
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