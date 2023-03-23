function [ zMUA_ABB ] = get_zMUAResponse_ABB( t, MUA_condition, params )
%UNTITLED4 Summary of this function goes here
%   obtain z-scored response of 225-ms ABB triplet period
% code modifed from get_zMUAResponse_AB.m 

% ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
% define analysis windows... modified on 12/14/21
win_ABB = [0:225:2250; 225:225:2475];
% win_spont = [-1000:5:-725; -775:5:-500]; % use grand mean and std of BL
d = 225; % duration of ABB triplet period (ms)

% load baseline activity (mean and std) for z-score...
fPath = fullfile(ROOT_DIR,params.RecordingDate,'RESP');
fName = strcat(params.RecordingDate,'_Baseline_ABB'); % get baseline activity
load(fullfile(fPath,fName));
mMUA_baseline = ones(size(win_ABB,2),1) * Baseline.mean; % mean of the spontaneous MUA
sMUA_baseline = ones(size(win_ABB,2),1) * Baseline.std; % standard deviation of spontaneous MUA

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
for j=1:size(win_ABB,2)
    i_ABB = ( t >= win_ABB(1,j) & t < win_ABB(2,j) );
    
    t_ABB = t(i_ABB);

    mua_ABB = MUA_condition(i_ABB,:);
    
    MUA_ABB(j,:) = trapz(t_ABB,mua_ABB) * 1000 / d;
end

% calculate z score
zMUA_ABB = ( MUA_ABB - mMUA_baseline ) ./ sMUA_baseline;

end

