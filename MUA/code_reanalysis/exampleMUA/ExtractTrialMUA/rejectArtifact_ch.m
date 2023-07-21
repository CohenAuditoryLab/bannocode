function [ denoiseRaw, iNoisyTrial ] = rejectArtifact_ch( raw_ch, ArtRej )
%rejectArtifact Summary of this function goes here
%   find noisy trials having voltage fructuation geater than ArtRej and
%   replace the trial with NaN. The raw shoud be a matrix Time x Trial x
%   Channel

% ArtRej = params.ArtRej;
% n_timepoints = size(raw_ch,2);
n_trials = size(raw_ch,1);
% n_channel = size(raw,3);
% nValidTrial = n_trials;
iNoisyTrial = zeros(n_trials,1);
for i=1:n_trials
    abs_raw = abs(raw_ch(i,:));
%     max_raw(q) = max(max(abs_raw)); % check the voltage distribution
%     max_raw2(q) = max(abs_raw(8));
    max_raw = max(abs_raw);
    i_noise = max_raw > ArtRej; % find violator
    if i_noise==1
        raw_ch(i,:) = []; % remove noisy trial
        iNoisyTrial(i) = 1;
    end
%     noise_ch = find(i_noise==1); % noisy channel
%     if ~isempty(noise_ch)
%         for j=noise_ch
%             raw(:,i,j) = NaN(n_timepoints,1); % put NaN in noisy trial
%         end
%         if length(noise_ch)==n_channel % when all channels are noisy
%             nValidTrial = nValidTrial - 1; % remove the trial
%         end
%     end
end
denoiseRaw = raw_ch;

end

