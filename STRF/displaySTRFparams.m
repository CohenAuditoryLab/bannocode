clear all

date = '20190930';
disp_figure = 1;

file_name = strcat(date,'_STRFReliability');
load(file_name);

% get STRF parameters
% rsh = []; rall = [];
for i=1:16 
    r(i,:) = nanmean(STRFSig(i).R12); % mean reliability index
%     rall = [rall STRFSig(i).R12]; % reliability index just for display
    rsh = STRFSig(i).R12sh; % shuffled reliability index
    peakBF(i,:) = 100 * 2^(RF1P(i).PeakBF); % best frequency (Hz)
    BW(i,:) = RF1P(i).BW; % STRF frequency band width (octave)
    peakDelay(i,:) = RF1P(i).PeakDelay; % latency (ms)
    Duration(i,:) = RF1P(i).Duration; % response duration (ms)
    
    % examine STRF significance based on reliability index
    sort_rsh = sort(rsh);
    rsh_95(i,:) = sort_rsh(round(length(rsh) * 0.95));
    sigR(i,:) = r(i,:)>rsh_95(i,:);
    clear rsh sort_rsh
end

% % obtain threshold value for reliability index
% sort_rsh = sort(rsh);
% rsh_95 = sort_rsh(round(length(rsh) * 0.95));
% sigR = r>rsh_95;

excel_out = [sigR r peakBF BW peakDelay Duration]; % summary for excel output

% parameter summary for "responding" channels
pp = excel_out(excel_out(:,1)==1,:);
medParam = median(pp,1);
meanParam = mean(pp,1);

% saving result
strf_param.all = excel_out; % all channels/units
strf_param.sig = pp; % significant STRF
strf_param.median = medParam; % median of significant STRF
strf_param.mean = meanParam; % mean of significant STRF

save_file_name = strcat(date, '_STRFParam');
save(save_file_name,'strf_param','params');

% % show distribution
% if disp_figure==1
%     figure;
%     max_r = max([max(rall) max(rsh)]);
%     min_r = min([min(rall) min(rsh)]);
%     edges = min_r:(max_r-min_r)/20:max_r;
%     histogram(rsh,edges); hold on;
%     histogram(rall,edges);
%     y_range = get(gca,'ylim');
%     plot([rsh_95 rsh_95],y_range,'--k');
%     legend({'shuffled','original'});
%     xlabel('Reliability Index'); ylabel('Count');
%     fig_title = strcat(date,' distribution of reliability index');
%     title(fig_title);
% end