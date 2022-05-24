%calculating STRF with tdt output
%Trig times and spet in samples
%load('C:\work\Sorted\meta_171018_B2.mat')
%temp=SEV2mat('F:\SAM-171013\BLock-5','Channel',66,'EVENTNAME','xpz5');
% triggers=temp.xpz5.data;
% % fs=temp.xpz5.fs;
% triggers=meta.triggers;
% fs=meta.fs;
%
% [b,a]=butter(6,1000/(fs/2));
% trf=filter(b,a,triggers);
% [pks,locs]=findpeaks(trf/max(trf),'MinPeakHeight',.9);
% %%
% %there are 917 triggers on the file
%  [TrigA,TrigB]=trigfixstrf2(locs,400,917);

%%
addpath(genpath('C:\Users\Cohen\Documents\MATLAB\STRF_files\matlab\keck'));

% Block = '~20200912_RippleF2_d01'; % single electrode
Block = '~20210317_RippleF2_d02'; % v-probe
% for ch=7 % single electrode
for ch=1:24 %16 % v-probe
%         [Data] = readtank_mwa_input_tb('G:\Cassius\Tanks\Cassius-200912',Block,ch,'local');
        [Data] = readtank_mwa_input_tb('D:\TDT\Tanks\Cassius-210317',Block,ch,'local');
%     [Data] = readtank_mwa_input_tb('D:\TDT\Synapse\Tanks\Domo-180702-112023',Block,ch,'local');
    TrigTimes=round(Data.Fs*Data.Trig);
    %      [TrigA,TrigB]=trigfixstrf2(TrigTimes,400,917);
