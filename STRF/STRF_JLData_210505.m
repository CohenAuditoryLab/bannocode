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
% data_dir = 'Cassius_190326_Belt';
% t_file = 'AudiResp_16_24-190326-154559-ripplesF_triggers';
data_dir = 'Cassius_190404_Core';
t_file = 'AudiResp_24_24-190404-134302-ripplesF_triggers';

% load data
load(fullfile(data_dir,'spike_times_goodmua_clust')); % spike time
load(fullfile(data_dir,t_file)); % trigger

nCluster = numel(cluster_id);
fs = 24414.0625;
for ch = 1:nCluster
% get spike time
spTime = double(spike_time{ch});
spet = spTime';

% calculate STRF
% TrigA
[taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdbint('C:\STRF_files\ripple_96k_new\DNR_Cortex_96k5min_4_50.spr',0,0.15,spet,TrigA,fs,80,30,'dB','MR',1700,5,'float');
% TrigB
[taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdbint('C:\STRF_files\ripple_96k_new\DNR_Cortex_96k5min_4_50.spr',0,0.15,spet,TrigB,fs,80,30,'dB','MR',1700,5,'float');

STRF1=(STRF1A+STRF1B)/2;
STRF2=(STRF2A+STRF2B)/2;
No1=No1A+No1B;
Wo1=(Wo1A+Wo1B)/2;
No2=No2A+No2B;
Wo2=(Wo2A+Wo2B)/2;

% threshold = max(max(STRF1)) * 0.15;
% i_exc = find(STRF1<=threshold); % excitatory part
% i_inh = find(STRF1>=threshold); % inhibitory part
% STRF1e = STRF1; STRF1i = STRF1;
% STRF1e(i_exc) = threshold; STRF1i(i_inh) = threshold;

% get STRFData and STRF parameter
STRFData(ch) = struct('No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'No1A',No1,'Wo1A',Wo1,'No2A',No2,'Wo2A',Wo2,'No1B',No1,'Wo1B',Wo1,'No2B',No2,'Wo2B',Wo2, ...
    'STRF1',STRF1,'STRF2',STRF2,'STRF1A',STRF1,'STRF2A',STRF2,'STRF1B',STRF1,'STRF2B',STRF2, ...
    'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
[STRF1s(:,:,ch),Tresh1(ch)] = wstrfstat(STRFData(ch).STRF1,0.001,STRFData(ch).No1,STRFData(ch).Wo1,STRFData(ch).PP,30,'dB','MR','dB');
RF1P(ch) = strfparam(STRFData(ch).taxis,STRFData(ch).faxis,STRFData(ch).STRF1,STRFData(ch).Wo1,STRFData(ch).PP,'MR',500,4,0.05,0.1,'y');

% display STRF
fig_name = strcat('cluster_',num2str(cluster_id(ch)));
figure; %subplot(1,2,1)
taxis=(taxis)*1e3;
% faxis=(faxis)*1e3;
pcolor(taxis,log2(faxis/faxis(1)),(STRF1A+STRF1B)/2);
colormap jet;set(gca,'YDir','normal'); shading flat;
% get positive peak
pkbf_p = RF1P(ch).PeakBFP; % peak BF
best_freq_p = faxis(1) * 2^pkbf_p; % use peakBF insted of BFHz
latency_p = RF1P(ch).PeakDelayP;
% get negative peak
pkbf_n = RF1P(ch).PeakBFN;
best_freq_n = faxis(1) * 2^pkbf_n;
latency_n = RF1P(ch).PeakDelayN;
text(100,7.5,['BF = ' num2str(best_freq_p) ' Hz'],'FontWeight','bold');
text(100,7,['latency = ' num2str(latency_p) ' ms'],'FontWeight','bold');
set(gca,'YTickLabel',{'100','200','400','800','1.6k','3.2k','6.4k','12.8k','25.6k'});
xlabel('time [ms]'); ylabel('frequency [Hz]');
hold on;
plot(latency_p,pkbf_p,'+w','LineWidth',1.5);
plot(latency_n,pkbf_n,'+y','LineWidth',1.5);
title(fig_name,'Interpreter','none');
saveas(gcf,fullfile(data_dir,'png',fig_name),'png');
close all;

BF_pos(ch,:) = best_freq_p;
BF_neg(ch,:) = best_freq_n;
Latency_pos(ch,:) = latency_p;
Latency_neg(ch,:) = latency_n;
PLI1(ch,:) = RF1P(ch).PLI;
PLI2(ch,:) = RF1P(ch).PLI2;

end

f_name = strcat(data_dir,'_RTWSTRFDBINT');
save(fullfile(data_dir,f_name),'STRFData');
f_name = strcat(data_dir,'_WSTRFSTAT');
save(fullfile(data_dir,f_name),'STRF1s','Tresh1');
f_name = strcat(data_dir,'_STRFPARAM');
save(fullfile(data_dir,f_name),'RF1P');

f_name = 'BF_Latency';
save(fullfile(data_dir,f_name),'BF_pos','BF_neg','Latency_pos','Latency_neg', ...
    'PLI1','PLI2','cluster_id','sorting_quality');

excel_out = [BF_pos BF_neg Latency_pos Latency_neg PLI1 PLI2];