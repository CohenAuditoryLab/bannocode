clear all

ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

load(fullfile(LIST_DIR,'RecordingDate_Both'));
% RecDate = '20180709';
% RecDate = '20200110';
% RecDate = '20210220';

for ff=1:numel(list_RecDate)
    RecDate = list_RecDate{ff};
    data_dir = fullfile(ROOT_DIR,RecDate,'Resp');
    
    fName1 = strcat(RecDate,'_zMUAtriplet');
    fName2 = strcat(RecDate,'_SignificantChannels');
    
    load(fullfile(data_dir,fName1));
    load(fullfile(data_dir,fName2));
    
    % stimulus selectivity 1st B tone
    B = squeeze(zMUA_B1.stdiff(1,[1 end],1,:) + zMUA_B2.stdiff(1,[1 end],1,:)) / 2;
    diffB = abs( B(1,:) - B(2,:) );
    
    % stimulus selectivity (T-1)th A tone
    A = squeeze(zMUA_A.stdiff(4,[1 end],1,:));
    diffA = abs( A(1,:) - A(2,:) );
    
    % stimulus selectivity Target
    T = squeeze(zMUA_A.stdiff(5,[1 end],1,:) + zMUA_B1.stdiff(5,[1 end],1,:) + zMUA_B2.stdiff(5,[1 end],1,:)) / 3;
    diffT = abs( T(1,:) - T(2,:) );
    
    val = [diffB; diffA; diffT]; % concatenate values...
    
    % variables to save...
    iBAT = val'; % transpose to make the first dim to be channels
    sig_ch = sig.Resp; % significant channels
    ch_L3 = L3_channel(ff); % layer 3b if defined...
    i_area = area_index(ff);
    
    save_file_name = strcat(RecDate,'_MUAProperty');
    save(fullfile(data_dir,save_file_name),'iBAT','sig_ch','ch_L3','i_area');
end