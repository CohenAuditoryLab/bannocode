clear all
close all

params.RecordingDate = '20181210';
params.SampleRate = 24414; %original SR
params.Baseline = 1000; %baseline correction window in ms
% Nyquist = SampleRate/2;
% pointspermsec = SampleRate/1000;
% msecperpoint = 1/pointspermsec;

% set path to the Data directory
ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
DATA_DIR = fullfile(ROOT_DIR,params.RecordingDate,'RESP');
SAVE_DIR = fullfile(ROOT_DIR,params.RecordingDate,'FFT');


% data_file_name = strcat(params.RecordingDate,'_ABBA_MUA');
data_file_name = strcat(params.RecordingDate,'_zMUAtriplet');
load(fullfile(DATA_DIR,data_file_name));

meanMUA = zMUA.stdiff;
for HorM=1:2 % hit or miss (1 for hit, 2 for miss)
    for i=1:length(list_st)
        MUA_stdiff = meanMUA(:,:,i,HorM); % mean MUA of each semitone diff...
        
        % get FFT peaks at A rate (4.4 Hz) and A+B rate (13.3 Hz)
        % normalized by CD (0 Hz)
        nPeak = getFFTMag_AB(MUA_stdiff,t,params);

        % peak FFT amplitude in all conditions...
        nPeak_all(:,:,i,HorM) = nPeak;
        
        % save figure
        string = strcat(params.RecordingDate,'_FFT_',num2str(list_st(i)),'ST');
        if HorM==1
            save_file_name = strcat(string,'_hit');
        elseif HorM==2
            save_file_name = strcat(string,'_miss');
        end
        saveas(gcf,fullfile(SAVE_DIR,save_file_name),'png');
        
        clear nPeak
        close all
    end
end
% nPeak_all -- (Arate-ABrate) x ch x stdiff x (Hit-Miss) 

% save data
save_file_name = strcat(params.RecordingDate,'_FFT');
save(fullfile(SAVE_DIR,save_file_name),'nPeak_all','list_st');
% save(fullfile(SAVE_DIR,params.RecordingDate,save_file_name), ...
%     'meanZ_1SRM','meanZ_2SRM','list_st');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nPeak_smallF = squeeze(nPeak_all(:,:,1,:));
nPeak_largeF = squeeze(nPeak_all(:,:,end,:));

bargraph_FFTPeaks_DC(nPeak_smallF);
sName = strcat(params.RecordingDate,'_DCNormaizedFFT_smallF');
saveas(gcf,fullfile(SAVE_DIR,sName),'png');

bargraph_FFTPeaks_DC(nPeak_largeF);
sName = strcat(params.RecordingDate,'_DCNormaizedFFT_largeF');
saveas(gcf,fullfile(SAVE_DIR,sName),'png');

close all;