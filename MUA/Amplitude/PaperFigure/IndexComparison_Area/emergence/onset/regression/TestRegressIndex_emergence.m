% regression analysis
clear all
load IndexTable.mat

% ABB = 3;
% data_abb = Data(:,:,ABB);
data_abb = mean(Data,3); % take the mean of triplet
data_abb_core = data_abb(data_abb(:,3)==0,:); % separated core data
data_abb_belt = data_abb(data_abb(:,3)==1,:); % separated belt data

nUnit_core = max(unique(data_abb_core(:,5)));
unit_belt = data_abb_belt(:,5);
unit_belt = unit_belt - nUnit_core; % reorder unit id number
data_abb_belt(:,5) = unit_belt; % substitute unit id

% format data into table
% smi_tbl = table(data_abb(:,1),data_abb(:,3),data_abb(:,4),data_abb(:,5), ...
%     'VariableNames',{'SMI','Area','Tpos','unit_id'});
bmi_tbl = table(data_abb(:,2),data_abb(:,3),data_abb(:,4),data_abb(:,5), ...
    'VariableNames',{'BMI','Area','Tpos','unit_id'});

% linear mixed-effects model
lme = fitlme(bmi_tbl,'BMI~Area*Tpos+(Tpos|unit_id)');

% format core and belt data
bmi_core = table(data_abb_core(:,2),data_abb_core(:,4),data_abb_core(:,5), ...
    'VariableNames',{'BMI','Tpos','unit_id'});
bmi_belt = table(data_abb_belt(:,2),data_abb_belt(:,4),data_abb_belt(:,5), ...
    'VariableNames',{'BMI','Tpos','unit_id'});

% linear mixed-effects model
lme_core = fitlme(bmi_core,'BMI~Tpos+(Tpos|unit_id)');
lme_belt = fitlme(bmi_belt,'BMI~Tpos+(Tpos|unit_id)');

% makes the Tpos "categorical" to examine effect of each triplet
% position... (cf. Yu et al.,2021 Neuron)
bmi_core.Tpos = categorical(bmi_core.Tpos);
bmi_belt.Tpos = categorical(bmi_belt.Tpos);

lme2_core = fitlme(bmi_core,'BMI~Tpos+(Tpos|unit_id)');
lme2_belt = fitlme(bmi_belt,'BMI~Tpos+(Tpos|unit_id)');