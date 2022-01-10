%calculating STRF with tdt output
%Trig times and spet in samples
clear all;
close all;

%%
addpath('C:\STRF_files'); % path for readtank_mwa_input_tb
addpath('C:\STRF_files\matlab\keck');

% DataFileName = '20191009_RippleF2_d03';
DataFileName = '20200110_RippleF2_spk2_d01';

STIM_DIR = 'C:\STRF_files\ripple_96k_new\DNR_Cortex_96k5min_4_50.spr'; % fast DMR
DATA_DIR = 'C:\TDT\Synapse\Tanks';
Tank_Name = strcat('Domo-',DataFileName(3:8));
Block = strcat('~',DataFileName);

for ch=1:16 % 16ch v-probe
    %     [Data] = readtank_mwa_input_tb('C:\TDT\Synapse\Tanks\Domo-180227-115025','~20180516_Ripple_u03',s,'local');
    [Data] = readtank_mwa_input_tb(fullfile(DATA_DIR,Tank_Name),Block,ch,'local');
    %         [Data] = readtank_mwa_input_tb('C:\TDT\Synapse\Tanks\Domo-190123',Block,ch,'local');
    %     [Data] = readtank_mwa_input_tb('D:\TDT\Synapse\Tanks\Domo-180702-112023',Block,ch,'local');
    TrigTimes=round(Data.Fs*Data.Trig);
    %      [TrigA,TrigB]=trigfixstrf2(TrigTimes,400,917);
    %          [TrigA,TrigB]=trigfixstrf2(TrigTimes,400,902/2); % single stim presentation
    [TrigA,TrigB]=trigfixstrf2(TrigTimes,400,899); % double stim presentation
    spet=(Data.SnipTimeStamp*Data.Fs);
    spet1=(Data.SnipTimeStamp1*Data.Fs1);
    fs=Data.Fs;
    
    
    % 1st 5-min DMR
    [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdbint(STIM_DIR,0,0.15,spet,TrigA,fs,80,30,'dB','MR',1700,5,'float');
    % 2nd 5-min DMR
    [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdbint(STIM_DIR,0,0.15,spet,TrigB,fs,80,30,'dB','MR',1700,5,'float');
    
    STRF1=(STRF1A+STRF1B)/2;
    STRF2=(STRF2A+STRF2B)/2;
    No1=No1A+No1B;
    Wo1=(Wo1A+Wo1B)/2;
    No2=No2A+No2B;
    Wo2=(Wo2A+Wo2B)/2;
    
%     threshold = max(max(STRF1)) * 0.15;
%     i_exc = find(STRF1<=threshold); % excitatory part
%     i_inh = find(STRF1>=threshold); % inhibitory part
%     STRF1e = STRF1; STRF1i = STRF1;
%     STRF1e(i_exc) = threshold; STRF1i(i_inh) = threshold;
    
    %         STRFDataML(contraML) = struct('No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'STRF1',STRF1,'STRF2',STRF2,'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
    %         STRFData(ch) = struct('No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'STRF1',STRF1,'STRF2',STRF2,'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
    STRFData(ch) = struct('No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'No1A',No1,'Wo1A',Wo1,'No2A',No2,'Wo2A',Wo2,'No1B',No1,'Wo1B',Wo1,'No2B',No2,'Wo2B',Wo2, ...
        'STRF1',STRF1,'STRF2',STRF2,'STRF1A',STRF1,'STRF2A',STRF2,'STRF1B',STRF1,'STRF2B',STRF2, ...
        'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
    [STRF1s,Tresh1] = wstrfstat(STRFData(ch).STRF1,0.001,STRFData(ch).No1,STRFData(ch).Wo1,STRFData(ch).PP,30,'dB','MR','dB');
    %         RF1P(ch) = strfparam(STRFData(ch).taxis,STRFData(ch).faxis,STRFData(ch).STRF1,STRFData(ch).Wo1,STRFData(ch).PP,'MR',500,4,0.05,0.1,'y');
    RF1P(ch) = strfparam(STRFData(ch).taxis,STRFData(ch).faxis,STRFData(ch).STRF1,STRFData(ch).Wo1,STRFData(ch).PP,'MR',500,4,0.05,0.1,'y');
    %         BF(ch) = faxis(1) * 2^RF1P(ch).BF;
    
    figure; %subplot(1,2,1)
    taxis=(taxis)*1e3;
    % faxis=(faxis)*1e3;
    pcolor(taxis,log2(faxis/faxis(1)),(STRF1A+STRF1B)/2);
    colormap jet;set(gca,'YDir','normal'); shading flat;
    %         text(100,7,['BF = ' num2str(RF1P(ch).BFHz) ' Hz'],'FontWeight','bold');
    best_freq = faxis(1) * 2^RF1P(ch).PeakBF; % use peakBF insted of BFHz
    text(100,7,['BF = ' num2str(best_freq) ' Hz'],'FontWeight','bold');
    set(gca,'YTickLabel',{'100','200','400','800','1.6k','3.2k','6.4k','12.8k','25.6k'});
    xlabel('time [ms]'); ylabel('frequency [Hz]');
%     saveFileName = [Block(2:10),'depth',Block(end-1:end),'_STRF_ch',num2str(ch)];
%     print(['C:\Taku\03_STRF\' saveFileName],'-djpeg');

    close all
    
end

% save data
save_file_name = strcat(DataFileName(1:8),'_STRF');
save(save_file_name,'faxis','taxis','STRFData','RF1P');

