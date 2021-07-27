function [ resp, chDepth ] = alignMUAResp( RecordingDate, L3_ch, isSave )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% RecordingDate = '20180807';
% L3_ch = 8; % channel corresponding to the bottom of layer 3...
% isSave = 0; % 1 if saving figure...

DATA_DIR = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results',RecordingDate,'RESP','zScore');
f_name = strcat(RecordingDate,'_zMUAtriplet');

load(fullfile(DATA_DIR,f_name));
nChannel = size(zMUA_A,4); % number of channels
resp_A  = squeeze(mean(zMUA_A,1)); % stdiff x HvsM x channel
resp_B1 = squeeze(mean(zMUA_B1,1));
resp_B2 = squeeze(mean(zMUA_B2,1));

% get distance from input layer
if nChannel==16
    ch_spacing = 150;
elseif nChannel==24
    ch_spacing = 100;
end
chDepth = 1:nChannel;
chDepth = (chDepth - L3_ch) * ch_spacing;

if isnan(L3_ch)
    x_range = [0 nChannel+1];
    x_label = 'Channel';
else
    x_range = [min(chDepth)-ch_spacing max(chDepth)+ch_spacing];
    x_label = 'Distance from input layer [um]';
end
figure;
H(1) = subplot(2,2,1);
for i=1:numel(list_st)
    if isnan(L3_ch)
        plot(1:nChannel,squeeze(resp_A(i,1,:)),'-o','LineWidth',2); hold on
    else
        plot(chDepth,squeeze(resp_A(i,1,:)),'-o','LineWidth',2); hold on
    end
    c = get(gca,'colororder');
    l{i} = strcat(num2str(list_st(i)),' semitone difference');
end
legend(l,'Location',[0.6 0.7 0.2 0.2]);
for i=1:numel(list_st)
    if isnan(L3_ch)
        plot(1:nChannel,squeeze(resp_A(i,2,:)),'--^','color',c(i,:),'LineWidth',1.5);
    else
        plot(chDepth,squeeze(resp_A(i,2,:)),'--^','color',c(i,:),'LineWidth',1.5);
    end
end
xlabel(x_label); ylabel('z-score');
title('MUA respose (A)');
box off;

H(2) = subplot(2,2,3);
for i=1:numel(list_st)
    if isnan(L3_ch)
        plot(1:nChannel,squeeze(resp_B1(i,1,:)),'-o','LineWidth',2); hold on
    else
        plot(chDepth,squeeze(resp_B1(i,1,:)),'-o','LineWidth',2); hold on
    end
%     c = get(gca,'colororder');
%     l{i} = strcat(num2str(list_st(i)),' semitone difference');
end
for i=1:numel(list_st)
    if isnan(L3_ch)
        plot(1:nChannel,squeeze(resp_B1(i,2,:)),'--^','color',c(i,:),'LineWidth',1.5);
    else
        plot(chDepth,squeeze(resp_B1(i,2,:)),'--^','color',c(i,:),'LineWidth',1.5);
    end
end
xlabel(x_label); ylabel('z-score');
title('MUA respose (B1)');
box off;

H(3) = subplot(2,2,4);
for i=1:numel(list_st)
    if isnan(L3_ch)
        plot(1:nChannel,squeeze(resp_B2(i,1,:)),'-o','LineWidth',2); hold on
    else
        plot(chDepth,squeeze(resp_B2(i,1,:)),'-o','LineWidth',2); hold on
    end
%     c = get(gca,'colororder');
%     l{i} = strcat(num2str(list_st(i)),' semitone difference');
end
for i=1:numel(list_st)
    if isnan(L3_ch)
        plot(1:nChannel,squeeze(resp_B2(i,2,:)),'--^','color',c(i,:),'LineWidth',1.5);
    else
        plot(chDepth,squeeze(resp_B2(i,2,:)),'--^','color',c(i,:),'LineWidth',1.5);
    end
end
xlabel(x_label); ylabel('z-score');
title('MUA respose (B2)');
box off;

for i=1:3
    y_lim = get(H(i),'YLim');
    y_min(i) = y_lim(1);
    y_max(i) = y_lim(2);
    clear y_lim
end

set(H,'xlim',x_range,'ylim',[min(y_min) max(y_max)]);

% reorganize matrix
resp_A  = permute(resp_A,[3 1 2]);
resp_B1 = permute(resp_B1,[3 1 2]);
resp_B2 = permute(resp_B2,[3 1 2]);
resp = struct('A',resp_A,'B1',resp_B1,'B2',resp_B2);

if isSave==1
    % save figure
    save_file_dir = DATA_DIR;
    save_file_name = strcat(RecordingDate,'_zMUA_stdiff');
    saveas(gcf,fullfile(save_file_dir,save_file_name),'png');
    % save variables
%     save(fullfile(save_file_dir,save_file_name),'resp','chDepth','list_st');
end

end

