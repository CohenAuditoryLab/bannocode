%This program computes the area under the MUA for 150-ms BB periods
% code modified from AreaUnderMUA_zScore_emergence
clear all
close all
addpath('myFunction'); % path for dependent function...

ANIMAL = 'Cassius'; % either 'Domo' or 'Cassius';
% set path to the Data directory
DATA_DIR = fullfile('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\DATA',ANIMAL,'MUA');
SAVE_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
th = 1.96; % 95% threshold of z-score
% th = 2.58; % 99% threshold of z-score
sTriplet = {'1st','2nd','3rd','T-3','T-2','T-1','T'};

params.RecordingDate = '20210403';
params.SampleRate = 24414.0625; % original SR
% params.Baseline = 500; % baseline correction window in ms
% Nyquist = SampleRate/2;
% pointspermsec = SampleRate / 1000;
% msecperpoint = 1 / pointspermsec;

fName = strcat(params.RecordingDate,'_ABBA_MUA'); % data file name
load(fullfile(DATA_DIR,fName));
params.AnalysisWindow = [0 1500]; % analysis time window in ms
nChannel = size(meanMUA{1,1,1},2);

for HorM=1:2 % hit or miss (1 for hit, 2 for miss)
    for i=1:length(list_st)
        for j=1:length(list_tt)
            tpos = list_tt(j) / 225 + 1;
%             i_tpos = [1:3 tpos-1 tpos];
%             i_tpos = tpos-3:tpos;
            i_tpos = [1:3 tpos-3:tpos]; %{1st,2nd,3rd,T-3,T-2,T-1,T}
            MUA_condition = meanMUA{i,j,HorM}; % mean MUA of each semitone diff...
%         [resp,spont,stim] = get_MUAResponse(t,MUA_stdiff,params.AnalysisWindow);  % original
%         [abb,trp] = get_MUAResponse_AB(t,MUA_stdiff);
            a = get_zMUAResponse_A(t,MUA_condition,params);
%             abb_tpos = abb(:,i_tpos,:);
%             zABB(:,:,:,i,j,HorM)  = abb_tpos; % ABB x triplet pos x ch x stdiff x ttime x behav
            a_tpos = a(i_tpos,:);
            zA(:,:,i,j,HorM)  = a_tpos; % triplet pos x ch x stdiff x ttime x behav
%         triplet(:,:,i,HorM) = trp;
        end
    end
end

n_ttime = sum(nTrial,1);
n_stdiff = sum(nTrial,2);
for k=1:2 % hit vs miss
    w_ttime = nTrial(:,:,k) ./ ( ones(length(list_st),1) * n_ttime(:,:,k) );
    w_stdiff = nTrial(:,:,k) ./ ( n_stdiff(:,:,k) * ones(1,length(list_tt)) );
    for i=1:length(list_st)
        for j=1:length(list_tt)
            if nTrial(i,j,k) == 0
                meanMUA{i,j,k} = zeros(size(meanMUA{i,j,k}));
%                 zABB(:,:,:,i,j,k) = zeros(3,length(i_tpos),nChannel);
                zA(:,:,i,j,k) = zeros(length(i_tpos),nChannel);
            end
            MUA_stdiff(:,:,i,j,k) = meanMUA{i,j,k} * w_stdiff(i,j);
            MUA_ttime(:,:,i,j,k) = meanMUA{i,j,k} * w_ttime(i,j);
%             zABB_stdiff(:,:,:,i,j,k) = zABB(:,:,:,i,j,k) * w_stdiff(i,j);
%             zABB_ttime(:,:,:,i,j,k) = zABB(:,:,:,i,j,k) * w_ttime(i,j);
            zA_stdiff(:,:,i,j,k) = zA(:,:,i,j,k) * w_stdiff(i,j);
            zA_ttime(:,:,i,j,k) = zA(:,:,i,j,k) * w_ttime(i,j);
        end
    end
end
MUA_stdiff = squeeze(sum(MUA_stdiff,4)); % average across target time
MUA_ttime = squeeze(sum(MUA_ttime,3)); % average across stdiff
% zABB_stdiff = squeeze(sum(zABB_stdiff,5)); % average across target time
% zABB_ttime = squeeze(sum(zABB_ttime,4)); % average across stdiff
zA_stdiff = squeeze(sum(zA_stdiff,4)); % average across target time
zA_ttime = squeeze(sum(zA_ttime,3)); % average across stdiff


% % plot
% [h,fName] = show_zTriplet_stdiff(zABB_stdiff,list_st,params.RecordingDate);
% for i=1:length(list_st)
%     saveas(h(i),fullfile(SAVE_DIR,params.RecordingDate,'RESP','Emergence',fName{i}),'png');
% end
% clear h fName;
% close all
% 
% [h,fName] = show_zTriplet_ttime(zABB_ttime,list_tt,params.RecordingDate);
% for j=1:length(list_tt)
%     saveas(h(j),fullfile(SAVE_DIR,params.RecordingDate,'RESP','Emergence',fName{j}),'png');
% end
% clear h fName;
% close all


% reorganize data for saving...
% zABB_stdiff = permute(zABB_stdiff,[2 4 5 3 1]);
% zABB_ttime = permute(zABB_ttime,[2 4 5 3 1]);
% zMUA_A.stdiff  = zABB_stdiff(:,:,:,:,1); % triplet pos x stdiff x behav x channel
% zMUA_B1.stdiff = zABB_stdiff(:,:,:,:,2);
% zMUA_B2.stdiff = zABB_stdiff(:,:,:,:,3);
% zMUA_A.ttime  = zABB_ttime(:,:,:,:,1); % triplet pos x ttime x behav x channel
% zMUA_B1.ttime = zABB_ttime(:,:,:,:,2);
% zMUA_B2.ttime = zABB_ttime(:,:,:,:,3);

zA_stdiff = permute(zA_stdiff,[1 3 4 2]); % tpos x stdiff x behav x channel
zA_ttime = permute(zA_ttime,[1 3 4 2]); % tpos x ttime x behav x channel
zMUA_A.stdiff  = zA_stdiff; % triplet pos x stdiff x behav x channel
zMUA_A.ttime  = zA_ttime; % triplet pos x ttime x behav x channel

zMUA.stdiff = MUA_stdiff;
zMUA.ttime = MUA_ttime;

% save data
save_file_name = strcat(params.RecordingDate,'_zMUAtriplet_A');
% save(fullfile(SAVE_DIR,params.RecordingDate,'RESP',save_file_name), ...
%     'zMUA_ABB','zMUA','t','list_st','list_tt');
save(fullfile(SAVE_DIR,params.RecordingDate,'RESP',save_file_name), ...
    'zMUA_A','sTriplet','list_st','list_tt');

close all