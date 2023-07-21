function [time,MUA] = align_MUA(t,MUA_trial,ttime)
% align MUA at simulus and target onset (for bootstrap analysis)
% code modified from plot_ExampleMUA_v4_2_gr.m

% set analysis time window
w_onset = [-50 700]; % 1st to 3rd triplet
w_target = [-250 250]; % T-1 and T triplet
t_onset = w_onset(1)/1000:1/24414:w_onset(2)/1000;
t_onset = t_onset * 1000; % in ms
t_target = w_target(1)/1000:1/24414:w_target(2)/1000;
t_target = t_target * 1000; % in ms

t_range = w_onset;
ind_t = find(t>=t_range(1),1,'first');
idx_onset = ind_t:ind_t+length(t_onset)-1;
clear t_range ind_t

% cut around stimulus onset
MUA_onset = MUA_trial(idx_onset,:);
mMUA_onset = mean(MUA_onset,2); % mean
% plot(t_onset,mean(MUA_onset,2));

% cut around target
n_trial = size(MUA_trial,2); % number of trials
for i=1:n_trial
    t_range = ttime(i) + w_target;
    ind_t = find(t>=t_range(1),1,'first');
    idx_target = ind_t:ind_t+length(t_target)-1;
    MUA_target(:,i) = MUA_trial(idx_target,i);
    clear t_range ind_t
end
mMUA_target = mean(MUA_target,2);

MUA.onset  = MUA_onset; % mMUA_onset;
MUA.target = MUA_target; % mMUA_target;
time.onset = t_onset;
time.target = t_target;

end