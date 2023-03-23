function [ zMUA_BB ] = get_zMUAResponse_BB( t, MUA_condition, params )
%UNTITLED4 Summary of this function goes here
%   obtain z-scored response of 150-ms BB triplet period
% code modifed from get_zMUAResponse_AB.m 

% ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
% define analysis windows... modified on 1/28/22
win_BB = [(0:225:2250) + 75; 225:225:2475];
% win_spont = [-1000:5:-725; -775:5:-500]; % use grand mean and std of BL
d = 150; % duration of BB period (ms)

% load baseline activity (mean and std) for z-score...
fPath = fullfile(ROOT_DIR,params.RecordingDate,'RESP');
fName = strcat(params.RecordingDate,'_Baseline_BB'); % get baseline activity
load(fullfile(fPath,fName));
mMUA_baseline = ones(size(win_BB,2),1) * Baseline.mean; % mean of the spontaneous MUA
sMUA_baseline = ones(size(win_BB,2),1) * Baseline.std; % standard deviation of spontaneous MUA

% % get spontaneous activity (old version)
% for k=1:size(win_spont,2)
%     i_spont = ( t >= win_spont(1,k) & t < win_spont(2,k) );
%     t_spont = t(i_spont);
%     mua_spont = MUA_condition(i_spont,:);
%     MUA_spont(k,:)  = trapz(t_spont,mua_spont) * 1000 / d;
% end
% mMUA_spont = ones(size(win_A,2),1) * mean(MUA_spont,1); % mean of the spontaneous MUA
% sMUA_spont = ones(size(win_A,2),1) * std(MUA_spont,0,1); % standard deviation of spontaneous MUA

% get MUA response for each tone
for j=1:size(win_BB,2)
    i_BB = ( t >= win_BB(1,j) & t < win_BB(2,j) );
    
    t_BB = t(i_BB);

    mua_BB = MUA_condition(i_BB,:);
    
    MUA_BB(j,:) = trapz(t_BB,mua_BB) * 1000 / d;
end

% calculate z score
zMUA_BB = ( MUA_BB - mMUA_baseline ) ./ sMUA_baseline;

end

