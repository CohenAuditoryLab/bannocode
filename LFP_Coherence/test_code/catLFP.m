function [catLFP] = catLFP(LFP1,LFP2)
%UNTITLED2 Summary of the function
%   concatenate LFP data for connectivity analaysis
data1 = LFP1.data_lfp;
data2 = LFP2.data_lfp;

% SNR = data1.SNR;
% choice = data1.choice;
% err = data1.err;
% pretone = data1.pretone;
% pretoneLength = data1.pretoneLength;
% prior = data1.prior;
% stim = data1.stim;
% trial_id = data1.trial_id;

% common variables
time = data1.time;
fsample = data1.fsample;
sampleinfo = data1.sampleinfo;

nTrial = size(sampleinfo,1); % number of trials

% concatenate label
label1 = data1.label; nCh1 = numel(label1);
label2 = data2.label; nCh2 = numel(label2);
% newLabel1 = rename_label(label1,data1.area,1);
% if nCh1==nCh2
%     newLabel2 = rename_label(label2,data2.area,nCh+1);
% else
%     newLabel2 = rename_label(label2,data2.area,1);
% end
% catLabel = [newLabel1; newLabel2];
catLabel = [label1; label2];

% concatenate lfp data
trial1 = data1.trial;
trial2 = data2.trial;
for i=1:nTrial
    catTrial{i} = [trial1{i}; trial2{i}];
end

catLFP.label = catLabel;
catLFP.time = time;
catLFP.trial = catTrial;
catLFP.fsample = fsample;
catLFP.sampleinfo = sampleinfo;


end

