% Bootstrap MUA

nBoot = 1000; %20; % number of bootstrapping
fName = '20190409_trialMUA_ch5';
% fName = '20200110_trialMUA_ch7';
isSave = 1;
load(fName);

% extract extreme stDiff
[MUA,stDiff,targetTime,index] = rm_middleSTDiff(MUA_trial,stDiff,targetTime,index);
% remove FA trial
[MUA,stDiff,targetTime,index] = rm_FA(MUA,stDiff,targetTime,index);
nTotal = size(MUA,2); % number of trial in total

list_stDiff = unique(stDiff);
% % % small dF % % %
ttime = targetTime(stDiff==list_stDiff(1));
MUA_condition = MUA(:,stDiff==list_stDiff(1));
[tt,mua.sdf] = align_MUA(t,MUA_condition,ttime);
% resample
nTrial = length(ttime); % number of trial
for i=1:nBoot
    i_rand = randsample(nTotal,nTrial);
    MUA_resample = MUA(:,i_rand);
    ttime_resample = targetTime(i_rand);
    [~,mua_rs] = align_MUA(t,MUA_resample,ttime_resample);
    mua_boot_onset(:,i) = mean(mua_rs.onset,2);
    mua_boot_target(:,i) = mean(mua_rs.target,2);
    clear MUA_resample ttime_resamle mua_rs
end
mua_boot.sdf.onset = mua_boot_onset;
mua_boot.sdf.target = mua_boot_target;
clear mua_boot_onset mua_boot_target
clear ttime MUA_condition

% % % large dF % % %
ttime = targetTime(stDiff==list_stDiff(end));
MUA_condition = MUA(:,stDiff==list_stDiff(end));
[~,mua.ldf] = align_MUA(t,MUA_condition,ttime);
% resample
nTrial = length(ttime); % number of trial
for i=1:nBoot
    i_rand = randsample(nTotal,nTrial);
    MUA_resample = MUA(:,i_rand);
    ttime_resample = targetTime(i_rand);
    [~,mua_rs] = align_MUA(t,MUA_resample,ttime_resample);
    mua_boot_onset(:,i) = mean(mua_rs.onset,2);
    mua_boot_target(:,i) = mean(mua_rs.target,2);
    clear MUA_resample ttime_resamle mua_rs
end
mua_boot.ldf.onset = mua_boot_onset;
mua_boot.ldf.target = mua_boot_target;
clear mua_boot_onset mua_boot_target
clear ttime MUA_condition

% add hit and miss...
% % % hit % % %
ttime = targetTime(index==0);
MUA_condition = MUA(:,index==0);
[~,mua.hit] = align_MUA(t,MUA_condition,ttime);
% resample
nTrial = length(ttime); % number of trial
for i=1:nBoot
    i_rand = randsample(nTotal,nTrial);
    MUA_resample = MUA(:,i_rand);
    ttime_resample = targetTime(i_rand);
    [~,mua_rs] = align_MUA(t,MUA_resample,ttime_resample);
    mua_boot_onset(:,i) = mean(mua_rs.onset,2);
    mua_boot_target(:,i) = mean(mua_rs.target,2);
    clear MUA_resample ttime_resamle mua_rs
end
mua_boot.hit.onset = mua_boot_onset;
mua_boot.hit.target = mua_boot_target;
clear mua_boot_onset mua_boot_target
clear ttime MUA_condition

% % % miss % % %
ttime = targetTime(index==1);
MUA_condition = MUA(:,index==1);
[~,mua.miss] = align_MUA(t,MUA_condition,ttime);
% resample
nTrial = length(ttime); % number of trial
for i=1:nBoot
    i_rand = randsample(nTotal,nTrial);
    MUA_resample = MUA(:,i_rand);
    ttime_resample = targetTime(i_rand);
    [~,mua_rs] = align_MUA(t,MUA_resample,ttime_resample);
    mua_boot_onset(:,i) = mean(mua_rs.onset,2);
    mua_boot_target(:,i) = mean(mua_rs.target,2);
    clear MUA_resample ttime_resamle mua_rs
end
mua_boot.miss.onset = mua_boot_onset;
mua_boot.miss.target = mua_boot_target;
clear mua_boot_onset mua_boot_target
clear ttime MUA_condition

% save data
if isSave==1
    pos_us = strfind(fName,'_');
    save_file_name = strcat(fName(1:pos_us(1)),'bootMUA',fName(pos_us(2):end));
    save(save_file_name,'tt','mua','mua_boot','nBoot');
end