clear all;
% addpath('E:\99_MatlabToolbox\myFunction');
% DATE = '20180907';
DATE = '20190409';
bin = 10; % bin size in ms

% load data
addpath(DATE);
load(strcat(DATE,'_activeCh'));

list_cl = clInfo.all_cluster;
active_cl = clInfo.active_cluster;
ch = clInfo.channel;
tt = trialInfo.target_time;
st = trialInfo.semitone_diff;
index = trialInfo.behav_ind;
index_tsRT = trialInfo.behav_ind_ts;

for n=1:length(list_cl)
% cl = active_cl(7);
cl = list_cl(n);
raster = Raster(:,:,list_cl==cl);
list_tt = unique(tt);
list_st = unique(st);
% obtain onset time for each tone
stim_a = transpose(ones(4,1)*(0:225:1350));
stim_a(5:end,1) = NaN; stim_a(6:end,2) = NaN; stim_a(7:end,3) = NaN;
stim_b = [];
for aa=1:size(stim_a,1)
    temp = [stim_a(aa,:)+75; stim_a(aa,:)+150];
    stim_b = [stim_b; temp];
end

c = [100 100 100; 51 102 255; 255 0 0] / 255; % set line color
w = [2 1 1]; % set line width
for i=1:length(list_tt)
    resp = raster(tt==list_tt(i),:);
    semitone_diff = st(tt==list_tt(i));
    behav = index(tt==list_tt(i));
%     list_st = unique(semitone_diff);
    figure(i);
    for j=1:length(list_st)
        resp_st = resp(semitone_diff==list_st(j),:);
        spCount = sum(resp(semitone_diff==list_st(j),t_raster>0&t_raster<=list_tt(i)+75),2);
%         fr_trial(j) = spCount * 1000 / (list_tt(i)+75);
        b = behav(semitone_diff==list_st(j));
        for k=0:2
            r = resp_st(b==k,:);
            R{i,j,k+1} = r; % target x semitone x behav
            sdf = conv(myGauss(0,bin),sum(r,1)) / size(r,1) * 1000;
            sdf = sdf(3*bin:end-3*bin-1);
            subplot(4,1,j); hold on;
            % plot SDF
            plot(t_raster,sdf,'Color',c(k+1,:),'LineWidth',w(k+1));
            SDF(:,i,j,k+1) = sdf; % target x semitone x behav
%             set(gca,'xlim',[-500 2500]);
        end
        
        % plot stim A
        stim_a_time = [stim_a(:,i) stim_a(:,i)+50];
        for aa=1:size(stim_a,1)
            plot(stim_a_time(aa,:),[0 0],'Color',[255 124 158]/255,'LineWidth',4);
        end
        % plot stim B
        stim_b_time = [stim_b(:,i) stim_b(:,i)+50];
        for bb=1:size(stim_b,1)
            plot(stim_b_time(bb,:),[0 0],'Color',[153 204 255]/255,'LineWidth',4);
        end
        % plot target
        plot([list_tt(i) list_tt(i)+50],[0 0],'Color',[204 0 0]/255,'LineWidth',4);
        set(gca,'xlim',[-500 2500]);
        title([num2str(list_st(j)) ' semitone diff']);
    end
    fig_title = [DATE '_SDF_cluster' num2str(list_cl(n)) '_TargetTime' num2str(list_tt(i))];
    saveas(gcf,fig_title,'png');
    close all;
end