%          [TrigA,TrigB]=trigfixstrf2(TrigTimes,400,902/2); % single stim presentation
    [TrigA,TrigB]=trigfixstrf2(TrigTimes,400,899); % double stim presentation
    spet=round(Data.SnipTimeStamp*Data.Fs);
    spet1=round(Data.SnipTimeStamp1*Data.Fs1);
    fs=Data.Fs;
    %ML

        %[taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdb('C:\work\Penn\DNR_updated\DNR_Cortex_100k5min.spr',0,0.3,spet,TrigA,fs,80,30,'dB','MR',1300,'float');
        %         [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdb('C:\work\Penn\Moving_Ripple_generation\DNR_Cortex_96k5min.spr',0,0.3,spet,TrigA,fs,80,30,'dB','MR',300,'float');
%         [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdb('C:\Users\Cohen\Documents\MATLAB\STRF_files\ripple_96k_4\DNR_Cortex_96k5min_4_50.spr',0,0.15,spet,TrigA,fs,80,30,'dB','MR',300,'float');
        [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdbint('C:\Users\Cohen\Documents\MATLAB\STRF_files\ripple_96k_4\DNR_Cortex_96k5min_4_50.spr',0,0.15,spet,TrigA,fs,80,30,'dB','MR',1700,2,'float');
        
        %[taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdb('C:\work\Penn\DNR_updated\DNR_Cortex_100k5min.spr',0,0.3,spet,TrigB,fs,80,30,'dB','MR',1300,'float');
        %         [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdb('C:\work\Penn\Moving_Ripple_generation\DNR_Cortex_96k5min.spr',0,0.3,spet,TrigB,fs,80,30,'dB','MR',300,'float');
%         [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdb('C:\Users\Cohen\Documents\MATLAB\STRF_files\ripple_96k_4\DNR_Cortex_96k5min_4_50.spr',0,0.15,spet,TrigB,fs,80,30,'dB','MR',300,'float');
        [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdbint('C:\Users\Cohen\Documents\MATLAB\STRF_files\ripple_96k_4\DNR_Cortex_96k5min_4_50.spr',0,0.15,spet,TrigB,fs,80,30,'dB','MR',1700,2,'float');
        STRF1=(STRF1A+STRF1B)/2;
        STRF2=(STRF2A+STRF2B)/2;
        No1=No1A+No1B;
        Wo1=(Wo1A+Wo1B)/2;
        No2=No2A+No2B;
        Wo2=(Wo2A+Wo2B)/2;
        
%         threshold = max(max(STRF1)) * 0.15;
%         i_exc = find(STRF1<=threshold); % excitatory part
%         i_inh = find(STRF1>=threshold); % inhibitory part
%         STRF1e = STRF1; STRF1i = STRF1;
%         STRF1e(i_exc) = threshold; STRF1i(i_inh) = threshold;
        
        %         STRFDataML(contraML) = struct('No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'STRF1',STRF1,'STRF2',STRF2,'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
%         STRFData(ch) = struct('No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'STRF1',STRF1,'STRF2',STRF2,'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
        STRFData(ch) = struct('No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'STRF1',STRF1,'STRF2',STRF2,'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
        [STRF1s,Tresh1] = wstrfstat(STRFData(ch).STRF1,0.001,STRFData(ch).No1,STRFData(ch).Wo1,STRFData(ch).PP,30,'dB','MR','dB');
%         RF1P(ch) = strfparam(STRFData(ch).taxis,STRFData(ch).faxis,STRFData(ch).STRF1,STRFData(ch).Wo1,STRFData(ch).PP,'MR',500,4,0.05,0.1,'y');
        RF1P(ch) = strfparam(STRFData(ch).taxis,STRFData(ch).faxis,STRFData(ch).STRF1,STRFData(ch).Wo1,STRFData(ch).PP,'MR',500,4,0.05,0.1,'y');
        %         BF(ch) = faxis(1) * 2^RF1P(ch).BF;
        
        figure; %subplot(1,2,1)
        taxis=(taxis)*1e3;
        % faxis=(faxis)*1e3;
        pcolor(taxis,log2(faxis/faxis(1)),(STRF1A+STRF1B)/2);
%         pcolor(taxis,log2(faxis/faxis(1)),STRF1A); % test
        colormap jet;set(gca,'YDir','normal'); shading flat;
%         text(100,7,['BF = ' num2str(RF1P(ch).BFHz) ' Hz'],'FontWeight','bold');
        pkbf_p = RF1P(ch).PeakBFP;
        best_freq_p = faxis(1) * 2^pkbf_p; % use peakBF insted of BFHz
        latency_p = RF1P(ch).PeakDelayP;
        pkbf_n = RF1P(ch).PeakBFN;
        best_freq_n = faxis(1) * 2^pkbf_n; % use peakBF insted of BFHz
        latency_n = RF1P(ch).PeakDelayN;
        text(100,7.5,['BF = ' num2str(best_freq_p) ' Hz'],'FontWeight','bold');
        text(100,7,['latency = ' num2str(latency_p) ' ms'],'FontWeight','bold');
        set(gca,'YTickLabel',{'100','200','400','800','1.6k','3.2k','6.4k','12.8k','25.6k'});
        xlabel('Time [ms]'); ylabel('Frequency {Hz}');
        hold on;
        plot(latency_p,pkbf_p,'+w','LineWidth',1.5);
        plot(latency_n,pkbf_n,'+y','LineWidth',1.5);
        saveFileName = [Block(2:10),'depth',Block(end-1:end),'_STRF_ch',num2str(ch)];
        print(['D:\Cassius\03_STRF\' saveFileName],'-djpeg');
        %   contaML=contaML+1;
        close all
        
        BF_pos(ch,:) = best_freq_p;
        BF_neg(ch,:) = best_freq_n;
        Latency_pos(ch,:) = latency_p;
        Latency_neg(ch,:) = latency_n;
        PLI1(ch,:) = RF1P(ch).PLI;
        PLI2(ch,:) = RF1P(ch).PLI2;
end

excel_out = [BF_pos BF_neg Latency_pos Latency_neg PLI1 PLI2];


