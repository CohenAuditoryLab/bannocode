function [pStream,list_st,sTriplet,criterion] = get_StreamingProbability_v2(date,cTP)
% slightly modified from get_StreamingProbability.m so that the code can
% handle with cTP as a vector (choose multple triplet positions)

global DATA_DIR
% DATA_PATH = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\trialMUA\zMUA_trial';
% date = '20180727';
% cTP = 6; % tpos to get criterion: 1 for 1st triplet, 6 for T-1 triplet    
resolution = 0.125;

fName = strcat(date,'_zMUA_trial');
load(fullfile(DATA_DIR,fName))

L  = squeeze(zMUA_trial(:,1,:,:));
H1 = squeeze(zMUA_trial(:,2,:,:));
n_ch = size(L,1); % number of channels
list_st = unique(stDiff);

for ch=1:n_ch
% ch=10; % test

    % get MUA distribution from specific tpos
    ll = squeeze(L(ch,cTP,:));
    hh = squeeze(H1(ch,cTP,:));
    % get ROC criterion
    c = get_ROC_Criterion(ll(:),hh(:),resolution,0);
    criterion(ch,:) = c;
    
    % get probability across triplet positions
    for t=1:size(L,2) %length(sTriplet)
        ll_tp = squeeze(L(ch,t,:));
        hh_tp = squeeze(H1(ch,t,:));

        % split trials by stdiff
        ll_df = split_trial_stdiff_v2(ll_tp,stDiff,index);
        hh_df = split_trial_stdiff_v2(hh_tp,stDiff,index);
%         [ll_df,i_df] = split_trial_stdiff(ll_tp,stDiff,index);
%         [hh_df,~] = split_trial_stdiff(hh_tp,stDiff,index); % i_df should be the same
        
        % get probality of two strem
        [p1_a(:,t),p2_a(:,t)] = count_two_stream(ll_df.all,hh_df.all,c);
        [p1_h(:,t),p2_h(:,t)] = count_two_stream(ll_df.hit,hh_df.hit,c);
        [p1_m(:,t),p2_m(:,t)] = count_two_stream(ll_df.miss,hh_df.miss,c);
        clear ll_tp hh_tp ll_df hh_df i_df
    end
    % combine data across channels
%     prob_1stream(:,:,ch) = p1;
%     prob_2stream(:,:,ch) = p2;
    prob_1stream_a(:,:,ch) = p1_a;
    prob_2stream_a(:,:,ch) = p2_a;
    prob_1stream_h(:,:,ch) = p1_h;
    prob_2stream_h(:,:,ch) = p2_h;
    prob_1stream_m(:,:,ch) = p1_m;
    prob_2stream_m(:,:,ch) = p2_m;

    clear ll hh c p1 p2
end

% reorder dimention 
% making matrix of channel x tpos x stdiff
prob_1stream_a = permute(prob_1stream_a,[3 2 1]);
prob_2stream_a = permute(prob_2stream_a,[3 2 1]);
prob_1stream_h = permute(prob_1stream_h,[3 2 1]);
prob_2stream_h = permute(prob_2stream_h,[3 2 1]);
prob_1stream_m = permute(prob_1stream_m,[3 2 1]);
prob_2stream_m = permute(prob_2stream_m,[3 2 1]);

pStream.single.all = prob_1stream_a;
pStream.dual.all = prob_2stream_a;
pStream.single.hit = prob_1stream_h;
pStream.dual.hit = prob_2stream_h;
pStream.single.miss = prob_1stream_m;
pStream.dual.miss = prob_2stream_m;

% if cTP==1
%     save_dir = fullfile(pwd,'threshold_1stTriplet');
% elseif cTP==6
%     save_dir = fullfile(pwd,'threshold_1stTriplet');
% else
%     error('cTP must be 1 or 6!!');
% end
% save_file_name = strcat(date,'_StreamingProb');
% save(fullfile(save_dir,save_file_name),'pStream');

end