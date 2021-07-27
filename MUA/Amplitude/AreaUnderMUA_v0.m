%This program computes the ACF of responses to streaming stimuli, the max
%ACF at the B tone lag and A tone lag and then computes the difference,(A-B)
clear all
close all

ANIMAL = 'Domo';
% set path to the Data directory
DATA_DIR = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/DATA/MUA',ANIMAL);
SAVE_DIR = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results';

params.RecordingDate = '20180807';
params.SampleRate = 24414; % original SR
% params.Baseline = 500; % baseline correction window in ms
% Nyquist = SampleRate/2;
% pointspermsec = SampleRate / 1000;
% msecperpoint = 1 / pointspermsec;

fName = strcat(params.RecordingDate,'_ABBA_MUA'); % data file name
load(fullfile(DATA_DIR,fName));
params.AnalysisWindow = [0 1500]; % analysis time window in ms
nChannel = size(meanMUA,2);

for HorM=1:2 % hit or miss (1 for hit, 2 for miss)
    for i=1:length(list_st)
        MUA_stdiff = meanMUA(:,:,i,HorM); % mean MUA of each semitone diff...
%         resp(:,i,HorM) = get_MUAResponse(t,MUA_stdiff,params.AnalysisWindow); 
        [resp,spont,stim] = get_MUAResponse(t,MUA_stdiff,params.AnalysisWindow);  % original
        MUA_resp(:,i,HorM)  = resp;
        MUA_spont(:,i,HorM) = spont;
        MUA_stim(:,i,HorM)  = stim;
    end
end

% plot
figure;
for i=1:length(list_st)
    H(i) = subplot(2,2,i);
    h = bar(1:nChannel,squeeze(MUA_resp(:,i,:)));
%     h = bar(1:nChannel,squeeze(MUA_spont(:,i,:)));
    set(h(1),'FaceColor','r');
    set(h(2),'FaceColor','b');
    set(H(i),'Xlim',[0 nChannel+1]);
    xlabel('Channel'); ylabel('area under the MUA');
    title([num2str(list_st(i)) ' semitone difference']);
    box off;
end
% save figure
save_fig_name = strcat(params.RecordingDate,'_RESP');
% saveas(gcf,fullfile(SAVE_DIR,params.RecordingDate,'RESP',save_fig_name),'png');


% save data
save_file_name = strcat(params.RecordingDate,'_MUAAmplitude');
% save(fullfile(SAVE_DIR,params.RecordingDate,'RESP',save_file_name), ...
%     'MUA_resp','MUA_spont','MUA_stim','list_st');

close all