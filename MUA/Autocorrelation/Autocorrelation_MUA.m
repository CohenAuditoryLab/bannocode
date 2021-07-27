%This program computes the ACF of responses to streaming stimuli, the max
%ACF at the B tone lag and A tone lag and then computes the difference,(A-B)
clear all
close all

ANIMAL = 'Cassius';
% set path to the Data directory
DATA_DIR = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/DATA/MUA',ANIMAL);
SAVE_DIR = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results';

params.RecordingDate = '20210403';
params.SampleRate = 24414; % original SR
params.Baseline = 500; % baseline correction window in ms
% Nyquist = SampleRate/2;
% pointspermsec = SampleRate / 1000;
% msecperpoint = 1 / pointspermsec;

fName = strcat(params.RecordingDate,'_ABBA_MUA'); % data file name
load(fullfile(DATA_DIR,fName));


for HorM=1:2 % hit or miss (1 for hit, 2 for miss)
    for i=1:length(list_st)
        MUA_stdiff = meanMUA(:,:,i,HorM); % mean MUA of each semitone diff...
%         [ACF_diff,ACF_A,ACF_B,hh] = getAutocorrelation_AB(MUA_stdiff,t,params); % original
        [ACF_diff,ACF_A,ACF_B,hh] = get_zACF(MUA_stdiff,t,params); % z-scored ACF
        ACF_diff_all(:,i,HorM) = ACF_diff;
        ACF_A_all(:,i,HorM) = ACF_A;
        ACF_B_all(:,i,HorM) = ACF_B;
        
        % save figure
        string1 = strcat(params.RecordingDate,'_ACF_',num2str(list_st(i)),'ST');
        string2 = strcat(params.RecordingDate,'_ACFch_',num2str(list_st(i)),'ST');
        if HorM==1
            save_file_name1 = strcat(string1,'_hit');
            save_file_name2 = strcat(string2,'_hit');
        elseif HorM==2
            save_file_name1 = strcat(string1,'_miss');
            save_file_name2 = strcat(string2,'_miss');
        end
        saveas(hh(1),fullfile(SAVE_DIR,params.RecordingDate,'ACF','zScore',save_file_name1),'png');
        saveas(hh(3),fullfile(SAVE_DIR,params.RecordingDate,'ACF','zScore',save_file_name2),'png');
        
        clear ACF_diff ACF_A ACF_B
        close all
    end
end

% save data
% save_file_name = strcat(params.RecordingDate,'_ACF');
save_file_name = strcat(params.RecordingDate,'_zACF');
save(fullfile(SAVE_DIR,params.RecordingDate,'ACF','zScore',save_file_name), ...
    'ACF_diff_all','ACF_A_all','ACF_B_all','list_st');


% %Plot Subts
% 
% AllSubts=[ST_8_ACF_Subt',ST_24_ACF_Subt'];
% 
% figure
% x=1:16;
% B=bar(x,AllSubts);
% %set(B(1),'LineWidth',25);
% title('ACF R(A-B)');
% 
% set(B(1),'FaceColor','blue','BarWidth',1);
% set(B(2),'FaceColor','red','BarWidth',1);
% xlabel('Electrode Contact');
% ylabel('R(A-B)');
% xlim([0 17]);
% 
% 
% % save(['C:\Yale Cohen Grant\Domo Data_',num2str(RecordingSite),'\',num2str(RecordingSite),'_ABBA_AllTargets_AllBehav_ACF_AminusB_RectMUA.dat'],'AllSubts','-ascii');
% 
% % hgsave(['C:\Yale Cohen Grant\Domo Data_',num2str(RecordingSite),'\',num2str(RecordingSite),'_ABBA_AllTargets_AllBehav_ACF_AminusB_RectMUA']);
