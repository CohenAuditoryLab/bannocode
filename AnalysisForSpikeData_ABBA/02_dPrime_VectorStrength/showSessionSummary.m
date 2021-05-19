clear all;

Date = '20190821';
addpath(Date); % add path to the data...

fname1 = strcat(Date,'_dPrimeROC');
fname2 = strcat(Date,'_ABBA_VectorStrength');

load(fname1);
% get d prime values 
unit_id = transpose(clInfo.active_cluster);
channel = transpose(clInfo.active_channel) + 1;
dp_adapt = transpose(Adapt.dprime_all); % adaptation
dp_AvsB  = transpose(AvsB.dprime_all); % frequency selectivity
dp_TvsNT = transpose(TvsNT.dprime_all); % target vs non-target
dp_HvsM  = transpose(HvsM.dprime_all); % hit vs miss

load(fname2);
% get vector strength
vs = transpose(VS_all);

excel_summary = [unit_id channel dp_AvsB vs dp_adapt dp_TvsNT dp_HvsM];

open excel_summary

data_mean = mean(excel_summary,1);
data_mean(1:2) = [];