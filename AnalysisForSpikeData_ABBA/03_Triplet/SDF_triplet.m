function [] = SDF_triplet(DATE)

% clear all;
% DATE = '20191009';
% DATE = '20210208';
bin = 5; % bin size in ms
save_dir = fullfile(DATE,'triplet'); % save file directory

% load data
addpath(DATE);
load(strcat(DATE,'_Raster_triplet'));
c = [100 100 100; 51 102 255; 255 0 0] / 255; % set line color
w = [2 1 1]; % set line width
window = [-25 225];

list_cl = clInfo.all_cluster;
active_cl = clInfo.active_cluster;
ch = clInfo.channel;
% tt = trialInfo.target_time;
% st = trialInfo.semitone_diff;
% index = trialInfo.behav_ind;
% index_tsRT = trialInfo.behav_ind_ts;


% obtain onset time for each tone
stim_on  = 0:75:150;
stim_off = stim_on + 50;
stim_period = [stim_on' stim_off'];

hmf = {'HIT','MISS','FALSE ALARM'};
l = {'1st','2nd','3rd','Target-1','Target'}; % label for title
if numel(list_st)==3
    X = transpose(1:5) * ones(1,numel(list_st)) + ones(5,1) * [-0.02 0 0.02];
elseif numel(list_st)==4
    X = transpose(1:5) * ones(1,numel(list_st)) + ones(5,1) * [-0.03 -0.01 0.01 0.03];
end
for n=1:length(list_cl)
    cl = list_cl(n);
    for i=1:5 % triplet position (1st, 2nd, 3rd, T-1, T)
        for j=1:length(list_st) % semitone difference
            for k=1:2 % hit and miss
                r = R_triplet{i,j,k}(:,:,n);
                sdf = conv(myGauss(0,bin),sum(r,1)) / size(r,1) * 1000;
                sdf = sdf(3*bin:end-3*bin-1);
                SDF(:,i,j,k) = sdf; % triplet pos x semitone x behav
            end
            % false alarm
            r_ts = R_triplet_tsRT{i,j}(:,:,n);
            sdf = conv(myGauss(0,bin),sum(r_ts,1)) / size(r_ts,1) * 1000;
            sdf = sdf(3*bin:end-3*bin-1);
            SDF(:,i,j,3) = sdf; % triplet pos x semitone x behav
        end
    end
    h1 = figure('Position',[50 50 1200 600],'visible','off');
    for k=1:3
        for i=1:5
            subplot(3,5,i+5*(k-1)); hold on
            for j=1:length(list_st);
                plot(t_triplet,SDF(:,i,j,k));
                set(gca,'xlim',[-25 225]);
                if i==1
                    ylabel(hmf{k});
                end
            end
            for ii = 1:3
                plot(stim_period(ii,:),[0 0],'k','LineWidth',3);
            end
            if k==1
                title(l{i});
            elseif k==3
                xlabel('Time [ms]');
                if i==5
                    legend(num2str(list_st));
                end
            end
        end
    end
    
    h2 = figure('Position',[60 60 1200 600],'visible','off');
    spCount_mean = SPC_triplet.mean(:,:,:,:,n);
    spCount_sem = SPC_triplet.sem(:,:,:,:,n);
    spCount_var = SPC_triplet.var(:,:,:,:,n);
    for k=1:2 % HIT and MISS
        subplot(3,3,3*(k-1)+1);
        A.mean = squeeze(spCount_mean(1,:,:,k));
        A.sem = squeeze(spCount_sem(1,:,:,k));
        A.var = squeeze(spCount_var(1,:,:,k));
        errorbar(X,A.mean,A.sem);
        set(gca,'XTick',1:5,'XTickLabel',{'1st','2nd','3rd','T-1','T'});
        ylabel(hmf{k});
        box off;
        title('A');
        subplot(3,3,3*(k-1)+2);
        B1.mean = squeeze(spCount_mean(2,:,:,k));
        B1.sem = squeeze(spCount_sem(2,:,:,k));
        B1.var = squeeze(spCount_var(2,:,:,k));
        errorbar(X,B1.mean,B1.sem);
        set(gca,'XTick',1:5,'XTickLabel',{'1st','2nd','3rd','T-1','T'});
        box off;
        title('B1');
        subplot(3,3,3*(k-1)+3);
        B2.mean = squeeze(spCount_mean(3,:,:,k));
        B2.sem = squeeze(spCount_sem(3,:,:,k));
        B2.var = squeeze(spCount_var(3,:,:,k));
        errorbar(X,B2.mean,B2.sem);
        set(gca,'XTick',1:5,'XTickLabel',{'1st','2nd','3rd','T-1','T'});
        box off;
        title('B2');
        index(k,n) = triplet_quantification(A,B1,B2);
    end
    % FALSE ALARM 
    spCount_ts_mean = SPC_triplet_tsRT.mean(:,:,:,n); % triplet x triplet pos x stdiff
    spCount_ts_sem = SPC_triplet_tsRT.sem(:,:,:,n);
    spCount_ts_var = SPC_triplet_tsRT.var(:,:,:,n);
    subplot(3,3,7);
    A.mean = squeeze(spCount_ts_mean(1,:,:));
    A.sem = squeeze(spCount_ts_sem(1,:,:));
    A.var = squeeze(spCount_ts_var(1,:,:));
    errorbar(X,A.mean,A.sem);
    set(gca,'XTick',1:5,'XTickLabel',{'1st','2nd','3rd','T-1','T'});
    ylabel(hmf{3});
    box off;
    title('A');
    subplot(3,3,8);
    B1.mean = squeeze(spCount_ts_mean(2,:,:));
    B1.sem = squeeze(spCount_ts_sem(2,:,:));
    B1.var = squeeze(spCount_ts_var(2,:,:));
    errorbar(X,B1.mean,B1.sem);
    set(gca,'XTick',1:5,'XTickLabel',{'1st','2nd','3rd','T-1','T'});
    box off;
    title('B1');
    subplot(3,3,9);
    B2.mean = squeeze(spCount_ts_mean(3,:,:));
    B2.sem = squeeze(spCount_ts_sem(3,:,:));
    B2.var = squeeze(spCount_ts_var(3,:,:));
    errorbar(X,B2.mean,B2.sem);
    set(gca,'XTick',1:5,'XTickLabel',{'1st','2nd','3rd','T-1','T'});
    box off;
    title('B2');
    index(3,n) = triplet_quantification(A,B1,B2);
%     legend({'8st','10st','16st','24st'});

    % save figure
    save_file_name_1 = strcat(DATE,'_SDFtriplet_cluster',num2str(cl));
    save_file_name_2 = strcat(DATE,'_spCountTriplet_cluster',num2str(cl));
    saveas(h1,fullfile(save_dir,'SDF',save_file_name_1),'png');
    saveas(h2,fullfile(save_dir,'SpikeCount',save_file_name_2),'png');
    close all;
end

% save index (h/m/fa x #clusters)
save_file_name = [DATE '_TripletIndex'];
save(fullfile(DATE,save_file_name),'index','clInfo','list_cl','list_tt','list_st');

end

% function [y] = myGauss(mu,sigma)
% % myGauss(mu,sigma) gives Gaussian function whose mean is mu and variance
% % is sigma.
% 
% x = mu-3*sigma:1:mu+3*sigma;
% M = ones(1,length(x)) * mu;
% y = 1/((2*pi)^0.5)/sigma * exp(-(x-mu).^2/(2*sigma^2));
% end