clear all;


% specify data directory
DATA_DIR = '/home/taku/Documents/Data';
SAVE_DIR = '/home/taku/Documents/Results/SpikeFieldCoherence';
sessionID = 'MrCassius-190921';
alignment = 'testToneOnset'; % 'stimOnset';

% choose electrode
% electrodeID_spk = 'D2_PFC';
electrodeID_spk = 'D4_AC';

% specify file name
fName_spike = strcat('Spike_',electrodeID_spk,'_',alignment);

% Spike
load(fullfile( DATA_DIR, sessionID, fName_spike));
t_raster = t;

n_trial = size(Spikes,2);
n_unit = size(Spikes,3);

% show figure
for i=1:n_unit
    uid = unit_id(i);
    figure;
    % RASTER PLOT
    subplot(2,1,1);
    imagesc(t_raster,1:n_trial,transpose(Spikes(:,:,i)));
    caxis([0 1]); colormap(1-gray);
    xlabel('time [ms]'); ylabel('trials');
    title(['unit #' num2str(uid) ' Raster']);
    % PSTH
    subplot(2,1,2);
    bar(t_raster,mean(Spikes(:,:,i),2)*1000);
    xlabel('time [ms]'); ylabel('response [spikes/sec]');
    title(['unit #' num2str(uid) ' PSTH']);
    
    % save figure setting...
    fig_name = ['unit_#' num2str(uid)];
    save_file_name = strcat(sessionID,'_',electrodeID_spk,'_',fig_name);
    save_file_dir = fullfile(SAVE_DIR,'Check_Response',sessionID,alignment,electrodeID_spk);
    
    % save figure
    saveas(gca,fullfile(save_file_dir,save_file_name),'png');
    close all
end
