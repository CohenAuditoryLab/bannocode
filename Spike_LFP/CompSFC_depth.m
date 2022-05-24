% compare spike-field coherence in correct and incorrect trials
clear all;

% add path for Chronux
% addpath(genpath('/home/taku/Documents/MATLAB/chronux_2_12'));
addpath(genpath('C:\Users\Cohen\Documents\MATLAB\chronux_2_12\chronux_2_12'));

% specify data directory
% ROOT_DIR = '/home/taku/Documents/Results/SpikeFieldCoherence/SFC_depth';
ROOT_DIR = 'D:\Spike_LFP\Results';
sessionID = 'MrCassius-190921';
alignment = 'testToneOnset'; 
unit = 'unit_234'; %'unit_286';
electrodeID_lfp = 'D2_PFC'; %'D2_PFC';
c_range = [-0.014 0.03]; %[-0.02 0.04];
isSave = 1;

ch_sup = 1:6; %1:6; % define superficial channels
ch_deep = 12:16; %11:16; % define deep channels

fName = strcat(sessionID,'_',unit,'w',electrodeID_lfp);
fDir = fullfile(ROOT_DIR,sessionID,alignment,unit);

load(fullfile(fDir,fName));

% spike-field coherence of [0 0.2] time bin
sbtC_correct = sbtC.correct;
sbtC_wrong = sbtC.wrong;
sbtC_delta = sbtC_correct - sbtC_wrong;

% devide channel into superficial and deep
Csup_c = sbtC_correct(:,ch_sup);
Csup_w = sbtC_wrong(:,ch_sup);
Cdeep_c = sbtC_correct(:,ch_deep);
Cdeep_w = sbtC_wrong(:,ch_deep);
% delta...
Csup_d = Csup_c - Csup_w;
Cdeep_d = Cdeep_c - Cdeep_w;

figure('Position',[100 100 700 400]);
subplot(2,3,1);
imagesc(f,1:16,sbtC_correct');
xlabel('Frequency [Hz]'); ylabel('Channel');
if ~isempty(c_range)
    caxis(c_range);
end
title('Correct');

subplot(2,3,2);
imagesc(f,1:16,sbtC_wrong');
xlabel('Frequency [Hz]'); ylabel('Channel');
if ~isempty(c_range)
    caxis(c_range);
end
title('Wrong');

subplot(2,3,3);
imagesc(f,1:16,sbtC_delta');
xlabel('Frequency [Hz]'); ylabel('Channel');
if ~isempty(c_range)
    caxis(c_range);
end
title('Delta');
colormap jet;

subplot(2,3,4);
plot(f,mean(Csup_c,2),'LineWidth',1.5); hold on;
plot(f,mean(Cdeep_c,2),'LineWidth',1.5);
if ~isempty(c_range)
    ylim(c_range);
end
xlabel('Frequency [Hz]'); ylabel('Coherence');
title('Correct');
box off;

subplot(2,3,5);
plot(f,mean(Csup_w,2),'LineWidth',1.5); hold on;
plot(f,mean(Cdeep_w,2),'LineWidth',1.5);
if ~isempty(c_range)
    ylim(c_range);
end
xlabel('Frequency [Hz]'); ylabel('Coherence');
title('Wrong');
box off;

subplot(2,3,6);
plot(f,mean(Csup_d,2),'LineWidth',1.5); hold on;
plot(f,mean(Cdeep_d,2),'LineWidth',1.5);
if ~isempty(c_range)
    ylim(c_range);
end
xlabel('Frequency [Hz]'); ylabel('Coherence');
title('Delta');
legend({'superficial','deep'});
box off;

if isSave==1
    % save figure
    save_file_name = strcat('SFCdepth_',unit,'w',electrodeID_lfp);
    saveas(gca,fullfile(fDir,save_file_name),'png');
end