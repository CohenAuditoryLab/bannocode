% function [] = Extract_CSD_MUA(DataFileName)
%ExtractTDTDataAvgOnly_Penn

% This program extracts AEP, MUA, and CSD Data from the OpenEx data tank and
% saves the averaged data in individual files
% 01/04/22 modified from Extract_CSD_MUA.m to further smooth MUA (based on
% Yon's comment)

clear all;
close all;

addpath(genpath('C:\Users\Taku\Documents\MATLAB\TDTMatlabSDK'));

% specify data...
% DataFileName = '20191009_SearchStim2_d03';
DataFileName = '20200110_SearchStim2_spk2_d01';

% TankDir = 'C:\TDT\Synapse\Tanks\';%hardwired answer
% TankName = strcat('Domo-',DataFileName(3:8));
TankDir = 'C:\Tanks';%hardwired answer
% TankName = strcat('Domo-',DataFileName(3:8));
% Block = strcat('~',DataFileName);
% Block = '~20191009_SearchStim2_d03';

% analysis parameters...
EpochStart = -0.15;%Enter the start of epoch in seconds relative to stimulus onset
EpochEnd = 0.45;%Enter the end of epoch in seconds relative to stimulus onset
LimitSwps=200;
ScaleFactor = 1;
ArtRej = 600;
StoreName = 'Tick';

EpochDuration=EpochEnd-EpochStart;
DirPathTankName=TankDir;
% DirPathTankName=[TankDir,TankName];
%DirPathTankName2=['H:\',answer{2}];%Also saves extracted files to external hard drive

SampFreq=12207.03125;
% SampFreq=12208.0; % Only for testing the script
SampPeriod=1/SampFreq;

% time = [EpochStart:SampPeriod:EpochEnd]; 
% time = time' * 1000; % convert time in ms

% ACCESSING TANK FILE
data = TDTbin2mat(fullfile(DirPathTankName,DataFileName),'TYPE',{'epocs','streams'},'CHANNEL',0);
% FILTER ANALYSIS TIME WINDOW
tempdata = TDTfilter(data, 'Tick', 'TIME', [EpochStart, EpochDuration]);
% GET AEP AND MUA OF EACH STIMULUS PRESENTATION    
ReadAEP = tempdata.streams.AEP1.filtered;
ReadMUA = tempdata.streams.MUA1.filtered;

n_timepoints = size(ReadAEP{1},2);
time = linspace(EpochStart,EpochEnd,n_timepoints);
time = time' * 1000; % convert time into ms

disp(['Total Number of Sweeps: ',num2str(size(ReadAEP,2))]);
noisy_trial = [];
sweep=1;
while sweep<=size(ReadAEP,2)
%     AEP_trial = ReadAEP{sweep} * -1; % invert the sign of the signal
    AEP_trial = ReadAEP{sweep};
    AEP_trial = -1 * AEP_trial; % polarity of the data flipped!!
    AEP_trial = AEP_trial / ScaleFactor;
    AEP_trial = AEP_trial * 1000000;
    AEP(:,:,sweep) = AEP_trial;
    
    MUA_trial = abs(ReadMUA{sweep});
    MUA_trial = MUA_trial / ScaleFactor;
    MUA_trial = MUA_trial * 1000000;
    RectMUA(:,:,sweep) = MUA_trial;
    % artifact rejection
    if max(abs(AEP(1,:)))>ArtRej || max(abs(AEP(2,:)))>ArtRej || max(abs(AEP(3,:)))>ArtRej ||...
            max(abs(AEP(4,:)))>ArtRej || max(abs(AEP(5,:)))>ArtRej || max(abs(AEP(6,:)))>ArtRej ||...
            max(abs(AEP(7,:)))>ArtRej || max(abs(AEP(8,:)))>ArtRej || max(abs(AEP(9,:)))>ArtRej ||...
            max(abs(AEP(10,:)))>ArtRej || max(abs(AEP(11,:)))>ArtRej || max(abs(AEP(12,:)))>ArtRej ||...
            max(abs(AEP(13,:)))>ArtRej || max(abs(AEP(14,:)))>ArtRej || max(abs(AEP(15,:)))>ArtRej ||...
            max(abs(AEP(16,:)))>ArtRej || sweep>LimitSwps ;%if the absolute value of any channel exceeds ArtRej
        
        noisy_trial = [noisy_trial sweep];
        sweep=sweep+1;
    else 
        sweep=sweep+1;
    end
end
AEP(:,:,noisy_trial) = [];
RectMUA(:,:,noisy_trial) = [];

disp(['Number of Sweeps Accepted: ',num2str(size(AEP,3))]);
disp([' ']);

MeanAEP = transpose(mean(AEP,3));
MeanRectMUA = transpose(mean(RectMUA,3));

%derive CSD:
C1=(-1*MeanAEP(:,1))+(2*MeanAEP(:,2))+(-1*MeanAEP(:,3));
C2=(-1*MeanAEP(:,2))+(2*MeanAEP(:,3))+(-1*MeanAEP(:,4));
C3=(-1*MeanAEP(:,3))+(2*MeanAEP(:,4))+(-1*MeanAEP(:,5));
C4=(-1*MeanAEP(:,4))+(2*MeanAEP(:,5))+(-1*MeanAEP(:,6));
C5=(-1*MeanAEP(:,5))+(2*MeanAEP(:,6))+(-1*MeanAEP(:,7));
C6=(-1*MeanAEP(:,6))+(2*MeanAEP(:,7))+(-1*MeanAEP(:,8));
C7=(-1*MeanAEP(:,7))+(2*MeanAEP(:,8))+(-1*MeanAEP(:,9));
C8=(-1*MeanAEP(:,8))+(2*MeanAEP(:,9))+(-1*MeanAEP(:,10));
C9=(-1*MeanAEP(:,9))+(2*MeanAEP(:,10))+(-1*MeanAEP(:,11));
C10=(-1*MeanAEP(:,10))+(2*MeanAEP(:,11))+(-1*MeanAEP(:,12));
C11=(-1*MeanAEP(:,11))+(2*MeanAEP(:,12))+(-1*MeanAEP(:,13));
C12=(-1*MeanAEP(:,12))+(2*MeanAEP(:,13))+(-1*MeanAEP(:,14));
C13=(-1*MeanAEP(:,13))+(2*MeanAEP(:,14))+(-1*MeanAEP(:,15));
C14=(-1*MeanAEP(:,14))+(2*MeanAEP(:,15))+(-1*MeanAEP(:,16));

MeanCSD=[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14];

%Now we smooth the data using a 5-point average:

% points=5;%specifies number of points to average for smoothing
points = 25; % 01/04/22 number increased for further smoothing
%MeanAEP:
rows=size(MeanAEP,1);
columns=size(MeanAEP,2);
for c=1:columns
for r=(points+1):rows-(points+1) %start at row #points+1 and ends at row #end-(points+1) for n-point average smooth
MeanAEP(r,c)=mean(MeanAEP(r-points:r+points,c)); %n-point average smooth
end
end
clear c r;

%MeanRectMUA:
rows=size(MeanRectMUA,1);
columns=size(MeanRectMUA,2);
for c=1:columns
for r=(points+1):rows-(points+1) %start at row #points+1 and ends at row #end-(points+1) for n-point average smooth
MeanRectMUA(r,c)=mean(MeanRectMUA(r-points:r+points,c)); %n-point average smooth
end
end
clear c r;

%MeanCSD:
rows=size(MeanCSD,1);
columns=size(MeanCSD,2);
for c=1:columns
for r=(points+1):rows-(points+1) %start at row #points+1 and ends at row #end-(points+1) for n-point average smooth
MeanCSD(r,c)=mean(MeanCSD(r-points:r+points,c)); %n-point average smooth
end
end
clear c r;

%now baseline correct the data to the negative time segment:
p=1;
q=1;
while p==1
    if time(q,1)>0 %finds where the negative time segment terminates
        timezeroindex=q;
       p==0;
       break;
    end
    q=q+1;
end

for r=1:size(MeanAEP,2)
    MeanAEP(:,r)=MeanAEP(:,r)-mean(MeanAEP(1:timezeroindex,r),1);
end

for r=1:size(MeanRectMUA,2)
    MeanRectMUA(:,r)=MeanRectMUA(:,r)-mean(MeanRectMUA(1:timezeroindex,r),1);
end

for r=1:size(MeanCSD,2)
    MeanCSD(:,r)=MeanCSD(:,r)-mean(MeanCSD(1:timezeroindex,r),1);
end

TimeMeanAEP=[time,MeanAEP];% append time axis
TimeMeanRectMUA=[time,MeanRectMUA];% append time axis
TimeMeanCSD=[time,MeanCSD];% append time axis

% save data
save_file_name = strcat(DataFileName(1:8),'_CSDMUA_ver2');
save(save_file_name,'time','MeanAEP','MeanRectMUA','MeanCSD');





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Now We Plot the Data:

figure; % CSD
spacingCSD=75;%spacing in microvolts
for n=1:14 % data channels
   z=MeanCSD(:,n);
   points=size(MeanCSD,1);
   grid off
   axis on

   plot(time,z-n*spacingCSD,'k','LineWidth',1.5);  %plots CSD
   hold on
   baseline=(zeros(1,points)-n*spacingCSD);
   plot(time,baseline,'k','LineWidth',.5); %plots baseline
end
   set(gcf,'Units','inches');%sets units of figure dimensions
   %D=[2 .75 5.75 8.3];%left,bottom,width,height
D=[9 .5 4.75 8.5];%left,bottom,width,height
   set(gcf,'Position',D);%sets figure position to values in D
   axis tight

xlabel('Time [ms]'), ylabel ('Amplitude [\muV]')
% title(['CSD ',Stimulus,' Inter-Waveform Spacing= ',num2str(spacingCSD)])
title('CSD');
set(gca,'XLim',[-100 400]);
hold off;
% 
% % pause(3);
% % close
% 
figure; % MUA
spacingRectMUA = 6;%spacing in microvolts
% spacingRectMUA = 10;

for n=1:16 % data channels
   z=MeanRectMUA(:,n);
   points=size(MeanRectMUA,1);
   grid off
   axis on

   plot(time,z-n*spacingRectMUA,'k','LineWidth',1.5);  %plots RectMUA
   hold on
   baseline=(zeros(1,points)-n*spacingRectMUA);
   plot(time,baseline,'k','LineWidth',.5); %plots baseline
end
   set(gcf,'Units','inches');%sets units of figure dimensions
   %D=[2 .75 5.75 8.3];%left,bottom,width,height
   D=[4.5 .5 4.75 8.5];%left,bottom,width,height
   set(gcf,'Position',D);%sets figure position to values in D
   axis tight

xlabel('Time [ms]'), ylabel ('Amplitude [\muV]')
% title(['RectMUA ',Stimulus,' Inter-Waveform Spacing= ',num2str(spacingRectMUA)])
title('MUA');
set(gca,'XLim',[-100 400]);
hold off;



figure; % AEP
spacingAEP=100;%spacing in microvolts

for n=1:16 % data channels
   z=MeanAEP(:,n);
   points=size(MeanAEP,1);
   grid off
   axis on

   plot(time,z-n*spacingAEP,'k','LineWidth',1.5);  %plots AEP
   hold on
   baseline=(zeros(1,points)-n*spacingAEP);
   plot(time,baseline,'k','LineWidth',.5); %plots baseline
end
   set(gcf,'Units','inches');%sets units of figure dimensions
   %D=[2 .75 5.75 8.3];%left,bottom,width,height
   D=[0 .5 4.75 8.5];%left,bottom,width,height
   set(gcf,'Position',D);%sets figure position to values in D
   axis tight

xlabel('Time [ms]'), ylabel ('Amplitude [\muV]')
% title(['AEP ',Stimulus,' Inter-Waveform Spacing= ',num2str(spacingAEP)])
title('AEP');
set(gca,'XLim',[-100 400]);
hold off;
% 
% % figure; % CSD (colormap)
% % subplot(1,2,1);
% % pcolor(time,14:-1:1,MeanCSD');
% % colormap jet;
% % set(gca,'YDir','normal','yTickLabel',14:-2:2);
% % shading interp;
% % xlabel('Time [ms]'); ylabel('electrode [ch]');
% % title('CSD');
% % 
% % subplot(1,3,3);
% % wn = [0 50]; % clipping window [ms]
% % MeanCSD_clipped = MeanCSD(time>=wn(1)&time<=wn(2),:);
% % pcolor(time(time>=wn(1)&time<=wn(2)),14:-1:1,MeanCSD_clipped');
% % colormap jet;
% % set(gca,'YDir','normal','yTickLabel',14:-2:2);
% % shading interp;
% % title('CSD 50ms')
% % xlabel('Time [ms]'); ylabel('electrode [ch]');
% 
% 
% % close
% 
% 
% clear C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12;
% clear Channel n MeanAEP MeanRectMUA MeanCSD ReadAEP ReadMUA AEP MUA RectMUA tranges
% 
% end
% end
