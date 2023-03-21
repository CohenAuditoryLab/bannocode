clear all

RecordingDate = '20200103';
DATA_DIR = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results',RecordingDate,'FFT');
f_name = strcat(RecordingDate,'_FFT');

load(fullfile(DATA_DIR,f_name));
iPeak_1SRM = 3; % set index for 13.3 Hz 
iPeak_2SRM = 1; % set index for 4.4 Hz 
% iPeak_1SRM = 6; % set index for 26.6 Hz
% iPeak_2SRM = 4; % set index for 8.8 Hz
iPeak_sum = [iPeak_2SRM iPeak_1SRM];

FFT_1SRM_hit  = mean(Z_all(iPeak_1SRM,:,:,1),1);
FFT_1SRM_miss = mean(Z_all(iPeak_1SRM,:,:,2),1);
FFT_2SRM_hit  = mean(Z_all(iPeak_2SRM,:,:,1),1);
FFT_2SRM_miss = mean(Z_all(iPeak_2SRM,:,:,2),1);

% index_hit  = (FFT_2SRM_hit - FFT_1SRM_hit) ./ (FFT_2SRM_hit + FFT_1SRM_hit);
% index_miss = (FFT_2SRM_miss - FFT_1SRM_miss) ./ (FFT_2SRM_miss + FFT_1SRM_miss);
index_hit  = sum(Z_all(iPeak_2SRM,:,:,1),1) ./ sum(Z_all(iPeak_sum,:,:,1),1);
index_miss = sum(Z_all(iPeak_2SRM,:,:,2),1) ./ sum(Z_all(iPeak_sum,:,:,2),1);

for i=1:numel(list_st); % choose semitone difference
fft1_hit  = FFT_1SRM_hit(:,:,i);
fft1_miss = FFT_1SRM_miss(:,:,i);
fft2_hit  = FFT_2SRM_hit(:,:,i);
fft2_miss = FFT_2SRM_miss(:,:,i);

fft2_HvsM = [fft2_hit',fft2_miss'];
index_2SRM(i,:) = (fft2_hit - fft2_miss) ./ (fft2_hit + fft2_miss);
FH(1) = figure(1);
subplot(2,2,i);
x=1:16;
h=bar(x,fft2_HvsM);
%set(B(1),'LineWidth',25);
title(strcat(num2str(list_st(i)),' semitone difference'));
set(h(1),'FaceColor','red','BarWidth',1);
set(h(2),'FaceColor','blue','BarWidth',1);
xlabel('Electrode Contact');
ylabel('Z-Scores at A rate');
xlim([0 17]);


fft1_HvsM = [fft1_hit',fft1_miss'];
index_1SRM(i,:) = (fft1_hit - fft1_miss) ./ (fft1_hit + fft1_miss);
FH(2) = figure(2);
subplot(2,2,i);
x=1:16;
h=bar(x,fft1_HvsM);
%set(B(1),'LineWidth',25);
title(strcat(num2str(list_st(i)),' semitone difference'));
set(h(1),'FaceColor','red','BarWidth',1);
set(h(2),'FaceColor','blue','BarWidth',1);
xlabel('Electrode Contact');
ylabel('Z-Scores at (A+B) rate');
xlim([0 17]);
end


for ch=1:16
fft1_hit  = FFT_1SRM_hit(:,ch,:);
fft1_miss = FFT_1SRM_miss(:,ch,:);
fft2_hit  = FFT_2SRM_hit(:,ch,:);
fft2_miss = FFT_2SRM_miss(:,ch,:);
FH(3) = figure(3);
subplot(4,4,ch);
plot(squeeze(fft2_hit),'-o'); hold on
plot(squeeze(fft2_miss),':^');
set(gca,'XTick',1:length(list_st),'XTickLabel',list_st,'XLim',[0 length(list_st)+1]);
title(strcat('ch',num2str(ch)));
FH(4) = figure(4);
subplot(4,4,ch);
plot(squeeze(fft1_hit),'-o'); hold on
plot(squeeze(fft1_miss),':^');
set(gca,'XTick',1:length(list_st),'XTickLabel',list_st,'XLim',[0 length(list_st)+1]);
title(strcat('ch',num2str(ch)));
end

FH(5) = figure(5);
for i=1:numel(list_st)
subplot(2,2,i);
plot(1:16,index_hit(:,:,i),'-o'); hold on
plot(1:16,index_miss(:,:,i),'--^');
plot([0 17],[0.5 0.5],':k');
set(gca,'xLim',[0 17]);
xlabel('Channel'); ylabel('index');
box off;
title(strcat(num2str(list_st(i)),' semitone difference'));
% 
% subplot(2,2,4);
% plot(1:16,index_miss(:,:,i),'-o'); hold on
% plot([0 17],[0 0],':k');
% set(gca,'xLim',[0 17]);
% xlabel('Channel'); ylabel('index');
% box off;
end

% save figure
fig_name = strcat(RecordingDate,'_FFT_Arate');
saveas(FH(1),fullfile(DATA_DIR,fig_name),'png');

fig_name = strcat(RecordingDate,'_FFT_A&Brate');
saveas(FH(2),fullfile(DATA_DIR,fig_name),'png');

fig_name = strcat(RecordingDate,'_FFT_Arate_channel');
saveas(FH(3),fullfile(DATA_DIR,fig_name),'png');

fig_name = strcat(RecordingDate,'_FFT_A&Brate_channel');
saveas(FH(4),fullfile(DATA_DIR,fig_name),'png');

fig_name = strcat(RecordingDate,'_FFT_index');
saveas(FH(5),fullfile(DATA_DIR,fig_name),'png');