function [] = Raster_triplet(DATE)
% clear all;
% DATE = '20191009';
% DATE = '20210208';

% load data
addpath(DATE);
load(strcat(DATE,'_activeCh'));

window = [-25 225];
% period = [0 50; 75 125; 150 200]; % set period of A, B1 and B2
period = [0 75; 75 150; 150 225]; % set period of A, B1 and B2 (3/26/21)
t_triplet = window(1):window(2)-1;
list_cl = clInfo.all_cluster;
active_cl = clInfo.active_cluster;
ch = clInfo.channel;
tt = trialInfo.target_time;
st = trialInfo.semitone_diff;
index = trialInfo.behav_ind;
index_tsRT = trialInfo.behav_ind_ts;

list_tt = unique(tt);
list_st = unique(st);

raster = Raster;
% false alarm trials with too short reaction time
raster_tsRT = raster(index_tsRT,:,:);
tt_tsRT = tt(index_tsRT);
st_tsRT = st(index_tsRT);

for i=1:length(list_tt)
    resp = raster(tt==list_tt(i),:,:);
    semitone_diff = st(tt==list_tt(i));
    behav = index(tt==list_tt(i));
    
    resp_tsRT = raster_tsRT(tt_tsRT==list_tt(i),:,:);
    semitone_diff_tsRT = st_tsRT(tt_tsRT==list_tt(i));
    
    for j=1:length(list_st)
        resp_st = resp(semitone_diff==list_st(j),:,:);
        %         spCount = sum(resp(semitone_diff==list_st(j),t_raster>0&t_raster<=list_tt(i)+75),2);
        %         fr_trial(j) = spCount * 1000 / (list_tt(i)+75);
        b = behav(semitone_diff==list_st(j));
        for k=0:2
            r = resp_st(b==k,:,:);
            R{i,j,k+1} = r; % target x semitone x behav
        end
        % too short RT trials
        r_tsRT = resp_tsRT(semitone_diff_tsRT==list_st(j),:,:);
        R_tsRT{i,j} = r_tsRT;
    end
end

% get raster for triplet
stim_a = 0:225:list_tt(end);
target_pos = list_tt/225 + 1;
% combine data across target time
R_combined = cell(length(list_st),3);
R_combined_tsRT = cell(length(list_st),1);
for i=1:length(list_tt)
    for j=1:length(list_st)
        for k=1:3
            R_temp = R{i,j,k};
            R_combined{j,k} = cat(1,R_combined{j,k},R_temp);
            clear R_temp
        end
        R_temp = R_tsRT{i,j};
        R_combined_tsRT{j} = cat(1,R_combined_tsRT{j},R_temp);
        clear R_temp
    end
end
clear i j k

R_triplet = cell(5,length(list_st),3);
R_triplet_tsRT = cell(5,length(list_st));
% get 1st, 2nd, and 3rd triplet
for i=1:3
    win = window + stim_a(i); % analysis time window for triplet
    for j=1:length(list_st)
        for k=1:3
            R_temp = R_combined{j,k};
            r = R_temp(:,t_raster>=win(1)&t_raster<win(2),:);
            R_triplet{i,j,k} = r;
            clear R_temp r
        end
        R_temp = R_combined_tsRT{j};
        r = R_temp(:,t_raster>=win(1)&t_raster<win(2),:);
        R_triplet_tsRT{i,j} = r;
        clear R_temp r 
    end
end

% get target-1 triplet
for i=1:length(list_tt)
    win = window + stim_a(target_pos(i) - 1);
    for j=1:length(list_st)
        for k=1:3
            R_temp = R{i,j,k};
            r = R_temp(:,t_raster>=win(1)&t_raster<win(2),:);
            R_triplet{4,j,k} = cat(1,R_triplet{4,j,k},r);
            clear R_temp r
        end
        R_temp = R_tsRT{i,j};
        r = R_temp(:,t_raster>=win(1)&t_raster<win(2),:);
        R_triplet_tsRT{4,j} = cat(1,R_triplet_tsRT{4,j},r);
        clear R_temp r
    end
