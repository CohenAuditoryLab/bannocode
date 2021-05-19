clear all
DATE = '20200114';
save_fig = 1; % save figure if 1

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

nTrial = numel(SpikeTiming);
nUnit = numel(active_cl);
delay = 10; % response latency = 10 ms
T_toneA = 225; % interval between tone A = 225 ms

% list_st = transpose(unique(st));
list_st = unique(st);
num_st = numel(list_st);

c = [.39 .39 .39; .2 .4 1; 1 0 0];
theta_hit = cell(1,num_st); ch_hit = cell(1,num_st);
theta_miss = cell(1,num_st); ch_miss = cell(1,num_st);
theta_fa = cell(1,num_st); ch_fa = cell(1,num_st);
for i=1:num_st
    iSTD = list_st(i);
    trial_id = 1:nTrial;
    i_hit = trial_id( index==0 & st==iSTD ); % Hit
    i_miss = trial_id( index==1 & st==iSTD ); % miss
    i_fa = transpose(index_tsRT(st(index_tsRT)==iSTD)); % false alarm
    
    % combine hit trials
    n = 1;
    for trial=i_hit
        time_stamps = SpikeTiming{trial}(:,1);
        channel_id = SpikeTiming{trial}(:,2);
        analysis_period = [delay tt(trial)+50+delay];
        t_spike = time_stamps(time_stamps>+analysis_period(1) & time_stamps<analysis_period(2));
        t_ch = channel_id(time_stamps>+analysis_period(1) & time_stamps<analysis_period(2));
        %             t_spike = t_spike - delay;
        theta = 2*pi*mod(t_spike,T_toneA)/T_toneA;
        theta_hit{i} = [theta_hit{i}; theta];
        ch_hit{i} = [ch_hit{i}; t_ch];
        
        n = n + 1;
    end
    nHit(i) = n-1; % number of hit trials
    
    % combine miss trials
    n = 1;
    for trial=i_miss
        time_stamps = SpikeTiming{trial}(:,1);
        channel_id = SpikeTiming{trial}(:,2);
        analysis_period = [delay tt(trial)+50+delay];
        t_spike = time_stamps(time_stamps>+analysis_period(1) & time_stamps<analysis_period(2));
        t_ch = channel_id(time_stamps>+analysis_period(1) & time_stamps<analysis_period(2));
        %             t_spike = t_spike - delay;
        theta = 2*pi*mod(t_spike,T_toneA)/T_toneA;
        theta_miss{i} = [theta_miss{i}; theta];
        ch_miss{i} = [ch_miss{i}; t_ch];
        n = n + 1;
    end
    nMiss(i) = n-1; % number of miss trials
    
    % combine false alarm trials
    n = 1;
    for trial=i_fa
        time_stamps = SpikeTiming{trial}(:,1);
        channel_id = SpikeTiming{trial}(:,2);
        analysis_period = [delay tt(trial)+50+delay];
        t_spike = time_stamps(time_stamps>+analysis_period(1) & time_stamps<analysis_period(2));
        t_ch = channel_id(time_stamps>+analysis_period(1) & time_stamps<analysis_period(2));
        %             t_spike = t_spike - delay;
        theta = 2*pi*mod(t_spike,T_toneA)/T_toneA;
        theta_fa{i} = [theta_fa{i}; theta];
        ch_fa{i} = [ch_fa{i}; t_ch];
        n = n + 1;
    end
    nFA(i) = n-1; % number of false alarm trials
end

% display polar distribution
Phase = nan(num_st,3,nUnit);
VS = nan(num_st,3,nUnit);
Rstat = nan(num_st,3,nUnit);
Phase_all = nan(3,nUnit);
VS_all = nan(3,nUnit);
Rstat_all = nan(3,nUnit);

for j=1:nUnit
    cl_id = active_cl(j);
    figure;
    for k=1:3
        if k==1
            temp_theta = theta_hit;
            temp_ch = ch_hit;
            string = '_VectorStrength_hit_';
        elseif k==2
            temp_theta = theta_miss;
            temp_ch = ch_miss;
            string = '_VectorStrength_miss_';
        else
            temp_theta = theta_fa;
            temp_ch = ch_fa;
            string = '_VectorStrength_fa_';
        end
        theta_all = [];
        for i=1:num_st
            T = []; R = [];
            th = temp_theta{i};
            ch = temp_ch{i};
            %                 theta = th(ch==j);
            theta = th(ch==cl_id);
            if ~isnan(theta)
                [T,R] = rose(theta,24);
                C = sum(cos(theta));
                S = sum(sin(theta));
                Phase(i,k,j) = atan(S/C); % mean phase
                VS(i,k,j) = sqrt(C^2+S^2) / numel(theta); % vector strength
                Rstat(i,k,j) = 2*VS(i,k,j)^2*numel(theta); % Rayleigh statistic
            else
                Phase(i,k,j) = NaN;
                VS(i,k,j) = NaN;
                Rstat(i,k,j) = NaN;
            end
            stdiff(i,k,j) = list_st(i);
            group(i,k,j) = k;
            
            % display polar distribution
            R = R/sum(R); % normalize
            subplot(2,num_st,i);
            h = polar(T,R); hold on;
            set(h,'Color',c(k,:));
%             polarplot(T,R,'Color',c(k,:)); hold on;
            %                 polarplot([Phase(i,j,k) Phase(i,j,k)],[0 VS(i,j,k)],'Color',c(k,:));
            title([num2str(list_st(i)) ' st diff']);
            theta_all = [theta_all; theta];
        end
        subplot(2,1,2);
        plot(list_st,VS(:,k,j),'Color',c(k,:),'LineWidth',2); hold on
        
        % calclate vector strength of all trials
        C_all = sum(cos(theta_all));
        S_all = sum(sin(theta_all));
        Phase_all(k,j) = atan(S_all/C_all); % mean phase
        VS_all(k,j) = sqrt(C_all^2+S_all^2) / numel(theta_all); % vector strength
        Rstat_all(k,j) = 2*VS_all(k,j)^2*numel(theta_all); % Rayleigh statistic  
    end
    xlabel('semitone difference'); ylabel('vector strength');
    fig_title = strcat(DATE,'_VectorStrength_cluster',num2str(cl_id));
    title(fig_title);
    box off
    
    if save_fig
        saveas(gcf,fig_title,'png');
        close all
    end
end


% save data
save_file_name = [DATE '_ABBA_VectorStrength'];
save(save_file_name,'VS','Phase','Rstat','VS_all','Phase_all','Rstat_all','stdiff','group','clInfo','active_cl','list_st');