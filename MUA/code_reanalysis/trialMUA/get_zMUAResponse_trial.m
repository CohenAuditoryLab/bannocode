function [ zMUA_ABB ] = get_zMUAResponse_trial( t, chMUA_trial, ch, params )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
% define analysis windows... modified on 6/20/21
win_A  = [0:225:2250; 75:225:2325];
win_B1 = [75:225:2325; 150:225:2400];
win_B2 = [150:225:2400; 225:225:2475];
% win_spont = [-1000:5:-575; -925:5:-500];
d = 75; % duration of A tone period in the triplet (ms)
n_trial = size(chMUA_trial,2); % number of trials

% load baseline activity (mean and std) for z-score...
fPath = fullfile(ROOT_DIR,params.RecordingDate,'RESP');
fName = strcat(params.RecordingDate,'_Baseline');
load(fullfile(fPath,fName));
mMUA_baseline = ones(size(win_A,2),n_trial) * Baseline.mean(ch); % mean of the spontaneous MUA
sMUA_baseline = ones(size(win_A,2),n_trial) * Baseline.std(ch); % standard deviation of spontaneous MUA

% get MUA response for each tone
for j=1:size(win_A,2)
    i_A   = ( t >= win_A(1,j) & t < win_A(2,j) );
    i_B1  = ( t >= win_B1(1,j) & t < win_B1(2,j) );
    i_B2  = ( t >= win_B2(1,j) & t < win_B2(2,j) );
    
    t_A  = t(i_A);
    t_B1 = t(i_B1);
    t_B2 = t(i_B2);
    
    mua_A  = chMUA_trial(i_A,:);
    mua_B1 = chMUA_trial(i_B1,:);
    mua_B2 = chMUA_trial(i_B2,:);
    
    MUA_ABB(1,j,:)  = trapz(t_A,mua_A,1) * 1000 / d;
    MUA_ABB(2,j,:) = trapz(t_B1,mua_B1,1) * 1000 / d;
    MUA_ABB(3,j,:) = trapz(t_B2,mua_B2,1) * 1000 / d;
end

% calculate z score
for i=1:3
    zMUA_ABB(i,:,:) = ( squeeze(MUA_ABB(i,:,:)) - mMUA_baseline ) ./ sMUA_baseline;
end

end

