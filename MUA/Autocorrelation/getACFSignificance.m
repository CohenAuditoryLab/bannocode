function [ sig, sigACF, sigIndex, chDepth ] = getACFSignificance( RecordingDate, L3_ch, isSave )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% RecordingDate = '20180807';
% nChannel = 16; %24; % number of channel (16 for Domo, 24 for Cassius)
% isSave = 0; % 1 if saving figure...
% L3_ch = 8; % channel corresponding to the bottom of layer 3...

DATA_DIR = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results',RecordingDate,'ACF','zScore');
f_name = strcat(RecordingDate,'_zACF');
th = 1.645; % 95% signiricande of one sided z-score...

% load data
load(fullfile(DATA_DIR,f_name));
nChannel = size(ACF_A_all,1);

% evaluate ACF significance
sigACF_A = (ACF_A_all > th);
sigACF_B = (ACF_B_all > th);
sigACF_either = ( sigACF_A + sigACF_B ) > 0;

sigACF_1SRM = ACF_B_all;
sigACF_2SRM = ACF_A_all;
sigIndex = ACF_A_all - ACF_B_all;

sigACF_1SRM(sigACF_B==0) = NaN;
sigACF_2SRM(sigACF_A==0) = NaN;
sigIndex(sigACF_either==0) = NaN;

% get distance from input layer
if nChannel==16
    ch_spacing = 150;
elseif nChannel==24
    ch_spacing = 100;
end
chDepth = 1:nChannel;
chDepth = (chDepth - L3_ch) * ch_spacing;


sig = struct('A',sigACF_A,'B',sigACF_B,'either',sigACF_either);
sigACF = struct('one_srm',sigACF_1SRM,'two_srm',sigACF_2SRM);

% ACF = struct('A',ACF_A_all,'B',ACF_B_all);

if isSave==1
    % save figure
    save_file_dir = DATA_DIR;
    save_file_name = strcat(RecordingDate,'_ACFSignificance');
%     saveas(gcf,fullfile(save_file_dir,save_file_name),'png');
    % save variables
    save(fullfile(save_file_dir,save_file_name),'sig','sigACF','sigIndex','chDepth','list_st');
end


end

