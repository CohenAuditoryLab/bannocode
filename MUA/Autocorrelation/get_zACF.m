function [ ACF_subt, Max_ACF_A_Lag, Max_ACF_B_Lag, H ] = get_zACF( MUA_ST, t, params )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


% clear all
% close all
% 
% ANIMAL = 'Domo';
% % set path to the Data directory
% DATA_DIR = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/DATA/MUA',ANIMAL);
% SAVE_DIR = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results';
% % set parameters
% params.RecordingDate = '20180727';
% params.SampleRate = 24414; % original SR
% params.Baseline = 500; % baseline correction window in ms
% % load file...
% fName = strcat(params.RecordingDate,'_ABBA_MUA'); % data file name
% load(fullfile(DATA_DIR,fName));
% 
% MUA_ST = meanMUA(:,:,3,1); % sample MUA for developing code...

Nyquist = params.SampleRate/2;
pointspermsec = params.SampleRate/1000;
% msecperpoint = 1/pointspermsec;
Baseline = params.Baseline; % baseline correction window in ms
% points = params.Points; % moving average window
points = 100;
th = 1.645; % significance threshold for z score (95% for one sided)

time = t';
NewData_ST = MUA_ST(round(pointspermsec*Baseline):round(pointspermsec*(Baseline+1500)),:);%isolate data
% Baseline_ST = MUA_ST(1:round(pointspermsec*Baseline),:);
New_t = time(round(pointspermsec*Baseline):round(pointspermsec*(Baseline+1500)));
nChannel = size(NewData_ST,2);

% compute ACF
ACF_ST=[];
for c=1:nChannel
    ACF_ST(:,c) = xcorr(NewData_ST(:,c),'coeff');
%     bACF_ST(:,c) = xcorr(Baseline_ST(:,c),'coeff');
end
d = find( ACF_ST(:,1) == 1.0 );%find 'zero' lag
if isempty(d) % in case that ACF_ST is all NaN (no trials with corresponding stim x behav condition)
    d = ceil( size(ACF_ST,1)/2 );
end
ACF_ST = ACF_ST(d:size(ACF_ST,1),:); % retain postive lags
ACF_ST = ACF_ST(1:8000,:); % limit ACF

ACFtime = 0:(time(2)-time(1)):size(ACF_ST,1)*(time(2)-time(1));
ACFtime = ACFtime';
ACFtime = ACFtime(1:(size(ACFtime,1)-1),1);

% % baseline
% d = find( bACF_ST(:,1) == 1.0);
% if isempty(d)
%     d = ceil( size(bACF_ST,1),2 );
% end
% bACF_ST = bACF_ST(d:size(bACF_ST,1),:);
% bACF_ST = bACF_ST(1:8000,:); % limit bACF

% get mean and std for z-score...
mean_ACF = mean(ACF_ST,1); mean_ACF = ones(size(ACF_ST,1),1) * mean_ACF;
std_ACF = std(ACF_ST,0,1); std_ACF = ones(size(ACF_ST,1),1) * std_ACF;

% calculate z-score
z_ACF = (ACF_ST - mean_ACF) ./ std_ACF;


%Compute ratio of ACF at B lag (150 ms) to A lag (225 ms):
% Find B lag
B_Lag = find( round(ACFtime) == 150 );
ACF_B_Lag = z_ACF( B_Lag(1)-200:B_Lag(size(B_Lag,1))+200, : );
Max_ACF_B_Lag = max( ACF_B_Lag, [], 1 );%Get Max value within B_Lag interval

% Find A lag
A_Lag = find( round(ACFtime) == 225 );
ACF_A_Lag = z_ACF( A_Lag(1)-200:A_Lag(size(A_Lag,1))+200, : );
Max_ACF_A_Lag = max( ACF_A_Lag, [], 1 );%Get Max value within A_Lag interval

% % Find null lag
% N_Lag = find( round(ACFtime) == 112 );
% ACF_N_Lag = z_ACF( N_Lag(1)-200:N_Lag(size(N_Lag,1))+200, : );
% % Min_ACF_N_Lag = min( ACF_N_Lag, [], 1 );%Get Min value within null_Lag interval
% Mean_ACF_N_Lag = mean( ACF_N_Lag, 1 );%Get mean value within null_Lag interval

% Max_ACF_A_Lag = Max_ACF_A_Lag - Mean_ACF_N_Lag;
% Max_ACF_B_Lag = Max_ACF_B_Lag - Mean_ACF_N_Lag;

% difference
ACF_subt = Max_ACF_A_Lag - Max_ACF_B_Lag;

% nlag_matrix = ones(size(z_ACF,1),1) * Mean_ACF_N_Lag;
% d_ACF = z_ACF - nlag_matrix;

% display figures
H(1) = figure;
subplot(2,1,1);
plot(New_t,NewData_ST);
title('rectifed MUA');
set(gca,'xlim',[min(New_t) max(New_t)]);
xlabel('Time [ms]'); ylabel('Voltage [uV]');
xlim([0 1500]);

subplot(2,1,2);
plot(ACFtime(points:end),z_ACF(points:end,:)); hold on;
% plot(ACFtime(points:end),d_ACF(points:end,:));
plot([0 325],[th th],':k');
xlabel('Time [ms]'); ylabel('z-score');
xlim([0 325]);

H(2) = figure;
subplot(2,1,1);
plot(1:nChannel,Max_ACF_A_Lag,'r','LineWidth',2); hold on;
plot(1:nChannel,Max_ACF_B_Lag,'b','LineWidth',2);
plot([0 nChannel+1],[th th],':k');
xlim([0 nChannel+1]);
legend({'A lag','B lag'});
title('Max ACF');
xlabel('Channel'); ylabel('z-score');
box off;

% figure;
subplot(2,1,2);
plot(1:nChannel,ACF_subt,'LineWidth',2);
xlim([0 nChannel+1]);
title('difference (A - B)');
xlabel('Channel');
box off;

%Plot ACF as surface plot
z_acf_plot = z_ACF(points:end,:);
% z_acf_plot = d_ACF(points:end,:);

Timematrix = ACFtime(points:end) * ones(1,nChannel);
% Channelmatrix = ones(size(z_acf_plot));%creates matrix of ones 

Channel = 1:nChannel;
Channelmatrix = ones(size(z_acf_plot,1),1) * Channel;

H(3) = figure;
surf( Timematrix, Channelmatrix, z_acf_plot );
colormap('jet');

shading interp
axis tight
view(0,-90);

xlabel('Time [ms]'); ylabel('Channel');


end

