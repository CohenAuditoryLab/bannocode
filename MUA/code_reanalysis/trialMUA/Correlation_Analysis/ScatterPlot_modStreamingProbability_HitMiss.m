% ROOT_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS';
% % DATA_PATH_BEHAVIOR = fullfile(ROOT_PATH,'Behavior','Data');
% DATA_PATH_NEURAL = fullfile(ROOT_PATH,'MUA\code_reanlysis\trialMUA\Streaming_Probability\threshold_allTriplet1');

addpath('mat_files');

tpos = 6; % T-1 triplet 
% load behavioral data
load dPrime_lowBF.mat
deltaDP = dPrime(4,:) - dPrime(1,:);
deltaDP_mat = repmat(deltaDP,24,1);
deltaDP_vec = deltaDP_mat(:);

% load neural data (hit trial)
load StreamingProb_lowBF_hit.mat
p1srm_h  = reshape(pStream.all.single_stream,[size(pStream.all.single_stream,1)*size(pStream.all.single_stream,2) size(pStream.all.single_stream,3) size(pStream.all.single_stream,4)]);
p2srm_h  = reshape(pStream.all.dual_stream,[size(pStream.all.dual_stream,1)*size(pStream.all.dual_stream,2) size(pStream.all.dual_stream,3) size(pStream.all.dual_stream,4)]);
% adjusted streaming probability
prob_hit = p2srm_h ./ (p1srm_h + p2srm_h);
clear pStream

load StreamingProb_lowBF_miss.mat
p1srm_m  = reshape(pStream.all.single_stream,[size(pStream.all.single_stream,1)*size(pStream.all.single_stream,2) size(pStream.all.single_stream,3) size(pStream.all.single_stream,4)]);
p2srm_m  = reshape(pStream.all.dual_stream,[size(pStream.all.dual_stream,1)*size(pStream.all.dual_stream,2) size(pStream.all.dual_stream,3) size(pStream.all.dual_stream,4)]);
% adjusted streaming probability
prob_miss = p2srm_m ./ (p1srm_m + p2srm_m);
clear pStream

deltaProb = prob_hit - prob_miss;

figure;
string = {'Smallest dF','Small dF','Large dF','Largest dF'};
for i=1:4 % 4 deltaF levels
    subplot(2,2,i); hold on;
    scatter(deltaDP_vec,deltaProb(:,tpos,i),'k');

    % plot baseline (0 level)
    plot([-0.5 2],[0 0],':k');

    deltaProb_mat = reshape(deltaProb(:,tpos,i),size(deltaDP_mat));
    X = median(deltaDP_mat,1);
    Y = nanmedian(deltaProb_mat,1);
    XY = [X' Y'];
    sortXY = sortrows(XY,1);
    sortXY(isnan(sortXY(:,2)),:) = []; % remove sessions without valid data
    % plot median
%     plot(sortXY(:,1),sortXY(:,2),':+m','LineWidth',2);
%     lsline;
    % plot regression line
    mdl = fitlm(sortXY(:,1),sortXY(:,2));
    h = plot(mdl,'LineWidth',1.5,'Color','r','Marker','+','MarkerSize',8);
    set(h(2),'LineWidth',1.5);
    legend off
    xlabel('delta d prime [largest - smallest dF]');
    ylabel({'delta streaming probability'; '[hit - miss]'});
    title(string{i});
    xlim([-0.5 2]); ylim([-0.6 0.6])
    
%     % show p value of regression...
%     disp(mdl)

    % p-value for slope
    pvalue(i) = mdl.Coefficients.pValue(2);
end

