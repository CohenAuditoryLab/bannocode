function [ lfp_pad, t_pad ] = zeropadLFP( lfp, t, nSamplePoint )
%zeropadLFP Summary of this function goes here
%   add zeros at the end of LFP signal
%   lfp -- LFP data (channel x sample)
%   t   -- time vector correspondin to the lfp
%   nSamplePoint -- number of samples in padded data (should be greater 
%                   than original sample points)

nChannel = size(lfp,1);
nSample_ori = size(lfp,2);

% pad lfp with zeros
lfp_pad = zeros(nChannel,nSamplePoint);
lfp_pad(:,1:nSample_ori) = lfp;

% pad time-axis with nans
t_pad = nan(1,nSamplePoint);
t_pad(1:nSapmle_ori) = t;

% % extend time...
% t_start = t(1);
% t_delta = t(2)-t(1);
% t_pad = 0:t_delta:(nSamplePoint * t_delta);
% t_pad(end) = [];
% t_pad = t_pad + t_start;

end

