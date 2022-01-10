function [ d_reshape ] = plot_index_tpos_v3( sigRESP_area )
%plot_index_tpos_v3.m 
%   function that calculate behavioral modulation index for the comparison
%   between areas (evaluate the effect of target time on the Target response)
%   sigRESP_area must be a matrix of channel x tpos x hit-miss x session

% reorganize matrix (channel x session x tpos)
Rhit  = permute(sigRESP_area(:,:,1,:),[1 4 2 3]); % hit
Rmiss  = permute(sigRESP_area(:,:,2,:),[1 4 2 3]); % miss

% original
% dBehav = abs( Rhit - Rmiss ); % modulation by behavioral outocme
dBehav = Rhit - Rmiss; % modulation by behavioral outocme
% dBehav = (Rhit - Rmiss) ./ (abs(Rhit) + abs(Rmiss));


size_reshape = [size(dBehav,1)*size(dBehav,2) size(dBehav,3)];
d_reshape = reshape(dBehav,size_reshape);
y_label = 'dBehavior';

% get the mean, standard deviation, and standard error...
y = nanmean(d_reshape,1);
n = sum(~isnan(d_reshape),1);
err  = nanstd(d_reshape,0,1);
err2 = err ./ sqrt(n); % standard error

x = 1:size(y,2);
% jitter = [-0.01; 0.01] * ones(1,size(y,2));
% x = x + jitter;

% plot behavioral index as a function of target position
h = errorbar(x',y',err2','LineWidth',1.5);
set(gca,'xLim',[0.5 length(x)+0.5],'xTick',x,'xTickLabel',x);
xlabel('Triplet Position');
ylabel(y_label);
box off;

end

