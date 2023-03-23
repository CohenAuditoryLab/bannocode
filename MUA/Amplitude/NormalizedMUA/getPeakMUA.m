function [MUA_prop] = getPeakMUA(meanMUA,t,nTrial,list_tt)
% get mean MUA across all trials and obtains its peak value
% MUA_prop -- struct containing peak MUA, mean and std of spontaneous MUA
% sig -- significant channel (AR > 3)

win_stim     = [-1000 675]; % stimulus window (first 3 triplets)
win_target   = [-225 225]; % target window
win_baseline = [-1000 -400]; % baseline window
th = 3; % threshold for "good" auditory response

% obtain trial numbers
n_st = size(meanMUA,1); % number of dF (usually 3 or 4)
n_tt = size(meanMUA,2); % number of target time (must be 4)
nTrial(:,:,3) = []; % remove false alarm
nTrial_all = sum(sum(sum(nTrial))); % number of all trials

% get mean MUA across ALL trials...
% mMUA = [];
mMUA_sOn = []; mMUA_tOn = [];
length_tTarget = 10986; % data length of the target period must be..
for i=1:n_st
    for j=1:n_tt
        ttime = list_tt(j);
        win_tOnset = win_target + ttime; % varied depending on target time
        win_sOnset = win_stim; % fixed...
        for k=1:2
            mua_condition = meanMUA{i,j,k};
            mua_sOnset = mua_condition(t>=win_sOnset(1) & t<=win_sOnset(2),:);
            mua_tOnset = mua_condition(t>=win_tOnset(1) & t<=win_tOnset(2),:);
            
            if size(mua_tOnset,1) > length_tTarget
                mua_tOnset(end,:) = [];
            end

            w = nTrial(i,j,k) / nTrial_all; % weight
%             mua_w = mua_condition * w;
            mua_wStim = mua_sOnset * w;
            mua_wTarget = mua_tOnset * w;

%             mMUA = cat(3,mMUA,mua_w);
            mMUA_sOn = cat(3,mMUA_sOn,mua_wStim);
            mMUA_tOn = cat(3,mMUA_tOn,mua_wTarget);
        end
    end
end
t_sOn = t(t>=win_sOnset(1) & t<=win_sOnset(2));
t_tOn = linspace(win_target(1),win_target(2),length_tTarget);

% mMUA = nansum(mMUA,3);
mMUA_sOn = nansum(mMUA_sOn,3);
mMUA_tOn = nansum(mMUA_tOn,3);

% Evaluate auditory response (see Poort et al., 2016)
% spontaneous activity
spMUA = mMUA_sOn( t_sOn >= win_baseline(1) & t_sOn <= win_baseline(2) , : ); 
Sp = mean(spMUA,1); % mean of spontaneous MUA
s = std(spMUA,[],1); % std of spontaneous MUA
% activity in stimulus period (aligned by stim onset and target onset)
stimMUA = mMUA_sOn(t_sOn>=0 , :); 
peMUA_stim = max(stimMUA,[],1); % get peak from the stimulus onset resp
peMUA_target = max(mMUA_tOn,[],1); % get peak from target response
Pe = max([peMUA_stim; peMUA_target],[],1); % get max of the peaks

% 
AR = (Pe - Sp) ./ s; % calculate AR (in the way same as Poort et al., 2016)
sig = AR>th; % significant channels
MUA_prop = struct('Pe',Pe,'Sp',Sp,'s',s,'AR',AR,'sig',sig); % MUA properties for each channel

% % check normalized MUA
% figure;
% pe_mat = ones(size(mMUA_sOn,1),1) * Pe;
% normMUA_sOn =  mMUA_sOn ./ pe_mat;
% plot(t_sOn,normMUA_sOn(:,sigAR==1));
% figure;
% pe_mat = ones(size(mMUA_tOn,1),1) * Pe;
% normMUA_tOn =  mMUA_tOn ./ pe_mat;
% plot(t_tOn,normMUA_tOn(:,sigAR==1));

end
