% regression analysis
clear all
load IndexTable_emergence.mat
IndexType = 'SMI';

% ABB = 3;
% data_abb = Data(:,:,ABB);
data_abb = mean(Data,3); % take the mean of triplet
data_abb_core = data_abb(data_abb(:,3)==0,:); % separated core data
data_abb_belt = data_abb(data_abb(:,3)==1,:); % separated belt data
% remove baseline
data_abb_woBL = data_abb;
data_abb_woBL(data_abb(:,4)==1,:) = [];
tpos_woBL = data_abb_woBL(:,4) - 1;
data_abb_woBL(:,4) = tpos_woBL;

% % get baseline data
% data_baseline = data_abb(data_abb(:,4)==1,:);
% SMIbl = data_baseline(:,1);
% BMIbl = data_baseline(:,2);
% iArea = data_baseline(:,3);
% % get mean of baseline
% mSMIbl_core = mean(SMIbl(iArea==0));
% mSMIbl_belt = mean(SMIbl(iArea==1));
% mBMIbl_core = mean(BMIbl(iArea==0));
% mBMIbl_belt = mean(BMIbl(iArea==1));
% 
% % subtract baseline
% data_abb_core(:,1) = data_abb_core(:,1) - mSMIbl_core;
% data_abb_core(:,2) = data_abb_core(:,2) - mBMIbl_core;
% data_abb_belt(:,1) = data_abb_belt(:,1) - mSMIbl_belt;
% data_abb_belt(:,2) = data_abb_belt(:,2) - mBMIbl_belt;

nUnit_core = max(unique(data_abb_core(:,5))); % # of units in core
unit_belt = data_abb_belt(:,5);
unit_belt = unit_belt - nUnit_core; % reorder unit id number
data_abb_belt(:,5) = unit_belt; % substitute unit id

nPenet_core = max(unique(data_abb_core(:,6))); % # of penetrations in core
electrode_belt = data_abb_belt(:,6);
electrode_belt = electrode_belt - nPenet_core; % reorder electrode id number
data_abb_belt(:,6) = electrode_belt; % substitute electrode id

% format data into table
if strcmp(IndexType,'SMI')
disp('analyzing SMI...');
% examine effects of area and tpos in the data WITHOUT baseline
index_tbl = table(data_abb_woBL(:,1),data_abb_woBL(:,3),data_abb_woBL(:,4),data_abb_woBL(:,5),data_abb_woBL(:,6),data_abb_woBL(:,8), ...
    'VariableNames',{'IDX','Area','Tpos','unit_id','electrode_id','animal_id'});

% examine effects of tpos in the data WITH baseline for each area
index_core = table(data_abb_core(:,1),data_abb_core(:,4),data_abb_core(:,5),data_abb_core(:,6),data_abb_core(:,8), ...
    'VariableNames',{'IDX','Tpos','unit_id','electrode_id','animal_id'});
index_belt = table(data_abb_belt(:,1),data_abb_belt(:,4),data_abb_belt(:,5),data_abb_belt(:,6),data_abb_belt(:,8), ...
    'VariableNames',{'IDX','Tpos','unit_id','electrode_id','animal_id'});
elseif strcmp(IndexType,'BMI')
disp('analyzing BMI...');
% examine effects of area and tpos in the data WITHOUT baseline
index_tbl = table(data_abb_woBL(:,2),data_abb_woBL(:,3),data_abb_woBL(:,4),data_abb_woBL(:,5),data_abb_woBL(:,6),data_abb_woBL(:,8), ...
    'VariableNames',{'IDX','Area','Tpos','unit_id','electrode_id','animal_id'});

% examine effects of tpos in the data WITH baseline for each area
index_core = table(data_abb_core(:,2),data_abb_core(:,4),data_abb_core(:,5),data_abb_core(:,6),data_abb_core(:,8), ...
    'VariableNames',{'IDX','Tpos','unit_id','electrode_id','animal_id'});
index_belt = table(data_abb_belt(:,2),data_abb_belt(:,4),data_abb_belt(:,5),data_abb_belt(:,6),data_abb_belt(:,8), ...
    'VariableNames',{'IDX','Tpos','unit_id','electrode_id','animal_id'});
end

% linear mixed-effects model
lme = fitlme(index_tbl,'IDX~Area*Tpos+(Tpos|unit_id)');
lme2 = fitlme(index_tbl,'IDX~Area*Tpos+(Tpos|unit_id)+(unit_id|electrode_id)');
lme3 = fitlme(index_tbl,'IDX~Area*Tpos+(Tpos|unit_id)+(unit_id|electrode_id)+(electrode_id|animal_id)');
% result1 = compare(lme,lme2); % lme2 is better
% result2 = compare(lme2,lme3); % 

[~,~,stats] = fixedEffects(lme2);
pval = stats.pValue;
pval(1) = []; % remove intercept...



% linear mixed-effects model
lme_core  = fitlme(index_core,'IDX~Tpos+(Tpos|unit_id)');
lme_belt  = fitlme(index_belt,'IDX~Tpos+(Tpos|unit_id)');
lme2_core = fitlme(index_core,'IDX~Tpos+(Tpos|unit_id)+(unit_id|electrode_id)');
lme2_belt = fitlme(index_belt,'IDX~Tpos+(Tpos|unit_id)+(unit_id|electrode_id)');
lme3_core = fitlme(index_core,'IDX~Tpos+(Tpos|unit_id)+(unit_id|electrode_id)+(electrode_id|animal_id)');
lme3_belt = fitlme(index_belt,'IDX~Tpos+(Tpos|unit_id)+(unit_id|electrode_id)+(electrode_id|animal_id)');
% result1_core = compare(lme_core,lme2_core); % lme2_core is better
% result2_core = compare(lme2_core,lme3_core); % lme2_core is better
% result1_belt = compare(lme_belt,lme2_belt); % lme2_belt is better
% result2_belt = compare(lme2_belt,lme3_belt); % lme2_belt is better

% IN GENERAL, LME2 GIVES THE BEST RESULT
% FURTHER EXAMINE EMERGENCE TIMING BASED ON THE LME2...

% makes the Tpos "categorical" to examine effect of each triplet
% position... (cf. Yu et al.,2021 Neuron)
index_core.Tpos = categorical(index_core.Tpos);
index_belt.Tpos = categorical(index_belt.Tpos);

lme22_core = fitlme(index_core,'IDX~Tpos+(Tpos|unit_id)+(unit_id|electrode_id)');
lme22_belt = fitlme(index_belt,'IDX~Tpos+(Tpos|unit_id)+(unit_id|electrode_id)');

[beta_core,~,stats_core] = fixedEffects(lme22_core);
[beta_belt,~,stats_belt] = fixedEffects(lme22_belt);
% [~,~,stats_core] = randomEffects(lme2_core);
% [~,~,stats_belt] = randomEffects(lme2_belt);
pval_core = stats_core.pValue;
pval_belt = stats_belt.pValue;
name = stats_core.Name;

disp('done!');