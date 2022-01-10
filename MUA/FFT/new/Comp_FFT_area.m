clear all

% path for function calculating effect size...
addpath('E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code');
% addpath('../myFunction');

% DATA_PATH = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/';
ROOT_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
% animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
load RecordingDate_Both

sigFFT = [];
for ff = 1:numel(list_RecDate)
    rec_date = list_RecDate{ff};
    % load FFT data
    fName1 = strcat(rec_date,'_FFT');
    load(fullfile(ROOT_PATH,rec_date,'FFT',fName1));
    % load significant channel
    fName2 = strcat(rec_date,'_SignificantChannels');
    load(fullfile(ROOT_PATH,rec_date,'RESP',fName2));

    % concatenate data across sessions
    % (Arate-ABrate) x channel x hard-easy x hit-miss x session
    n_ch = size(nPeak_all,2);
    tempFFT = NaN(2,24,2,2);
    sigMUA = sig.Resp;
    sigPeak = nPeak_all(:,:,[1 end],:); % choose small and large dF...
    sigPeak(:,sigMUA==0,:,:) = NaN; % make non-significant NaN...
    tempFFT(:,1:n_ch,:,:) = sigPeak;
    
    sigFFT  = cat(5,sigFFT,tempFFT);
    clear sig nPeak_all sigPeak tempFFT
end

% choose sessions based on the recording sites...
j = 1:length(area_index);
j_core = j(area_index==1);
j_belt = j(area_index==0);
FFT_core = sigFFT(:,:,:,:,j_core);
FFT_belt = sigFFT(:,:,:,:,j_belt);

% % A rate (4.4 Hz)
% FFTc_A = FFT_core(1,:,2,1,:); % FFT @Arate in large dF hit trial
% FFTb_A = FFT_belt(1,:,2,1,:);
% % A+B rate (13.3 Hz)
% FFTc_AB = FFT_core(2,:,1,1,:); % FFT @ABrate in small dF hit trial
% FFTb_AB = FFT_belt(2,:,1,1,:);
% 
% % comparison between areas
% [p_A,h_A] = ranksum(FFTc_A(:),FFTb_A(:)); % -> no significance...
% [p_AB,h_AB] = ranksum(FFTc_AB(:),FFTb_AB(:)); % significant!! (higher in core)


% FFT amplitude in small and large dF trials
FFTc_s = squeeze(FFT_core(:,:,1,1,:)); % small dF
FFTc_l = squeeze(FFT_core(:,:,2,1,:)); % large dF
FFTb_s = squeeze(FFT_belt(:,:,1,1,:)); % small dF
FFTb_l = squeeze(FFT_belt(:,:,2,1,:)); % large dF

% FFT at A rate
FFTc_sA = FFTc_s(1,:,:); 
FFTc_lA = FFTc_l(1,:,:); 
FFTb_sA = FFTb_s(1,:,:);
FFTb_lA = FFTb_l(1,:,:);

% FFT at A+B rate
FFTc_sAB = FFTc_s(2,:,:); 
FFTc_lAB = FFTc_l(2,:,:); 
FFTb_sAB = FFTb_s(2,:,:);
FFTb_lAB = FFTb_l(2,:,:);

% FFT change by stimulus (large - small dF)
dFFTc_A  = log10(FFTc_lA(:)) - log10(FFTc_sA(:));
dFFTc_AB = log10(FFTc_lAB(:)) - log10(FFTc_sAB(:));
dFFTb_A  = log10(FFTb_lA(:)) - log10(FFTb_sA(:));
dFFTb_AB = log10(FFTb_lAB(:)) - log10(FFTb_sAB(:));

core = repmat('Core',length(dFFTc_A),1);
belt = repmat('Belt',length(dFFTb_A),1);

figure;
x = [log10(FFTb_sA(:)); log10(FFTc_sA(:))];
y = [log10(FFTb_sAB(:)); log10(FFTc_sAB(:))];
aud_area = [belt; core];
scatterhist(x,y,'Group',aud_area,'Kernel','on','Location','SouthEast',...
    'Direction','out','Color','br','LineStyle',{'-','-'},...
    'LineWidth',[2,2],'Marker','^o','MarkerSize',[5,5]);
