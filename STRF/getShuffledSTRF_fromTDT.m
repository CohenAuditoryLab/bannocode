function getShuffledSTRF_fromTDT(DATA_DIR,DATA_FILE_NAME,SPR_DIR,display_fig)
%obtain shuffled STRF for statistical significance of STRF
%Trig times and spet in samples

disp('obtaining suffled STRF');
%%
addpath(genpath('C:\STRF_files\matlab\keck'));
addpath(genpath('C:\STRF_files\matlab\infotheory'));

nBoot = 8;
% Block = '~20180516_Ripple_u03'; % single electrode
% Block = '~20180807_Ripple2_d01'; % v-probe
% Block = '~20190123_Ripple_d02'; % v-probe
Block = ['~',DATA_FILE_NAME];
% for ch=8 % single electrode
for ch=1:16 % v-probe
    disp(['channel ', num2str(ch)]);
    [Data] = readtank_mwa_input_tb(DATA_DIR,Block,ch,'local');
%     [Data] = readtank_mwa_input_tb('C:\TDT\Synapse\Tanks\Domo-180813-182551',Block,ch,'local');
    %         [Data] = readtank_mwa_input_tb('C:\TDT\Synapse\Tanks\Domo-190123',Block,ch,'local');
    %     [Data] = readtank_mwa_input_tb('D:\TDT\Synapse\Tanks\Domo-180702-112023',Block,ch,'local');
    TrigTimes=round(Data.Fs*Data.Trig);
    %      [TrigA,TrigB]=trigfixstrf2(TrigTimes,400,917);
    %          [TrigA,TrigB]=trigfixstrf2(TrigTimes,400,902/2); % single stim presentation
    [TrigA,TrigB]=trigfixstrf2(TrigTimes,400,899); % double stim presentation
    spet=(Data.SnipTimeStamp*Data.Fs);
    %     spet1=(Data.SnipTimeStamp1*Data.Fs1);
    
    % shuffle spike timing
    shSpet = shufflespet(spet);
    
    fs=Data.Fs;
    %         [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdb('C:\STRF_files\ripple_96k\DNR_Cortex_96k5min.spr',0,0.15,spet,TrigA,fs,80,30,'dB','MR',300,'float');
    %         [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdbint('C:\STRF_files\ripple_96k\DNR_Cortex_96k5min.spr',0,0.15,shSpet,TrigA,fs,80,30,'dB','MR',1700,5,'float');
    [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdbintboot(SPR_DIR,0,0.15,shSpet,TrigA,fs,80,30,'dB','MR',1700,5,'float',nBoot);
    
    %         [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdb('C:\STRF_files\ripple_96k\DNR_Cortex_96k5min.spr',0,0.15,spet,TrigB,fs,80,30,'dB','MR',300,'float');
    %         [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdbint('C:\STRF_files\ripple_96k\DNR_Cortex_96k5min.spr',0,0.15,shSpet,TrigB,fs,80,30,'dB','MR',1700,5,'float');
    [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdbintboot(SPR_DIR,0,0.15,shSpet,TrigB,fs,80,30,'dB','MR',1700,5,'float',nBoot);
    
    
    STRFData(ch) = struct('No1A',No1A,'Wo1A',Wo1A,'No2A',No2A,'Wo2A',Wo2A,'No1B',No1B,'Wo1B',Wo1B,'No2B',No2B,'Wo2B',Wo2B, ...
        'STRF1A',STRF1A,'STRF2A',STRF2A,'STRF1B',STRF1B,'STRF2B',STRF2B, ...
        'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
    
    if display_fig == 1
        % display figure
        figure; %subplot(1,2,1)
        taxis=(taxis)*1e3;
        % faxis=(faxis)*1e3;
        pcolor(taxis,log2(faxis/faxis(1)),(mean(STRF1A,3)+mean(STRF1B,3))/2);
        colormap jet;set(gca,'YDir','normal'); shading flat;
        set(gca,'YTickLabel',{'100','200','400','800','1.6k','3.2k','6.4k','12.8k','25.6k'});
        xlabel('time [ms]'); ylabel('frequency [Hz]');
        % save figure
        saveFileName = [Block(2:10),'depth',Block(end-1:end),'_shSTRF_ch',num2str(ch)];
        print(['C:\Taku\03_STRF\' saveFileName],'-djpeg');
        close all
    end
end

% save data
disp('saving shuffled STRF...');
save_file_name = [Block(2:9) '_shuffledSTRF' Block(end-3:end)];
save(save_file_name,'STRFData','-v7.3','DATA_FILE_NAME');

end
