clear all

RecordingDate = '20210403';
DATA_DIR = fullfile('/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results',RecordingDate,'ACF','zScore');
f_name = strcat(RecordingDate,'_zACF');

% load data
load(fullfile(DATA_DIR,f_name));
% nChannel = size(ACF_diff_all,1);

% plot ACF
h_a = plotACF(ACF_A_all,list_st);
h_b = plotACF(ACF_B_all,list_st);
h_d = plotACF(ACF_diff_all,list_st);

% save figures...
fig_name = strcat(RecordingDate,'_zACF_Arate_channel');
saveas(h_a(1),fullfile(DATA_DIR,fig_name),'png');
fig_name = strcat(RecordingDate,'_zACF_Arate_stdiff');
saveas(h_a(2),fullfile(DATA_DIR,fig_name),'png');

fig_name = strcat(RecordingDate,'_zACF_A&Brate_channel');
saveas(h_b(1),fullfile(DATA_DIR,fig_name),'png');
fig_name = strcat(RecordingDate,'_zACF_A&Brate_stdiff');
saveas(h_b(2),fullfile(DATA_DIR,fig_name),'png');

fig_name = strcat(RecordingDate,'_zACF_ABcomp_channel');
saveas(h_d(1),fullfile(DATA_DIR,fig_name),'png');
fig_name = strcat(RecordingDate,'_zACF_ABcomp_stdiff');
saveas(h_d(2),fullfile(DATA_DIR,fig_name),'png');

