function [ ACF_subt, Max_ACF_A_Lag, Max_ACF_B_Lag, H ] = getAutocorrelation_AB( MUA_ST, t, params )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% RecordingDate = '20180807';
% HorM = 1; % hit or miss (1 for hit, 2 for miss)

% SampleRate = 24414; % original SR
% Nyquist = SampleRate/2;
% Baseline = 500; % baseline correction window in ms
% pointspermsec = SampleRate / 1000;
% msecperpoint = 1 / pointspermsec;
Nyquist = params.SampleRate/2;
pointspermsec = params.SampleRate/1000;
Baseline = params.Baseline;

% fName = strcat(RecordingDate,'_ABBA_MUA'); % data file name
% load(fullfile(DATA_DIR,fName));



% Data_ST_8 = meanMUA(:,:,1,HorM);

time = t';
NewData_ST = MUA_ST(round(pointspermsec*Baseline):round(pointspermsec*(Baseline+1500)),:); % isolate data
Newtime = time(round(pointspermsec*Baseline):round(pointspermsec*(Baseline+1500)),:); % isolate time
nChannel = size(NewData_ST,2);



ACF_ST=[];
for c=1:nChannel
    ACF_ST(:,c) = xcorr(NewData_ST(:,c),'coeff');
end



d = find( ACF_ST(:,1) == 1.0 );%find 'zero' lag
if isempty(d) % in case that ACF_ST is all NaN (no trials with corresponding stim x behav condition)
    d = ceil( size(ACF_ST,1)/2 );
end
ACF_ST = ACF_ST(d:size(ACF_ST,1),:);% retain postive lags

ACF_ST = ACF_ST(1:8000,:);%limit ACF

ACFtime = 0:(time(2)-time(1)):size(ACF_ST,1)*(time(2)-time(1));
ACFtime = ACFtime';
ACFtime = ACFtime(1:(size(ACFtime,1)-1),1);
% figure(1);
% contourf(ACF_ST);
% view(30,-90);


H(1) = figure;
subplot(2,1,1);
plot(Newtime,NewData_ST);% plot ACF
title('rectified MUA');
xlabel('Time [ms]'); ylabel('Voltage [uV]');
xlim([0 1500]);

% figure;
subplot(2,1,2);
plot(ACFtime,ACF_ST);% plot ACF
title('ACF');
xlabel('Time [ms]'); ylabel('xCorr');
xlim([0 325]);

%Compute ratio of ACF at B lag (150 ms) to A lag (225 ms):
% Find B lag
B_Lag = find( round(ACFtime) == 150 );
ACF_B_Lag = ACF_ST( B_Lag(1)-200:B_Lag(size(B_Lag,1))+200, : );
Max_ACF_B_Lag = max( ACF_B_Lag, [], 1 );%Get Max value within B_Lag interval

% Find A lag
A_Lag = find( round(ACFtime) == 225 );
ACF_A_Lag = ACF_ST( A_Lag(1)-200:A_Lag(size(A_Lag,1))+200, : );
Max_ACF_A_Lag = max( ACF_A_Lag, [], 1 );%Get Max value within A_Lag interval

% difference
ACF_subt = Max_ACF_A_Lag - Max_ACF_B_Lag;

H(2) = figure;
subplot(2,1,1);
plot(1:nChannel,Max_ACF_A_Lag,'r','LineWidth',2); hold on;
plot(1:nChannel,Max_ACF_B_Lag,'b','LineWidth',2);
xlim([0 nChannel+1]);
legend({'A lag','B lag'});
title('Max ACF');
xlabel('Channel'); ylabel('xCorr');
box off;

% figure;
subplot(2,1,2);
plot(1:nChannel,ACF_subt,'LineWidth',2);
xlim([0 nChannel+1]);
title('difference (A - B)');
xlabel('Channel');
box off;

%Plot ACF as surface plot

for g=1:size(ACF_ST,2);
    Timematrix(:,g) = ACFtime;%creates matrix consisting of g-identical columns of time points
end

Channelmatrix = ones(size(ACF_ST,1),size(ACF_ST,2));%creates matrix of ones 

Channel = 1:nChannel;
%Channel=Channel';

for c=1:nChannel
    Channelmatrix(:,c) = Channel(c);
end

H(3) = figure;
surf( Timematrix, Channelmatrix, ACF_ST );
colormap('jet');

shading interp
axis tight
view(0,-90);

xlabel('Time [ms]'); ylabel('Channel');

end

