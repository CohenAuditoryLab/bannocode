% function [] = Extract_CSD_MUA(DataFileName)
%ExtractTDTDataAvgOnly_Penn

%This program extracts AEP, MUA, and CSD Data from the OpenEx data tank and
%saves the averaged data in individual files

clear all;
close all;

% specify data...
% DataFileName = '20191009_SearchStim2_d03';
DataFileName = '20200110_SearchStim2_spk2_d01';

TankDir = 'C:\TDT\Synapse\Tanks\';%hardwired answer
TankName = strcat('Domo-',DataFileName(3:8));
Block = strcat('~',DataFileName);
% Block = '~20191009_SearchStim2_d03';

% analysis parameters...
EpochStart = -0.1;%Enter the start of epoch in seconds relative to stimulus onset
EpochEnd = 0.4;%Enter the end of epoch in seconds relative to stimulus onset
LimitSwps=200;
ScaleFactor = 1;
ArtRej = 600;
StoreName = 'Tick';

EpochDuration=EpochEnd-EpochStart;
DirPathTankName=[TankDir,TankName];
%DirPathTankName2=['H:\',answer{2}];%Also saves extracted files to external hard drive

% SampFreq=12207.03125;
SampFreq=12208.0; % Only for testing the script
SampPeriod=1/SampFreq;

time = [EpochStart:SampPeriod:EpochEnd]; 
time = time' * 1000; % convert time in ms

TT = actxcontrol('TTank.X');
invoke(TT,'ConnectServer','Local','Me');
invoke(TT,'SetGlobalV','WavesMemLimit',128e6);
e=invoke(TT,'OpenTank',DirPathTankName,'R');
e1=invoke(TT,'SelectBlock',Block);
if e1+e==2 %checks to see if specified tank and block found

for S=1:1 %size(StimCode,2); %DO THE FOLLOWING FOR EACH STIMULUS TYPE:


invoke(TT,'ResetFilters');
invoke(TT, 'SetGlobals', 'Options = FILTERED');
invoke(TT,'SetGlobals','RespectOffsetEpoc = 0'); % don't know why we need this for our data



MyEpocs=invoke(TT,'GetEpocsV',StoreName,0,0,1000);%Returns the Epoc events for Trigger returns a NaN event in this case
%     Filt1 = invoke (TT, 'SetFilterWithDescEx',FilterSettings);% Here is were you choose what frequency or Stim type.
Filt = invoke(TT,'SetEpocTimeFilterV', StoreName, EpochStart, EpochDuration);% Sets the Time filter-the first number is starting time, the second number is epoch duration
tranges = invoke (TT, 'GetValidTimeRangesV');% Gets the start and end of the Time ranges.
    

for channel=1:16 % for each electrode channel:
    
ReadAEP= invoke (TT, 'ReadWavesOnTimeRangeV', 'AEP1', channel);% reads back the single-sweep AEPs for a single channel of epoc stream data.
ReadAEP = -1 * ReadAEP; % polarity of the data flipped!!
AEP{1,channel}=double(ReadAEP);% creates cell array, with each column storing a matrix of single sweeps for a specified channel
AEP{1,channel}=AEP{1,channel}/ScaleFactor;%divides values by scale factor
AEP{1,channel}=AEP{1,channel}*1000000;%convert volts to microvolts

ReadMUA= invoke (TT, 'ReadWavesOnTimeRangeV', 'MUA1', channel);% reads back the single-sweep MUA for a single channel of epoc stream data.
% ReadMUA = -1 * ReadMUA; % polarity of the data flipped??
MUA{1,channel}=double(ReadMUA);% creates cell array, with each column storing a matrix of single sweeps for a specified channel
MUA{1,channel}=MUA{1,channel}/ScaleFactor;%divides values by scale factor
MUA{1,channel}=MUA{1,channel}*1000000;%convert volts to microvolts
RectMUA{1,channel}=double(abs(ReadMUA));%same as above but for rectified MUA
RectMUA{1,channel}=RectMUA{1,channel}/ScaleFactor;%divides values by scale factor
RectMUA{1,channel}=RectMUA{1,channel}*1000000;%convert volts to microvolts
end

% the next loop reads single sweeps and rejects those that exceed the
% specified artifact reject value:

% disp(Stimulus);
disp(['Total Number of Sweeps: ',num2str(size(AEP{1,1},2))]);


sweep=1;
while sweep<=size(AEP{1,1},2);
if max(abs(AEP{1,1}(:,sweep)))>ArtRej || max(abs(AEP{1,2}(:,sweep)))>ArtRej || max(abs(AEP{1,3}(:,sweep)))>ArtRej ||...
   max(abs(AEP{1,4}(:,sweep)))>ArtRej || max(abs(AEP{1,5}(:,sweep)))>ArtRej || max(abs(AEP{1,6}(:,sweep)))>ArtRej ||...
   max(abs(AEP{1,7}(:,sweep)))>ArtRej || max(abs(AEP{1,8}(:,sweep)))>ArtRej || max(abs(AEP{1,9}(:,sweep)))>ArtRej ||...
   max(abs(AEP{1,10}(:,sweep)))>ArtRej || max(abs(AEP{1,11}(:,sweep)))>ArtRej || max(abs(AEP{1,12}(:,sweep)))>ArtRej ||...
   max(abs(AEP{1,13}(:,sweep)))>ArtRej || max(abs(AEP{1,14}(:,sweep)))>ArtRej || max(abs(AEP{1,15}(:,sweep)))>ArtRej ||...
   max(abs(AEP{1,16}(:,sweep)))>ArtRej || sweep>LimitSwps ;%if the absolute value of any channel exceeds ArtRej




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Use the following to limit the time range of art rej:
% 
% if max(abs(AEP{1,1}(1:round(SampFreq*.3),sweep)))>ArtRej || max(abs(AEP{1,2}(1:round(SampFreq*.3),sweep)))>ArtRej || max(abs(AEP{1,3}(1:round(SampFreq*.3),sweep)))>ArtRej ||...
%    max(abs(AEP{1,4}(1:round(SampFreq*.3),sweep)))>ArtRej || max(abs(AEP{1,5}(1:round(SampFreq*.3),sweep)))>ArtRej || max(abs(AEP{1,6}(1:round(SampFreq*.3),sweep)))>ArtRej ||...
%    max(abs(AEP{1,7}(1:round(SampFreq*.3),sweep)))>ArtRej || max(abs(AEP{1,8}(1:round(SampFreq*.3),sweep)))>ArtRej || max(abs(AEP{1,9}(1:round(SampFreq*.3),sweep)))>ArtRej ||...
%    max(abs(AEP{1,10}(1:round(SampFreq*.3),sweep)))>ArtRej || max(abs(AEP{1,11}(1:round(SampFreq*.3),sweep)))>ArtRej || max(abs(AEP{1,12}(1:round(SampFreq*.3),sweep)))>ArtRej ||...
%    max(abs(AEP{1,13}(1:round(SampFreq*.3),sweep)))>ArtRej || max(abs(AEP{1,14}(1:round(SampFreq*.3),sweep)))>ArtRej || max(abs(AEP{1,15}(1:round(SampFreq*.3),sweep)))>ArtRej ||...
%    max(abs(AEP{1,16}(1:round(SampFreq*.3),sweep)))>ArtRej;%if the absolute value of any channel exceeds ArtRej
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    AEP{1,1}(:,sweep)=[];%omit sweep
    AEP{1,2}(:,sweep)=[];%omit sweep
    AEP{1,3}(:,sweep)=[];%omit sweep
    AEP{1,4}(:,sweep)=[];%omit sweep
    AEP{1,5}(:,sweep)=[];%omit sweep
    AEP{1,6}(:,sweep)=[];%omit sweep
    AEP{1,7}(:,sweep)=[];%omit sweep
    AEP{1,8}(:,sweep)=[];%omit sweep
    AEP{1,9}(:,sweep)=[];%omit sweep
    AEP{1,10}(:,sweep)=[];%omit sweep
    AEP{1,11}(:,sweep)=[];%omit sweep
    AEP{1,12}(:,sweep)=[];%omit sweep
    AEP{1,13}(:,sweep)=[];%omit sweep
    AEP{1,14}(:,sweep)=[];%omit sweep
    AEP{1,15}(:,sweep)=[];%omit sweep
    AEP{1,16}(:,sweep)=[];%omit sweep
    
    MUA{1,1}(:,sweep)=[];%omit sweep
    MUA{1,2}(:,sweep)=[];%omit sweep
    MUA{1,3}(:,sweep)=[];%omit sweep
    MUA{1,4}(:,sweep)=[];%omit sweep
    MUA{1,5}(:,sweep)=[];%omit sweep
    MUA{1,6}(:,sweep)=[];%omit sweep
    MUA{1,7}(:,sweep)=[];%omit sweep
    MUA{1,8}(:,sweep)=[];%omit sweep
    MUA{1,9}(:,sweep)=[];%omit sweep
    MUA{1,10}(:,sweep)=[];%omit sweep
    MUA{1,11}(:,sweep)=[];%omit sweep
    MUA{1,12}(:,sweep)=[];%omit sweep
    MUA{1,13}(:,sweep)=[];%omit sweep
    MUA{1,14}(:,sweep)=[];%omit sweep
    MUA{1,15}(:,sweep)=[];%omit sweep
    MUA{1,16}(:,sweep)=[];%omit sweep
    
    RectMUA{1,1}(:,sweep)=[];%omit sweep
    RectMUA{1,2}(:,sweep)=[];%omit sweep
    RectMUA{1,3}(:,sweep)=[];%omit sweep
    RectMUA{1,4}(:,sweep)=[];%omit sweep
    RectMUA{1,5}(:,sweep)=[];%omit sweep
    RectMUA{1,6}(:,sweep)=[];%omit sweep
    RectMUA{1,7}(:,sweep)=[];%omit sweep
    RectMUA{1,8}(:,sweep)=[];%omit sweep
    RectMUA{1,9}(:,sweep)=[];%omit sweep
    RectMUA{1,10}(:,sweep)=[];%omit sweep
    RectMUA{1,11}(:,sweep)=[];%omit sweep
    RectMUA{1,12}(:,sweep)=[];%omit sweep
    RectMUA{1,13}(:,sweep)=[];%omit sweep
    RectMUA{1,14}(:,sweep)=[];%omit sweep
    RectMUA{1,15}(:,sweep)=[];%omit sweep
    RectMUA{1,16}(:,sweep)=[];%omit sweep
sweep=1;
else
sweep=sweep+1;
end
end


disp(['Number of Sweeps Accepted: ',num2str(size(AEP{1,1},2))]);
disp([' ']);


% the next 'for' loop gets the mean AEP and RectMUA, i.e., averages across
% single-sweeps:

for channel=1:16 %for each electrode channel
    MeanAEP(:,channel)=mean(AEP{1,channel},2);
    MeanRectMUA(:,channel)=mean(RectMUA{1,channel},2);
end

% MeanAEP=fliplr(MeanAEP);%reverses channel order assignment so that Ch1 (column1) is superficial and Ch16 (column16) is deep
% MeanRectMUA=fliplr(MeanRectMUA);%reverses channel order assignment so that Ch1 (column1) is superficial and Ch16 (column16) is deep

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

points=5;%specifies number of points to average for smoothing
%MeanAEP:

rows=size(MeanAEP,1);
columns=size(MeanAEP,2);
for c=1:columns
for r=(points+1):rows-(points+1)%start at row #points+1 and ends at row #end-(points+1) for n-point average smooth
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
save_file_name = strcat(DataFileName(1:8),'_CSDMUA');
save(save_file_name,'time','MeanAEP','MeanRectMUA','MeanCSD');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Now We Plot the Data:

% figure; % CSD
% spacingCSD=75;%spacing in microvolts
% for n=1:14 % data channels
%    z=MeanCSD(:,n);
%    points=size(MeanCSD,1);
%    grid off
%    axis on
% 
%    plot(time,z-n*spacingCSD,'k','LineWidth',1);  %plots CSD
%    hold on
%    baseline=(zeros(1,points)-n*spacingCSD);
%    plot(time,baseline,'k','LineWidth',.5); %plots baseline
% end
%    set(gcf,'Units','inches');%sets units of figure dimensions
%    %D=[2 .75 5.75 8.3];%left,bottom,width,height
% D=[9 .5 4.75 8.5];%left,bottom,width,height
%    set(gcf,'Position',D);%sets figure position to values in D
%    axis tight
% 
% xlabel('Time [ms]'), ylabel ('Amplitude [\muV]')
% % title(['CSD ',Stimulus,' Inter-Waveform Spacing= ',num2str(spacingCSD)])
% title('CSD');
% hold off;
% 
% % pause(3);
% % close
% 
% figure; % MUA
% % spacingRectMUA = 6;%spacing in microvolts
% spacingRectMUA = 10;
% 
% for n=1:16 % data channels
%    z=MeanRectMUA(:,n);
%    points=size(MeanRectMUA,1);
%    grid off
%    axis on
% 
%    plot(time,z-n*spacingRectMUA,'k','LineWidth',1);  %plots RectMUA
%    hold on
%    baseline=(zeros(1,points)-n*spacingRectMUA);
%    plot(time,baseline,'k','LineWidth',.5); %plots baseline
% end
%    set(gcf,'Units','inches');%sets units of figure dimensions
%    %D=[2 .75 5.75 8.3];%left,bottom,width,height
%    D=[4.5 .5 4.75 8.5];%left,bottom,width,height
%    set(gcf,'Position',D);%sets figure position to values in D
%    axis tight
% 
% xlabel('Time [ms]'), ylabel ('Amplitude [\muV]')
% % title(['RectMUA ',Stimulus,' Inter-Waveform Spacing= ',num2str(spacingRectMUA)])
% title('RectMUA');
% hold off;



% figure; % AEP
% spacingAEP=100;%spacing in microvolts
% 
% for n=1:16 % data channels
%    z=MeanAEP(:,n);
%    points=size(MeanAEP,1);
%    grid off
%    axis on
% 
%    plot(time,z-n*spacingAEP,'k','LineWidth',1);  %plots AEP
%    hold on
%    baseline=(zeros(1,points)-n*spacingAEP);
%    plot(time,baseline,'k','LineWidth',.5); %plots baseline
% end
%    set(gcf,'Units','inches');%sets units of figure dimensions
%    %D=[2 .75 5.75 8.3];%left,bottom,width,height
%    D=[0 .5 4.75 8.5];%left,bottom,width,height
%    set(gcf,'Position',D);%sets figure position to values in D
%    axis tight
% 
% xlabel('Time [ms]'), ylabel ('Amplitude [\muV]')
% % title(['AEP ',Stimulus,' Inter-Waveform Spacing= ',num2str(spacingAEP)])
% title('AEP');
% hold off;

% figure; % CSD (colormap)
% subplot(1,2,1);
% pcolor(time,14:-1:1,MeanCSD');
% colormap jet;
% set(gca,'YDir','normal','yTickLabel',14:-2:2);
% shading interp;
% xlabel('Time [ms]'); ylabel('electrode [ch]');
% title('CSD');
% 
% subplot(1,3,3);
% wn = [0 50]; % clipping window [ms]
% MeanCSD_clipped = MeanCSD(time>=wn(1)&time<=wn(2),:);
% pcolor(time(time>=wn(1)&time<=wn(2)),14:-1:1,MeanCSD_clipped');
% colormap jet;
% set(gca,'YDir','normal','yTickLabel',14:-2:2);
% shading interp;
% title('CSD 50ms')
% xlabel('Time [ms]'); ylabel('electrode [ch]');


% close


clear C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12;
clear Channel n MeanAEP MeanRectMUA MeanCSD ReadAEP ReadMUA AEP MUA RectMUA tranges

end
end

% end