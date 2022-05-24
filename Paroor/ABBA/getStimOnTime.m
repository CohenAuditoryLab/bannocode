function stim_on_time = getStimOnTime(time,stim,th)

% obtain envelop of the pure tones
[up,lo] = envelope(abs(stim),5,'peak'); % set smoothing facter = 15 points
 tdiff = (time(1:end-1) + time(2:end))/2;
 envdiff = diff(up);
% plot(tdiff,envdiff); hold on;
% axis([-50 200 -0.01 0.01]);
% plot([0 0],[-0.01 0.01],'--k');
% title('Stimulus (difference)');

% base = envdiff(tdiff<-10);
% mbase = mean(base); stdbase = std(base);
% th = mbase + 2.5*stdbase; % set threshold to be 2.5 x std
% plot([-50 200],[th th],':k');

i = find(envdiff>=th,20,'first');
% [ii,jj] = find(i>5950,1,'first'); % remove edge
% i = i(jj);
ii = i(i>100); % remove edge
i = ii(1);
stim_on_time = time(i);

% subplot(2,1,1);
% plot([t_onset(n) t_onset(n)],[-1.5 1.5],'--r');
% subplot(2,1,2);
% plot([t_onset(n) t_onset(n)],[-0.01 0.01],'--r');

end