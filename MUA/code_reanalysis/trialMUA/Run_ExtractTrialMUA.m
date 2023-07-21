clear all;

addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis');
load RecordingDate_Domo.mat

n_session = length(list_RecDate);
for ff=2:n_session
    RecDate = list_RecDate{ff};
    disp(['Processing ', num2str(ff) ' out of ' num2str(n_session)]);
    extract_trialZMUA(RecDate);
end

disp('Done!');