% obtain firing rate
fr_whole = cell(length(list_st),3);
fr_a = cell(length(list_tt),length(list_st),3);
fr_b = cell(length(list_tt),length(list_st),3);
fr_target = cell(length(list_st),3);
fr_adapt = cell(length(list_st),3);
fr_AvsB = cell(length(list_st),3);
for i=1:length(list_tt)
    window_a = [stim_a(:,i) stim_a(:,i)+75];
    window_b = [stim_b(1:2:end,i) stim_b(1:2:end,i)+150];
    n_tone = sum(~isnan(stim_a(:,i)));
    t_a = logical(sum(t_raster>window_a(1:i+2,1) & t_raster<=window_a(1:i+2,2),1));
    t_b = logical(sum(t_raster>window_b(1:i+2,1) & t_raster<=window_b(1:i+2,2),1));
    for j=1:length(list_st)
        temp_h = R{i,j,1}; % hit trials
        temp_m = R{i,j,2}; % miss trials
        temp_f = R{i,j,3}; % false alarm trials
        % whole period (stimlus onset to the end of the "target triplet")
        fr_whole{j,1} = [fr_whole{j,1}; sum(temp_h(:,t_raster>0&t_raster<=(list_tt(i)+225)),2)*1000/(list_tt(i)+225)];
        fr_whole{j,2} = [fr_whole{j,2}; sum(temp_m(:,t_raster>0&t_raster<=(list_tt(i)+225)),2)*1000/(list_tt(i)+225)];
        fr_whole{j,3} = [fr_whole{j,3}; sum(temp_f(:,t_raster>0&t_raster<=(list_tt(i)+225)),2)*1000/(list_tt(i)+225)];
        
        tempfr_ah = []; tempfr_am = []; tempfr_af = [];
        tempfr_bh = []; tempfr_bm = []; tempfr_bf = [];
        for k=1:n_tone
            % tone A + target
            tempfr_ah = [tempfr_ah sum(temp_h(:,t_raster>window_a(k,1)&t_raster<=window_a(k,2)),2)*1000/75];
            tempfr_am = [tempfr_am sum(temp_m(:,t_raster>window_a(k,1)&t_raster<=window_a(k,2)),2)*1000/75];
            tempfr_af = [tempfr_af sum(temp_f(:,t_raster>window_a(k,1)&t_raster<=window_a(k,2)),2)*1000/75];
            % tone B (include the ones immediately after the target)
            tempfr_bh = [tempfr_bh sum(temp_h(:,t_raster>window_b(k,1)&t_raster<=window_b(k,2)),2)*1000/150];
            tempfr_bm = [tempfr_bm sum(temp_m(:,t_raster>window_b(k,1)&t_raster<=window_b(k,2)),2)*1000/150];
            tempfr_bf = [tempfr_bf sum(temp_f(:,t_raster>window_b(k,1)&t_raster<=window_b(k,2)),2)*1000/150];
        end
        fr_a{i,j,1} = tempfr_ah; fr_a{i,j,2} = tempfr_am; fr_a{i,j,3} = tempfr_af;
        fr_b{i,j,1} = tempfr_bh; fr_b{i,j,2} = tempfr_bm; fr_b{i,j,3} = tempfr_bf;
        
        % target period
        fr_target{j,1} = [fr_target{j,1}; sum(temp_h(:,t_raster>list_tt(i)&t_raster<=(list_tt(i)+75)),2)*1000/75];
        fr_target{j,2} = [fr_target{j,2}; sum(temp_m(:,t_raster>list_tt(i)&t_raster<=(list_tt(i)+75)),2)*1000/75];
        fr_target{j,3} = [fr_target{j,3}; sum(temp_f(:,t_raster>list_tt(i)&t_raster<=(list_tt(i)+75)),2)*1000/75];

        % 1st A and tone A immediately before the target
        r_1st = sum(temp_h(:,t_raster>0&t_raster<=75),2)*1000/75;
        r_tm1 = sum(temp_h(:,t_raster>(list_tt(i)-225)&t_raster<=(list_tt(i)-150)),2)*1000/75;
        fr_adapt{j,1} = [fr_adapt{j,1}; [r_1st r_tm1]];
        r_1st = sum(temp_m(:,t_raster>0&t_raster<=75),2)*1000/75;
        r_tm1 = sum(temp_m(:,t_raster>(list_tt(i)-225)&t_raster<=(list_tt(i)-150)),2)*1000/75;
        fr_adapt{j,2} = [fr_adapt{j,2}; [r_1st r_tm1]];
        r_1st = sum(temp_f(:,t_raster>0&t_raster<=75),2)*1000/75;
        r_tm1 = sum(temp_f(:,t_raster>(list_tt(i)-225)&t_raster<=(list_tt(i)-150)),2)*1000/75;
        fr_adapt{j,3} = [fr_adapt{j,3}; [r_1st r_tm1]];

        % tone A and tone B (target not included)
        r_a = sum(temp_h(:,t_a),2)*1000/(75*(n_tone-1));
        r_b = sum(temp_h(:,t_b),2)*1000/(150*(n_tone-1));
        fr_AvsB{j,1} = [fr_AvsB{j,1}; [r_a r_b]];
        r_a = sum(temp_m(:,t_a),2)*1000/(75*(n_tone-1));
        r_b = sum(temp_m(:,t_b),2)*1000/(150*(n_tone-1));
        fr_AvsB{j,2} = [fr_AvsB{j,2}; [r_a r_b]];
        r_a = sum(temp_f(:,t_a),2)*1000/(75*(n_tone-1));
        r_b = sum(temp_f(:,t_b),2)*1000/(150*(n_tone-1));
        fr_AvsB{j,3} = [fr_AvsB{j,3}; [r_a r_b]];
    end
end
fr(n).whole = fr_whole;
fr(n).a = fr_a;
fr(n).b = fr_b;
fr(n).target = fr_target;
fr(n).adapt = fr_adapt;
fr(n).AvsB = fr_AvsB;
end
save_file_name = [DATE '_ABBA_FiringRate'];
save(save_file_name,'fr','clInfo','list_cl','list_tt','list_st');

% % test sdf plotting
% sptime = [];
% bin = 5; % bin size in ms
% for i=1:size(raster,1)
%     temp = SpikeTiming{i};
%     sp = temp(:,1);
%     cid = temp(:,2);
%     sp_temp = sp(cid==cl);
%     sptime = [sptime sp_temp'];
% end
% psth = histcounts(sptime,-500:bin:2500) / size(raster,1) * 1000/bin;
% sdf = conv(myGauss(0,bin),sum(raster,1)) / size(raster,1) * 1000;
% sdf = sdf(3*bin:end-3*bin-1);
% figure;
% bar(bin/2:bin:3000-bin/2,psth); hold on;
% plot(sdf,'LineWidth',1.5);
% % end test

function [y] = myGauss(mu,sigma)
% myGauss(mu,sigma) gives Gaussian function whose mean is mu and variance
% is sigma.

x = mu-3*sigma:1:mu+3*sigma;
M = ones(1,length(x)) * mu;
y = 1/((2*pi)^0.5)/sigma * exp(-(x-mu).^2/(2*sigma^2));
end