function [] = plot_spectrum(data,fs)
%UNTITLED4 Summary of this function goes here
%   data -- coutinuous data (samples x channel/trials)

% add path for chronux toolbox
TOOLBOX_DIR = 'C:\Users\Cohen\OneDrive\Documents\MATLAB';
addpath(genpath(fullfile(TOOLBOX_DIR,'chronux_2_12','chronux_2_12')));

params.tapers = [3 5];
params.Fs    = fs;
params.fpass = [0 250];

[S,f] = mtspectrumc(data,params);

plot_vector(S,f);

end

