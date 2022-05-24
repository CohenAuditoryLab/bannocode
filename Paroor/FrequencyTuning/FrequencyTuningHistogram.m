

%% Housekeeping
% Clear workspace and close existing figures. Add SDK directories to Matlab
% path.
close all; clear all; clc;
DATE = '20210410';
SDKPATH = 'C:\TDT\TDTMatlabSDK'; % path to the functions accessing the Tank files
DATAPATH = fullfile('D:\TDT\Tanks',['Cassius-' DATE(3:end)]);
BLOCKPATH = fullfile(DATAPATH,[DATE '_TuningTestD2_d03']);
% [MAINEXAMPLEPATH,name,ext] = fileparts(cd); % \TDTMatlabSDK\Examples
% [SDKPATH,name,ext] = fileparts(MAINEXAMPLEPATH); % \TDTMatlabSDK
addpath(genpath(SDKPATH));
saving_dir = fullfile('D:\Cassius\02_TUNING_TEST',DATE);


%% Variable Setup
% Set up the varibles for the data you want to extract. We will extract
% a single channel from a fixed duration strobed storage gizmo.
REF_EPOC = 'Freq';
SNIP_STORE = 'eNe1';
% SORTID = 'TankSort';
% CHANNEL = 5;
SORTCODE = 0; % set to 0 to use all sorts
TRANGE = [-0.1 0.4]; % -100 to 300 ms from stimulus onset  
N_CH = 24; %16; % number of channels
bin = 0.010; % time bin for histogram
window = [0 0.2]; % response time window
% window = [0.2 0.4]; % response time window (off response)

%%
% read data.
data = TDTbin2mat(BLOCKPATH, 'TYPE', {'epocs', 'snips'});
% load speaker_sequence; % stimulus order

%%
% extract data only from the time range around he epoc event.
raster_data = TDTfilter(data, REF_EPOC, 'TIME', TRANGE);

% obatain time stamp
CH = raster_data.snips.(SNIP_STORE).chan; % channel
TS = raster_data.snips.(SNIP_STORE).ts; % time stamp
SC = raster_data.snips.(SNIP_STORE).sortcode; % sortcode

freq_sequence = raster_data.epocs.Freq.data;
list_freq = unique(freq_sequence);
num_freq = numel(list_freq);
index = 1:num_freq;
for CHANNEL=1:N_CH
    TS_ch = TS(CH==CHANNEL);
    SC_ch = SC(CH==CHANNEL);
    if SORTCODE ~= 0
        t = find(SC_ch == SORTCODE);
        TS_ch = TS_ch(t);
    end
    if isempty(TS_ch)
        error('no matching timestamps found')
    end
    num_trials = size(raster_data.time_ranges, 2);
    
    % spike time in each trial
    all_TS = cell(num_trials, 1);
    for trial = 1:num_trials
        trial_on = raster_data.time_ranges(1, trial);
        trial_off = raster_data.time_ranges(2, trial);
        trial_TS = TS_ch(TS_ch >= trial_on & TS_ch < trial_off);
        all_TS{trial} = trial_TS - trial_on + TRANGE(1);
    end
    
%     list_speaker = unique(speaker_sequence);
%     num_speaker = length(list_speaker);
    trial_number = 1:num_trials;
    hist_data = cell(1,num_freq);
    for i=1:num_freq
        trial_id = trial_number(freq_sequence==list_freq(i));
        num_trial = length(trial_id);
        for j=1:num_trial
            hist_data{i} = [hist_data{i}; all_TS{trial_id(j)}];
        end
    end
    
%     speaker_angle = -60:15:60;
    figure;
    for i=1:num_freq
        subplot(6,6,i);
        histogram(hist_data{i},TRANGE(2)/bin);
        fr(i) = histcounts(hist_data{i},window) / diff(window) / (num_trials/num_freq);
        set(gca,'xlim',[TRANGE(1) sum(TRANGE)],'ylim',[0 50]);
        title(strcat(num2str(round(list_freq(i),1)),' Hz'));
        box off
    end
    ii = index(fr==max(fr));
    if length(ii)>1
        ii = min(ii);
    end
    BF(CHANNEL) = list_freq(ii);
    subplot(6,3,18);
    plot(fr,'-o','LineWidth',1);
    set(gca,'XTick',[1 3:6:34],'XTickLabel',list_freq([1 3:6:end]),'XLim',[0 35]);
    xlabel('Frequency [Hz]'); ylabel('Firing Rate [spk/sec]');
    box off
    set(gcf, 'Units', 'Inches', 'Position', [3.5,1, 11.75, 8.25], 'PaperUnits', 'Inches', 'PaperSize', [11.75, 8.25]);
    fig_title = [DATE '_FrequencyTuning_ch' num2str(CHANNEL)];
    save_file_name = fullfile(saving_dir,fig_title);
%     title(fig_title,'Interpreter','none');
    saveas(gcf,save_file_name,'png');
    close all
end