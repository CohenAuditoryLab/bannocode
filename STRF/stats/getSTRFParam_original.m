function RF1P = getSTRFparam(STRFData)
% addpath(genpath('C:\STRF_files\matlab\keck'));
% load 20180709_STRF_d02

for ch = 1:16
    strf_data = STRFData(ch);
    STRF1 = mean((strf_data.STRF1A + strf_data.STRF1B)/2,3);
    Wo1 = mean((strf_data.Wo1A + strf_data.Wo1B)/2);
    taxis = strf_data.taxis;
    faxis = strf_data.faxis;
    PP = strf_data.PP;
    
    % get STRF1e and STRF1i
    threshold = max(max(STRF1)) * 0.15;
    i_exc = find(STRF1<=threshold); % excitatory part
    i_inh = find(STRF1>=threshold); % inhibitory part
    STRF1e = STRF1; STRF1i = STRF1;
    STRF1e(i_exc) = threshold; STRF1i(i_inh) = threshold;
    
%     RF1P(ch) = strfparam( taxis, faxis, STRF1, Wo1, PP, 'MR', 500, 4, 0.05, 0.1, 'y' );
    RF1P(ch) = strfparam( taxis, faxis, STRF1e, Wo1, PP, 'MR', 500, 4, 0.05, 0.1, 'y' ); % use STRF1e to calculate STRF parameters
    
    % pcolor(strf_data.taxis,log2(strf_data.faxis/strf_data.faxis(1)),strf_data.STRF1);
    % colormap jet;set(gca,'YDir','normal'); shading flat;
end

end