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
load StreamingProb_lowBF.mat
p1srm  = reshape(pStream.all.single_stream,[size(pStream.all.single_stream,1)*size(pStream.all.single_stream,2) size(pStream.all.single_stream,3) size(pStream.all.single_stream,4)]);
p2srm  = reshape(pStream.all.dual_stream,[size(pStream.all.dual_stream,1)*size(pStream.all.dual_stream,2) size(pStream.all.dual_stream,3) size(pStream.all.dual_stream,4)]);
% adjusted streaming probability
prob_stdiff = p2srm ./ (p1srm + p2srm);
prob_smallDF = prob_stdiff(:,:,1); % small deltaF trial
prob_largeDF = prob_stdiff(:,:,4); % large deltaF trial
clear pStream

% load neural data (hit trial)
load StreamingProb_lowBF_hit.mat
p1srm_h  = reshape(pStream.all.single_stream,[size(pStream.all.single_stream,1)*size(pStream.all.single_stream,2) size(pStream.all.single_stream,3) size(pStream.all.single_stream,4)]);
p2srm_h  = reshape(pStream.all.dual_stream,[size(pStream.all.dual_stream,1)*size(pStream.all.dual_stream,2) size(pStream.all.dual_stream,3) size(pStream.all.dual_stream,4)]);
% adjusted streaming probability
prob_stdiff_h = p2srm_h ./ (p1srm_h + p2srm_h);
prob_smallDF_h = prob_stdiff_h(:,:,1); % small deltaF trial
prob_largeDF_h = prob_stdiff_h(:,:,4); % large deltaF trial
clear pStream

load StreamingProb_lowBF_miss.mat
p1srm_m  = reshape(pStream.all.single_stream,[size(pStream.all.single_stream,1)*size(pStream.all.single_stream,2) size(pStream.all.single_stream,3) size(pStream.all.single_stream,4)]);
p2srm_m  = reshape(pStream.all.dual_stream,[size(pStream.all.dual_stream,1)*size(pStream.all.dual_stream,2) size(pStream.all.dual_stream,3) size(pStream.all.dual_stream,4)]);
% adjusted streaming probability
prob_stdiff_m = p2srm_m ./ (p1srm_m + p2srm_m);
prob_smallDF_m = prob_stdiff_m(:,:,1); % small deltaF trial
prob_largeDF_m = prob_stdiff_m(:,:,4); % large deltaF trial
clear pStream

% deltaProb = prob_hit - prob_miss;
deltaProb(:,:,1) = prob_largeDF - prob_smallDF;
deltaProb(:,:,2) = prob_largeDF_h - prob_smallDF_h;
deltaProb(:,:,3) = prob_largeDF_m - prob_smallDF_m;

figure('Position',[185 420 835 220]);
string = {'All','Hit','Miss'};
% i = 1;
for i=1:3 % 4 deltaF levels
%     subplot(2,2,i); hold on;
    subplot(1,3,i); hold on;
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
    ylabel({'delta streaming probability'; '[lagest - smallest dF]'});
    title(string{i});
    xlim([-0.5 2]); ylim([-0.6 0.6])
    
%     % show p value of regression...
%     disp(mdl)

    % p-value for slope
    pvalue(i) = mdl.Coefficients.pValue(2);
end

