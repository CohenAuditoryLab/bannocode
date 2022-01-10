% concatenate Site information of Domo and Cassius
% save them as RecordingDate_Both
clear all;

Domo = load('RecordingDate_Domo.mat');
Cassius = load('RecordingDate_Cassius.mat');

area_index = [Domo.area_index Cassius.area_index];
L3u_channel = [Domo.L3u_channel Cassius.L3u_channel];
L3_channel = [Domo.L3_channel Cassius.L3_channel];
L4_channel = [Domo.L4_channel Cassius.L4_channel];
L5_channel = [Domo.L5_channel Cassius.L5_channel];
list_RecDate = [Domo.list_RecDate Cassius.list_RecDate];

save_file_name = strcat('RecordingDate_Both');
save(save_file_name,'area_index','L3u_channel','L3_channel','L4_channel','L5_channel','list_RecDate');