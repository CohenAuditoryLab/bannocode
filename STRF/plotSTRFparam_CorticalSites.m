clear all

% LIST_DATE = {'20180709'};
LIST_A1 = {'20180709','20180727','20180807','20180907'}; % A1
LIST_BELT = {'20181210','20181212','20190123','20190404','20190409','20190821','20190828','20190830','20190904','20190906','20190930'}; % non-primary auditory cortex

REC_SITE_A1 = [-4 0; -4 0; -4 0; -4 0];
REC_SITE_BELT = [-1 3; -1 3; 5 5; 3 3; 3 3; -3 2; 2 2; 4 2; 4 4; -3 1; 0 3];
REC_SITE_ORIGIN = [-4 0];

% calculate cortical distance from "origin"
n_a1 = size(REC_SITE_A1,1); % number of recording sites in A1
xy_a1 = REC_SITE_A1 - ones(n_a1,1) * REC_SITE_ORIGIN;
for n=1:n_a1
    dist_a1(n) = norm(xy_a1(n,:));
end

n_belt = size(REC_SITE_BELT,1); % number of recording sites in belt
xy_belt = REC_SITE_BELT - ones(size(REC_SITE_BELT,1),1) * REC_SITE_ORIGIN;
for n=1:n_belt
    dist_belt(n) = norm(xy_belt(n,:));
end

STRFParam_a1 = []; % all
medianSTRFParam_a1 = []; % median for each recording session 
x_a1 = [];
for ff=1:length(LIST_A1)
    file_name = strcat(LIST_A1{ff},'_STRFParam');
    load(file_name);
    
    STRFParam_a1 = [STRFParam_a1; strf_param.sig]; % [sig RI BF BW latency duration]
    medianSTRFParam_a1 = [medianSTRFParam_a1; median(strf_param.sig,1)]; % [sig RI BF BW latency duration]
    x_a1 = [x_a1; ones(size(strf_param.sig,1),1) * dist_a1(ff)];
end
BF_a1 = STRFParam_a1(:,3);
BW_a1 = STRFParam_a1(:,4);
latency_a1 = STRFParam_a1(:,5);
duration_a1 = STRFParam_a1(:,6);

STRFParam_belt = []; % all
medianSTRFParam_belt = []; % median for each recording session
x_belt = [];
for ff=1:length(LIST_BELT)
    file_name = strcat(LIST_BELT{ff},'_STRFParam');
    load(file_name);
    
    STRFParam_belt = [STRFParam_belt; strf_param.sig]; % [sig RI BF BW latency duration]
    medianSTRFParam_belt = [medianSTRFParam_belt; median(strf_param.sig,1)]; % [sig RI BF BW latency duration]
    x_belt = [x_belt; ones(size(strf_param.sig,1),1) * dist_belt(ff)];
end
BF_belt = STRFParam_belt(:,3);
BW_belt = STRFParam_belt(:,4);
latency_belt = STRFParam_belt(:,5);
duration_belt = STRFParam_belt(:,6);



% parameter summary for "responding" channels
figure;
subplot(2,1,1);
max_value = max([BW_a1; BW_belt]);
edges = linspace(0,max_value,15);
histogram(BW_a1,edges); hold on
histogram(BW_belt,edges);
xlabel('BW [octave]'); ylabel('number of channels');
title('tuning width');
box off

subplot(2,1,2);
max_value = max([latency_a1; latency_belt]);
edges = linspace(0,max_value,15);
histogram(latency_a1,edges); hold on
histogram(latency_belt,edges);
legend({'A1','non-primary'})
xlabel('Delay [ms]'); ylabel('number of channels');
title('latency');
box off


figure
subplot(2,2,1);
% plot(dist_a1,log2(medianSTRFParam_a1(:,3)/100),'o'); hold on
% plot(dist_belt,log2(medianSTRFParam_belt(:,3)/100),'o');
plot(REC_SITE_A1(:,1),log2(medianSTRFParam_a1(:,3)/100),'o'); hold on
plot(REC_SITE_BELT(:,1),log2(medianSTRFParam_belt(:,3)/100),'o');
xlim([-4.5 4.5]); ylim([0 8]);
xlabel('Recording Sites (AP axis)'); ylabel('Best Frequency [octave]');
box off;

subplot(2,2,2);
% plot(dist_a1,medianSTRFParam_a1(:,5),'o'); hold on
% plot(dist_belt,medianSTRFParam_belt(:,5),'o');
plot(REC_SITE_A1(:,2),medianSTRFParam_a1(:,5),'o'); hold on
plot(REC_SITE_BELT(:,2),medianSTRFParam_belt(:,5),'o');
xlim([-0.5 3.5]); ylim([10 50]);
xlabel('Recording Sites (ML axis)'); ylabel('Response Latency [ms]');
box off;

% function [ch,bw,latency] = getSignificantSTRFparam(STRFSig,RF1P)
% channel = transpose(1:16);
% rsh = [];
% for i=1:16
%     r(i,:) = mean(STRFSig(i).R12); % mean reliability index
%     rsh = [rsh STRFSig(i).R12sh]; % shuffled reliability index
%     %         peakBF(i,:) = 100 * 2^(RF1P(i).PeakBF); % best frequency (Hz)
%     BW(i,:) = RF1P(i).BW; % STRF frequency band width (octave)
%     peakDelay(i,:) = RF1P(i).PeakDelay; % latency (ms)
%     %         Duration(i,:) = RF1P(i).Duration; % response duration (ms)
% end
% 
% % obtain threshold value for reliability index
% sort_rsh = sort(rsh);
% rsh_95 = sort_rsh(round(length(rsh) * 0.95));
% 
% ch = channel(r>rsh_95);
% bw = BW(r>rsh_95);
% latency = peakDelay(r>rsh_95);
% end