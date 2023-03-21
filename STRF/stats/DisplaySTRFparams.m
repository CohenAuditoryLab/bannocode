clear all

date = '20210403';
% date = '20201127';
disp_figure = 1;
alpha = 0.01; % significant threshold for MHUtest

file_name = strcat(date,'_STRFReliability');
load(file_name);

% get STRF parameters
% rsh = []; rall = [];
n_ch = numel(RF1P); % number of channels
for i=1:n_ch
    r = STRFSig(i).R1; % reliability index
%     rall = [rall STRFSig(i).R12]; % reliability index just for display
    rsh = STRFSig(i).R1sh; % shuffled reliability index
%     peakBF(i,:) = 100 * 2^(RF1P(i).PeakBF); % best frequency (Hz)
    peakBF(i,:) = 100 * 2^(RF1P(i).PeakBFP); % best frequency (Hz)
    BW(i,:) = RF1P(i).BW; % STRF frequency band width (octave)
%     peakDelay(i,:) = RF1P(i).PeakDelay; % latency (ms)
    peakDelay(i,:) = RF1P(i).PeakDelayP; % latency (ms)
    Duration(i,:) = RF1P(i).Duration; % response duration (ms)
    PLI(i,:) = RF1P(i).PLI; % phase locking index
    
    % statistical comparison between R1 and R1sh
    [P(i,:),H(i,:)] = ranksum(r,rsh,'alpha',alpha); % MHUtest
    clear r rsh
    
%     sort_rsh = sort(rsh);
%     rsh_95(i,:) = sort_rsh(round(length(rsh) * 0.95));
%     sigR(i,:) = r(i,:)>rsh_95(i,:);
%     clear rsh sort_rsh
end

% % obtain threshold value for reliability index
% sort_rsh = sort(rsh);
% rsh_95 = sort_rsh(round(length(rsh) * 0.95));
% sigR = r>rsh_95;

excel_out = [H P peakBF BW peakDelay Duration PLI]; % summary for excel output

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
