% Get d' for the correlation analysis
DATA_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION_SEGREGATION\ANALYSIS\Behavior\Data';

load RecordingDate_lowBF.mat
RecDate = list_RecDate;

dPrime = [];
n4 = 0; n3 = 0;
for ff=1:numel(RecDate)
    fName = strcat(RecDate{ff},'_Behavior');
    load(fullfile(DATA_DIR,fName));

    % concatenate data across sessions
    if length(list_st)==3
        temp_dp = [dp(1); NaN; NaN; dp(end)];
        dPrime = [dPrime temp_dp];
        n3 = n3 + 1;
        clear temp_dp
    elseif length(list_st)==4
        dPrime = [dPrime dp];
        n4 = n4 + 1;
    end
    
%     dp_hard(ff) = dp(1);
%     dp_easy(ff) = dp(end);
end

save('dPrime_lowBF','AP_index','area_index','dPrime','list_RecDate');
