%ExtractTDTDataAvgOnly_Penn

%This program extracts AEP, MUA, and CSD Data from the OpenEx data tank and
%saves the averaged data in individual files

%Note: some of the answers to initial prompt are or can be hardwired into the
%program. Check this before running...

%Note also that in this version of the program, scale factor is set to = 1.0,
%since there is no scaling of the data (data are stored as FP values).

%Important: Before running program, you must change or assign the stim
%codes and filter settings- see below:

clear all;
close all;

%answer{1}=['Z:\Steinschneider Lab\Monkey_Data\Malu Intracortical Data\'];%hardwired answer
TankDir=['D:\TDT\Tanks\'];%hardwired answer
TankName = ['Cassius-200928'];
% TankDir=['D:\TDT\Synapse\Tanks\'];%hardwired answer
% TankName = ['Domo-180702-112023'];
% Block = '~20180820_TuningTest_test';
% Block = ['~20180521_TuningTest_u02'];
Block = '~20200928_TuningTestD_d01';
% Block = '~20200827_TuningTestD_test';
channel = 12;
ScaleFactor = 1;
respLatency = 10; % response latency in ms

DirPathTankName = [TankDir,TankName];


TT = actxcontrol('TTank.X');
invoke(TT,'ConnectServer','Local','Me');
invoke(TT,'SetGlobalV','WavesMemLimit',128e6);
e=invoke(TT,'OpenTank',DirPathTankName,'R');
e1=invoke(TT,'SelectBlock',Block);
% if e1+e==2;%checks to see if specified tank and block found

% for S=1:size(StimCode,2); %DO THE FOLLOWING FOR EACH STIMULUS TYPE:

% for p=1:16;%preallocate for speed (16 channels)
% AEP{1,p}=zeros(6104,100);%preallocate space
% MUA{1,p}=zeros(6104,100);%preallocate space
% RectMUA{1,p}=zeros(6104,100);%preallocate space
% end


invoke(TT,'ResetFilters');
invoke (TT, 'SetGlobals', 'Options = FILTERED');
invoke(TT,'SetGlobals','RespectOffsetEpoc = 0'); 

% FilterSettings=[Stimulus];%filters irrespective of animal behavioral responses

% StoreName = 'Ep1/';
% StoreName = 'Wfq/';
StoreName = 'Freq';
% StoreName = 'Tick';
% freq = 1000;
% freq = 200;
% FilterSettings = [StoreName,'=',num2str(freq)];
% StoreName = 'Tick';
MyEpocs=invoke(TT,'GetEpocsV',StoreName,0,0,1000);%Returns the Epoc events for Trigger returns a NaN event in this case
% Filt1 = invoke(TT,'SetFilterWithDescEx',FilterSettings);
% Filt = invoke(TT,'SetEpocTimeFilterV',StoreName,-.010,.220);
Filt = invoke(TT,'SetEpocTimeFilterV',StoreName,-.1,.5);
tranges = invoke(TT,'GetValidTimerangesV');
% Filt1 = invoke (TT, 'SetFilterWithDescEx',FilterSettings);% Here is were you choose what frequency or Stim type.
% Filt = invoke(TT,'SetEpocTimeFilterV', StoreName, EpochStart, EpochDuration);% Sets the Time filter-the first number is starting time, the second number is epoch duration
% tranges = invoke (TT, 'GetValidTimeRangesV');% Gets the start and end of the Time ranges.


% READ ANALOG DATA
% waves = TT.ReadWavesV('Wav2');
% waves = double(waves);
stim = TT.ReadWavesV('aS1r');
readStim = invoke(TT,'ReadWavesOnTimeRangeV','aS1r',1);
stimID = MyEpocs(1,:);
frequency = unique(stimID);
% lever = waves(:,3);
% rew = waves(:,4);


% for channel=1:16;% for each electrode channel:
% channel = 10;
% READ UNFILTERED NEURAL DATA
ReadWave = invoke(TT, 'ReadWavesOnTimeRangeV', 'Wav1', channel);
FS = 24414.0625;
% obtain AEP from unfiltered neural data
[b,a] = butter(4,300/(FS/2),'low');
y = filtfilt(b,a,double(ReadWave));
[b,a] = butter(4,3/(FS/2),'high');
AEP = filtfilt(b,a,y) * 1000000;
d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',FS);
AEP = filtfilt(d,AEP);
% [b,a] = butter(4,[57 63]/12207,'stop');
% AEP = filtfilt(b,a,AEP) * 1000000;
clear y;
% obtain MUA from unfiltered neural data
[b,a] = butter(4,3000/(FS/2),'low');
y = filtfilt(b,a,double(ReadWave));
[b,a] = butter(4,300/(FS/2),'high');
MUA = filtfilt(b,a,y) * 1000000;
clear y;

% artifact rejection
threshold = 400;
maxAEP = abs(max(AEP,[],1));
index = 1:size(AEP,2);
index = index(maxAEP<threshold);

stimID = stimID(index);
AEP_trial = AEP(:,index);
t = [-0.1:1/FS:0.4] * 1000;
figure;
for i=1:length(frequency)
    AEPEachTrial = AEP_trial(:,stimID==frequency(i));
%     temp = AEPEachTrial(1:end-1,:);
%     temp = AEPEachTrial;
    subplot(6,6,i);
    plot(t,AEPEachTrial); hold on;
    plot(t,mean(AEPEachTrial,2),'k','LineWidth',2);
    set(gca,'xlim',[-100 400],'ylim',[-300 300]); 
%     ylim([-200 200]);
    title([num2str(round(frequency(i),1)) ' Hz']);
    box off;
end

MUA_trial = MUA(:,index);
RectMUA = abs(MUA_trial);
RectMUA_trial = RectMUA / ScaleFactor; % divides values by scale factor
% RectMUA_trial = RectMUA * 1000000; % convert volts to microvolts

% smoothing
points = 10;
rows=size(RectMUA_trial,1);
columns=size(RectMUA_trial,2);
for c=1:columns
    for r=(points+1):rows-(points+1) %start at row #points+1 and ends at row #end-(points+1) for n-point average smooth
        RectMUA_trial(r,c)=mean(RectMUA_trial(r-points:r+points,c)); %n-point average smooth
    end
end
clear c r;

figure;
for i=1:length(frequency)
    RectMUAEachTrial = RectMUA_trial(:,stimID==frequency(i));
%     temp = RectMUAEachTrial(1:end-1,:);
%     temp = RectMUAEachTrial;
    subplot(6,6,i);
    plot(t,RectMUAEachTrial); hold on;
    plot(t,mean(RectMUAEachTrial,2),'k','LineWidth',2);
    set(gca,'xlim',[-100 400],'ylim',[0 40]); 
%     ylim([0 40]);
    title([num2str(round(frequency(i),1)) ' Hz']);
    box off;
    
    % tuning curve 
    temp = mean(RectMUAEachTrial,2);
    spont = temp(t<=0);
    spont = spont(points+1:end);
    tSpont = t(t<=0);
    tSpont = tSpont(points+1:end);
    resp = temp(t>0+respLatency & t<=200+respLatency);
    tResp = t(t>0+respLatency & t<=200+respLatency);
    z(i) = (mean(resp)-mean(spont)) / std(spont); % z-score
    R(i) = trapz(tResp,resp) - trapz(tSpont,spont)*(200/100); % area
end

figure;
subplot(2,1,1);
semilogx(frequency,z,'k','LineWidth',2); box off; hold on;
plot(frequency(z==max(z)),max(z),'or','LineWidth',2);
set(gca,'xlim',[frequency(1) frequency(end)]);
ylim = get(gca,'ylim');
xlabel('frequency [Hz]'); ylabel('z-score');
zBF = frequency(z==max(z));
xpos = (frequency(end) - frequency(1)) * 0.5;
ypos = ylim(1) + diff(ylim) * 0.8;
text(xpos,ypos,[num2str(round(zBF,1)) ' Hz']);

subplot(2,1,2);
semilogx(frequency,R,'k','LineWidth',2); box off; hold on;
plot(frequency(R==max(R)),max(R),'or','LineWidth',2);
set(gca,'xlim',[frequency(1) frequency(end)]);
ylim = get(gca,'ylim');
xlabel('frequency [Hz]'); ylabel('area');
aBF = frequency(R==max(R));
ypos = ylim(1) + diff(ylim) * 0.8;
text(xpos,ypos,[num2str(round(aBF,1)) ' Hz']);

% clear y;

% ReadAEP= invoke (TT, 'ReadWavesOnTimeRangeV', 'AEP1', channel);% reads back the single-sweep AEPs for a single channel of epoc stream data.
% AEP{1,channel}=double(ReadAEP);% creates cell array, with each column storing a matrix of single sweeps for a specified channel
% AEP{1,channel}=AEP{1,channel}/ScaleFactor;%divides values by scale factor
% AEP{1,channel}=AEP{1,channel}*1000000;%convert volts to microvolts

% ReadMUA = invoke (TT, 'ReadWavesOnTimeRangeV', 'MUA1', channel);% reads back the single-sweep MUA for a single channel of epoc stream data.
% MUA{1,channel}=double(ReadMUA);% creates cell array, with each column storing a matrix of single sweeps for a specified channel
% MUA{1,channel}=MUA{1,channel}/ScaleFactor;%divides values by scale factor
% MUA{1,channel}=MUA{1,channel}*1000000;%convert volts to microvolts
% RectMUA{1,channel}=double(abs(ReadMUA));%same as above but for rectified MUA
% RectMUA{1,channel}=RectMUA{1,channel}/ScaleFactor;%divides values by scale factor
% RectMUA{1,channel}=RectMUA{1,channel}*1000000;%convert volts to microvolts

% end

% % AEP
% figure;
% t = -0.1:1/1017:0.3; % sampling freq for AEP = 1017 Hz
% t = t*1000; % display in ms
% AEP_trial = ReadAEP(1:end-1,2:end); % omit first trial
% AEP_trial = AEP_trial * 1000000; % convert volts to microvolts
% plot(t,AEP_trial); hold on; 
% plot(t,mean(AEP_trial,2),'k','LineWidth',2);
% xlabel('time [ms]');
% ylabel('microvolt');
% 
% % MUA
% figure;
% MUA = double(ReadMUA(:,2:end)); % omit first trial
% MUA = MUA / ScaleFactor; %divides values by scale factor
% MUA = MUA * 1000000; % convert volts to microvolts
% RectMUA = double(abs(ReadMUA(:,2:end))); % omit first trial
% RectMUA = RectMUA / ScaleFactor; % divides values by scale factor
% RectMUA = RectMUA * 1000000; % convert volts to microvolts
% t = -0.1:1/12207:0.3; % sampling freq for MUA = 12 kHz
% t = t*1000; % display in ms
% RectMUA_trial = RectMUA(1:end-1,:);
% plot(t,RectMUA_trial); hold on;
% plot(t,mean(RectMUA_trial,2),'k','LineWidth',2);
% xlabel('time [ms]');
% ylabel('microvolt');
% 
% tstamp = tstamp(trial>1) * 1000; % omit first trial and display data in ms
% trial = trial(trial>1);
% figure
% subplot(2,1,1);
% plot(tstamp,trial,'.');
% box off; axis off;
% subplot(2,1,2);
% histogram(tstamp,'BinWidth',10);
% box off;
% % Num_event_T = TT.ReadEventsV(10000,'Tick',0,0,0,0,'All');
% % stim_on_time = TT.ParseEvInfoV(0,Num_event_T,6);
% 