end

% get target triplet
for i=1:length(list_tt)
    win = window + stim_a(target_pos(i));
    for j=1:length(list_st)
        for k=1:3
            R_temp = R{i,j,k};
            r = R_temp(:,t_raster>=win(1)&t_raster<win(2),:);
            R_triplet{5,j,k} = cat(1,R_triplet{5,j,k},r);
            clear R_temp r
        end
        R_temp = R_tsRT{i,j};
        r = R_temp(:,t_raster>=win(1)&t_raster<win(2),:);
        R_triplet_tsRT{5,j} = cat(1,R_triplet_tsRT{5,j},r);
        clear R_temp r
    end
end

% spike count triplet
for i=1:5 % triplet position
    for j=1:length(list_st) % semitone difference
        for k=1:3 % hit miss fa
            r = R_triplet{i,j,k};
%             sp_count = get_spikecount_triplet(r,t_triplet,period);
            [sp_count,a,b1,b2] = get_spikecount_triplet(r,t_triplet,period);
            SPC_triplet_m(i,j,k,:,:) = sp_count.mean;
            SPC_triplet_v(i,j,k,:,:) = sp_count.var;
            SPC_triplet_s(i,j,k,:,:) = sp_count.std;
            SPC_triplet_se(i,j,k,:,:) = sp_count.std / sqrt(size(r,1));
            A{i,j,k} = a;
            B1{i,j,k} = b1;
            B2{i,j,k} = b2;
            clear r sp_count a b1 b2
        end
        r_ts = R_triplet_tsRT{i,j};
%         sp_count_ts = get_spikecount_triplet(r_ts,t_triplet,period);
        [sp_count_ts,a_ts,b1_ts,b2_ts] = get_spikecount_triplet(r_ts,t_triplet,period);
        SPC_triplet_ts_m(i,j,:,:) = sp_count_ts.mean;
        SPC_triplet_ts_v(i,j,:,:) = sp_count_ts.var;
        SPC_triplet_ts_s(i,j,:,:) = sp_count_ts.std;
        SPC_triplet_ts_se(i,j,:,:) = sp_count_ts.std / sqrt(size(r_ts,1));
        A_ts{i,j} = a_ts;
        B1_ts{i,j} = b1_ts;
        B2_ts{i,j} = b2_ts;
        clear r_ts sp_count_ts a_ts b1_ts b2_ts
    end
end
% reshape the matrix in the order of 
% triplet x triplet pos x st diff x behav x unit
SPC_triplet.mean = permute(SPC_triplet_m,[4 1 2 3 5]);
SPC_triplet.var = permute(SPC_triplet_v,[4 1 2 3 5]);
SPC_triplet.std = permute(SPC_triplet_s,[4 1 2 3 5]);
SPC_triplet.sem = permute(SPC_triplet_se,[4 1 2 3 5]);
% reshape matric in the order of
% triplet x triplet pos x stdiff x unit
SPC_triplet_tsRT.mean = permute(SPC_triplet_ts_m,[3 1 2 4]);
SPC_triplet_tsRT.var = permute(SPC_triplet_ts_v,[3 1 2 4]);
SPC_triplet_tsRT.std = permute(SPC_triplet_ts_s,[3 1 2 4]);
SPC_triplet_tsRT.sem = permute(SPC_triplet_ts_se,[3 1 2 4]);

% save file
save_file_name = [DATE '_Raster_triplet'];
save(fullfile(DATE,save_file_name),'R','R_tsRT','R_triplet','R_triplet_tsRT', ...
     'SPC_triplet','SPC_triplet_tsRT', 'A','A_ts', ...
     'B1','B1_ts','B2','B2_ts', ...
     't_raster','t_triplet','clInfo','list_cl','list_tt','list_st');
 
end
