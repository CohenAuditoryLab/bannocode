function [ denoiseRaw ] = rejectArtifact_original( raw, params )
%rejectArtifact Summary of this function goes here
%   find noisy trials having voltage fructuation geater than ArtRej and
%   replace the trial with NaN. The raw shoud be a matrix Time x Trial x
%   Channel

ArtRej = params.ArtRej;
n_timepoints = size(raw,1);
n_trials = size(raw,2);
for i=1:n_trials
    abs_raw = squeeze(abs(raw(:,i,:)));
%     max_raw(q) = max(max(abs_raw)); % check the voltage distribution
%     max_raw2(q) = max(abs_raw(8));
    max_raw = max(abs_raw,[],1);
    i_noise = max_raw > ArtRej; % find violator
    noise_ch = find(i_noise==1); % noisy channel
    if ~isempty(noise_ch)
        for j=noise_ch
            raw(:,i,j) = NaN(n_timepoints,1); % put NaN in noisy trial
        end
    end
end
denoiseRaw = raw;

end

