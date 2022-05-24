% compare spike-field coherence in correct and incorrect trials
clear all;

% add path for Chronux
% addpath(genpath('/home/taku/Documents/MATLAB/chronux_2_12'));
addpath(genpath('C:\Users\Cohen\Documents\MATLAB\chronux_2_12\chronux_2_12'));

% specify data directory
% DATA_DIR = '/home/taku/Documents/Data';
% SAVE_DIR = '/home/taku/Documents/Results/SpikeFieldCoherence';
DATA_DIR = 'D:\Spike_LFP\Data';
SAVE_DIR = 'D:\Spike_LFP\Results';
sessionID = 'MrCassius-190921';
alignment = 'testToneOnset'; %'stimOnset';


% specify Spike
electrodeID_spk = 'D3_AC';
cl = 286; % cluster ID for spike
% specify LFP
electrodeID_lfp = 'D2_PFC';
% ch = 4; % channel ID for LFP


% load Spike data
fName_spike = strcat('Spike_',electrodeID_spk,'_',alignment);
load(fullfile( DATA_DIR, sessionID, fName_spike));
t_raster = t;
list_cluster = unit_id; % list of cluster
list_channel = ch_id;
% load LFP data
fName_lfp = strcat('LFP_',electrodeID_lfp,'_',alignment);
load(fullfile( DATA_DIR, sessionID, fName_lfp));
t_lfp = t;

% choose spike data to analyze...
idx = 1:length(list_cluster); % index to choose unit...
idx = idx(list_cluster==cl);
% raster_cl = Spikes(:,iBehav==cw,idx); % choose responding unit
raster_cl = Spikes(:,:,idx);

n_ch = size(LFP,3);
for ch=4 %1:n_ch
    aInfo = struct('lfp',struct('EID',electrodeID_lfp,'ch',ch), ...
        'spk',struct('EID',electrodeID_spk,'cl',cl));
    % choose LFP data to analyze...
    % iBehav = err;
    % lfp_ch = squeeze(LFP(:,iBehav==cw,ch)); % choose channel 10 for test
    lfp_ch = LFP(:,:,ch);
    lfp_ch = lfp_ch * 10^6; % convert unit from V to uV
    % resample lfp at 1000 Hz
    [y,tt] = resample(lfp_ch,t_lfp/1000,1000,'spline');
    % overwrite lfp
    lfp_ch = y;
    % t_lfp = tt*1000;
    
    
    % calculate spike-field coherence
    lfp_c = lfp_ch(:,err=='C'); % correct trial
    lfp_w = lfp_ch(:,err=='W'); % incorrect trial
    raster_c = raster_cl(:,err=='C'); % correct trial
    raster_w = raster_cl(:,err=='W'); % incorrect trial
    
    % display figure
    [coh,cgm,H(1)] = calc_SFC_figure(lfp_ch,raster_cl,t_raster/1000,aInfo);
    [coh_c,cgm_c,H(2)] = calc_SFC_figure(lfp_c,raster_c,t_raster/1000,aInfo);
    [coh_w,cgm_w,H(3)] = calc_SFC_figure(lfp_w,raster_w,t_raster/1000,aInfo);
    sbtC.all(:,ch) = coh.C_diff;
    sbtC.correct(:,ch) = coh_c.C_diff;
    sbtC.wrong(:,ch) = coh_w.C_diff;
    sbtCmat.all(:,:,ch) = cgm.Cmat_diff; 
    sbtCmat.correct(:,:,ch) = cgm_c.Cmat_diff;
    sbtCmat.wrong(:,:,ch) = cgm_w.Cmat_diff;
    
    
    % difference between correct and incorrect
    sbtC_diff = coh_c.C_diff - coh_w.C_diff; % comp shift-pred subtracted SFC
    % Cmat_diff = cgm_c.Cmat - cgm_w.Cmat;
    sbtCmat_diff = cgm_c.Cmat_diff - cgm_w.Cmat_diff; % comp shift-pred subtracted SFC
    f = coh_c.f;
    ff = cgm_c.ff;
    tt = cgm_c.tt;
    
%     % plot figure
%     H(3) = figure('Position',[50 50 500 700]);
%     subplot(3,1,3);
%     % plot_vector(C_sh,f,'n',[],':k'); hold on;
%     plot_vector(sbtC_diff,f,'n',[],'r',1.5); % should not take log for coherence
%     set(gca,'XLim',[0 100]);
%     xlabel('frequency [Hz]'); ylabel('coherence');
% %     title(['channel ' num2str(ch)]);
%     title('coherence in: 0 - 0.2 sec');
%     box off;
    
%     subplot(3,1,2);
%     plot_matrix(sbtCmat_diff,tt,ff,'n'); % should not take log for coherence
%     % pcolor(t,f,C'); shading('interp');
%     xlabel('time [sec]'); ylabel('frequency [Hz]');
%     title('shift-predictor-subtracted SFC');
%     % caxis([8 28]);
%     colormap jet
    
    % save figures
    unit = strcat('unit_',num2str(cl));
    s_dir = fullfile(SAVE_DIR,sessionID,alignment,unit,electrodeID_lfp,'figure'); % save directory
    s_name = strcat('SFC_',electrodeID_spk,'_#',num2str(cl),'_', ...
        electrodeID_lfp,'_ch',num2str(ch),'_'); % save file name
    ext = {'all','correct','wrong','diff'};
    for i=1:3 %4
        ss = strcat(s_name,ext{i});
        saveas(H(i),fullfile(s_dir,ss),'pdf');
    end
    close all;
    
end

% tt = tt + t_lfp(1)/1000;
% aInfo.sessionID = sessionID;
% aInfo.alignment = alignment;
% aInfo.nTrial.correct = size(lfp_c,2);
% aInfo.nTrial.wrong = size(lfp_w,2);
% % save coherograms
% save_file_name = strcat(sessionID,'_',unit,'w',electrodeID_lfp);
% s_dir = fullfile(SAVE_DIR,'SFC_depth',sessionID,alignment,unit);
% save(fullfile(s_dir,save_file_name),'sbtC','sbtCmat','f','tt','ff','aInfo');