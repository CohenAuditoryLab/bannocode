% 8/8/22 modified to re-assign laminar boundaries
% get FMI, SMI and BMI for each MUA
% using response for A period for SMI, BB period for FMI and ABB triplet period for BMI
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
    
    fName1a   = strcat(RecDate,'_zMUAtriplet_A');
    fName1bb  = strcat(RecDate,'_zMUAtriplet_BB');
    fName1abb = strcat(RecDate,'_zMUAtriplet_ABB');
    fName2 = strcat(RecDate,'_SignificantChannels');
    
    % load data...
    load(fullfile(data_dir,fName1a));
    load(fullfile(data_dir,fName1bb));
    load(fullfile(data_dir,fName1abb));
    load(fullfile(data_dir,fName2));

    % calculate index
    smi_a   = get_index_ver3(zMUA_A.stdiff,'SMI');
    fmi_bb  = get_index_ver3(zMUA_BB.stdiff,'FMI');
    bmi_abb = get_index_ver3(zMUA_ABB.stdiff,'BMI');

%     [smi_a , bmi_a] = get_index(zMUA_A.stdiff);
%     [smi_b1, bmi_b1] = get_index(zMUA_B1.stdiff);
%     [smi_b2, bmi_b2] = get_index(zMUA_B2.stdiff);
%     [smi_abb, bmi_abb] = get_index(zMUA_ABB.stdiff);

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
    SMI.A   = smi_a'; % transpose to make the first dim to be channels
    FMI.BB  = fmi_bb';
    BMI.ABB = bmi_abb';
    sig_ch = sig.Resp; % significant channels
    ch_L3u = L3u_channel(ff);
    ch_L3 = L3_channel(ff); % layer 3b if defined...
    ch_L5 = L5_channel(ff);
    i_area = area_index(ff); % index for belt (0) and core (1) recording site

    % 8/8/22 added
    uBorder = Boundary_up(ff); % upper border of thalamorecipient layer
    lBorder = Boundary_low(ff); % lower border of thalamorecipient layer
    i_AP = AP_index(ff); % index for anterior(0) and posteror(1) recording site
    
    % SMI is NOT log-transformed yet!!
    save_file_name = strcat(RecDate,'_MUAProperty3_ABB_ext');
    save(fullfile(data_dir,save_file_name),'SMI','FMI','BMI','sig_ch', ...
        'ch_L3u','ch_L3','ch_L5','uBorder','lBorder','i_area','i_AP','sTriplet');
end