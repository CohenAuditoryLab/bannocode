% get SMI and BMI for each MUA
% using response for each of the ABB triplet (225-ms periods)
clear all

ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

load(fullfile(LIST_DIR,'RecordingDate_Both'));
% RecDate = '20180709';
% RecDate = '20200110';
% RecDate = '20210220';

for ff=1:numel(list_RecDate)
    RecDate = list_RecDate{ff};
    data_dir = fullfile(ROOT_DIR,RecDate,'Resp');
    
    fName1 = strcat(RecDate,'_zMUAtriplet_ABB');
    fName2 = strcat(RecDate,'_SignificantChannels');
    
    load(fullfile(data_dir,fName1));
    load(fullfile(data_dir,fName2));
    
%     [smi_a , bmi_a] = get_index(zMUA_A.stdiff);
%     [smi_b1, bmi_b1] = get_index(zMUA_B1.stdiff);
%     [smi_b2, bmi_b2] = get_index(zMUA_B2.stdiff);
    [smi_abb, bmi_abb] = get_index(zMUA_ABB.stdiff);

%     % stimulus selectivity 1st B tone
%     B = squeeze(zMUA_B1.stdiff(1,[1 end],1,:) + zMUA_B2.stdiff(1,[1 end],1,:)) / 2;
%     diffB = abs( B(1,:) - B(2,:) );
%     
%     % stimulus selectivity (T-1)th A tone
%     A = squeeze(zMUA_A.stdiff(4,[1 end],1,:));
%     diffA = abs( A(1,:) - A(2,:) );
%     
%     % stimulus selectivity Target
%     T = squeeze(zMUA_A.stdiff(5,[1 end],1,:) + zMUA_B1.stdiff(5,[1 end],1,:) + zMUA_B2.stdiff(5,[1 end],1,:)) / 3;
%     diffT = abs( T(1,:) - T(2,:) );
%     
%     val = [diffB; diffA; diffT]; % concatenate values...
    
    % variables to save...
%     iBAT = val'; % transpose to make the first dim to be channels
%     SMI.A = smi_a'; % transpose to make the first dim to be channels
%     SMI.B1 = smi_b1';
%     SMI.B2 = smi_b2';
%     BMI.A = bmi_a';
%     BMI.B1 = bmi_b1';
%     BMI.B2 = bmi_b2';
    SMI.ABB = smi_abb'; % transpose to make the first dim to be channels
    BMI.ABB = bmi_abb';
    sig_ch = sig.Resp; % significant channels
    ch_L3u = L3u_channel(ff);
    ch_L3 = L3_channel(ff); % layer 3b if defined...
    ch_L5 = L5_channel(ff);
    i_area = area_index(ff);
    
    % SMI is NOT log-transformed yet!!
    save_file_name = strcat(RecDate,'_MUAProperty2_ABB');
    save(fullfile(data_dir,save_file_name),'SMI','BMI','sig_ch','ch_L3u','ch_L3','ch_L5','i_area','sTriplet');
end