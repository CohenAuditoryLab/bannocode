DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';
date = '20180727';
cTP = 6; % tpos to get criterion: 1 for 1st triplet, 6 for T-1 triplet    
resolution = 0.125;

fName = strcat(date,'_zMUA_trial');
load(fullfile(DATA_PATH,fName))

L  = squeeze(zMUA_trial(:,1,:,:));
H1 = squeeze(zMUA_trial(:,2,:,:));
n_ch = size(L,1); % number of channels

for ch=1:n_ch
% ch=10; % test

    % get MUA distribution from specific tpos
    ll = squeeze(L(ch,cTP,:));
    hh = squeeze(H1(ch,cTP,:));
    % get ROC criterion
    c = get_ROC_Criterion(ll,hh,resolution,0);
    criterion(ch,:) = c;
    
    % get probability across triplet positions
    for t=1:length(sTriplet)
        ll_tp = squeeze(L(ch,t,:));
        hh_tp = squeeze(H1(ch,t,:));

        % split trials by stdiff
        [ll_df,i_df] = split_trial_stdiff(ll_tp,stDiff,index);
        [hh_df,~] = split_trial_stdiff(hh_tp,stDiff,index); % i_df should be the same
        
        % get probality of two strem
        [p1(:,t),p2(:,t)] = count_two_strem(ll_df,hh_df,c);
        clear ll_tp hh_tp lldf hh_Df i_df
    end
    % combine data across channels
    prob_1stream(:,:,ch) = p1;
    prob_2stream(:,:,ch) = p2;

    clear ll hh c p1 p2
end

% reorder dimention 
% making matrix of channel x tpos x stdiff
prob_1stream = permute(prob_1stream,[3 2 1]);
prob_2stream = permute(prob_2stream,[3 2 1]);

pStreaming.single_stream = prob_1stream;
pStreaming.dual_stream = prob_2stream;

if cTP==1
    save_dir = fullfile(pwd,'threshold_1stTriplet');
elseif cTP==6
    save_dir = fullfile(pwd,'threshold_1stTriplet');
else
    error('cTP must be 1 or 6!!');
end
save_file_name = strcat(date,'_StreamingProb');
save(fullfile(save_dir,save_file_name),'pStreaming');