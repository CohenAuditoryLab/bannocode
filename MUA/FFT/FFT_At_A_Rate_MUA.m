clear all
close all

%FFT_At_A_Rate_MUA_Ver2

% set path to the Data directory
DATA_DIR = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/DATA/MUA';
SAVE_DIR = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results';

params.RecordingDate = '20201123';
params.SampleRate = 24414; %original SR
params.Baseline = 500; %baseline correction window in ms
% Nyquist = SampleRate/2;
% pointspermsec = SampleRate/1000;
% msecperpoint = 1/pointspermsec;

data_file_name = strcat(params.RecordingDate,'_ABBA_MUA');
load(fullfile(DATA_DIR,data_file_name));

for HorM=1:2 % hit or miss (1 for hit, 2 for miss)
    for i=1:length(list_st)
        MUA_stdiff = meanMUA(:,:,i,HorM); % mean MUA of each semitone diff...
        % Z_Score_ST_8 = getFFTMag_atA(ST_8,t,params); % only 4.4 Hz
        peakZ = getFFTMag_AB(MUA_stdiff,t,params);
%         % get FFT amplitude related to A+B rate (one stream, 13.3 Hz)...
%         zAmp_1SRM = peakZ(3:3:end,:);
%         % get FFT amplitude related to A rate (two stream, 4.4 Hz)...
%         zAmp_2SRM = peakZ;
%         zAmp_2SRM(3:3:end,:) = [];
%         % get mean
%         meanZ_1SRM(i,:,HorM) = mean(zAmp_1SRM,1);
%         meanZ_2SRM(i,:,HorM) = mean(zAmp_2SRM,1);
        % peak FFT amplitude in all conditions...
        Z_all(:,:,i,HorM) = peakZ;
        
        % save figure
        string = strcat(params.RecordingDate,'_FFT_',num2str(list_st(i)),'ST');
        if HorM==1
            save_file_name = strcat(string,'_hit');
        elseif HorM==2
            save_file_name = strcat(string,'_miss');
        end
        saveas(gcf,fullfile(SAVE_DIR,params.RecordingDate,'FFT',save_file_name),'png');
        
        clear peakZ zAmp_1SRM zAmp_2SRM
        close all
    end
end

% save data
save_file_name = strcat(params.RecordingDate,'_FFT');
save(fullfile(SAVE_DIR,params.RecordingDate,'FFT',save_file_name),'Z_all','list_st');
% save(fullfile(SAVE_DIR,params.RecordingDate,save_file_name), ...
%     'meanZ_1SRM','meanZ_2SRM','list_st');





% ST_8 = meanMUA(:,:,1,HorM); 
% % Z_Score_ST_8 = getFFTMag_atA(ST_8,t,params); % only 4.4 Hz
% peakZ_ST_8 = getFFTMag_AB(ST_8,t,params);
% A_ST_8 = peakZ_ST_8;
% A_ST_8(3:3:end,:) = [];
% B_ST_8 = peakZ_ST_8(3:3:end,:);
% meanA_ST_8 = mean(A_ST_8,1);
% meanB_ST_8 = mean(B_ST_8,1);
% 
% 
% ST_24 = meanMUA(:,:,end,HorM);
% % Z_Score_ST_24 = getFFTMag_atA(ST_24,t,params); only 4.4 Hz
% peakZ_ST_24 = getFFTMag_AB(ST_24,t,params);
% A_ST_24 = peakZ_ST_24;
% A_ST_24(3:3:end,:) = [];
% B_ST_24 = peakZ_ST_24(3:3:end,:);
% meanA_ST_24 = mean(A_ST_24,1);
% meanB_ST_24 = mean(B_ST_24,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% all_1SRM = meanZ_1SRM';
% all_2SRM = meanZ_2SRM';
% 
% figure
% subplot(2,2,1);
% x=1:16;
% h=bar(x,all_2SRM);
% %set(B(1),'LineWidth',25);
% title('Z-Scores at A rate');
% set(h,'BarWidth',1);
% % set(h(1),'FaceColor','blue','BarWidth',1);
% % set(h(2),'FaceColor','red','BarWidth',1);
% xlabel('Electrode Contact');
% ylabel('Z-Score');
% xlim([0 17]);
% 
% subplot(2,2,2);
% x=1:16;
% h=bar(x,all_1SRM);
% %set(B(1),'LineWidth',25);
% title('Z-Scores at (A+B) rate');
% set(h,'BarWidth',1);
% % set(h(1),'FaceColor','blue','BarWidth',1);
% % set(h(2),'FaceColor','red','BarWidth',1);
% xlabel('Electrode Contact');
% ylabel('Z-Score');
% xlim([0 17]);
% 
% subplot(2,2,3);
% x=1:16;
% stIndex = (all_2SRM - all_1SRM) ./ (all_2SRM + all_1SRM); % streaming index
% h=bar(x,stIndex);
% %set(B(1),'LineWidth',25);
% title('Z-Scores');
% set(h,'BarWidth',1);
% % set(h(1),'FaceColor','blue','BarWidth',1);
% % set(h(2),'FaceColor','red','BarWidth',1);
% xlabel('Electrode Contact');
% ylabel('index');
% xlim([0 17]);

