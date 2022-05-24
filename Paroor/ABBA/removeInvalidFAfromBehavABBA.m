function [] = removeInvalidFAfromBehavABBA(date)
% remove FA trials 
% clear all

% date = '20201123';
file_name = strcat(date,'_ABBA_BehavData');
behav_file_dir = fullfile('D:\Cassius\04_ABBA',date);

load(fullfile(behav_file_dir,file_name));

n_original = numel(index);
n_invalid_FA = sum(index==2) - numel(index_tsRT);
n_SE = sum(index>=3);

disp(strcat('number of trials before process = ',num2str(n_original)));
disp(strcat(num2str(n_invalid_FA),' invalid FA trials detected...'));
disp(strcat(num2str(n_SE),' start error trials detected...'));

i = 1:numel(index);
index_temp = index;
index_temp(index_tsRT) = -1;
i_invalid = i(index_temp>=2);
TrialID_original = i;
clear i index_temp

% remove invalid FA trials...
index(i_invalid) = [];
Lever1(i_invalid,:) = [];
Lever2(i_invalid,:) = [];
leverRelease(i_invalid) = [];
LeverReleaseTime(i_invalid) = [];
Rew(i_invalid,:) = [];
stDiff(i_invalid) = [];
Stim(i_invalid,:) = [];
stimOn(i_invalid) = [];
StimOnTime(i_invalid) = [];
targetTime(i_invalid) = [];
tranges(:,i_invalid) = [];
TrialID_original(i_invalid) = [];

n_ValidTrials = numel(index);
disp(strcat(num2str(n_ValidTrials),' valid trials in the end...'));

% updata params
param.nValidTrials = n_ValidTrials;

% save file...
disp(strcat('saving ', file_name));
save_file_name = strcat(file_name,'_tsFA');
save(fullfile(behav_file_dir,save_file_name),'param','tranges', 'TrialID_original', ...
                    'stimOn','StimOnTime','leverRelease','LeverReleaseTime', ...
                    'index','targetTime','stDiff', ...
                    'Stim','Lever1','Lever2','Rew','t_stim','t_hand','-v7.3');
                
end
