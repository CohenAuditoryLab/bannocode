clear all

ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\';
LIST_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

load(fullfile(LIST_DIR,'RecordingDate_Both'));
iBAT_core = []; iBAT_belt = [];
iPL_core = []; iPL_belt = [];
for ff=1:numel(list_RecDate)
    RecDate = list_RecDate{ff};
    
    % load iBAT
    % iBAT -- 2D matrix
    % (channel) x (B-A-T) see MUA_property.m for details
    data_dir = fullfile(ROOT_DIR,RecDate,'RESP');
    fName = strcat(RecDate,'_MUAProperty_normalize');
    load(fullfile(data_dir,fName));
    
    % load nPeak_all
    % nPeak_all -- 4D matrix 
    % (4.4Hz vs 13.3Hz) x (channel) x (stdiff) x (hit-miss)
    data_dir2 = fullfile(ROOT_DIR,RecDate,'FFT');
    fName2 = strcat(RecDate,'_FFT');
    load(fullfile(data_dir2,fName2));
    
    iBAT_sig = iBAT;
%     iBAT_sig(sig_ch==0,:) = NaN;
    iBAT_sig(sig_ch==0,:) = [];
    
    iPL = [squeeze(nPeak_all(1,:,1,1)); ...
           squeeze(nPeak_all(2,:,1,1)); ...
           squeeze(nPeak_all(1,:,end,1)); ...
           squeeze(nPeak_all(2,:,end,1))];
    iPL_sig = iPL';
    iPL_sig(sig_ch==0,:) = [];
    
    if i_area == 1
        iBAT_core = cat(1,iBAT_core,iBAT_sig);
        iPL_core = cat(1,iPL_core,iPL_sig);
    elseif i_area == 0
        iBAT_belt = cat(1,iBAT_belt,iBAT_sig);
        iPL_belt = cat(1,iPL_belt,iPL_sig);
    end
    
end
iMUAprop_core = [iBAT_core iPL_core];
iMUAprop_belt = [iBAT_belt iPL_belt];

% log transform
ilProp_core = log10(iMUAprop_core);
ilProp_belt = log10(iMUAprop_belt);

ilProp_all = [ilProp_core; ilProp_belt];

[coeff,score] = pca(ilProp_all);
n = size(ilProp_core,1);
score_core = score(1:n,:);
score_belt = score(n+1:end,:);
plot3(score_core(:,1),score_core(:,2),score_core(:,3),'or'); hold on
plot3(score_belt(:,1),score_belt(:,2),score_belt(:,3),'^b'); 
grid on;

% % log transform
% ilBAT_core = log(iBAT_core);
% ilBAT_belt = log(iBAT_belt);
% 
% ilBAT_all = [ilBAT_core; ilBAT_belt];
% 
% [coeff,score] = pca(ilBAT_all);
% n = size(ilBAT_core,1);
% score_core = score(1:n,:);
% score_belt = score(n+1:end,:);
% plot(score_core(:,1),score_core(:,2),'ob'); hold on
% plot(score_belt(:,1),score_belt(:,2),'^r'); 