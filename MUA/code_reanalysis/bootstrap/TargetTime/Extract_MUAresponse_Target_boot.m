% extract and reorganize data for bootstrap analysis
% modified from Extract_MUAresponse_ABB_boot.m

clear all

% set path for data...
% DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response';
DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
% set path for RecordingDate_Both.mat
INFO_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis';

% sTriplet = {'1st','2nd','3rd','Tm3','Tm2','Tm1','T','Tp1'};
sTriplet = {'T'};

load(fullfile(INFO_PATH,'RecordingDate_Both.mat'));

% obtain zMUA response for Target
sigRESP_T = nan(4,2,24,length(list_RecDate));
for ff = 1:length(list_RecDate)
    fName1 = strcat(list_RecDate{ff},'_zMUAtriplet_','A');
    fName2 = strcat(list_RecDate{ff},'_SignificantChannels');
    load(fullfile(DATA_PATH,list_RecDate{ff},'RESP',fName1));
    load(fullfile(DATA_PATH,list_RecDate{ff},'RESP',fName2));

    zR = zMUA_A.ttime;
    sig_ch = sig.Resp;
    n_ch = length(sig_ch);

    sigR = zR(7,:,:,:); % choose target response 
    sigR(:,:,:,sig_ch==0) = NaN;
    
    % concatenate data across sessions
    % ttime x hit-miss x channel x session
    sigRESP_T(:,:,1:n_ch,ff) = squeeze(sigR);
    clear zMUA_A zR sig sig_ch n_ch sigR
end
% rearrange matrix
% channel x hit-miss x session x ttime
sigRESP_T = permute(sigRESP_T,[3 2 4 1]);

% % obtain zMUA response for BB
% sigRESP_BB = nan(length(sTriplet),2,2,24,length(list_RecDate));
% for ff = 1:length(list_RecDate)
%     fName1 = strcat(list_RecDate{ff},'_zMUAtriplet_','BB');
%     fName2 = strcat(list_RecDate{ff},'_SignificantChannels');
%     load(fullfile(DATA_PATH,list_RecDate{ff},'RESP',fName1));
%     load(fullfile(DATA_PATH,list_RecDate{ff},'RESP',fName2));
% 
%     zR = zMUA_BB.stdiff;
%     sig_ch = sig.Resp;
%     n_ch = length(sig_ch);
% 
%     sigR = zR(:,[1 end],:,:); % choose extreme dF conditions
%     sigR(:,:,:,sig_ch==0) = NaN;
%     
%     % concatenate data across sessions
%     % tpos x easy-hard x hit-miss x channel x session
%     sigRESP_BB(:,:,:,1:n_ch,ff) = sigR;
%     clear zMUA_BB zR sig sig_ch n_ch sigR
% end
% sigRESP_BB = permute(sigRESP_BB,[4 2 3 5 1]);
% 
% % obtain zMUA response for ABB
% sigRESP_ABB = nan(length(sTriplet),2,2,24,length(list_RecDate));
% for ff = 1:length(list_RecDate)
%     fName1 = strcat(list_RecDate{ff},'_zMUAtriplet_','ABB');
%     fName2 = strcat(list_RecDate{ff},'_SignificantChannels');
%     load(fullfile(DATA_PATH,list_RecDate{ff},'RESP',fName1));
%     load(fullfile(DATA_PATH,list_RecDate{ff},'RESP',fName2));
% 
%     zR = zMUA_ABB.stdiff;
%     sig_ch = sig.Resp;
%     n_ch = length(sig_ch);
% 
%     sigR = zR(:,[1 end],:,:); % choose extreme dF conditions
%     sigR(:,:,:,sig_ch==0) = NaN;
%     
%     % concatenate data across sessions
%     % tpos x easy-hard x hit-miss x channel x session
%     sigRESP_ABB(:,:,:,1:n_ch,ff) = sigR;
%     clear zMUA_ABB zR sig sig_ch n_ch sigR
% end
% sigRESP_ABB = permute(sigRESP_ABB,[4 2 3 5 1]);

% rALL.A   = sigRESP_A;
% rALL.BB  = sigRESP_BB;
% rALL.ABB = sigRESP_ABB;
rTarget = sigRESP_T;

% save data...
save_file_name = 'MUAResponse_Target';
save(save_file_name,'rTarget','sTriplet','area_index','AP_index');