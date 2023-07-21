% ROOT_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS';
% % DATA_PATH_BEHAVIOR = fullfile(ROOT_PATH,'Behavior','Data');
% DATA_PATH_NEURAL = fullfile(ROOT_PATH,'MUA\code_reanlysis\trialMUA\Streaming_Probability\threshold_allTriplet1');

addpath('mat_files');

tpos = 8; %8; 
% load behavioral data
load dPrime_lowBF.mat
deltaDP = dPrime(4,:) - dPrime(1,:);
deltaDP_mat = repmat(deltaDP,24,1);
deltaDP_vec = deltaDP_mat(:);

% load neural data
load modROC_ABB_lowBF.mat
bROC = AUC.all.behav; % behavioral modulation index
% reshape matrix
bROC = reshape(bROC,[size(bROC,1)*size(bROC,2) size(bROC,3) size(bROC,4) size(bROC,5)]);

% plot modulation as a function of d'
string = {'Smallest dF','Small dF','Large dF','Largest dF'};
string2 = {'L','H1','H2'};
i = [1 4]; % small and large semitone difference
% j = 1; % ABB
% figure('Position',[185 420 830 420]);
figure("Position",[500 500 800 440]);
for ii=1:2
    for j=1:3 % ABB
        subplot(2,3,3*(ii-1)+j); hold on;
%         deltaDP_vec_jitter = deltaDP_vec + (rand(size(deltaDP_vec))-0.5) * 0.025;
        scatter(deltaDP_vec,bROC(:,tpos,i(ii),j),'k');

        % plot baseline (0 level)
        plot([-0.5 2],[0.5 0.5],':k');
        
        % reshape matrix again...
        bROC_mat = reshape(bROC(:,tpos,i(ii),j),size(deltaDP_mat));
        X = median(deltaDP_mat,1);
        Y = nanmedian(bROC_mat,1);
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
        xlabel('\Delta d prime [Largest - Smallest \DeltaF]','Interpreter','tex');
        ylabel('auROC');
        title(string2{j});
        xlim([-0.5 2]);
        if ii==1
            ylim([0.0 0.9]);
        elseif ii==2
            ylim([0.2 0.9]);
        end

%         % show p value of regression
%         disp(mdl)

        % p-value for slope
        pvalue(ii,j) = mdl.Coefficients.pValue(2);
    end
end

% difference in different stimulus conditions (lagest dF - smallest dF)
diff_bROC = squeeze(bROC(:,:,4,:) - bROC(:,:,1,:));
figure('Position',[200 450 835 220]);
for j=1:3 % ABB
    subplot(1,3,j); hold on;
    scatter(deltaDP_vec,diff_bROC(:,tpos,j),'k');
    
    % plot baseline (0 level)
    plot([-0.5 2],[0.0 0.0],':k');

    % reshape matrix again...
    dROC_mat = reshape(diff_bROC(:,tpos,j),size(deltaDP_mat));
    X = median(deltaDP_mat,1);
    Y = nanmedian(dROC_mat,1);
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
    xlabel('\Delta d prime [Largest - Smallest \DeltaF]','Interpreter','tex');
    ylabel({'\Delta auROC','[Largest - Smallest \DeltaF]'},'Interpreter','tex');
    title(string2{j});
    xlim([-0.5 2]);
    
    pvalue2(j) = mdl.Coefficients.pValue(2);
end