% xlabel('A rate'); ylabel('A+B rate');
xlabel('L Rate'); ylabel('L-H-H Rate');
title('FFT amplitude (small dF)');
axis equal
xlim([-2 0.75]); ylim([-2 0.75]);
grid on;
clear x y;

% comparison between areas
[p_small.A,h_small.A] = ranksum(FFTb_sA(:),FFTc_sA(:));
[p_small.AB,h_small.AB] = ranksum(FFTb_sAB(:),FFTc_sAB(:));

figure;
x = [log10(FFTb_lA(:)); log10(FFTc_lA(:))];
y = [log10(FFTb_lAB(:)); log10(FFTc_lAB(:))];
scatterhist(x,y,'Group',aud_area,'Kernel','on','Location','SouthEast',...
    'Direction','out','Color','br','LineStyle',{'-','-'},...
    'LineWidth',[2,2],'Marker','^o','MarkerSize',[5,5]);
% xlabel('A rate'); ylabel('A+B rate');
xlabel('L Rate'); ylabel('L-H-H Rate');
title('FFT amplitude (large dF)');
axis equal
xlim([-2 0.75]); ylim([-2 0.75]);
grid on;
clear x y;

% comparison between areas
[p_large.A,h_large.A] = ranksum(FFTb_lA(:),FFTc_lA(:));
[p_large.AB,h_large.AB] = ranksum(FFTb_lAB(:),FFTc_lAB(:));

figure;
x = [dFFTb_A; dFFTc_A];
y = [dFFTb_AB; dFFTc_AB];
scatterhist(x,y,'Group',aud_area,'Kernel','on','Location','SouthEast',...
    'Direction','out','Color','br','LineStyle',{'-','-'},...
    'LineWidth',[2,2],'Marker','^o','MarkerSize',[5,5]);
xlabel('L Rate'); ylabel('L-H-H Rate');
title('Large dF - Small dF');
grid on;
clear x y;

[h_diff.A,p_diff.A] = ranksum(dFFTb_A(:),dFFTc_A(:));
[h_diff.AB,p_diff.AB] = ranksum(dFFTb_AB(:),dFFTc_AB(:));

% figure;
% % small dF
% subplot(2,2,1);
% scatter(log(FFTb_sA(:)),log(FFTb_sAB(:)),'^b','MarkerFaceColor','w'); hold on;
% scatter(log(FFTc_sA(:)),log(FFTc_sAB(:)),'or','MarkerFaceColor','w'); 
% % plot(log(FFTb_sA(:)),log(FFTb_lA(:)),'^b'); hold on;
% % plot(log(FFTc_sA(:)),log(FFTc_lA(:)),'or');
% xlabel('A rate'); ylabel('A+B rate');
% title('FFT amplitude (small dF)');
% grid on;
% 
% % large dF
% subplot(2,2,2);
% scatter(log(FFTb_lA(:)),log(FFTb_lAB(:)),'^b','MarkerFaceColor','w'); hold on;
% scatter(log(FFTc_lA(:)),log(FFTc_lAB(:)),'or','MarkerFaceColor','w'); 
% % plot(log(FFTb_sAB(:)),log(FFTb_lAB(:)),'^b'); hold on;
% % plot(log(FFTc_sAB(:)),log(FFTc_lAB(:)),'or'); 
% xlabel('A rate'); ylabel('A+B rate');
% title('FFT amplitude (large dF trials)');
% grid on;
% 
% % change
% subplot(2,2,3);
% dFFTc_A  = log(FFTc_lA(:)) - log(FFTc_sA(:));
% dFFTc_AB = log(FFTc_lAB(:)) - log(FFTc_sAB(:));
% dFFTb_A  = log(FFTb_lA(:)) - log(FFTb_sA(:));
% dFFTb_AB = log(FFTb_lAB(:)) - log(FFTb_sAB(:));
% scatter(dFFTb_A,dFFTb_AB,'^b','MarkerFaceColor','w'); hold on;
% scatter(dFFTc_A,dFFTc_AB,'or','MarkerFaceColor','w');
% % plot(dFFTb_A,dFFTb_AB,'^b'); hold on;
% % plot(dFFTc_A,dFFTc_AB,'or');
% xlabel('A rate'); ylabel('A+B rate');
% title('large dF - small dF');
% grid on;