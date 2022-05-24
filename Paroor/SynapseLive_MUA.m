%% Online Signal Averaging Example
%
% <html>
% Import strobe store gizmo data into Matlab using SynapseLive during the
% experiment <br>
% Plot the average waveform <br>
% Good for Evoked Potential visualization <br>
% </html>

%% Housekeeping
% Clear workspace and close existing figures. Add SDK directories to Matlab
% path.
close all; clc;
SDK_DIR = 'C:\TDT\TDTMatlabSDK';
% [MAINEXAMPLEPATH,name,ext] = fileparts(cd); % \TDTMatlabSDK\Examples
% [SDKPATH,name,ext] = fileparts(MAINEXAMPLEPATH); % \TDTMatlabSDK
addpath(genpath(SDK_DIR));

%% Variable Setup
% Set up the varibles for the data you want to extract. We will extract
% a single channel from a fixed duration strobed storage gizmo.
REF_EPOC = 'Tick';
% EVENT = 'aS1r';
EVENT = 'MUA1';
CHANNEL = 1;
TRANGE = [-0.1 0.4];
N_CH = 24; %16; % number of channels

%%
% show the last N waveforms in the plot.
N = 10; 

%%
% Set KEEPALL to 0 to only show the running average of the last N waveforms.
% Otherwise, all waveforms in the block are included in the average.
KEEPALL = 0; 

%%
% Setup SynapseLive
% t = SynapseLive('MODE', 'Preview', 'EXPERIMENT', 'OnlineAveragingDemo'); % we will default to 'Preview' mode
% t = SynapseLive('MODE', 'Preview', 'EXPERIMENT', 'SearchAudResp'); % we will default to 'Preview' mode
t = SynapseLive('MODE', 'Preview', 'EXPERIMENT', strcat('SearchStim_',num2str(N_CH))); % we will default to 'Preview' mode
t.TYPE = {'epocs','streams'}; % we only care about these types of events
t.VERBOSE = false;
first_pass = true;

%% The Main Loop
prevWaves = cell(1,N);
prevWaves_mat = nan(N_CH,4882,N);
nsweeps = 0;
while 1
    
    % slow it down a little
    pause(1)
    
    % get the most recent data, exit loop if the block has stopped.
    if t.update==0 %isempty(t.update)
        break
    end

    % read the snippet events.
    r = t.get_data(EVENT);
    if isstruct(r)
        if ~isnan(r.data)
            % get our channel of data
            data = TDTfilter(t.data, REF_EPOC, 'TIME', TRANGE);
            ts = linspace(t.T1,t.T2,max(size(r.data))-1);
%             wave = data.streams.(EVENT).data(1:end-1);
            wave = r.data(:,1:end-1);
            
            num_trials = size(data.time_ranges,2);
            disp(num_trials)
%             if num_trials>1
%                 data.time_ranges = data.time_ranges(:,1);
%             end
            try
                w_filt = wave(:,ts>data.time_ranges(1) & ts<data.time_ranges(2));
                size_w = floor(TRANGE(2)*r.fs);
                if length(w_filt)>size_w
                    w_filt = w_filt(:,1:size_w);
                end
                t_filt = linspace(TRANGE(1),sum(TRANGE),max(size(w_filt)));
                
                if max(size(w_filt)) ~= size_w
                    continue
                end
            catch
                continue
            end
%             chan_data = r.data(r.chan == CHANNEL,:);
%             chan_data = r.data(CHANNEL,:);
            chan_data = w_filt(CHANNEL,:);
            nsize = size(chan_data,1);
            
            % cache the waveforms in our circular buffer
            prevWaves = circshift(prevWaves, -nsize);
            prevWaves_mat = circshift(prevWaves_mat, -nsize, 3);
            for i = 1:(min(nsize, N))
                prevWaves{i} = chan_data(end-(i-1),:);
                prevWaves_mat(:,:,i) = abs(w_filt); % rectify MUA
            end
            
            
            % find average signal
            cache_ind = ~cellfun('isempty', prevWaves);
            if KEEPALL == 0
                % if we are only keeping the previous N, do average on just those.
                avg_data = mean(cell2mat(prevWaves(cache_ind)'), 1);
                avg_data_mat = nanmean(prevWaves_mat,3);
            else
                if first_pass
                    first_pass = false;
                    nsweeps = nsize;
                    avg_data = new_mean;
                else
                    new_mean = mean(chan_data, 1);
                    % add new average into the old average
                    avg_data = (avg_data .* nsweeps + new_mean * nsize) / (nsweeps + nsize);
                end
            end
            
            nsweeps = nsweeps + nsize;
            
            spacing = 10;
            add_spacing = 0:spacing:(N_CH-1)*spacing;
            add_spacing = add_spacing' * ones(1,size_w);
            mua = prevWaves_mat * 1000000 + flipud(add_spacing);
            avg_mua = avg_data_mat * 1000000 + flipud(add_spacing);
            % plot the preview N waves in gray
%             t_ms = 1000*(1:numel(avg_data)) / r.fs;
%             plot(t_ms, cell2mat(prevWaves(cache_ind)')','Color', [.85 .85 .85]); hold on;
            t_ms = t_filt*1000;            
            for j=1:N
                plot(t_ms, mua(:,:,j), 'Color', [.85 .85 .85]); hold on;
            end
            
            % plot the average signal in thick blue
%             plot(t_ms, avg_data, 'b', 'LineWidth', 3); hold off;
             plot(t_ms, avg_mua, 'LineWidth', 1); hold off;
            
            % finish up plot
            title(sprintf('nsweeps = %d, last %d shown', nsweeps, N));
%             set(gca,'ylim',[0 N_CH*spacing]);
            set(gca,'ylim',[0 N_CH*spacing],'YTick',add_spacing(:,1)+3.5,'YTickLabel',N_CH:-1:1);
            xlabel('Time, ms','FontSize',12)
            ylabel('Channel', 'FontSize', 12)
            temp_axis = axis;
            temp_axis(1) = t_ms(1);
            temp_axis(2) = t_ms(end);
            axis(temp_axis);
            
            % force the plots to update
            try
                snapnow
            catch
                drawnow
            end
            
            % for publishing, end early
            if exist('quitEarly','var') && nsweeps > 30
                break
            end
        end
    end
end