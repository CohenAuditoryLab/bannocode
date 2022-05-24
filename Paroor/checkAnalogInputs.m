load '20200807_ABBA_BehavData_test';

nTrial = param.nValidTrials;
i_temp = 1:nTrial; % index number of whole sesssion
iHit = i_temp(index==0); % index for hit
iMiss = i_temp(index==1); % index for miss
iFA = i_temp(index==2); % index for false alarm
iSE = i_temp(index==3); % index for start error

count = 1;
% for i = 31:40
i = 32;
n = iFA(i);
figure;
% subplot(2,5,count);
plot(t_stim,Stim(n,:)); hold on;
plot(t_hand,Lever2(n,:)/16);
plot(t_hand,Lever1(n,:)/16);
plot(t_hand,Rew(n,:)/32);
count = count + 1;
% end